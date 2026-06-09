import 'package:flutter/material.dart';
import 'package:construction_ms_ui/shared/models/user_role.dart';
import 'package:construction_ms_ui/shared/services/auth_service.dart';
import 'package:construction_ms_ui/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:construction_ms_ui/features/auth/presentation/pages/login_page.dart';
import 'package:construction_ms_ui/features/home/presentation/pages/home_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_home_page.dart';
import 'package:construction_ms_ui/features/worker_management/presentation/pages/worker_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isFirstTime = await AuthService.isFirstTime();
  final savedRole = await AuthService.getSavedRole();

  runApp(MyApp(isFirstTime: isFirstTime, savedRole: savedRole));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final UserRole savedRole;

  const MyApp({
    super.key,
    required this.isFirstTime,
    required this.savedRole,
  });

  Widget _resolveHome() {
    if (isFirstTime) return const OnboardingPage();

    // Returning user — check if a role was actually saved
    // (if no role key in prefs, getSavedRole defaults to admin,
    //  so we use the LoginPage as a safe fallback for new installs)
    return const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aatzy Build',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF06B6D4)),
        useMaterial3: true,
      ),
      home: _resolveHome(),
    );
  }
}

/// Helper: returns the correct home page widget for a given role.
Widget homePageForRole(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return const HomePage();
    case UserRole.client:
      return const ClientHomePage();
    case UserRole.worker:
      return const WorkerHomePage();
  }
}
