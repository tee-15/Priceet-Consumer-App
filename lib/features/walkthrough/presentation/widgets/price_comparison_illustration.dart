import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The animated price-card illustration shown on the walkthrough screen.
/// Three frosted-glass cards (Shoprite, Konga, Jumia) fanned out with
/// slight rotations, matching the Figma design exactly.
class PriceComparisonIllustration extends StatelessWidget {
  const PriceComparisonIllustration({super.key});

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
                    Color(0x4D5B9BFF), // rgba(91,155,255,0.3)
                    Color(0x262E4E80), // rgba(46,78,128,0.15)
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
            child: Transform.rotate(
              angle: 4 * 3.14159 / 180,
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
            child: Transform.rotate(
              angle: -4 * 3.14159 / 180,
              child: _PriceCard(
                storeName: 'Shoprite',
                price: '₦2,400',
                storeNameStyle: AppTextStyles.cardStoreName,
                priceStyle: AppTextStyles.cardPrice,
                showBestDeal: true,
              ),
            ),
          ),

          // ── Front card: Jumia (white, no rotation) ────────────────────
          Positioned(
            left: 60,
            top: 43,
            child: _PriceCard(
              storeName: 'Jumia',
              price: '₦2,850',
              isWhite: true,
              storeNameStyle: AppTextStyles.cardStoreNameDark,
              priceStyle: AppTextStyles.cardPriceDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single frosted-glass price card.
class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.storeName,
    required this.price,
    required this.storeNameStyle,
    required this.priceStyle,
    this.isWhite = false,
    this.showBestDeal = false,
  });

  final String storeName;
  final String price;
  final TextStyle storeNameStyle;
  final TextStyle priceStyle;
  final bool isWhite;
  final bool showBestDeal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: isWhite ? 113 : (showBestDeal ? 118 : 111),
      decoration: BoxDecoration(
        color: isWhite
            ? const Color(0xF7FFFFFF)
            : const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWhite
              ? const Color(0xCCFFFFFF)
              : const Color(0x2EFFFFFF),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(storeName, style: storeNameStyle, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(price, style: priceStyle, textAlign: TextAlign.center),
          if (showBestDeal) ...[
            const SizedBox(height: 8),
            Container(
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: Text(
                '✓ BEST DEAL',
                style: AppTextStyles.bestDealBadge,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
