import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:barber_booking_app/controllers/main_controller.dart';
import 'package:barber_booking_app/pages/home.dart';
import 'package:barber_booking_app/pages/Booking.dart';
import 'package:barber_booking_app/pages/Profile.dart';
import 'package:barber_booking_app/services/colors.dart';

class CoolBottomNavigation extends StatelessWidget {
  final int initialTab;
  const CoolBottomNavigation({super.key, this.initialTab = 0});

  // Pages list
  final List<Widget> _pages = const [Home(), MyBookings(), Profile()];

  @override
  Widget build(BuildContext context) {
    // Initialize Controller and set initial tab
    final MainController controller = Get.put(MainController());
    controller.changeIndex(initialTab);

    return Scaffold(
      backgroundColor: AppColors.background,
      
      // Use Obx to listen to changes in currentIndex
      body: Obx(() => _pages[controller.currentIndex.value]),

      bottomNavigationBar: Obx(() => CurvedNavigationBar(
        index: controller.currentIndex.value,
        height: 60,
        backgroundColor: AppColors.background,
        color: AppColors.card,
        animationDuration: const Duration(milliseconds: 300),

        items: const [
          Icon(Icons.home, color: AppColors.primary),
          Icon(Icons.calendar_month, color: AppColors.primary),
          Icon(Icons.person, color: AppColors.primary),
        ],

        onTap: (index) {
          controller.changeIndex(index);
        },
      )),
    );
  }
}
