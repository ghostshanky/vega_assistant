import 'package:flutter/material.dart';
import '../presentation/main_chat_interface/main_chat_interface.dart';
import '../presentation/system_controls_dashboard/system_controls_dashboard.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/settings_and_preferences/settings_and_preferences.dart';
import '../presentation/memory_management/memory_management.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/signup_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String mainChatInterface = '/main_chat_interface';
  static const String systemControlsDashboard = '/system_controls_dashboard';
  static const String splashScreen = '/splash_screen';
  static const String settingsAndPreferences = '/settings_and_preferences';
  static const String memoryManagement = '/memory_management';
  static const String onboardingFlow = '/onboarding_flow';
  static const String loginScreen = '/login_screen';
  static const String signupScreen = '/signup_screen';

  static Map<String, WidgetBuilder> get routes => {
        initial: (context) => const SplashScreen(),
        mainChatInterface: (context) => const MainChatInterface(),
        systemControlsDashboard: (context) => const SystemControlsDashboard(),
        splashScreen: (context) => const SplashScreen(),
        settingsAndPreferences: (context) => const SettingsAndPreferences(),
        memoryManagement: (context) => const MemoryManagement(),
        onboardingFlow: (context) => const OnboardingFlow(),
        loginScreen: (context) => const LoginScreen(),
        signupScreen: (context) => const SignupScreen(),
      };
}
