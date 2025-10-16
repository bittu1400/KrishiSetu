// import 'package:flutter/material.dart';
// import 'fourth.dart';
// import 'second.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneEmailController = TextEditingController();
//   final _pinController = TextEditingController();
//   bool _obscurePin = true;

//   @override
//   void dispose() {
//     _phoneEmailController.dispose();
//     _pinController.dispose();
//     super.dispose();
//   }

//   void _sendOTP() {
//     if (_formKey.currentState!.validate()) {
//       print('Sending OTP to: ${_phoneEmailController.text}');
      
//       // Navigate to OTP verification screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OTPVerificationScreen(
//             phoneNumber: _phoneEmailController.text,
//             isSignUp: false,
//           ),
//         ),
//       );
//     }
//   }

//   void _forgotPin() {
//     print('Forgot PIN clicked');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Password reset link sent!')),
//     );
//   }

//   void _navigateToCreateAccount() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F1ED),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
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
//                   child: Text(
//                     'Welcome Back',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 8),
                
//                 Container(
//                   height: 2,
//                   margin: const EdgeInsets.symmetric(horizontal: 40),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.grey.shade300,
//                         Colors.grey.shade500,
//                         Colors.grey.shade300,
//                       ],
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 80),
                
//                 const Center(
//                   child: Icon(
//                     Icons.eco,
//                     size: 60,
//                     color: Color(0xFF4CAF50),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
                
//                 const Center(
//                   child: Text(
//                     'KrishiSetu',
//                     style: TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2E7D32),
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 8),
                
//                 const Center(
//                   child: Text(
//                     'Sign in to continue',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 50),
                
//                 const Text(
//                   'Phone Number or Email',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _phoneEmailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     hintText: '+977-XXXXXXXXXX',
//                     hintStyle: TextStyle(color: Colors.grey.shade600),
//                     filled: true,
//                     fillColor: Colors.grey.shade300,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.all(16),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter your phone number or email';
//                     }
//                     return null;
//                   },
//                 ),
                
//                 const SizedBox(height: 20),
                
//                 const Text(
//                   'PIN',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _pinController,
//                   obscureText: _obscurePin,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: 'Enter your PIN',
//                     hintStyle: TextStyle(color: Colors.grey.shade600),
//                     filled: true,
//                     fillColor: Colors.grey.shade300,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                     // After the divider line, you should add:
//                     const SizedBox(height: 60),

//                     const Center(
//                       child: Icon(
//                         Icons.eco,
//                         size: 60,
//                         color: Color(0xFF4CAF50),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     const Center(
//                       child: Text(
//                         'Join KrishiSetu',
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2E7D32),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     const Center(
//                       child: Text(
//                         'Start your smart farming journey',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     contentPadding: const EdgeInsets.all(16),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePin ? Icons.visibility_off : Icons.visibility,
//                         color: Colors.grey.shade600,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePin = !_obscurePin;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter your PIN';
//                     }
//                     return null;
//                   },
//                 ),
                
//                 const SizedBox(height: 50),
                
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _sendOTP,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF4CAF50),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: const Text(
//                       'Send OTP',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
                
//                 Center(
//                   child: TextButton(
//                     onPressed: _forgotPin,
//                     child: const Text(
//                       'Forget PIN?',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 10),
                
//                 Center(
//                   child: TextButton(
//                     onPressed: _navigateToCreateAccount,
//                     child: const Text(
//                       'New to KrishiSetu? Create Account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'fourth.dart';
import 'second.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneEmailController = TextEditingController();
  final _pinController = TextEditingController();
  bool _obscurePin = true;

  @override
  void dispose() {
    _phoneEmailController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _sendOTP() {
    if (_formKey.currentState!.validate()) {
      print('Sending OTP to: ${_phoneEmailController.text}');
      
      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: _phoneEmailController.text,
            isSignUp: false,
          ),
        ),
      );
    }
  }

  void _forgotPin() {
    print('Forgot PIN clicked');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset link sent!')),
    );
  }

  void _navigateToCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
    );
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
                
                const SizedBox(height: 80),
                
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
                
                const SizedBox(height: 50),
                
                const Text(
                  'Phone Number or Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: '+977-XXXXXXXXXX',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number or email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'PIN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pinController,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter your PIN',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePin ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePin = !_obscurePin;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your PIN';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 50),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Center(
                  child: TextButton(
                    onPressed: _forgotPin,
                    child: const Text(
                      'Forget PIN?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                Center(
                  child: TextButton(
                    onPressed: _navigateToCreateAccount,
                    child: const Text(
                      'New to KrishiSetu? Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
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
}