import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../tasks/presentation/pages/tasks_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Triggers the initial authentication check when the app launches
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    // Listens for auth state changes to determine where to route the user
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigate to the main dashboard if a valid session exists
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const TasksPage(),
            ),
          );
        } else if (state is AuthUnauthenticated) {
          // Redirect to the onboarding screen if no user is logged in
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const OnboardingPage(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App branding logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              
              // App Name
              const Text(
                'TaskFlow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              
              // Loading indicator showing background activity
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}