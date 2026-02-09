import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/custom_button.dart';
import 'package:barber_booking_app/pages/custom_text_field.dart';
import 'package:barber_booking_app/pages/login.dart';
import 'package:barber_booking_app/pages/BottomNavigation.dart';
import 'package:barber_booking_app/services/database.dart';
import 'package:barber_booking_app/services/shared_pref.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Meelaha lagu xakameeyo qoraalka (Text editing controllers)
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController securityAnswerController = TextEditingController();
  
  String? selectedSecurityQuestion;
  final List<String> securityQuestions = [
    "What's your favorite color?",
    "What's your football growing up?",
    "What's your first lover name?",
  ];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // 'registration' waa shaqada abuuraysa akoonka isticmaalaha cusub.
  Future<void> registration() async {
    // Hubi in dhammaan sanduuqyada qoraalka ay buuxaan ka hor intaanan bilaabin.
    if (passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        selectedSecurityQuestion != null &&
        securityAnswerController.text.isNotEmpty) {
      try {
        // Concept: 'createUserWithEmailAndPassword' waxay akoon cusub ka dhisaysaa Firebase.
        // Waxay si toos ah u xaqiijinaysaa haddii iimaylku sax yahay ama horey loo isticmaalay.
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Concept: Waxaan abuuraynaa ID gaar ah (Random ID) si aan isugu xirno xogta Firestore iyo SharedPreferences.
        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userData = {
          "id": id,
          "username": usernameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "securityQuestion": selectedSecurityQuestion,
          "securityAnswer": securityAnswerController.text,
        };

        // Keydinta xogta ee Labada Meelood (Data Sync):
        // 1. Firestore (Cloud): Si xogta looga helo talifoon kasta.
        await DatabaseService().addUserData(userData, id);
        // 2. SharedPreferences (Local): Si abka uu u xasuusto qofka xitaa haddii internet-ku go'o ama abka la xiro.
        await sharedpreferenceHelper().saveUserId(id);
        await sharedpreferenceHelper().saveUserName(usernameController.text);
        await sharedpreferenceHelper().saveUserEmail(emailController.text);

        if (!mounted) return;
        // Marka uu guuleysto, muuji farriin guul ah
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text("Account created successfully"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CoolBottomNavigation()),
        );
      } on FirebaseAuthException catch (e) {
        // Meesha lagu qabto khaladaadka Firebase ee diiwaangelinta
        String message = 'Error occurred: ${e.message}';
        if (e.code == 'weak-password') {
          message = "The password provided is too weak.";
        } else if (e.code == 'email-already-in-use') {
          message = "The account already exists for that email.";
        } else if (e.code == 'invalid-email') {
          message = "The email address is badly formatted.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: AppColors.error, content: Text(message)),
        );
      }
    }
  }

  // 'randomAlphaNumeric' waa shaqo yar oo soo saarta qoraal isku dhafan (Xarfaha iyo Tirooyinka).
  // Concept: Waxaan u isticmaalaynaa tan si aan u siino isticmaalaha ID gaar ah oo aan ku ogaano (Unique Identifier).
  String randomAlphaNumeric(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Create Account',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign up to get started',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: usernameController,
                hintText: 'Username',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                     BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ]
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSecurityQuestion,
                    dropdownColor: AppColors.card,
                    hint: const Text(
                      "Select Security Question",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 18.0),
                    ),
                    items: securityQuestions.map((String question) {
                      return DropdownMenuItem<String>(
                        value: question,
                        child: Text(
                          question,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 16.0),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSecurityQuestion = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: securityAnswerController,
                hintText: 'Answer',
                prefixIcon: Icons.question_answer_outlined,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: "Sign Up",
                onTap: () {
                  if (passwordController.text.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.amber, // Warning color
                        content: Text("The password provided is too weak."),
                      ),
                    );
                  } else if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.amber,
                        content: Text("Passwords do not match"),
                      ),
                    );
                  } else {
                    registration();
                  }
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
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
