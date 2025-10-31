// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// // EXPERT REGISTRATION SCREEN
// class ExpertRegistrationScreen extends StatefulWidget {
//   const ExpertRegistrationScreen({Key? key}) : super(key: key);

//   @override
//   State<ExpertRegistrationScreen> createState() => _ExpertRegistrationScreenState();
// }

// class _ExpertRegistrationScreenState extends State<ExpertRegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _titleController = TextEditingController();
//   final _experienceController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _specializationController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _featuresController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _bioController = TextEditingController();
  
//   String _selectedCategory = 'All';
//   bool _obscurePassword = true;
//   bool _isLoading = false;
//   final String _baseUrl = 'http://127.0.0.1:8000';

//   final List<String> _categories = ['All', 'Crop Disease', 'Nutrition', 'Organic'];

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _titleController.dispose();
//     _experienceController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _specializationController.dispose();
//     _priceController.dispose();
//     _featuresController.dispose();
//     _passwordController.dispose();
//     _bioController.dispose();
//     super.dispose();
//   }

//   Future<void> _registerExpert() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       try {
//         final response = await http.post(
//           Uri.parse('$_baseUrl/expert/register'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({
//             'name': _nameController.text.trim(),
//             'title': _titleController.text.trim(),
//             'experience': _experienceController.text.trim(),
//             'email': _emailController.text.trim(),
//             'phone': _phoneController.text.trim(),
//             'specialization': _specializationController.text.trim(),
//             'price': _priceController.text.trim(),
//             'features': _featuresController.text.trim(),
//             'password': _passwordController.text,
//             'bio': _bioController.text.trim(),
//             'category': _selectedCategory,
//           }),
//         );

//         setState(() => _isLoading = false);

//         if (response.statusCode == 200) {
//           final responseData = jsonDecode(response.body);
          
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Registration successful!'),
//                 backgroundColor: Colors.green,
//               ),
//             );

//             // Navigate to expert login
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => const ExpertLoginScreen(),
//               ),
//             );
//           }
//         } else {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Registration failed: ${response.body}'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         }
//       } catch (e) {
//         setState(() => _isLoading = false);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Error: $e'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F1ED),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Expert Registration',
//           style: TextStyle(color: Colors.black87),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Center(
//                   child: Icon(
//                     Icons.person_add,
//                     size: 64,
//                     color: Color(0xFF2E7D32),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
                
//                 _buildTextField('Full Name', _nameController, 'Enter your full name'),
//                 const SizedBox(height: 16),
                
//                 _buildTextField('Professional Title', _titleController, 'e.g., Plant Pathologist'),
//                 const SizedBox(height: 16),
                
//                 _buildTextField('Experience', _experienceController, 'e.g., 12 years experience'),
//                 const SizedBox(height: 16),
                
//                 _buildTextField('Email', _emailController, 'your@email.com', isEmail: true),
//                 const SizedBox(height: 16),
                
//                 _buildTextField('Phone', _phoneController, '+977-XXXXXXXXXX'),
//                 const SizedBox(height: 16),
                
//                 _buildTextField('Specialization', _specializationController, 
//                   'e.g., Tomato, potato diseases', maxLines: 2),
//                 const SizedBox(height: 16),
                
//                 _buildTextField('Consultation Price', _priceController, 
//                   'e.g., NPR 500/consultation'),
//                 const SizedBox(height: 16),
                
//                 _buildTextField('Features', _featuresController, 
//                   'e.g., Video call available'),
//                 const SizedBox(height: 16),
                
//                 const Text(
//                   'Category',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: _selectedCategory,
//                       isExpanded: true,
//                       items: _categories.map((category) {


//                         // Only half is done

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// EXPERT REGISTRATION SCREEN
class ExpertRegistrationScreen extends StatefulWidget {
  const ExpertRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<ExpertRegistrationScreen> createState() => _ExpertRegistrationScreenState();
}

