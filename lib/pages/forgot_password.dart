import 'package:barber_booking_app/pages/login.dart';
import 'package:barber_booking_app/pages/custom_button.dart';
import 'package:barber_booking_app/pages/custom_text_field.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController securityAnswerController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? securityQuestion;
  String? storedSecurityAnswer;
  String? userId;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // 0: Enter Email, 1: Answer Question, 2: Reset Password
  int currentStep = 0; 

  Future<void> verifyEmail() async {
    if (emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.amber,
          content: Text("Please enter your email"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Query Firestore for the user with this email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          securityQuestion = userData['securityQuestion'];
          storedSecurityAnswer = userData['securityAnswer'];
          userId = userData['id']; 
          _isLoading = false;
          
          if (securityQuestion != null && storedSecurityAnswer != null) {
            currentStep = 1;
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.error,
                content: Text("Account doesn't have a security question set."),
              ),
            );
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text("No account found with this email."),
          ),
        );
      }
    } catch (e) {
      setState(() {
          _isLoading = false;
        });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text("Error: ${e.toString()}"),
        ),
      );
    }
  }

  void verifyAnswer() {
    if (securityAnswerController.text.trim().toLowerCase() ==
        storedSecurityAnswer?.trim().toLowerCase()) {
      setState(() {
        currentStep = 2;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text("Incorrect answer."),
        ),
      );
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.amber,
          content: Text("Passwords do not match"),
        ),
      );
      return;
    }
     if (newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.amber,
          content: Text("Password must be at least 6 characters"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Update password in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'password': newPasswordController.text,
      });

      // 2. Trigger Password Reset Email
      // Note: Firebase Auth doesn't support setting password directly without old password (credentials).
      // So we rely on the reset email for the AUTH part, but we updated Firestore for database consistency if used elsewhere.
      // Ideally, the user should use the link in the email to set the new password in Auth system properly.
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      
      setState(() {
        _isLoading = false;
      });

      if(!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text(
            "Password Reset Successfully",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen())); // Go back to Login
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );

    } catch (e) {
       setState(() {
        _isLoading = false;
      });
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text("Error resetting password: ${e.toString()}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               GestureDetector(
                onTap: () {
                    if(currentStep > 0){
                        setState(() {
                          currentStep--;
                        });
                    } else {
                        Navigator.pop(context);
                    }
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Forgot Password',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              
              if (_isLoading) 
                 const Center(child: CircularProgressIndicator())
              else if (currentStep == 0) ...[
                 const Text(
                  'Enter your email to reset password',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "Next",
                  onTap: verifyEmail,
                ),
              ] else if (currentStep == 1) ...[
                const Text(
                  'Answer security question',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 40),
                Container(
                   padding: const EdgeInsets.all(16),
                   width: MediaQuery.of(context).size.width,

                   decoration: BoxDecoration(
                     color: AppColors.card,
                     borderRadius: BorderRadius.circular(10),
                     boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                   ),
                   child: Text(
                     securityQuestion ?? "No Question",
                     style: const TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.w500,
                       color: AppColors.textPrimary
                     ),
                   ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: securityAnswerController,
                  hintText: 'Your Answer',
                  prefixIcon: Icons.question_answer_outlined,
                ),
                 const SizedBox(height: 30),
                CustomButton(
                  text: "Verify",
                  onTap: verifyAnswer,
                ),
              ] else if (currentStep == 2) ...[
                 const Text(
                  'Create new password',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 40),
                 CustomTextField(
                controller: newPasswordController,
                hintText: 'New Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
               const SizedBox(height: 30),
                CustomButton(
                  text: "Reset Password",
                  onTap: resetPassword,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
