import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:barber_booking_app/admin/admin_home.dart';
import 'package:barber_booking_app/admin/admin_bookings.dart';
import 'package:barber_booking_app/admin/admin_users.dart';
import 'package:barber_booking_app/admin/admin_profile.dart';
import 'package:barber_booking_app/services/colors.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminHome(),
    AdminBookings(),
    AdminUsers(), // We will update this file to be full screen soon
    AdminProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60,
        backgroundColor: AppColors.background,
        color: AppColors.card,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, color: AppColors.primary),
          Icon(Icons.calendar_today, color: AppColors.primary), // Bookings
          Icon(Icons.people, color: AppColors.primary), // Users
          Icon(Icons.person, color: AppColors.primary), // Profile
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
