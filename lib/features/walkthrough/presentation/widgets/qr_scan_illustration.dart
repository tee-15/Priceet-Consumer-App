import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class QrScanIllustration extends StatefulWidget {
  const QrScanIllustration({super.key});

  @override
  State<QrScanIllustration> createState() => _QrScanIllustrationState();
}

class _QrScanIllustrationState extends State<QrScanIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scanAnim;
  late final Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scanAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Loop scan line up and down
    _controller.repeat(reverse: true);

    // Badge scale pop (elastic entry after a short delay)
    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 314,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── White card ─────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 200,
              height: 258,
              decoration: BoxDecoration(
                color: const Color(0xF2FFFFFF),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 64,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR code area
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 156,
                      child: Stack(
                        children: [
                          // QR pattern
                          const _QrPattern(),
                          // Corner markers
                          const _QrCornerMarker(left: 4, top: 4),
                          const _QrCornerMarker(left: 120, top: 4),
                          const _QrCornerMarker(left: 4, top: 120),
                          // Animated scan line
                          AnimatedBuilder(
                            animation: _scanAnim,
                            builder: (context, child) {
                              final y = 8 + _scanAnim.value * 130;
                              return Positioned(
                                top: y,
                                left: 4,
                                right: 4,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Color(0xFF34D399),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xCC34D399),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Store label
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Scanning at',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardStoreNameDark.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Shoprite Lagos',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardStoreNameDark.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF001444),
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── "₦3,200 Paid!" badge ───────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 26,
            child: ScaleTransition(
              scale: _badgeScale,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0x2E34D399),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(0x5934D399),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFF34D399),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '✓',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '₦3,200 Paid!',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF34D399),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPattern extends StatelessWidget {
  const _QrPattern();

  static const List<List<int>> _grid = [
    [1, 0, 1, 1, 0, 1],
    [0, 1, 1, 0, 1, 1],
    [0, 1, 1, 1, 0, 1],
    [1, 1, 0, 1, 1, 0],
    [1, 1, 1, 0, 1, 1],
    [0, 1, 1, 1, 0, 1],
    [1, 1, 0, 1, 1, 1],
  ];

  @override
  Widget build(BuildContext context) {
    const dotSize = 9.664;
    const gap = 11.66;

    return Positioned(
      left: 44,
      top: 44,
      child: SizedBox(
        width: 68,
        height: 68,
        child: Stack(
          children: [
            for (int row = 0; row < _grid.length; row++)
              for (int col = 0; col < _grid[row].length; col++)
                if (_grid[row][col] == 1)
                  Positioned(
                    left: col * gap,
                    top: row * gap,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFF001444),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _QrCornerMarker extends StatelessWidget {
  const _QrCornerMarker({required this.left, required this.top});

  final double left;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF001444), width: 4),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.fromLTRB(5, 9, 5, 4),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF001444),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
