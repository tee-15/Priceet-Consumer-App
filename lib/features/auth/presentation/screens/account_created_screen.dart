import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_success_checkmark.dart';
import '../../../../core/widgets/app_button.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedSuccessCheckmark(size: 96),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Account Set Up',
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
                'Your account is ready, Let start shopping',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyText,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Dashboard button
              SizedBox(
                width: 280,
                child: AppButton(
                  label: 'Dashboard',
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
