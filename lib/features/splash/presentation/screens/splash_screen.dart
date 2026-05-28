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
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

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
                  // 143° angle
                  begin: Alignment(-0.72, -0.70),
                  end: Alignment(0.72, 0.70),
                  stops: [0.0849, 0.4585, 0.9151],
                  colors: [
                    AppColors.gradientStart, // #000D2E
                    AppColors.gradientMid,   // #001858
                    AppColors.gradientEnd,   // #002D8A
                  ],
                ),
              ),
            ),
          ),

          // ── Top-left blue radial glow ────────────────────────────────────
          // Figma: left=-57.87, top=-182.19, size=343.565
          Positioned(
            left: -57.87,
            top: -182.19,
            child: _RadialGlow(
              size: 343.565,
              centerColor: const Color(0x731E50FF), // rgba(30,80,255,0.45)
              midColor: const Color(0x390F2880),    // rgba(15,40,128,0.225)
            ),
          ),

          // ── Bottom-right red radial glow ─────────────────────────────────
          // Figma: left=212.26, top=380.53, size=269.57
          Positioned(
            left: 212.26,
            top: 380.53,
            child: _RadialGlow(
              size: 269.57,
              centerColor: const Color(0x2ED90000), // rgba(217,0,0,0.18)
              midColor: const Color(0x176D0000),    // rgba(109,0,0,0.09)
            ),
          ),

          // ── Centre logo block ────────────────────────────────────────────
          // Figma: centred horizontally, top=276
          // White rounded box (83×83, radius 24.4) + "Priceet" wordmark below
          Positioned(
            top: 276,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // White rounded container with logo icon inside
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
                // "Priceet" wordmark
                Text(
                  'Priceet',
                  style: AppTextStyles.splashWordmark,
                ),
              ],
            ),
          ),

          // ── Tagline ──────────────────────────────────────────────────────
          // Figma: top=435, centred, width=275
          Positioned(
            top: 435,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 275,
                child: Text(
                  'Priceet always finds the best deal for you.',
                  style: AppTextStyles.tagline,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // ── Spinning loader ──────────────────────────────────────────────
          // Figma: top=752, centred, size=42.426
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

/// Soft radial gradient circle for ambient glow effects.
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
