import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'fifth.dart'; // Import CropDashboard
import 'third.dart'; // Import third.dart

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isSignUp;
  final Map<String, dynamic>? userData;

  const OTPVerificationScreen({
    Key? key,
    required this.phoneNumber,
    this.isSignUp = false,
    this.userData,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isOTPComplete = false;
  int _secondsRemaining = 30;
  bool _canResend = false;
  late Timer _timer;
  final String _baseUrl = 'http://127.0.0.1:8000'; // Configurable base URL

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _sendOTP();
  }

  @override
  void dispose() {
    _otpControllers.forEach((c) => c.dispose());
    _focusNodes.forEach((n) => n.dispose());
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _secondsRemaining = 30;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining == 0) {
          _canResend = true;
          timer.cancel();
        } else {
          _secondsRemaining--;
        }
      });
    });
  }

  Future<void> _sendOTP() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"phone": widget.phoneNumber}),
      );
      if (response.statusCode != 200) {
        print('Failed to send OTP: ${response.body}');
      }
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;
    await _sendOTP();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _startCountdown();
    }
  }

  void _onOTPDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    String otp = _otpControllers.map((c) => c.text).join();
    setState(() {
      _isOTPComplete = otp.length == 6;
    });
    if (_isOTPComplete) _verifyOTP();
  }

  Future<void> _verifyOTP() async {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) return;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"identifier": widget.phoneNumber, "otp": otp}),
      );

      if (response.statusCode == 200) {
        if (widget.isSignUp && widget.userData != null) {
          final registerResponse = await http.post(
            Uri.parse('$_baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(widget.userData),
          );
          if (registerResponse.statusCode != 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed: ${registerResponse.body}'), backgroundColor: Colors.red),
            );
            return;
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP Verified Successfully!'), backgroundColor: Colors.green),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => CropDashboard(userData: widget.userData ?? {})),
            (route) => false,
          );
        }
      } else {
        final error = jsonDecode(response.body)['detail'] ?? 'Invalid OTP';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e'), backgroundColor: Colors.red),
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
              const Text('OTP Verification', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(height: 2, width: 200, color: Colors.grey.shade500),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.lock_outline, size: 60, color: Color(0xFF4CAF50)),
              ),
              const SizedBox(height: 30),
              Text('Enter the verification code we just sent to', style: TextStyle(color: Colors.grey.shade700)),
              Text(widget.phoneNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => _onOTPDigitChanged(value, index),
                  ),
                )),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive code? ", style: TextStyle(color: Colors.grey.shade700)),
                  TextButton(
                    onPressed: _canResend ? _resendOTP : null,
                    child: Text(
                      _canResend ? 'Resend' : 'Resend ($_secondsRemaining s)',
                      style: TextStyle(color: _canResend ? const Color(0xFF4CAF50) : Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isOTPComplete ? _verifyOTP : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isOTPComplete ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text('Verify OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}