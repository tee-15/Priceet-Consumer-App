import 'package:flutter/material.dart';

import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/walkthrough/presentation/screens/walkthrough_screen.dart';

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
      },
    );
  }
}
