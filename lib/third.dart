import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'fifth.dart'; // User dashboard
import 'expert_dashboard.dart'; // Expert dashboard
import 'second.dart'; // Create account screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _loginType = 'User'; // 'User' or 'Expert'
  final String _baseUrl = 'http://127.0.0.1:8000';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Determine endpoint based on login type
        final endpoint = _loginType == 'User' ? '/login' : '/expert/login';
        
        final response = await http.post(
          Uri.parse('$_baseUrl$endpoint'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'identifier': _emailController.text.trim(),
            'password': _passwordController.text,
          }),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          if (_loginType == 'User') {
            // User login successful
            final userData = data['user'];
            print('✅ User login successful: ${userData['name']}');
            
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => CropDashboard(
                    userData: {
                      'name': userData['name'],
                      'email': userData['email'],
                      'phone': userData['phone'],
                      'city': userData['city'],
                    },
                  ),
                ),
              );
            }
          } else {
            // Expert login successful
            final expertData = data['expert'];
            print('✅ Expert login successful: ${expertData['name']}');
            
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpertDashboardScreen(expertData: expertData),
                ),
              );
            }
          }
        } else {
          // Handle login failure
          final error = jsonDecode(response.body)['detail'] ?? 'Invalid credentials';
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ $error'),
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
              content: Text('Network error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
        print('❌ Login error: $e');
      }
    }
  }

  void _navigateToCreateAccount() {
    if (_loginType == 'Expert') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ExpertRegistrationScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CreateAccountScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade300,
                        Colors.grey.shade500,
                        Colors.grey.shade300,
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),
                
                const Center(
                  child: Icon(
                    Icons.eco,
                    size: 60,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                const Center(
                  child: Text(
                    'KrishiSetu',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Center(
                  child: Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Login Type Selector
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLoginTypeButton('User', Icons.person),
                        _buildLoginTypeButton('Expert', Icons.verified_user),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                const Text(
                  'Email or Phone Number',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'your@email.com or +977-9800000000',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
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
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
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
                        : Text(
                            'Login as $_loginType',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Center(
                  child: TextButton(
                    onPressed: _navigateToCreateAccount,
                    child: Text(
                      _loginType == 'Expert' 
                          ? 'New Expert? Register Here'
                          : 'New to KrishiSetu? Create Account',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTypeButton(String type, IconData icon) {
    final isSelected = _loginType == type;
    return GestureDetector(
      onTap: () {
        setState(() => _loginType = type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}