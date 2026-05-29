import 'package:flutter/material.dart';

import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/walkthrough/presentation/screens/walkthrough_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/check_email_screen.dart';
import 'features/auth/presentation/screens/verify_screen.dart';
import 'features/auth/presentation/screens/add_address_screen.dart';
import 'features/auth/presentation/screens/create_pin_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/screens/all_products_screen.dart';
import 'features/home/presentation/screens/cheapest_near_you_screen.dart';
import 'features/home/presentation/screens/nearby_retailers_screen.dart';
import 'features/home/presentation/screens/search_screen.dart';
import 'features/home/presentation/screens/notifications_screen.dart';
import 'features/auth/presentation/screens/account_created_screen.dart';

void main() {
  runApp(const PriceetApp());
}

class PriceetApp extends StatelessWidget {
  const PriceetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Priceet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Outfit',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002367),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/walkthrough':
            page = const WalkthroughScreen();
          case '/signup':
            page = const SignUpScreen();
          case '/signin':
            page = const SignInScreen();
          case '/forgot-password':
            page = const ForgotPasswordScreen();
          case '/check-email':
            final email = settings.arguments as String;
            page = CheckEmailScreen(email: email);
          case '/verify':
            page = const VerifyScreen();
          case '/add-address':
            page = const AddAddressScreen();
          case '/create-pin':
            page = const CreatePinScreen();
          case '/account-created':
            page = const AccountCreatedScreen();
          case '/home':
            page = const HomeScreen();
          case '/all-products':
            page = const AllProductsScreen();
          case '/cheapest-near-you':
            page = const CheapestNearYouScreen();
          case '/nearby-retailers':
            page = const NearbyRetailersScreen();
          case '/search':
            page = const SearchScreen();
          case '/notifications':
            page = const NotificationsScreen();
          default:
            return null;
        }

        // Routes that replace the stack (no back gesture needed) use a
        // pure fade so there's no directional "slide" confusion.
        final isReplacement = settings.name == '/walkthrough' ||
            settings.name == '/home' ||
            settings.name == '/account-created';

        return _SmoothPageRoute(
          page: page,
          settings: settings,
          fade: isReplacement,
        );
      },
    );
  }
}

/// A custom [PageRouteBuilder] that combines a subtle upward slide with a
/// fade-in for forward navigation, and a pure fade for replacement routes.
class _SmoothPageRoute extends PageRouteBuilder {
  _SmoothPageRoute({
    required Widget page,
    required RouteSettings settings,
    bool fade = false,
  }) : super(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Smooth deceleration curve
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            if (fade) {
              // Pure fade for replacement screens (splash→walkthrough, etc.)
              return FadeTransition(opacity: curved, child: child);
            }

            // Slide up + fade for forward pushes
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(curved);

            // Outgoing screen fades out slightly
            final outFade = Tween<double>(begin: 1.0, end: 0.92).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeInCubic,
              ),
            );

            return FadeTransition(
              opacity: outFade,
              child: SlideTransition(
                position: slide,
                child: FadeTransition(opacity: curved, child: child),
              ),
            );
          },
        );
}
