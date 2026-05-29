import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_success_checkmark.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_button.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBackBar(),
      body: Column(
        children: [
          // ── Centred content ──────────────────────────────────────────
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AnimatedSuccessCheckmark(size: 96),
                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Check your email',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandBlue,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      "We've sent a password reset link to",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyText,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Email address (bold, brand blue)
                    Text(
                      email,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandBlue,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom bar ───────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Back to Sign In',
                  onPressed: () =>
                      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false),
                ),
                const SizedBox(height: 24),

                // Try a different email
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Center(
                    child: Text(
                      'Try a different email',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
