import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/custom_button.dart';
import 'package:barber_booking_app/pages/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // 'build' waa shaqada dhisaysa muuqaalka (UI) ee boggan.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Concept: 'Stack' waxaa loo isticmaalaa in widgets-ka la is-dulo saaro (Layering).
      // Halkan, sawirka ayaa hoos yaalla, ka dib waxaa ku xiga hoos (gradient), ugu dambeyna qoraalka ayaa dusha kaga yaalla.
      body: Stack(
        children: [
          // Sawirka asalka ah (Background Image)
          Positioned.fill(
            child: Image.asset('assets/barber.jpeg', fit: BoxFit.cover),
          ),
          // Hooska madow (Gradient Overlay)
          // Concept: 'LinearGradient' waxay naga caawinaysaa in qoraalku uu cadaado (Readability).
          // Waxay ka bilaabataa madow khafiif ah (top) ilaa madow adag (bottom) si sawirka uusan u qarin qoraalka.
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    AppColors.background.withOpacity(0.9),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Center(
                    child: Image.asset(
                      'assets/LogoApp.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Maqas Barber',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Experience the\nUltimate Haircut.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Precision, Style, and Premium Grooming.\nBook your appointment today.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                    text: "Get Started",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
