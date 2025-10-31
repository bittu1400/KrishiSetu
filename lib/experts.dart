// import 'package:flutter/material.dart';

// class ExpertsPage extends StatefulWidget {
//   const ExpertsPage({Key? key}) : super(key: key);

//   @override
//   State<ExpertsPage> createState() => _ExpertsPageState();
// }

// class _ExpertsPageState extends State<ExpertsPage> {
//   String _selectedFilter = 'All';
//   final TextEditingController _searchController = TextEditingController();

//   final List<String> _filters = ['All', 'Crop Disease', 'Nutrition', 'Organic'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF66BB6A), Color(0xFFF5F5F5)],
//             stops: [0.0, 0.3],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context),
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.all(20),
//                   children: [
//                     _buildExpertCard(
//                       initials: 'RP',
//                       name: 'Dr. Ram Prasad Rijal',
//                       title: 'Plant Pathologist',
//                       experience: '12 years experience',
//                       rating: 4.9,
//                       reviews: 156,
//                       specialization: 'Specializes in tomato, potato diseases',
//                       price: 'NPR 500/consultation',
//                       features: 'Video call available',
//                       status: 'Available',
//                       statusColor: Colors.green[100]!,
//                       statusTextColor: Colors.green[700]!,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildExpertCard(
//                       initials: 'MP',
//                       name: 'Dr. Maya Poudel',
//                       title: 'Soil & Nutrition Expert',
//                       experience: '15 years experience',
//                       rating: 4.7,
//                       reviews: 203,
//                       specialization: 'Soil testing & fertilizer recommendations',
//                       price: 'NPR 600/consultation',
//                       features: 'Video + Report',
//                       status: 'Busy',
//                       statusColor: Colors.yellow[100]!,
//                       statusTextColor: Colors.yellow[700]!,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 '👨‍🌾',
//                 style: TextStyle(fontSize: 28),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Find Experts',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       hintText: 'Search by name or speciality',
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: IconButton(
//                   icon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
//                   onPressed: () {},
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: 36,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: _filters.length,
//               separatorBuilder: (context, index) => const SizedBox(width: 8),
//               itemBuilder: (context, index) {
//                 final filter = _filters[index];
//                 final isSelected = _selectedFilter == filter;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedFilter = filter;
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         filter,
//                         style: TextStyle(
//                           color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExpertCard({
//     required String initials,
//     required String name,
//     required String title,
//     required String experience,
//     required double rating,
//     required int reviews,
//     required String specialization,
//     required String price,
//     required String features,
//     required String status,
//     required Color statusColor,
//     required Color statusTextColor,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF2E7D32),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     initials,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '$title • $experience',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: statusTextColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               ...List.generate(5, (index) {
//                 return const Icon(
//                   Icons.star,
//                   color: Colors.orange,
//                   size: 18,
//                 );
//               }),
//               const SizedBox(width: 8),
//               Text(
//                 rating.toString(),
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 '($reviews reviews)',
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             specialization,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Text(
//                 price,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF2E7D32),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 '•',
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey[400],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 features,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Color(0xFF2E7D32),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2E7D32),
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 0,
//               ),
//               child: const Text(
//                 'Book Consultation',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpertsPage extends StatefulWidget {
  const ExpertsPage({Key? key}) : super(key: key);

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

  final List<String> _filters = ['All', 'Crop Disease', 'Nutrition', 'Organic'];

  @override
  void initState() {
    super.initState();
    _fetchExperts();
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
              onPressed: () {
                // TODO: Implement booking functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking ${expert['name']}...'),
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                );
              },
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