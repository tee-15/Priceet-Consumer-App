import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _spinController;
  late final AnimationController _entryController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Spring scale pop for the logo
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Logo fade-in
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Tagline fade-in
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Trigger entry animations
    _entryController.forward();

    // Navigate to walkthrough after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/walkthrough');
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gradientStart,
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.72, -0.70),
                  end: Alignment(0.72, 0.70),
                  stops: [0.0849, 0.4585, 0.9151],
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientMid,
                    AppColors.gradientEnd,
                  ],
                ),
              ),
            ),
          ),

          // ── Top-left blue radial glow ────────────────────────────────────
          Positioned(
            left: -57.87,
            top: -182.19,
            child: _RadialGlow(
              size: 343.565,
              centerColor: const Color(0x731E50FF),
              midColor: const Color(0x390F2880),
            ),
          ),

          // ── Bottom-right red radial glow ─────────────────────────────────
          Positioned(
            left: 212.26,
            top: 380.53,
            child: _RadialGlow(
              size: 269.57,
              centerColor: const Color(0x2ED90000),
              midColor: const Color(0x176D0000),
            ),
          ),

          // ── Centre logo block ────────────────────────────────────────────
          Positioned(
            top: 276,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _entryController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 83,
                    height: 83,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.4),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 2.44,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 2.44,
                    ),
                    child: Image.asset(
                      'assets/images/priceet_logo_small.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 11),
                  const Text(
                    'Priceet',
                    style: AppTextStyles.splashWordmark,
                  ),
                ],
              ),
            ),
          ),

          // ── Tagline ──────────────────────────────────────────────────────
          Positioned(
            top: 435,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 275,
                child: FadeTransition(
                  opacity: _taglineOpacity,
                  child: const Text(
                    'Priceet always finds the best deal for you.',
                    style: AppTextStyles.tagline,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // ── Spinning loader ──────────────────────────────────────────────
          Positioned(
            top: 752,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _spinController,
                builder: (_, child) => Transform.rotate(
                  angle: _spinController.value * 2 * math.pi,
                  child: child,
                ),
                child: SvgPicture.asset(
                  'assets/images/loading_indicator.svg',
                  width: 42.426,
                  height: 42.426,
                  colorFilter: const ColorFilter.mode(
                    AppColors.brandRed,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadialGlow extends StatelessWidget {
  const _RadialGlow({
    required this.size,
    required this.centerColor,
    required this.midColor,
  });

  final double size;
  final Color centerColor;
  final Color midColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [centerColor, midColor, Colors.transparent],
            stops: const [0.0, 0.35, 0.70],
          ),
        ),
      ),
    );
  }
}
