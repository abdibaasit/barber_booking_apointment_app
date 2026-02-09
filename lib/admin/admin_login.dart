import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'package:barber_booking_app/services/database.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/custom_text_field.dart';
import 'package:barber_booking_app/pages/custom_button.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  // Meelaha lagu xakameeyo qoraalka (Text editing controllers)
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Shaqada 'loginAdmin' waxay xaqiijisaa aqoonsiga maamulaha (Admin credentials).
  void loginAdmin() {
    // Concept: Waxaan xogta maamulaha ka soo qaadaynaa Firestore 'Admin' collection.
    // Mar haddii aanan isticmaalin FirebaseAuth oo gaar ah maamulka, waxaan u baahannahay inaan gacanta ku hubinno.
    DatabaseService().getAdminData().then((snapshot) {
      bool found = false;

      // Concept: Loop-kani wuxuu dhex marayaa dhammaan dukumentiyada ku jira collection-ka 'Admin'.
      // Waxay barbardhigaysaa magaca (username) iyo ereyga sirta ah (password) ee uu maamuluhu soo geliyay.
      for (var result in snapshot.docs) {
        Map<String, dynamic> data = result.data() as Map<String, dynamic>;

        // ".trim()" waxaa loo isticmaalaa in laga saaro meelaha banaan (spaces) ee ka horreeya ama ka dambeeya qoraalka.
        if (data['username'] == usernameController.text.trim() &&
            data['password'] == passwordController.text.trim()) {
          found = true;
          break;
        }
      }

      if (found) {
        // 'pushReplacement' waxay beddelaysaa bogga hadda joogo iyadoo la geeyo bog cusub.
        // Concept: Tani waxay ka dhigan tahay in maamuluhu uusan dib ugu soo noqon karin bogga login-ka marka uu galo.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHome()),
        );
      } else {
        // Haddii aan xogta la helin, muuji farriin khalad ah (SnackBar).
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Username or Password"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
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
                "Admin Panel",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Authorized access only",
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
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 40),
              CustomButton(text: "Login", onTap: loginAdmin),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Ku laabo bogga hore ee soo galidda isticmaalaha
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Back to User Login",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
