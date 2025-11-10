import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'fifth.dart';
import 'chat.dart';

// CAMERA CAPTURE PAGE
class CropDiagnosisCamera extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const CropDiagnosisCamera({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  State<CropDiagnosisCamera> createState() => _CropDiagnosisCameraState();
}

class _CropDiagnosisCameraState extends State<CropDiagnosisCamera> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _showSuccessSnackBar('Image captured successfully!');
      }
    } catch (e) {
      _showErrorDialog('Unable to access camera. Please check permissions.');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _showSuccessSnackBar('Image selected successfully!');
      }
    } catch (e) {
      _showErrorDialog('Unable to access gallery. Please check permissions.');
    }
  }

  Future<void> _sendImageForDiagnosis() async {
    if (_selectedImage == null) {
      _showErrorSnackBar('Please capture or select an image first');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8000/diagnose'),
      );

      String fileName = _selectedImage!.path.split('/').last;
      String contentType = 'image/jpeg';
      
      if (fileName.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.toLowerCase().endsWith('.jpg') || 
                fileName.toLowerCase().endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _selectedImage!.path,
          contentType: MediaType.parse(contentType),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final diagnosisData = jsonDecode(responseBody);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CropDiagnosisResults(
                diagnosisData: diagnosisData,
                capturedImagePath: _selectedImage!.path,
                userData: widget.userData,
              ),
            ),
          );
        }
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Error response: $responseBody');
        _showErrorDialog('Failed to diagnose crop. Please try again.');
      }
    } catch (e) {
      print('Exception: $e');
      _showErrorDialog('Connection error. Please check your internet connection.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _navigateBackToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => CropDashboard(userData: widget.userData ?? {}),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBackToDashboard();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crop Diagnosis', style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFF66BB6A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _navigateBackToDashboard,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF66BB6A), Color(0xFFF5F5F5)],
              stops: [0.0, 0.25],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.eco,
                            size: 48,
                            color: Colors.black.withOpacity(0.9),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'AI-Powered Crop Analysis',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Capture a clear image of your crop for instant AI diagnosis and expert recommendations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Image Preview Card
                    Container(
                      height: 320,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _selectedImage != null
                            ? Stack(
                                children: [
                                  Image.file(
                                    _selectedImage!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Material(
                                      color: Colors.red[700],
                                      borderRadius: BorderRadius.circular(30),
                                      elevation: 4,
                                      child: InkWell(
                                        onTap: _removeImage,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.7),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Image ready for diagnosis',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF66BB6A).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'No image selected',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Capture or select an image to begin',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Tips Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber[200]!, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.tips_and_updates, color: Colors.amber[800], size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tip: Ensure good lighting and focus on affected areas for best results',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.amber[900],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            onPressed: _isLoading ? null : _captureImage,
                            icon: Icons.camera_alt,
                            label: 'Camera',
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionButton(
                            onPressed: _isLoading ? null : _pickImageFromGallery,
                            icon: Icons.photo_library,
                            label: 'Gallery',
                            color: const Color(0xFF558B2F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Diagnose Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendImageForDiagnosis,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDD835),
                          disabledBackgroundColor: Colors.grey[300],
                          elevation: _isLoading ? 0 : 4,
                          shadowColor: const Color(0xFFFDD835).withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey[700]!,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Analyzing...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.psychology,
                                    color: Colors.grey[900],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Diagnose Crop',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey[300],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DIAGNOSIS RESULTS PAGE
class CropDiagnosisResults extends StatefulWidget {
  final Map<String, dynamic> diagnosisData;
  final String capturedImagePath;
  final Map<String, dynamic>? userData;

  const CropDiagnosisResults({
    Key? key,
    required this.diagnosisData,
    required this.capturedImagePath,
    this.userData,
  }) : super(key: key);

  @override
  State<CropDiagnosisResults> createState() => _CropDiagnosisResultsState();
}

class _CropDiagnosisResultsState extends State<CropDiagnosisResults> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateBackToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => CropDashboard(userData: widget.userData ?? {}),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBackToDashboard();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Diagnosis Results', style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFF66BB6A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _navigateBackToDashboard,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share feature coming soon!')),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF66BB6A), Color(0xFFF5F5F5)],
              stops: [0.0, 0.2],
            ),
          ),
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Card with Status Badge
                    Stack(
                      children: [
                        Container(
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(widget.capturedImagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Analyzed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    
                    // Results Card
                    _buildResultCard(
                      title: 'Detection Results',
                      icon: Icons.analytics,
                      data: widget.diagnosisData,
                    ),
                    const SizedBox(height: 20),
                    
                    // Recommendations Card
                    _buildRecommendationsCard(widget.diagnosisData),
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    _buildActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ChatPage()),
                        );
                      },
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat with Expert',
                      color: const Color(0xFF2E7D32),
                      isPrimary: true,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      onPressed: _navigateBackToDashboard,
                      icon: Icons.home_outlined,
                      label: 'Back to Dashboard',
                      color: Colors.white,
                      textColor: const Color(0xFF2E7D32),
                      isPrimary: false,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required IconData icon,
    required Map<String, dynamic> data,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF2E7D32),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._buildDataRows(data),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDataRows(Map<String, dynamic> data) {
    List<Widget> rows = [];
    int index = 0;
    
    data.forEach((key, value) {
      if (key != 'recommendation' && key != 'recommendations') {
        rows.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: index % 2 == 0 ? Colors.grey[50] : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    _formatKey(key),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    value.toString(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        index++;
      }
    });

    return rows;
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  Widget _buildRecommendationsCard(Map<String, dynamic> data) {
    final recommendations = data['recommendation'] ?? data['recommendations'] ?? 'No recommendations available';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber[50]!,
            Colors.orange[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.amber[200]!,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lightbulb,
                    color: Colors.amber[800],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'Recommendations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                recommendations.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    Color? textColor,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor ?? Colors.white,
          elevation: isPrimary ? 4 : 0,
          shadowColor: isPrimary ? color.withOpacity(0.4) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary ? BorderSide.none : BorderSide(
              color: const Color(0xFF2E7D32),
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}