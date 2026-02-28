import 'package:flutter/material.dart';
import 'package:medrpha_labs/config/routes/routes_name.dart';
import '../../pages/onboarding/on_boarding_screen.dart';
import '../../views/bottom_tabs/CartScreen/my_cart_page.dart';
import '../../views/view.dart';   // should export SplashScreen, LoginScreen, OtpScreen, DashboardScreen, MyCartPage, etc.

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RoutesName.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case RoutesName.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RoutesName.otpScreen:
        final phone = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => OtpScreen(phoneNumber: phone));

      case RoutesName.dashboardScreen:
        return MaterialPageRoute(builder: (_) => DashboardScreen());

    // ✅ NEW: cart page
      case RoutesName.cartScreen:
        return MaterialPageRoute(builder: (_) => const MyCartPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route found for this screen')),
          ),
        );
    }
  }
}
