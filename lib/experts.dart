import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpertsPage extends StatefulWidget {
  final String userEmail; // Pass user email from login/dashboard
  
  const ExpertsPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<ExpertsPage> createState() => _ExpertsPageState();
}

class _ExpertsPageState extends State<ExpertsPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  final String _baseUrl = 'http://127.0.0.1:8000';
  
  List<Map<String, dynamic>> _experts = [];
  List<Map<String, dynamic>> _filteredExperts = [];
  bool _isLoading = true;
  int _bookingsCount = 0;
  bool _loadingBookings = false;

  final List<String> _filters = ['All', 'Crop Disease', 'Nutrition', 'Organic'];

  @override
  void initState() {
    super.initState();
    _fetchExperts();
    _fetchBookingsCount();
  }

  Future<void> _fetchExperts() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/experts${_selectedFilter != 'All' ? '?category=$_selectedFilter' : ''}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _experts = List<Map<String, dynamic>>.from(data['experts']);
          _filteredExperts = _experts;
          _isLoading = false;
        });
        print('✅ Loaded ${_experts.length} experts');
      } else {
        throw Exception('Failed to load experts');
      }
    } catch (e) {
      print('❌ Error fetching experts: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading experts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchBookingsCount() async {
    setState(() => _loadingBookings = true);
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bookings/count/${widget.userEmail}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _bookingsCount = data['total'] ?? 0;
          _loadingBookings = false;
        });
        print('✅ User has $_bookingsCount bookings');
      } else {
        throw Exception('Failed to load bookings count');
      }
    } catch (e) {
      print('❌ Error fetching bookings count: $e');
      setState(() => _loadingBookings = false);
    }
  }

  Future<void> _bookConsultation(Map<String, dynamic> expert) async {
    // Show date picker first
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;

    // Show time picker
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null) return;

    // Show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _buildConfirmationDialog(
        expert,
        selectedDate,
        selectedTime,
      ),
    );

    if (confirmed != true) return;

    // Proceed with booking
    await _submitBooking(expert, selectedDate, selectedTime);
  }

  Widget _buildConfirmationDialog(
    Map<String, dynamic> expert,
    DateTime date,
    TimeOfDay time,
  ) {
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Confirm Booking'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expert: ${expert['name']}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text('Date: $formattedDate'),
          Text('Time: $formattedTime'),
          const SizedBox(height: 8),
          Text('Price: ${expert['price']}'),
          const SizedBox(height: 16),
          Text(
            'Are you sure you want to book this consultation?',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Confirm', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Future<void> _submitBooking(
    Map<String, dynamic> expert,
    DateTime date,
    TimeOfDay time,
  ) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2E7D32),
        ),
      ),
    );

    try {
      // Combine date and time
      final bookingDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_email': widget.userEmail,
          'expert_id': expert['id'],
          'expert_name': expert['name'],
          'expert_title': expert['title'],
          'specialization': expert['specialization'],
          'price': expert['price'],
          'booking_date': bookingDateTime.toIso8601String(),
          'status': 'pending',
        }),
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Booking successful: ${data['booking_id']}');
        
        // Refresh bookings count
        await _fetchBookingsCount();
        
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Consultation booked with ${expert['name']}!'),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF2E7D32),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Show success dialog with booking details
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Booking Confirmed!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your consultation with ${expert['name']} has been booked.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Booking ID: ${data['booking_id']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showMyBookings();
                  },
                  child: const Text('View Bookings'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Done', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception('Booking failed: ${response.body}');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.pop(context);
      
      print('❌ Error booking consultation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Failed to book consultation: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showMyBookings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyBookingsPage(userEmail: widget.userEmail),
      ),
    ).then((_) => _fetchBookingsCount()); // Refresh count when returning
  }

  void _filterExperts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredExperts = _experts;
      } else {
        _filteredExperts = _experts.where((expert) {
          final name = expert['name'].toString().toLowerCase();
          final title = expert['title'].toString().toLowerCase();
          final specialization = expert['specialization'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          
          return name.contains(searchLower) ||
                 title.contains(searchLower) ||
                 specialization.contains(searchLower);
        }).toList();
      }
    });
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green[100]!;
      case 'busy':
        return Colors.yellow[100]!;
      case 'offline':
        return Colors.grey[300]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green[700]!;
      case 'busy':
        return Colors.yellow[700]!;
      case 'offline':
        return Colors.grey[700]!;
      default:
        return Colors.grey[600]!;
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
              _buildHeader(context),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2E7D32),
                        ),
                      )
                    : _filteredExperts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_off_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No experts found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _fetchExperts,
                                  child: const Text('Refresh'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchExperts,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: _filteredExperts.length,
                              itemBuilder: (context, index) {
                                final expert = _filteredExperts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildExpertCard(expert),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 12),
              const Text(
                '👨‍🌾',
                style: TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              const Text(
                'Find Experts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              // Bookings Badge
              GestureDetector(
                onTap: _showMyBookings,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF2E7D32),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      if (_loadingBookings)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2E7D32),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _bookingsCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterExperts,
                    decoration: const InputDecoration(
                      hintText: 'Search by name or speciality',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                  onPressed: () => _filterExperts(_searchController.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                    _fetchExperts();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertCard(Map<String, dynamic> expert) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getInitials(expert['name']),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expert['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${expert['title']} • ${expert['experience']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(expert['status']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  expert['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getStatusTextColor(expert['status']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < expert['rating'].floor() ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                  size: 18,
                );
              }),
              const SizedBox(width: 8),
              Text(
                expert['rating'].toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${expert['reviews']} reviews)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            expert['specialization'],
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                expert['price'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                expert['features'],
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _bookConsultation(expert),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Book Consultation',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// ============================================================================
// MY BOOKINGS PAGE - Separate page for viewing all bookings
// ============================================================================

class MyBookingsPage extends StatefulWidget {
  final String userEmail;
  
  const MyBookingsPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final String _baseUrl = 'http://127.0.0.1:8000';
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;
  String _selectedTab = 'All';

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() => _isLoading = true);

    try {
      final url = _selectedTab == 'All'
          ? '$_baseUrl/bookings?user_email=${widget.userEmail}'
          : '$_baseUrl/bookings?user_email=${widget.userEmail}&status=${_selectedTab.toLowerCase()}';
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _bookings = List<Map<String, dynamic>>.from(data['bookings']);
          _isLoading = false;
        });
        print('✅ Loaded ${_bookings.length} bookings');
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print('❌ Error fetching bookings: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading bookings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cancelBooking(String bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/bookings/$bookingId'),
      );

      if (response.statusCode == 200) {
        await _fetchBookings();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking cancelled successfully'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        throw Exception('Failed to cancel booking');
      }
    } catch (e) {
      print('❌ Error cancelling booking: $e');
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
      case 'pending':
        return Colors.orange[100]!;
      case 'confirmed':
        return Colors.blue[100]!;
      case 'completed':
        return Colors.green[100]!;
      case 'cancelled':
        return Colors.red[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[700]!;
      case 'confirmed':
        return Colors.blue[700]!;
      case 'completed':
        return Colors.green[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _formatDateTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final day = date.day;
      final month = months[date.month - 1];
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      
      return '$day $month $year at $hour:$minute';
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: ['All', 'Pending', 'Confirmed', 'Completed', 'Cancelled']
                    .map((tab) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(tab),
                            selected: _selectedTab == tab,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedTab = tab);
                                _fetchBookings();
                              }
                            },
                            selectedColor: const Color(0xFF2E7D32),
                            labelStyle: TextStyle(
                              color: _selectedTab == tab
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2E7D32),
                    ),
                  )
                : _bookings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No bookings found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _fetchBookings,
                              child: const Text('Refresh'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchBookings,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _bookings.length,
                          itemBuilder: (context, index) {
                            final booking = _bookings[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildBookingCard(booking),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] as String;
    final canCancel = status.toLowerCase() == 'pending' || 
                      status.toLowerCase() == 'confirmed';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  color: _getStatusTextColor(status),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusTextColor(status),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${booking['booking_id']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: _getStatusTextColor(status).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expert info
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(booking['expert_name']),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['expert_name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking['expert_title'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                
                // Details
                _buildDetailRow(
                  Icons.medical_services_outlined,
                  'Specialization',
                  booking['specialization'],
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.calendar_today_outlined,
                  'Appointment',
                  _formatDateTime(booking['booking_date']),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.payments_outlined,
                  'Fee',
                  booking['price'],
                ),
                
                if (canCancel) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _cancelBooking(booking['booking_id']),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancel Booking'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }
}