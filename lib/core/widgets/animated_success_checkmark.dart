import 'package:flutter/material.dart';

class AnimatedSuccessCheckmark extends StatefulWidget {
  const AnimatedSuccessCheckmark({
    super.key,
    this.size = 96.0,
    this.onCompleted,
  });

  final double size;
  final VoidCallback? onCompleted;

  @override
  State<AnimatedSuccessCheckmark> createState() => _AnimatedSuccessCheckmarkState();
}

class _AnimatedSuccessCheckmarkState extends State<AnimatedSuccessCheckmark>
    with TickerProviderStateMixin {
  late final AnimationController _circleController;
  late final AnimationController _checkController;
  late final AnimationController _pulseController;

  late final Animation<double> _circleScale;
  late final Animation<double> _checkDraw;

  @override
  void initState() {
    super.initState();

    // Circle pop entry (0 to 150ms)
    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _circleScale = CurvedAnimation(
      parent: _circleController,
      curve: Curves.elasticOut,
    );

    // Checkmark drawing path (150ms to 450ms)
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _checkDraw = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeInOut,
    );

    // Radial pulses looping (450ms onwards)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Run cascade
    _circleController.forward().then((_) {
      _checkController.forward().then((_) {
        widget.onCompleted?.call();
      });
    });
  }

  @override
  void dispose() {
    _circleController.dispose();
    _checkController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 1.8,
      height: widget.size * 1.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Radial pulse waves behind ──────────────────────────────────
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: List.generate(2, (index) {
                  final progress = (_pulseController.value + index / 2.0) % 1.0;
                  final scale = 1.0 + progress * 0.7;
                  final opacity = (1.0 - progress) * 0.35;
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: widget.size,
                        height: widget.size,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF22C55E),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // ── Main circle ────────────────────────────────────────────────
          ScaleTransition(
            scale: _circleScale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size * 0.3),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D16A34A),
                    blurRadius: 16,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _checkDraw,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size * 0.45, widget.size * 0.45),
                    painter: _CheckmarkPainter(progress: _checkDraw.value),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  const _CheckmarkPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;


    // Checkmark coordinate points relative to size
    final p1 = Offset(size.width * 0.15, size.height * 0.5);
    final p2 = Offset(size.width * 0.45, size.height * 0.8);
    final p3 = Offset(size.width * 0.85, size.height * 0.2);

    final pathMetric = Path();
    pathMetric.moveTo(p1.dx, p1.dy);
    pathMetric.lineTo(p2.dx, p2.dy);
    pathMetric.lineTo(p3.dx, p3.dy);

    final metricsList = pathMetric.computeMetrics().toList();
    if (metricsList.isNotEmpty) {
      final metric = metricsList.first;
      final totalLength = metric.length;
      final currentLength = totalLength * progress;
      final extractPath = metric.extractPath(0.0, currentLength);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
