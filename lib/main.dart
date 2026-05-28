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
      routes: {
        '/walkthrough': (_) => const WalkthroughScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/signin': (_) => const SignInScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/check-email': (ctx) {
          final email = ModalRoute.of(ctx)!.settings.arguments as String;
          return CheckEmailScreen(email: email);
        },
        '/verify': (_) => const VerifyScreen(),
        '/add-address': (_) => const AddAddressScreen(),
        '/create-pin': (_) => const CreatePinScreen(),
        '/account-created': (_) => const AccountCreatedScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
