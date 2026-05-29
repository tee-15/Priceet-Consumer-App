import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class PriceComparisonIllustration extends StatefulWidget {
  const PriceComparisonIllustration({super.key});

  @override
  State<PriceComparisonIllustration> createState() => _PriceComparisonIllustrationState();
}

class _PriceComparisonIllustrationState extends State<PriceComparisonIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Animation definitions for Jumia (Center, Front)
  late final Animation<double> _jumiaScale;
  late final Animation<double> _jumiaOpacity;
  late final Animation<double> _jumiaOffsetY;

  // Animation definitions for Shoprite (Left, Back)
  late final Animation<double> _shopriteScale;
  late final Animation<double> _shopriteOpacity;
  late final Animation<double> _shopriteOffsetX;
  late final Animation<double> _shopriteRotation;

  // Animation definitions for Konga (Right, Back)
  late final Animation<double> _kongaScale;
  late final Animation<double> _kongaOpacity;
  late final Animation<double> _kongaOffsetX;
  late final Animation<double> _kongaRotation;

  // Best Deal Badge Scale
  late final Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Front card (Jumia) entry: 0.0 -> 0.5
    _jumiaScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _jumiaOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _jumiaOffsetY = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    // Left card (Shoprite) entry: 0.2 -> 0.7
    _shopriteScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _shopriteOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
    _shopriteOffsetX = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _shopriteRotation = Tween<double>(begin: 0.0, end: -4 * 3.14159 / 180).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Right card (Konga) entry: 0.35 -> 0.85
    _kongaScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutBack),
      ),
    );
    _kongaOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );
    _kongaOffsetX = Tween<double>(begin: -60.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _kongaRotation = Tween<double>(begin: 0.0, end: 4 * 3.14159 / 180).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // Best Deal Badge pop-in: 0.7 -> 1.0
    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Delay start slightly to wait for screen slide transitions
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ── Blue radial glow behind cards ──────────────────────────────
          Positioned(
            left: 0,
            top: 30,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x4D5B9BFF),
                    Color(0x262E4E80),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.35, 0.70],
                ),
              ),
            ),
          ),

          // ── Back card: Konga (rotated +4°) ────────────────────────────
          Positioned(
            right: 0,
            top: 64,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _kongaOpacity.value,
                  child: Transform.translate(
                    offset: Offset(_kongaOffsetX.value, 0),
                    child: Transform.scale(
                      scale: _kongaScale.value,
                      child: Transform.rotate(
                        angle: _kongaRotation.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: _PriceCard(
                storeName: 'Konga',
                price: '₦3,100',
                storeNameStyle: AppTextStyles.cardStoreName,
                priceStyle: AppTextStyles.cardPrice,
              ),
            ),
          ),

          // ── Back card: Shoprite (rotated -4°) ─────────────────────────
          Positioned(
            left: 0,
            top: 69,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _shopriteOpacity.value,
                  child: Transform.translate(
                    offset: Offset(_shopriteOffsetX.value, 0),
                    child: Transform.scale(
                      scale: _shopriteScale.value,
                      child: Transform.rotate(
                        angle: _shopriteRotation.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: _PriceCard(
                storeName: 'Shoprite',
                price: '₦2,400',
                storeNameStyle: AppTextStyles.cardStoreName,
                priceStyle: AppTextStyles.cardPrice,
                showBestDeal: true,
                badgeScale: _badgeScale,
              ),
            ),
          ),

          // ── Front card: Jumia (white, no rotation) ────────────────────
          Positioned(
            left: 60,
            top: 43,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _jumiaOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _jumiaOffsetY.value),
                    child: Transform.scale(
                      scale: _jumiaScale.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: _PriceCard(
                storeName: 'Jumia',
                price: '₦2,850',
                isWhite: true,
                storeNameStyle: AppTextStyles.cardStoreNameDark,
                priceStyle: AppTextStyles.cardPriceDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.storeName,
    required this.price,
    required this.storeNameStyle,
    required this.priceStyle,
    this.isWhite = false,
    this.showBestDeal = false,
    this.badgeScale,
  });

  final String storeName;
  final String price;
  final TextStyle storeNameStyle;
  final TextStyle priceStyle;
  final bool isWhite;
  final bool showBestDeal;
  final Animation<double>? badgeScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: isWhite ? 113 : (showBestDeal ? 118 : 111),
      decoration: BoxDecoration(
        color: isWhite ? const Color(0xF7FFFFFF) : const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWhite ? const Color(0xCCFFFFFF) : const Color(0x2EFFFFFF),
          width: isWhite ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isWhite ? 0.45 : 0.25),
            blurRadius: isWhite ? 60 : 24,
            offset: isWhite ? const Offset(0, 20) : const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(storeName, style: storeNameStyle, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(price, style: priceStyle, textAlign: TextAlign.center),
            if (showBestDeal) ...[
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: badgeScale ?? const AlwaysStoppedAnimation<double>(1.0),
                builder: (context, child) {
                  return Transform.scale(
                    scale: badgeScale?.value ?? 1.0,
                    child: child,
                  );
                },
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '✓ BEST DEAL',
                    style: AppTextStyles.bestDealBadge,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
