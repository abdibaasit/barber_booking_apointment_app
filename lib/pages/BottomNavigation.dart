import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:barber_booking_app/pages/home.dart';
import 'package:barber_booking_app/pages/Booking.dart';
import 'package:barber_booking_app/pages/Profile.dart';
import 'package:barber_booking_app/services/colors.dart';

class CoolBottomNavigation extends StatefulWidget {
  const CoolBottomNavigation({super.key});

  @override
  State<CoolBottomNavigation> createState() => _CoolBottomNavigationState();
}

// CoolBottomNavigation waa widget-ka saldhigga u ah navigation-ka hoose.
// Concept: 'StatefulWidget' ayaa loo isticmaalay sababtoo ah waxaan u baahannahay inaan beddelno 'index-ka' bogga marka qofku badhamada riixo.
class _CoolBottomNavigationState extends State<CoolBottomNavigation> {
  // '_currentIndex' waxay noo sheegaysaa bogga hadda furan (0=Home, 1=Bookings, 2=Profile).
  int _currentIndex = 0;

  // Concept: Liiskani wuxuu ka kooban yahay bogagga rasmiga ah ee abka.
  // Marka index-ku isbeddelo, 'body' ee Scaffold ayaa iyaduna isbeddelaysa.
  final List<Widget> _pages = const [Home(), MyBookings(), Profile()];

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
          Icon(Icons.calendar_month, color: AppColors.primary),
          Icon(Icons.person, color: AppColors.primary),
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
