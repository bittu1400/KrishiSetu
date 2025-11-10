import 'package:flutter/material.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({Key? key}) : super(key: key);

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select a Calculator',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Tools Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                        children: [
                          _buildToolCard(
                            context,
                            icon: '🌾',
                            title: 'Seed Calculator',
                            description: 'Calculate seed\nquantity needed',
                            color: const Color(0xFFFF6B6B),
                            onTap: () => _navigateToCalculator(context, 'seed'),
                          ),
                          _buildToolCard(
                            context,
                            icon: '🧪',
                            title: 'Fertilizer Calculator',
                            description: 'NPK dosage\ncalculation',
                            color: const Color(0xFF4ECDC4),
                            onTap: () => _navigateToCalculator(context, 'fertilizer'),
                          ),
                          _buildToolCard(
                            context,
                            icon: '💧',
                            title: 'Irrigation Calculator',
                            description: 'Water requirement\nestimation',
                            color: const Color(0xFF45B7D1),
                            onTap: () => _navigateToCalculator(context, 'irrigation'),
                          ),
                          _buildToolCard(
                            context,
                            icon: '📅',
                            title: 'Harvest Estimator',
                            description: 'Predict harvest\ndate',
                            color: const Color(0xFFFFA07A),
                            onTap: () => _navigateToCalculator(context, 'harvest'),
                          ),
                          _buildToolCard(
                            context,
                            icon: '💰',
                            title: 'Profit Calculator',
                            description: 'Calculate expected\nprofit',
                            color: const Color(0xFF98D8C8),
                            onTap: () => _navigateToCalculator(context, 'profit'),
                          ),
                          _buildToolCard(
                            context,
                            icon: '🦠',
                            title: 'Pesticide Guide',
                            description: 'Safe dosage\nrecommendations',
                            color: const Color(0xFFFFB6B9),
                            onTap: () => _navigateToCalculator(context, 'pesticide'),
                          ),
                        ],
                      ),
                    ],
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
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          const Text(
            '🔧',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          const Text(
            'Farming Tools',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                icon,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCalculator(BuildContext context, String type) {
    Widget calculator;
    
    switch (type) {
      case 'seed':
        calculator = const SeedCalculator();
        break;
      case 'fertilizer':
        calculator = const FertilizerCalculator();
        break;
      case 'irrigation':
        calculator = const IrrigationCalculator();
        break;
      case 'harvest':
        calculator = const HarvestEstimator();
        break;
      case 'profit':
        calculator = const ProfitCalculator();
        break;
      case 'pesticide':
        calculator = const PesticideGuide();
        break;
      default:
        calculator = const SeedCalculator();
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => calculator),
    );
  }
}

// ============ SEED CALCULATOR ============
class SeedCalculator extends StatefulWidget {
  const SeedCalculator({Key? key}) : super(key: key);

  @override
  State<SeedCalculator> createState() => _SeedCalculatorState();
}

class _SeedCalculatorState extends State<SeedCalculator> {
  final _areaController = TextEditingController();
  String _selectedCrop = 'Rice';
  String _result = '';

  final Map<String, double> seedRates = {
    'Rice': 30.0, // kg per bigha
    'Wheat': 40.0,
    'Maize': 8.0,
    'Potato': 200.0,
    'Tomato': 0.15,
    'Onion': 4.0,
    'Cabbage': 0.2,
    'Cauliflower': 0.25,
  };

