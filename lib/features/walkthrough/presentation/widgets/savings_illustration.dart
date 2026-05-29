import 'package:flutter/material.dart';

class SavingsIllustration extends StatefulWidget {
  const SavingsIllustration({super.key});

  @override
  State<SavingsIllustration> createState() => _SavingsIllustrationState();
}

class _SavingsIllustrationState extends State<SavingsIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Layered cards slide & fade
  late final Animation<double> _statsCardOpacity;
  late final Animation<double> _statsCardSlide;
  late final Animation<double> _chartCardOpacity;
  late final Animation<double> _chartCardSlide;

  // Staggered bars growth
  late final List<Animation<double>> _barAnimations;

  // April highlighted tag scale
  late final Animation<double> _highlightTagScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Stats Card entry: 0.0 -> 0.45
    _statsCardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );
    _statsCardSlide = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // Chart Card entry: 0.15 -> 0.60
    _chartCardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.45, curve: Curves.easeIn),
      ),
    );
    _chartCardSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.60, curve: Curves.easeOutCubic),
      ),
    );

    // Staggered bar animations (5 bars)
    // Starts around 0.4 and spreads up to 0.9
    _barAnimations = List.generate(5, (index) {
      final start = 0.4 + (index * 0.09);
      final end = (start + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    // Highlight bubble tag pop: 0.75 -> 1.0
    _highlightTagScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Delay slightly to coordinate with page transitions
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
      width: 260,
      height: 307.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Stats card (top, glassmorphism) ───────────────────────────
          Positioned(
            top: 0,
            left: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _statsCardOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _statsCardSlide.value),
                    child: child,
                  ),
                );
              },
              child: _StatsCard(),
            ),
          ),

          // ── Bar chart card (bottom) ────────────────────────────────────
          Positioned(
            top: 163,
            left: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _chartCardOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _chartCardSlide.value),
                    child: child,
                  ),
                );
              },
              child: _BarChartCard(
                barAnimations: _barAnimations,
                highlightTagScale: _highlightTagScale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                Color(0x2EFFFFFF),
                Color(0x0FFFFFFF),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0x33FFFFFF)),
          ),
          child: Stack(
            children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Saved',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0x80FFFFFF),
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
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
                        Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0x40FBBF24),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: const Color(0x66FBBF24)),
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
                    const Row(
                      children: [
                        _StatItem(
                          label: 'Cashback',
                          value: '₦1,240',
                          valueColor: Color(0xFFF87171),
                        ),
                        SizedBox(width: 16),
                        _StatItem(
                          label: 'Best month',
                          value: 'April',
                          valueColor: Color(0xFF34D399),
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

class _BarChartCard extends StatelessWidget {
  const _BarChartCard({
    required this.barAnimations,
    required this.highlightTagScale,
  });

  final List<Animation<double>> barAnimations;
  final Animation<double> highlightTagScale;

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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_bars.length, (i) {
                final bar = _bars[i];
                final label = bar.$1;
                final ratio = bar.$2;
                final isHighlighted = bar.$3;
                final barAnim = barAnimations[i];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedBuilder(
                      animation: barAnim,
                      builder: (context, child) {
                        final barH = _maxBarHeight * ratio * barAnim.value;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isHighlighted)
                              ScaleTransition(
                                scale: highlightTagScale,
                                child: Container(
                                  width: double.infinity,
                                  height: 28,
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
                              ),
                            Container(
                              width: double.infinity,
                              height: isHighlighted ? (barH - 28).clamp(0.0, _maxBarHeight) : barH,
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
                                color: isHighlighted ? null : const Color(0x26FFFFFF),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                  bottomLeft: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
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
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
