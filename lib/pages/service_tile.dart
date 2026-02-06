import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';

// ServiceTile waa component aan dib u isticmaalayno (Reusable Component).
// Concept: Halkii aan bogga Home ku qori lahayn code dheer oo isku mid ah adeeg kasta, waxaan samaynay hal widget oo qaata 'name', 'icon', iyo 'onTap'.
class ServiceTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap; // Shaqada la fulinayo marka la taabto

  const ServiceTile({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140, // Taller for elegance
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [AppColors.card, AppColors.card.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Icon(icon, size: 32, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
