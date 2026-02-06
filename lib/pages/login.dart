import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/custom_button.dart';
import 'package:barber_booking_app/pages/custom_text_field.dart';
import 'package:barber_booking_app/pages/signup.dart';
import 'package:barber_booking_app/pages/BottomNavigation.dart';
import 'package:barber_booking_app/admin/admin_login.dart';

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

  // 'userLogin' waa shaqada dhabta ah ee xaqiijinaysa soo gelitaanka isticmaalaha.
  Future<void> userLogin() async {
    try {
      // Concept: 'signInWithEmailAndPassword' waa qaabka Firebase ay u xaqiijiso in iimaylka iyo sirta ay sax yihiin.
      // Tani waa mid ammaan ah oo sirta u keydisa si aan la jebin karin.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Haddii uu code-kani guuleysto, waxaa la fulinayaa talaabada xigta.
      if (!mounted) return;

      // 'pushReplacement' waxay nagu geynaysaa bogga navigation-ka hoose (Main App).
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CoolBottomNavigation()),
      );
    } on FirebaseAuthException catch (e) {
      // Concept: 'try-catch' waxay naga caawinaysaa inaan qabano khaladaadka server-ka ka soo laabta.
      // Sida: iimayl aan jirin ama ereyga sirta ah oo khalad ah.
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
      // Muuji farriinta khaladka ah adoo isticmaalaya SnackBar
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
                  padding: const EdgeInsets.all(20),
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
                  child: const Icon(
                    Icons.content_cut_rounded,
                    size: 60,
                    color: AppColors.primary,
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
                "Please sign in to your account",
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
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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
