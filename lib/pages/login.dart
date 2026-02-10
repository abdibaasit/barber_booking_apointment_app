import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/custom_button.dart';
import 'package:barber_booking_app/pages/custom_text_field.dart';
import 'package:barber_booking_app/pages/signup.dart';
import 'package:barber_booking_app/pages/BottomNavigation.dart';
import 'package:barber_booking_app/admin/admin_login.dart';
import 'package:barber_booking_app/pages/forgot_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barber_booking_app/services/database.dart';
import 'package:barber_booking_app/services/shared_pref.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// LoginScreen waa bogga loogu talagalay in isticmaalaha uu gashado aqoonsigiisa (Email & Password).
// Concept: Waa StatefulWidget sababtoo ah waxaan u baahannahay inaan muujino 'Loading' ama 'Errors' marka uu qofku isku dayo inuu galo.
class _LoginScreenState extends State<LoginScreen> {
  // Concept: 'TextEditingController' waa bridge (xiriiriye) noo ogolaanaya inaan ka soo qaadno qoraalka uu isticmaalahu ku qorayo Field-yada.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  // 'userLogin' waa shaqada dhabta ah ee xaqiijinaysa soo gelitaanka isticmaalaha.
  Future<void> userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      
      // If Firebase Auth succeeds, we should fetch and save user data to SharedPrefs for the app session
      await _saveUserSession(emailController.text);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CoolBottomNavigation()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        // Fallback: Check Firestore directly (in case password was reset via Forgot Password but Auth not synced)
        bool fallbackSuccess = await _tryFallbackLogin(emailController.text, passwordController.text);
        if (fallbackSuccess) {
           if (!mounted) return;
           Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CoolBottomNavigation()),
           );
           return;
        }
      }

      String message = 'An error occurred: ${e.message}';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        message = 'Invalid email or password.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            message,
            style: const TextStyle(fontSize: 18, color: AppColors.textPrimary),
          ),
        ),
      );
    }
  }

  Future<bool> _tryFallbackLogin(String email, String password) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        if (data['password'] == password) {
          // Credentials match Firestore record
          await _saveUserSessionFromData(data);
          return true;
        }
      }
    } catch (e) {
      // Ignore errors in fallback
    }
    return false;
  }

  Future<void> _saveUserSession(String email) async {
     try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (snapshot.docs.isNotEmpty) {
         var data = snapshot.docs.first.data() as Map<String, dynamic>;
         await _saveUserSessionFromData(data);
      }
     } catch (e) {
       // Handle error
     }
  }

  Future<void> _saveUserSessionFromData(Map<String, dynamic> data) async {
      await sharedpreferenceHelper().saveUserId(data['id']);
      await sharedpreferenceHelper().saveUserName(data['username']);
      await sharedpreferenceHelper().saveUserEmail(data['email']);
      await sharedpreferenceHelper().saveUserImage(data['Image'] ?? '');
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
              const SizedBox(height: 40),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/LogoApp.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign in to Maqas Barber",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: emailController,
                hintText: 'Email Address',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: "Login",
                onTap: () {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    userLogin();
                  }
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Are you an Admin? ",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminLogin(),
                        ),
                      );
                    },
                    child: const Text(
                      "Admin Login",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