class _ExpertRegistrationScreenState extends State<ExpertRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _experienceController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specializationController = TextEditingController();
  final _priceController = TextEditingController();
  final _featuresController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  
  String _selectedCategory = 'All';
  bool _obscurePassword = true;
  bool _isLoading = false;
  final String _baseUrl = 'http://127.0.0.1:8000';

  final List<String> _categories = ['All', 'Crop Disease', 'Nutrition', 'Organic'];

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _experienceController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _priceController.dispose();
    _featuresController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _registerExpert() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/expert/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': _nameController.text.trim(),
            'title': _titleController.text.trim(),
            'experience': _experienceController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'specialization': _specializationController.text.trim(),
            'price': _priceController.text.trim(),
            'features': _featuresController.text.trim(),
            'password': _passwordController.text,
            'bio': _bioController.text.trim(),
            'category': _selectedCategory,
          }),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful!'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to expert login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ExpertLoginScreen(),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration failed: ${response.body}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, 
    {bool isEmail = false, bool isPassword = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          maxLines: maxLines,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            if (isEmail && !value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Expert Registration',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.person_add,
                    size: 64,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildTextField('Full Name', _nameController, 'Enter your full name'),
                const SizedBox(height: 16),
                
                _buildTextField('Professional Title', _titleController, 'e.g., Plant Pathologist'),
                const SizedBox(height: 16),
                
                _buildTextField('Experience', _experienceController, 'e.g., 12 years experience'),
                const SizedBox(height: 16),
                
                _buildTextField('Email', _emailController, 'your@email.com', isEmail: true),
                const SizedBox(height: 16),
                
                _buildTextField('Phone', _phoneController, '+977-XXXXXXXXXX'),
                const SizedBox(height: 16),
                
                _buildTextField('Specialization', _specializationController, 
                  'e.g., Tomato, potato diseases', maxLines: 2),
                const SizedBox(height: 16),
                
                _buildTextField('Consultation Price', _priceController, 
                  'e.g., NPR 500/consultation'),
                const SizedBox(height: 16),
                
                _buildTextField('Features', _featuresController, 
                  'e.g., Video call available'),
                const SizedBox(height: 16),
                
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildTextField('Password', _passwordController, 'Create a password', isPassword: true),
                const SizedBox(height: 16),
                
                _buildTextField('Bio', _bioController, 'Tell us about yourself...', maxLines: 4),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerExpert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Register as Expert',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExpertLoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Already registered? Login here',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// EXPERT LOGIN SCREEN
class ExpertLoginScreen extends StatefulWidget {
  const ExpertLoginScreen({Key? key}) : super(key: key);

  @override
  State<ExpertLoginScreen> createState() => _ExpertLoginScreenState();
}

class _ExpertLoginScreenState extends State<ExpertLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final String _baseUrl = 'http://127.0.0.1:8000';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginExpert() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/expert/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          }),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          
          if (mounted) {
            // Navigate to expert dashboard with expert data
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ExpertDashboardScreen(expertData: responseData['expert']),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed: ${response.body}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Expert Login',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: Icon(
                    Icons.verified_user,
                    size: 80,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 40),
                
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'your@email.com',
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginExpert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExpertRegistrationScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Don\'t have an account? Register here',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// EXPERT DASHBOARD SCREEN
class ExpertDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> expertData;

  const ExpertDashboardScreen({Key? key, required this.expertData}) : super(key: key);

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {
  late Map<String, dynamic> _expertData;
  String _status = 'Available';
  bool _isUpdating = false;
  final String _baseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();
    _expertData = widget.expertData;
    _status = _expertData['status'] ?? 'Available';
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/expert/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _expertData['email'],
          'status': newStatus,
        }),
      );

      setState(() => _isUpdating = false);

      if (response.statusCode == 200) {
        setState(() {
          _status = newStatus;
          _expertData['status'] = newStatus;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Status updated to $newStatus'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update status'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isUpdating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF66BB6A), Color(0xFFF5F5F5)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Text(
                      '👨‍🌾',
                      style: TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Expert Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExpertLoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Profile Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(_expertData['name']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _expertData['name'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _expertData['title'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _expertData['experience'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(5, (index) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 24,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                '${_expertData['rating'] ?? 4.5}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Status Control
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(_status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _status,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_isUpdating)
                            const Center(child: CircularProgressIndicator())
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildStatusButton('Available', Colors.green),
                                _buildStatusButton('Busy', Colors.orange),
                                _buildStatusButton('Offline', Colors.red),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Information Cards
                    _buildInfoCard('📧 Email', _expertData['email']),
                    const SizedBox(height: 12),
                    _buildInfoCard('📱 Phone', _expertData['phone']),
                    const SizedBox(height: 12),
                    _buildInfoCard('🎯 Specialization', _expertData['specialization']),
                    const SizedBox(height: 12),
                    _buildInfoCard('💰 Price', _expertData['price']),
                    const SizedBox(height: 12),
                    _buildInfoCard('✨ Features', _expertData['features']),
                    const SizedBox(height: 12),
                    _buildInfoCard('📂 Category', _expertData['category'] ?? 'All'),
                    const SizedBox(height: 12),
                    _buildInfoCard('📝 Bio', _expertData['bio'] ?? 'No bio provided'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status, Color color) {
    final isSelected = _status == status;
    return ElevatedButton(
      onPressed: () => _updateStatus(status),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: isSelected ? 2 : 0,
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}