  void _calculate() {
    final area = double.tryParse(_areaController.text);
    if (area == null || area <= 0) {
      setState(() {
        _result = 'Please enter a valid area';
      });
      return;
    }

    final rate = seedRates[_selectedCrop] ?? 0;
    final totalSeed = area * rate;

    setState(() {
      _result = 'You need approximately ${totalSeed.toStringAsFixed(2)} kg of $_selectedCrop seeds for $area bigha';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seed Calculator'),
        backgroundColor: const Color(0xFF66BB6A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate Seed Quantity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Land Area (Bigha)',
                hintText: 'Enter area in bigha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.landscape),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              decoration: InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.grass),
              ),
              items: seedRates.keys.map((crop) {
                return DropdownMenuItem(value: crop, child: Text(crop));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _result,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }
}

// ============ FERTILIZER CALCULATOR ============
class FertilizerCalculator extends StatefulWidget {
  const FertilizerCalculator({Key? key}) : super(key: key);

  @override
  State<FertilizerCalculator> createState() => _FertilizerCalculatorState();
}

class _FertilizerCalculatorState extends State<FertilizerCalculator> {
  final _areaController = TextEditingController();
  String _selectedCrop = 'Rice';
  Map<String, double> _result = {};

  final Map<String, Map<String, double>> fertilizerRates = {
    'Rice': {'Urea': 20.0, 'DAP': 15.0, 'Potash': 10.0},
    'Wheat': {'Urea': 25.0, 'DAP': 18.0, 'Potash': 12.0},
    'Maize': {'Urea': 30.0, 'DAP': 20.0, 'Potash': 15.0},
    'Potato': {'Urea': 35.0, 'DAP': 25.0, 'Potash': 20.0},
    'Tomato': {'Urea': 25.0, 'DAP': 20.0, 'Potash': 18.0},
  };

  void _calculate() {
    final area = double.tryParse(_areaController.text);
    if (area == null || area <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid area')),
      );
      return;
    }

    final rates = fertilizerRates[_selectedCrop] ?? {};
    final calculatedResult = <String, double>{};
    
    rates.forEach((fertilizer, ratePerBigha) {
      calculatedResult[fertilizer] = area * ratePerBigha;
    });

    setState(() {
      _result = calculatedResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertilizer Calculator'),
        backgroundColor: const Color(0xFF66BB6A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate Fertilizer Requirements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Land Area (Bigha)',
                hintText: 'Enter area in bigha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.landscape),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              decoration: InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.eco),
              ),
              items: fertilizerRates.keys.map((crop) {
                return DropdownMenuItem(value: crop, child: Text(crop));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            if (_result.isNotEmpty) ...[
              const Text(
                'Required Fertilizers:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ..._result.entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${entry.value.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }
}

// ============ IRRIGATION CALCULATOR ============
class IrrigationCalculator extends StatefulWidget {
  const IrrigationCalculator({Key? key}) : super(key: key);

  @override
  State<IrrigationCalculator> createState() => _IrrigationCalculatorState();
}

class _IrrigationCalculatorState extends State<IrrigationCalculator> {
  final _areaController = TextEditingController();
  String _selectedCrop = 'Rice';
  String _selectedSeason = 'Summer';
  String _result = '';

  final Map<String, Map<String, double>> waterRequirements = {
    'Rice': {'Summer': 1500.0, 'Winter': 1200.0, 'Monsoon': 800.0},
    'Wheat': {'Summer': 450.0, 'Winter': 350.0, 'Monsoon': 300.0},
    'Maize': {'Summer': 600.0, 'Winter': 500.0, 'Monsoon': 400.0},
    'Potato': {'Summer': 500.0, 'Winter': 400.0, 'Monsoon': 350.0},
    'Tomato': {'Summer': 700.0, 'Winter': 600.0, 'Monsoon': 500.0},
  };

  void _calculate() {
    final area = double.tryParse(_areaController.text);
    if (area == null || area <= 0) {
      setState(() {
        _result = 'Please enter a valid area';
      });
      return;
    }

    final waterPerBigha = waterRequirements[_selectedCrop]?[_selectedSeason] ?? 0;
    final totalWater = area * waterPerBigha;
    final liters = totalWater * 1000;

    setState(() {
      _result = 'Water needed: ${totalWater.toStringAsFixed(0)} cubic meters (${liters.toStringAsFixed(0)} liters) for the entire growing season';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigation Calculator'),
        backgroundColor: const Color(0xFF66BB6A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate Water Requirements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Land Area (Bigha)',
                hintText: 'Enter area in bigha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.landscape),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              decoration: InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.eco),
              ),
              items: waterRequirements.keys.map((crop) {
                return DropdownMenuItem(value: crop, child: Text(crop));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedSeason,
              decoration: InputDecoration(
                labelText: 'Select Season',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.wb_sunny),
              ),
              items: ['Summer', 'Winter', 'Monsoon'].map((season) {
                return DropdownMenuItem(value: season, child: Text(season));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSeason = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blue, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _result,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }
}

// ============ HARVEST ESTIMATOR ============
class HarvestEstimator extends StatefulWidget {
  const HarvestEstimator({Key? key}) : super(key: key);

  @override
  State<HarvestEstimator> createState() => _HarvestEstimatorState();
}

class _HarvestEstimatorState extends State<HarvestEstimator> {
  DateTime _plantingDate = DateTime.now();
  String _selectedCrop = 'Rice';
  String _result = '';

  final Map<String, int> growingDays = {
    'Rice': 120,
    'Wheat': 120,
    'Maize': 90,
    'Potato': 90,
    'Tomato': 70,
    'Onion': 120,
    'Cabbage': 80,
    'Cauliflower': 75,
  };

  void _calculate() {
    final days = growingDays[_selectedCrop] ?? 0;
    final harvestDate = _plantingDate.add(Duration(days: days));
    
    setState(() {
      _result = 'Expected harvest date: ${harvestDate.day}/${harvestDate.month}/${harvestDate.year}\n\nGrowing period: $days days';
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _plantingDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harvest Estimator'),
        backgroundColor: const Color(0xFF66BB6A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estimate Harvest Date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Planting Date: ${_plantingDate.day}/${_plantingDate.month}/${_plantingDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              decoration: InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.eco),
              ),
              items: growingDays.keys.map((crop) {
                return DropdownMenuItem(value: crop, child: Text(crop));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Estimate',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.orange, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _result,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============ PROFIT CALCULATOR ============
class ProfitCalculator extends StatefulWidget {
  const ProfitCalculator({Key? key}) : super(key: key);

  @override
  State<ProfitCalculator> createState() => _ProfitCalculatorState();
}

class _ProfitCalculatorState extends State<ProfitCalculator> {
  final _areaController = TextEditingController();
  final _costController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCrop = 'Rice';
  Map<String, dynamic> _result = {};

  final Map<String, double> yieldPerBigha = {
    'Rice': 400.0, // kg
    'Wheat': 350.0,
    'Maize': 450.0,
    'Potato': 2500.0,
    'Tomato': 2000.0,
  };

  void _calculate() {
    final area = double.tryParse(_areaController.text);
    final costPerBigha = double.tryParse(_costController.text);
    final pricePerKg = double.tryParse(_priceController.text);

    if (area == null || costPerBigha == null || pricePerKg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields with valid numbers')),
      );
      return;
    }

    final yieldKg = (yieldPerBigha[_selectedCrop] ?? 0) * area;
    final totalRevenue = yieldKg * pricePerKg;
    final totalCost = costPerBigha * area;
    final profit = totalRevenue - totalCost;

    setState(() {
      _result = {
        'yield': yieldKg,
        'revenue': totalRevenue,
        'cost': totalCost,
        'profit': profit,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Calculator'),
        backgroundColor: const Color(0xFF66BB6A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate Expected Profit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Land Area (Bigha)',
                hintText: 'Enter area in bigha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.landscape),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              decoration: InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.eco),
              ),
              items: yieldPerBigha.keys.map((crop) {
                return DropdownMenuItem(value: crop, child: Text(crop));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cost per Bigha (NPR)',
                hintText: 'Enter total cost per bigha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.money_off),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Selling Price per Kg (NPR)',
                hintText: 'Enter price per kg',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Calculate Profit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            if (_result.isNotEmpty) ...[
              const Text(
                'Results:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildResultCard(
                'Expected Yield',
                '${_result['yield'].toStringAsFixed(0)} kg',
                Colors.blue,
              ),
              const SizedBox(height: 12),
              
              _buildResultCard(
                'Total Revenue',
                'NPR ${_result['revenue'].toStringAsFixed(2)}',
                Colors.green,
              ),
              const SizedBox(height: 12),
              
              _buildResultCard(
                'Total Cost',
                'NPR ${_result['cost'].toStringAsFixed(2)}',
                Colors.orange,
              ),
              const SizedBox(height: 12),
              
              _buildResultCard(
                'Net Profit',
                'NPR ${_result['profit'].toStringAsFixed(2)}',
                _result['profit'] >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _areaController.dispose();
    _costController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}

// ============ PESTICIDE GUIDE ============
class PesticideGuide extends StatefulWidget {
  const PesticideGuide({Key? key}) : super(key: key);

  @override
  State<PesticideGuide> createState() => _PesticideGuideState();
}

class _PesticideGuideState extends State<PesticideGuide> {
  String _selectedCrop = 'Rice';
  String _selectedPest = 'Insects';
  
  final Map<String, Map<String, Map<String, String>>> pesticideData = {
    'Rice': {
      'Insects': {
        'name': 'Chlorpyrifos 20% EC',
        'dosage': '2 ml per liter of water',
        'timing': 'Apply when pest is observed',
        'safety': 'Wear protective gear. Wait 15 days before harvest',
      },
      'Fungal Disease': {
        'name': 'Carbendazim 50% WP',
        'dosage': '1 gram per liter of water',
        'timing': 'Apply at disease onset',
        'safety': 'Avoid spray during flowering. PHI: 7 days',
      },
    },
    'Wheat': {
      'Insects': {
        'name': 'Cypermethrin 10% EC',
        'dosage': '1.5 ml per liter of water',
        'timing': 'Apply during tillering stage',
        'safety': 'Do not spray during windy conditions',
      },
      'Fungal Disease': {
        'name': 'Propiconazole 25% EC',
        'dosage': '1 ml per liter of water',
        'timing': 'Preventive application recommended',
        'safety': 'PHI: 10 days. Toxic to fish',
      },
    },
    'Potato': {
      'Insects': {
        'name': 'Imidacloprid 17.8% SL',
        'dosage': '0.5 ml per liter of water',
        'timing': 'Apply when aphids appear',
        'safety': 'Highly toxic to bees. Evening application preferred',
      },
      'Fungal Disease': {
        'name': 'Mancozeb 75% WP',
        'dosage': '2.5 gram per liter of water',
        'timing': 'Start before disease appearance',
        'safety': 'PHI: 7 days. Wear mask during application',
      },
    },
    'Tomato': {
      'Insects': {
        'name': 'Spinosad 45% SC',
        'dosage': '0.5 ml per liter of water',
        'timing': 'Apply at early infestation stage',
        'safety': 'Organic certified. Safe for beneficial insects',
      },
      'Fungal Disease': {
        'name': 'Copper Oxychloride 50% WP',
        'dosage': '3 gram per liter of water',
        'timing': 'Weekly application during humid weather',
        'safety': 'PHI: 3 days. Avoid mixing with alkaline products',
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    final recommendation = pesticideData[_selectedCrop]?[_selectedPest];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesticide Guide'),
        backgroundColor: const Color(0xFF66BB6A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get Pesticide Recommendations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              decoration: InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.eco),
              ),
              items: pesticideData.keys.map((crop) {
                return DropdownMenuItem(value: crop, child: Text(crop));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value!;
                  _selectedPest = 'Insects'; // Reset to default
                });
              },
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedPest,
              decoration: InputDecoration(
                labelText: 'Select Problem Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.bug_report),
              ),
              items: ['Insects', 'Fungal Disease'].map((pest) {
                return DropdownMenuItem(value: pest, child: Text(pest));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPest = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            if (recommendation != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
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
                    Row(
                      children: const [
                        Icon(Icons.recommend, color: Color(0xFF2E7D32)),
                        SizedBox(width: 8),
                        Text(
                          'Recommended Pesticide',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildInfoRow('Product', recommendation['name']!),
                    const Divider(height: 24),
                    
                    _buildInfoRow('Dosage', recommendation['dosage']!),
                    const Divider(height: 24),
                    
                    _buildInfoRow('Application Timing', recommendation['timing']!),
                    const Divider(height: 24),
                    
                    const Text(
                      'Safety Precautions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              recommendation['safety']!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.lightbulb, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'General Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('• Always read the product label before use'),
                    const Text('• Store pesticides in original containers'),
                    const Text('• Keep away from children and animals'),
                    const Text('• Dispose of empty containers properly'),
                    const Text('• Never spray near water sources'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}