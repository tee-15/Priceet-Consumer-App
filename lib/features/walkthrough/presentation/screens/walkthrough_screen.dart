import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../widgets/price_comparison_illustration.dart';
import '../widgets/qr_scan_illustration.dart';
import '../widgets/savings_illustration.dart';

// ── Shared transition helpers ──────────────────────────────────────────────────

/// Duration used for all within-screen slide/fade transitions.
const _kTransitionDuration = Duration(milliseconds: 500);
const _kTransitionCurve = Curves.easeInOutCubic;

// ── Slide data model ───────────────────────────────────────────────────────────

class _WalkthroughSlide {
  const _WalkthroughSlide({
    required this.buildIllustration,
    required this.heading,
    required this.body,
    required this.gradientColors,
  });

  /// Builder so each slide gets a fresh widget instance — required for
  /// StatefulWidget illustrations (e.g. QrScanIllustration with animations).
  final Widget Function() buildIllustration;
  final String heading;
  final String body;
  final List<Color> gradientColors;
}

// ── Slide definitions ──────────────────────────────────────────────────────────

final List<_WalkthroughSlide> _slides = [
  _WalkthroughSlide(
    buildIllustration: () => const PriceComparisonIllustration(),
    heading: 'Compare Prices Instantly',
    body:
        'See live prices from every nearby store in one glance — Priceet always finds the best deal for you.',
    gradientColors: const [
      Color(0xFF000D2E),
      Color(0xFF001858),
      Color(0xFF002D8A),
    ],
  ),
  _WalkthroughSlide(
    buildIllustration: () => QrScanIllustration(),
    heading: 'Scan & Pay Anywhere',
    body:
        'Shop at partner stores cashlessly. Scan once, pay instantly — no cards, no cash, no stress.',
    gradientColors: const [
      Color(0xFF021F1C),
      Color(0xFF0A3D38),
      Color(0xFF0F5E58),
    ],
  ),
  _WalkthroughSlide(
    buildIllustration: () => SavingsIllustration(),
    heading: 'Watch Savings Grow',
    body:
        'Track every naira saved with beautiful insights. Earn cashback rewards and build smarter habits.',
    gradientColors: const [
      Color(0xFF1F0000), // rgb(31,0,0)
      Color(0xFF5A0000), // rgb(90,0,0)
      Color(0xFF8C0000), // rgb(140,0,0)
    ],
  ),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  int _currentPage = 0;
  int _previousPage = 0;
  Timer? _timer;

  /// How long each slide stays visible before auto-advancing.
  static const _slideDuration = Duration(seconds: 4);

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
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_slideDuration, (_) {
      if (!mounted) return;
      _goToPage((_currentPage + 1) % _slides.length);
    });
  }

  void _goToPage(int index) {
    setState(() {
      _previousPage = _currentPage;
      _currentPage = index;
    });
  }

  /// Stop the auto-advance — called when the user taps an action button.
  void _stopTimer() => _timer?.cancel();

  void _skip() {
    _stopTimer();
    Navigator.of(context).pushReplacementNamed('/signin');
  }

  void _signIn() {
    _stopTimer();
    Navigator.of(context).pushNamed('/signin');
  }

  void _getStarted() {
    _stopTimer();
    Navigator.of(context).pushNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];
    // Forward = advancing, backward = going back
    final isForward = _currentPage >= _previousPage;

    return Scaffold(
      backgroundColor: slide.gradientColors[0],
      body: Stack(
        children: [
          // ── Animated background gradient ───────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-0.72, -0.70),
                end: const Alignment(0.72, 0.70),
                stops: const [0.0849, 0.4585, 0.9151],
                colors: slide.gradientColors,
              ),
            ),
          ),

          // ── Illustration (slides + fades on slide change) ──────────────
          Positioned(
            top: 112,
            bottom: 344,
            left: 0,
            right: 0,
            child: _SlideTransitionSwitcher(
              pageKey: _currentPage,
              isForward: isForward,
              child: Center(
                key: ValueKey<int>(_currentPage),
                child: slide.buildIllustration(),
              ),
            ),
          ),

          // ── Top nav bar ────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopNavBar(onSkip: _skip),
          ),

          // ── Bottom content ─────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomSection(
              currentPage: _currentPage,
              totalPages: _slides.length,
              heading: slide.heading,
              body: slide.body,
              isForward: isForward,
              onSignIn: _signIn,
              onGetStarted: _getStarted,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Directional slide+fade switcher ───────────────────────────────────────────

/// Wraps [AnimatedSwitcher] with a horizontal slide+fade that respects
/// the direction of travel (forward = slide left, backward = slide right).
class _SlideTransitionSwitcher extends StatelessWidget {
  const _SlideTransitionSwitcher({
    required this.pageKey,
    required this.isForward,
    required this.child,
  });

  final int pageKey;
  final bool isForward;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _kTransitionDuration,
      switchInCurve: _kTransitionCurve,
      switchOutCurve: _kTransitionCurve,
      transitionBuilder: (child, animation) {
        // Determine if this is the incoming or outgoing child.
        final isIncoming = child.key == ValueKey<int>(pageKey);
        final direction = isForward ? 1.0 : -1.0;

        final slideIn = Tween<Offset>(
          begin: Offset(direction * 0.18, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: _kTransitionCurve));

        final slideOut = Tween<Offset>(
          begin: Offset(-direction * 0.18, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: _kTransitionCurve));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: isIncoming ? slideIn : slideOut,
            child: child,
          ),
        );
      },
      child: child,
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

// ── Bottom section ─────────────────────────────────────────────────────────────

class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.currentPage,
    required this.totalPages,
    required this.heading,
    required this.body,
    required this.isForward,
    required this.onSignIn,
    required this.onGetStarted,
  });

  final int currentPage;
  final int totalPages;
  final String heading;
  final String body;
  final bool isForward;
  final VoidCallback onSignIn;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final direction = isForward ? 1.0 : -1.0;

    // Shared transition builder for text content
    Widget textTransition(Widget child, Animation<double> animation) {
      final slide = Tween<Offset>(
        begin: Offset(direction * 0.12, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: _kTransitionCurve),
      );
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: slide, child: child),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _PageIndicator(currentIndex: currentPage, total: totalPages),
          const SizedBox(height: 36),

          // Heading — directional slide+fade
          AnimatedSwitcher(
            duration: _kTransitionDuration,
            switchInCurve: _kTransitionCurve,
            switchOutCurve: _kTransitionCurve,
            transitionBuilder: textTransition,
            child: Align(
              key: ValueKey(heading),
              alignment: Alignment.centerLeft,
              child: Text(heading, style: AppTextStyles.walkthroughHeading),
            ),
          ),
          const SizedBox(height: 14),

          // Body — directional slide+fade, slightly delayed feel
          AnimatedSwitcher(
            duration: _kTransitionDuration,
            switchInCurve: _kTransitionCurve,
            switchOutCurve: _kTransitionCurve,
            transitionBuilder: textTransition,
            child: Align(
              key: ValueKey(body),
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 299,
                child: Text(body, style: AppTextStyles.walkthroughBody),
              ),
            ),
          ),
          const SizedBox(height: 36),

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

// ── Animated page indicator dots ──────────────────────────────────────────────

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
