import 'package:flutter/material.dart';
// 1. Add Firebase Auth import
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  // 2. Add Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // 3. Implement the Reset Password function
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.sendPasswordResetEmail(email: emailController.text.trim());

        // Success: Show a success snackbar and navigate back to login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset link sent! Check your email.'),
              backgroundColor: Color(0xFF6B9B37),
              duration: Duration(seconds: 4),
            ),
          );
          Navigator.of(context).pop(); // Go back to Login Page
        }
      } on FirebaseAuthException catch (e) {
        // Error: Show an error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF6B9B37);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: themeColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),

                // Lock icon
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 50,
                    color: Color(0xFFFFB300),
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter the email associated with your account and we will send an email with instructions to reset your password.",
                  style: TextStyle(fontSize: 15, color: Color(0xFFADB5BD)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email Field
                _buildTextField(
                  controller: emailController,
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Reset Password Button
                ElevatedButton(
                  // 4. Connect the button to the reset password function
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
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
                          "SEND RESET LINK",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        validator: validator,
        style: const TextStyle(color: Color(0xFF2D3436), fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6B9B37), size: 22),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
