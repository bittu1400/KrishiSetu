import 'package:flutter/material.dart';

class ExpertsPage extends StatefulWidget {
  const ExpertsPage({Key? key}) : super(key: key);

  @override
  State<ExpertsPage> createState() => _ExpertsPageState();
}

class _ExpertsPageState extends State<ExpertsPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Crop Disease', 'Nutrition', 'Organic'];

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
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildExpertCard(
                      initials: 'RP',
                      name: 'Dr. Ram Prasad Rijal',
                      title: 'Plant Pathologist',
                      experience: '12 years experience',
                      rating: 4.9,
                      reviews: 156,
                      specialization: 'Specializes in tomato, potato diseases',
                      price: 'NPR 500/consultation',
                      features: 'Video call available',
                      status: 'Available',
                      statusColor: Colors.green[100]!,
                      statusTextColor: Colors.green[700]!,
                    ),
                    const SizedBox(height: 16),
                    _buildExpertCard(
                      initials: 'MP',
                      name: 'Dr. Maya Poudel',
                      title: 'Soil & Nutrition Expert',
                      experience: '15 years experience',
                      rating: 4.7,
                      reviews: 203,
                      specialization: 'Soil testing & fertilizer recommendations',
                      price: 'NPR 600/consultation',
                      features: 'Video + Report',
                      status: 'Busy',
                      statusColor: Colors.yellow[100]!,
                      statusTextColor: Colors.yellow[700]!,
                    ),
                  ],
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
                  onPressed: () {},
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

  Widget _buildExpertCard({
    required String initials,
    required String name,
    required String title,
    required String experience,
    required double rating,
    required int reviews,
    required String specialization,
    required String price,
    required String features,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
  }) {
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
                    initials,
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
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$title • $experience',
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
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(5, (index) {
                return const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 18,
                );
              }),
              const SizedBox(width: 8),
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($reviews reviews)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            specialization,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                price,
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
                features,
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
              onPressed: () {},
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