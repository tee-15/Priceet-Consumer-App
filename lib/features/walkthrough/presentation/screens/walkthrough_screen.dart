import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/price_comparison_illustration.dart';

/// Data model for a single walkthrough slide.
class _WalkthroughSlide {
  const _WalkthroughSlide({
    required this.illustration,
    required this.heading,
    required this.body,
  });

  final Widget illustration;
  final String heading;
  final String body;
}

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_WalkthroughSlide> _slides = [
    _WalkthroughSlide(
      illustration: PriceComparisonIllustration(),
      heading: 'Compare Prices Instantly',
      body:
          'See live prices from every nearby store in one glance — Priceet always finds the best deal for you.',
    ),
    _WalkthroughSlide(
      illustration: PriceComparisonIllustration(),
      heading: 'Save More Every Day',
      body:
          'Track price drops and get notified when your favourite products go on sale.',
    ),
    _WalkthroughSlide(
      illustration: PriceComparisonIllustration(),
      heading: 'Shop Smarter, Not Harder',
      body:
          'Build your shopping list and let Priceet find the cheapest basket across all stores.',
    ),
  ];

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _skip() {
    // TODO: navigate to sign-in / home
  }

  void _signIn() {
    // TODO: navigate to sign-in screen
  }

  void _getStarted() {
    // TODO: navigate to registration screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gradientStart,
      body: Stack(
        children: [
          // ── Background gradient ────────────────────────────────────────
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

          // ── Page content ───────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _SlideContent(slide: _slides[index]);
            },
          ),

          // ── Top nav bar (logo + skip) ──────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopNavBar(onSkip: _skip),
          ),

          // ── Bottom CTA area ────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomSection(
              currentPage: _currentPage,
              totalPages: _slides.length,
              heading: _slides[_currentPage].heading,
              body: _slides[_currentPage].body,
              onSignIn: _signIn,
              onGetStarted: _getStarted,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slide content (illustration only — text is in the bottom section) ─────────
class _SlideContent extends StatelessWidget {
  const _SlideContent({required this.slide});

  final _WalkthroughSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 112), // below nav bar
      child: Align(
        alignment: const Alignment(0, -0.35),
        child: slide.illustration,
      ),
    );
  }
}

// ── Top navigation bar ─────────────────────────────────────────────────────────
class _TopNavBar extends StatelessWidget {
  const _TopNavBar({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: topPadding + 14, left: 24, right: 24),
      child: SizedBox(
        height: 54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo + wordmark
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Image.asset(
                    'assets/images/priceet_logo_small.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Priceet', style: AppTextStyles.walkthroughAppName),
              ],
            ),

            // Skip button
            GestureDetector(
              onTap: onSkip,
              child: Container(
                height: 33.5,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                ),
                alignment: Alignment.center,
                child: Text('Skip', style: AppTextStyles.skipButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom section: dots + heading + body + CTA buttons ───────────────────────
class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.currentPage,
    required this.totalPages,
    required this.heading,
    required this.body,
    required this.onSignIn,
    required this.onGetStarted,
  });

  final int currentPage;
  final int totalPages;
  final String heading;
  final String body;
  final VoidCallback onSignIn;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicator dots
          _PageIndicator(currentIndex: currentPage, total: totalPages),
          const SizedBox(height: 36),

          // Heading
          Text(
            heading,
            style: AppTextStyles.walkthroughHeading,
          ),
          const SizedBox(height: 14),

          // Body
          SizedBox(
            width: 299,
            child: Text(
              body,
              style: AppTextStyles.walkthroughBody,
            ),
          ),
          const SizedBox(height: 36),

          // CTA buttons
          Row(
            children: [
              Expanded(
                child: _WalkthroughButton(
                  label: 'Sign In',
                  onTap: onSignIn,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _WalkthroughButton(
                  label: 'Get Started',
                  onTap: onGetStarted,
                  isOutlined: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Animated page indicator ────────────────────────────────────────────────────
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentIndex, required this.total});

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(right: i < total - 1 ? 8 : 0),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : const Color(0xFFC4C4C4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ── CTA button ─────────────────────────────────────────────────────────────────
class _WalkthroughButton extends StatelessWidget {
  const _WalkthroughButton({
    required this.label,
    required this.onTap,
    required this.isOutlined,
  });

  final String label;
  final VoidCallback onTap;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isOutlined
              ? Colors.white.withValues(alpha: 0.20)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: isOutlined
              ? AppTextStyles.buttonPrimary
              : AppTextStyles.buttonSecondary,
        ),
      ),
    );
  }
}
