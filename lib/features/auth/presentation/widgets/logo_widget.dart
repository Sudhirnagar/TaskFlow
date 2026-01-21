import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';

class LogoWidget extends StatelessWidget {
  final double size;

  const LogoWidget({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 60, //space for sparkles
      height: size + 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // --- Sparkles ---
          _buildSparkle(top: 10, right: 20, color: Colors.orange, size: 8),
          _buildSparkle(bottom: 15, left: 10, color: Colors.blueAccent, size: 10),
          _buildSparkle(top: 30, left: 5, color: Colors.grey.withOpacity(0.4), size: 6),
          _buildSparkle(bottom: 25, right: 5, color: Colors.purple.withOpacity(0.3), size: 12),
          _buildSparkle(top: 0, left: 60, color: Colors.yellow, size: 7),
          _buildSparkle(bottom: 0, left: 50, color: Colors.deepPurpleAccent.withOpacity(0.2), size: 9),
          _buildSparkle(top: 70, right: 0, color: Colors.pink.withOpacity(0.2), size: 11),
          _buildSparkle(top: 40, left: 20, color: Colors.greenAccent.withOpacity(0.3), size: 5),

          // --- Main Logo Box ---
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(size * 0.24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: size * 0.6,
              weight: 900,
              grade: 0.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle({double? top, double? bottom, double? left, double? right, required Color color, required double size}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}