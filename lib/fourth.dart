// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'fifth.dart'; // Import the dashboard

// class OTPVerificationScreen extends StatefulWidget {
//   final String phoneNumber;
//   final bool isSignUp;

//   const OTPVerificationScreen({
//     Key? key,
//     required this.phoneNumber,
//     this.isSignUp = false,
//   }) : super(key: key);

//   @override
//   State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
// }

// class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
//   final List<TextEditingController> _otpControllers =
//       List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

//   bool _isOTPComplete = false;
//   int _secondsRemaining = 30;
//   bool _canResend = false;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startCountdown();
//   }

//   @override
//   void dispose() {
//     for (var controller in _otpControllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     _timer.cancel();
//     super.dispose();
//   }

//   void _onOTPDigitChanged(String value, int index) {
//     if (value.isNotEmpty && index < 5) {
//       _focusNodes[index + 1].requestFocus();
//     }

//     String otp = _otpControllers.map((c) => c.text).join();
//     setState(() {
//       _isOTPComplete = otp.length == 6;
//     });
//   }

//   void _onOTPDigitDeleted(int index) {
//     if (index > 0) {
//       _focusNodes[index - 1].requestFocus();
//     }
//   }

//   void _startCountdown() {
//     setState(() {
//       _secondsRemaining = 30;
//       _canResend = false;
//     });

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_secondsRemaining == 0) {
//         setState(() {
//           _canResend = true;
//         });
//         _timer.cancel();
//       } else {
//         setState(() {
//           _secondsRemaining--;
//         });
//       }
//     });
//   }

//   void _resendOTP() async {
//     if (!_canResend) return;

//     try {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:8000/send-otp'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "phone": widget.phoneNumber,
//         }),
//       );

//       if (response.statusCode == 200) {
//         print('Resending OTP to: ${widget.phoneNumber}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('OTP sent successfully!')),
//         );
//         _startCountdown();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to resend OTP: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error resending OTP: $e')),
//       );
//     }
//   }

//   Future<void> _verifyOTP() async {
//     String otp = _otpControllers.map((c) => c.text).join();
//     if (otp.length != 6) return;

//     try {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:8000/verify-otp'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "identifier": widget.phoneNumber,
//           "otp": otp,
//         }),
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('OTP Verified Successfully!')),
//         );
        
//         // Navigate to Dashboard (fifth.dart)
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const CropDashboard(),
//           ),
//           (route) => false, // Remove all previous routes
//         );
//       } else {
//         final error = jsonDecode(response.body)['detail'] ?? 'Unknown error';
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(error)));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Network error: $e')),
//       );
//     }
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
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),

//               // Header
//               const Text(
//                 'OTP Verification',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // Divider
//               Container(
//                 height: 2,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.grey.shade300,
//                       Colors.grey.shade500,
//                       Colors.grey.shade300,
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 60),

//               // Icon
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF4CAF50).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.lock_outline,
//                   size: 60,
//                   color: Color(0xFF4CAF50),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // Description
//               Text(
//                 'Enter the verification code we just sent to',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade700,
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // Phone Number
//               Text(
//                 widget.phoneNumber,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2E7D32),
//                 ),
//               ),

//               const SizedBox(height: 50),

//               // OTP Input Fields
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(6, (index) {
//                   return SizedBox(
//                     width: 50,
//                     height: 60,
//                     child: TextField(
//                       controller: _otpControllers[index],
//                       focusNode: _focusNodes[index],
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       maxLength: 1,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       decoration: InputDecoration(
//                         counterText: '',
//                         filled: true,
//                         fillColor: Colors.grey.shade300,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Color(0xFF4CAF50),
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       onChanged: (value) => _onOTPDigitChanged(value, index),
//                       onTap: () {
//                         _otpControllers[index].selection = TextSelection.fromPosition(
//                           TextPosition(offset: _otpControllers[index].text.length),
//                         );
//                       },
//                       onEditingComplete: () {
//                         if (index == 5) {
//                           _verifyOTP();
//                         }
//                       },
//                     ),
//                   );
//                 }),
//               ),

//               const SizedBox(height: 40),

//               // Resend OTP
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Didn't receive code? ",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: _canResend ? _resendOTP : null,
//                     child: Text(
//                       _canResend ? 'Resend' : 'Resend ($_secondsRemaining s)',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: _canResend ? const Color(0xFF4CAF50) : Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 30),

//               // Verify Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isOTPComplete ? _verifyOTP : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         _isOTPComplete ? const Color(0xFF4CAF50) : Colors.grey.shade400,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: const Text(
//                     'Verify OTP',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'fifth.dart'; // Import the dashboard

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isSignUp;
  final Map<String, dynamic>? userData; // Add this to receive user data

  const OTPVerificationScreen({
    Key? key,
    required this.phoneNumber,
    this.isSignUp = false,
    this.userData, // Add this parameter
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isOTPComplete = false;
  int _secondsRemaining = 30;
  bool _canResend = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _sendOTP(); // Automatically send OTP when screen loads
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _onOTPDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    String otp = _otpControllers.map((c) => c.text).join();
    setState(() {
      _isOTPComplete = otp.length == 6;
    });
  }

  void _onOTPDigitDeleted(int index) {
    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<void> _sendOTP() async {
    try {
      // Replace with your actual backend URL
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone": widget.phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        print('OTP sent to: ${widget.phoneNumber}');
      } else {
        print('Failed to send OTP: ${response.body}');
      }
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  void _resendOTP() async {
    if (!_canResend) return;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone": widget.phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        print('Resending OTP to: ${widget.phoneNumber}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _startCountdown();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error resending OTP: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _verifyOTP() async {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) return;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "identifier": widget.phoneNumber,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Verified Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to Dashboard (fifth.dart) with user data
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CropDashboard(
              userData: widget.userData ?? {}, // Pass user data to dashboard
            ),
          ),
          (route) => false, // Remove all previous routes
        );
      } else {
        final error = jsonDecode(response.body)['detail'] ?? 'Invalid OTP';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Header
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              // Divider
              Container(
                height: 2,
                width: 200,
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

              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: Color(0xFF4CAF50),
                ),
              ),

              const SizedBox(height: 30),

              // Description
              Text(
                'Enter the verification code we just sent to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 8),

              // Phone Number
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),

              const SizedBox(height: 50),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4CAF50),
                            width: 2,
                          ),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => _onOTPDigitChanged(value, index),
                      onTap: () {
                        _otpControllers[index].selection = TextSelection.fromPosition(
                          TextPosition(offset: _otpControllers[index].text.length),
                        );
                      },
                      onEditingComplete: () {
                        if (index == 5) {
                          _verifyOTP();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TextButton(
                    onPressed: _canResend ? _resendOTP : null,
                    child: Text(
                      _canResend ? 'Resend' : 'Resend ($_secondsRemaining s)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _canResend ? const Color(0xFF4CAF50) : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isOTPComplete ? _verifyOTP : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isOTPComplete ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}