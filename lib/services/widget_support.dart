import 'package:flutter/widgets.dart';

class AppWidgetSupport {
  static TextStyle headingstyle(double? size) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: Color(0xFFD4AF37), // Gold
    );
  }

  static TextStyle greenTextstyle(double? size) {
    return TextStyle(
      color: Color(0xFFD4AF37), // Gold
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }
}
