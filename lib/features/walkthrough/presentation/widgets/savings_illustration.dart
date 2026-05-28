import 'package:flutter/material.dart';

/// Savings dashboard illustration for walkthrough slide 3 — "Watch Savings Grow".
///
/// Two layered cards:
///  • Top: glassmorphism stats card — Total Saved ₦15,400, +34% badge,
///    Cashback ₦1,240, Best month April.
///  • Bottom: bar chart card — Monthly Savings with 5 bars (Dec–Apr),
///    the April bar highlighted in red gradient with ₦5.2k label.
class SavingsIllustration extends StatefulWidget {
  const SavingsIllustration({super.key});

  @override
  State<SavingsIllustration> createState() => _SavingsIllustrationState();
}

class _SavingsIllustrationState extends State<SavingsIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _barAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 307.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Stats card (top, glassmorphism) ───────────────────────────
          Positioned(
            top: 0,
            left: 0,
            child: _StatsCard(),
          ),

          // ── Bar chart card (bottom) ────────────────────────────────────
          Positioned(
            top: 163,
            left: 0,
            child: _BarChartCard(barAnim: _barAnim),
          ),
        ],
      ),
    );
  }
}

// ── Stats card ─────────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrap in a separate container for the shadow, then clip the inner card.
    // This is necessary because clipBehavior clips the shadow too if combined.
    return Container(
      width: 260,
      height: 149,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 48,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.6, -1.0),
              end: Alignment(0.6, 1.0),
              colors: [
                Color(0x2EFFFFFF), // 18% white
                Color(0x0FFFFFFF), // 6% white
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0x33FFFFFF)),
          ),
          child: Stack(
            children: [
              // Decorative red circle top-right
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0x33F87171),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row: Total Saved + badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Saved',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0x80FFFFFF),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '₦15,400',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.5,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        // +34% badge
                        Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0x40FBBF24),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: const Color(0x66FBBF24),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '+34%',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFBBF24),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Row: Cashback + Best month
                    Row(
                      children: [
                        _StatItem(
                          label: 'Cashback',
                          value: '₦1,240',
                          valueColor: const Color(0xFFF87171),
                        ),
                        const SizedBox(width: 16),
                        _StatItem(
                          label: 'Best month',
                          value: 'April',
                          valueColor: const Color(0xFF34D399),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Color(0x66FFFFFF),
            height: 1.5,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── Bar chart card ─────────────────────────────────────────────────────────────

class _BarChartCard extends StatelessWidget {
  const _BarChartCard({required this.barAnim});

  final Animation<double> barAnim;

  // [label, normalised height 0–1, isHighlighted]
  static const List<(String, double, bool)> _bars = [
    ('Dec', 0.42, false),
    ('Jan', 0.65, false),
    ('Feb', 0.58, false),
    ('Mar', 0.84, false),
    ('Apr', 1.00, true),
  ];

  static const double _maxBarHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 145,
      decoration: BoxDecoration(
        color: const Color(0x12FFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      padding: const EdgeInsets.fromLTRB(19, 17, 19, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          const Text(
            'MONTHLY SAVINGS',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0x73FFFFFF),
              letterSpacing: 0.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          // Bars
          Expanded(
            child: AnimatedBuilder(
              animation: barAnim,
              builder: (context, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _bars.map((bar) {
                    final label = bar.$1;
                    final ratio = bar.$2;
                    final isHighlighted = bar.$3;
                    final barH = _maxBarHeight * ratio * barAnim.value;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Value label on highlighted bar
                            if (isHighlighted)
                              Container(
                                width: double.infinity,
                                height: 28,
                                margin: const EdgeInsets.only(bottom: 0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF87171),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 5),
                                child: const Text(
                                  '₦5.2k',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            // Bar body
                            Container(
                              width: double.infinity,
                              height: isHighlighted
                                  ? (barH - 28).clamp(0, _maxBarHeight)
                                  : barH,
                              decoration: BoxDecoration(
                                gradient: isHighlighted
                                    ? const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFF87171),
                                          Color(0xFFDC2626),
                                        ],
                                      )
                                    : null,
                                color: isHighlighted
                                    ? null
                                    : const Color(0x26FFFFFF),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                  bottomLeft: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Month label
                            Text(
                              label,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: Color(0x59FFFFFF),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
