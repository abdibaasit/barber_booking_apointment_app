import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';

// HomeHeader waa widget yar oo mas'uul ka ah salaanta iyo magaca isticmaalaha.
// Concept: Waa StatelessWidget sababtoo ah xogta 'userName' ayaa dibadda looga soo dhiibayaa (Constructor), isna iskama beddelo.
class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello,', // Salaan guud
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: const TextStyle(
            color: AppColors.primary, // Copper Name
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Look Sharp,\nFeel Sharp.', // Hal-ku-dhegga ganacsiga
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
