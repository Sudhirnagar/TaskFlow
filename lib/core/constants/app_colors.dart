import 'package:flutter/material.dart';

class AppColors {
  // Main brand colors for App Bar, Buttons, and Active states
  static const primary = Color(0xFF827AFA);
  static const primaryDark = Color(0xFF6C63FF);

  // Background surfaces for the scaffold and cards/dialogs
  static const background = Color(0xFFF5F6FA);
  static const cardBackground = Colors.white;

  // Typography colors for high-emphasis (titles) and medium-emphasis (hints/dates) text
  static const textPrimary = Color(0xFF2D3748);
  static const textSecondary = Color(0xFF718096);

  // Functional colors for error states, delete actions, and success messages
  static const error = Color(0xFFE53E3E);
  static const success = Color(0xFF38A169);
  
  // Task priority indicators (Low/Green, Medium/Orange, High/Red)
  static const lowPriority = Color(0xFF68D391);
  static const mediumPriority = Color(0xFFFBD38D);
  static const highPriority = Color(0xFFFC8181);
  
  // Brand colors for social authentication buttons
  static const facebook = Color(0xFF4267B2);
  static const google = Color(0xFFDB4437);
  static const apple = Color(0xFF000000);
}