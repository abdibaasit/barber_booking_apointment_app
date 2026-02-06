import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';

// CustomButton waa badhan aan annagu iska dhisnay (Custom UI).
// Concept: 'Encapsulation' - Waxaan ku dhex qarinay dhammaan quruxda (Gradient, Shadows) hal class dhexdiisa si abka intiisa kale uu ugu yeerto 'CustomButton' uun.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.textBlack,
    this.width,
    this.height = 50.0,
  });

  // Meesha laga dhisayo badhanka (Build method)
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
