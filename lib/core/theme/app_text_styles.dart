import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Priceet text styles — all using the Outfit font family.
class AppTextStyles {
  AppTextStyles._();

  // ── Splash ──────────────────────────────────────────────────────────────
  static const TextStyle splashWordmark = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.5, // 22.5 / 15 scaled
    color: Color(0xCCFFFFFF), // white 80%
  );

  static const TextStyle tagline = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.7, // 25.5 / 15
    color: AppColors.taglineText,
  );

  static const TextStyle statusBarTime = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
  );

  // ── Walkthrough ──────────────────────────────────────────────────────────
  static const TextStyle walkthroughHeading = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.15, // 41.4 / 36
    color: AppColors.white,
    letterSpacing: -1.5,
  );

  static const TextStyle walkthroughBody = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.7, // 25.5 / 15
    color: AppColors.taglineText,
  );

  static const TextStyle walkthroughAppName = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: Color(0xCCFFFFFF), // white 80%
  );

  static const TextStyle skipButton = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: Color(0xBFFFFFFF), // white 75%
  );

  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: AppColors.white,
    letterSpacing: -0.3,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: AppColors.brandBlue,
    letterSpacing: -0.3,
  );

  // ── Price cards ──────────────────────────────────────────────────────────
  static const TextStyle cardStoreName = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Color(0x99FFFFFF), // white 60%
  );

  static const TextStyle cardStoreNameDark = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Color(0xFF64748B),
  );

  static const TextStyle cardPrice = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 19,
    fontWeight: FontWeight.w800,
    height: 1.5,
    color: AppColors.white,
    letterSpacing: -0.5,
  );

  static const TextStyle cardPriceDark = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 19,
    fontWeight: FontWeight.w800,
    height: 1.5,
    color: Color(0xFF001444),
    letterSpacing: -0.5,
  );

  static const TextStyle bestDealBadge = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  // ── Forms & Standard UI ──────────────────────────────────────────────────
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.greyText,
    letterSpacing: 0.6,
    height: 1.5,
  );

  static const TextStyle inputText = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    color: AppColors.darkText,
  );

  static const TextStyle hintText = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    color: Color(0x80111827), // darkText with 50% opacity
  );

  static const TextStyle errorText = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 13,
    color: AppColors.error,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    height: 1.4,
  );
}

