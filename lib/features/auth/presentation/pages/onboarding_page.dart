import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_manager/features/auth/presentation/widgets/logo_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'register_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Main Content (Logo, Text, Dots)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 1),

                  // --- Logo Area with "More Sparkles" ---
                  Center(child: LogoWidget()),

                  const SizedBox(height: 40),

                  Text(
                    AppStrings.getThingsDone,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 28,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.startPlanning,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[500],
                          height: 1.5,
                          fontSize: 16,
                        ),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      _buildDot(active: false),
                      _buildDot(active: false),
                      _buildDot(active: true, color: AppColors.primary),
                    ],
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),

          // 2. Bottom Right Corner Button (Quarter Circle)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const RegisterPage(),
                  ),
                );
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(160),
                  ),
                ),
                padding: const EdgeInsets.only(left: 70, top: 40),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.arrow_right, // Thin look
                  color: Colors.white,
                  size: 60,
                  weight: 10, // Very thin weight
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({bool active = false, Color? color}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? (color ?? Colors.blue) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
