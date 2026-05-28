import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../fitur/progres/penyedia_progres.dart';

class AnimasiPendar extends ConsumerStatefulWidget {
  final Widget child;
  final Color warna;
  final double borderRadius;
  final double borderWidth;
  final bool isCircle;
  final bool forceLegend;

  const AnimasiPendar({
    super.key,
    required this.child,
    required this.warna,
    this.borderRadius = 0,
    this.borderWidth = 2.0,
    this.isCircle = false,
    this.forceLegend = false,
  });

  @override
  ConsumerState<AnimasiPendar> createState() => _AnimasiPendarState();
}

class _AnimasiPendarState extends ConsumerState<AnimasiPendar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final isLegend = progress.totalStars >= 2100 || widget.forceLegend;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _PendarPainter(
              rotation: _controller.value * 2 * math.pi,
              warna: widget.warna,
              borderRadius: widget.borderRadius,
              borderWidth: isLegend ? widget.borderWidth * 1.5 : widget.borderWidth,
              isCircle: widget.isCircle,
              isLegend: isLegend,
              animationValue: _controller.value,
            ),
            child: child,
          );
        },
        child: Padding(
          padding: EdgeInsets.all(widget.borderWidth),
          child: widget.child,
        ),
      ),
    );
  }
}

class _PendarPainter extends CustomPainter {
  final double rotation;
  final Color warna;
  final double borderRadius;
  final double borderWidth;
  final bool isCircle;
  final bool isLegend;
  final double animationValue;

  _PendarPainter({
    required this.rotation,
    required this.warna,
    required this.borderRadius,
    required this.borderWidth,
    required this.isCircle,
    this.isLegend = false,
    this.animationValue = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(borderWidth / 2);

    final sweepGradient = SweepGradient(
      colors: [
        warna.withValues(alpha: 0.0),
        warna.withValues(alpha: 1.0),
        warna.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.15, 0.3],
      transform: GradientRotation(rotation),
    ).createShader(rect);

    Path path = Path();
    if (isCircle) {
      path.addOval(rect);
    } else {
      path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
    }

    final glowPaint = Paint()
      ..shader = sweepGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = isLegend ? borderWidth * 4 : borderWidth * 3
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isLegend ? 20.0 : 12.0);

    final borderPaint = Paint()
      ..shader = sweepGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, borderPaint);

    if (isLegend) {
      final metrics = path.computeMetrics().toList();
      if (metrics.isNotEmpty) {
        final metric = metrics.first;
        final sparkPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
          // Menghapus maskFilter blur pada percikan untuk mengurangi lag
          
        final int numSparks = 8; // Mengurangi jumlah percikan agar lebih ringan
        for (int i = 0; i < numSparks; i++) {
          double headProgress = (animationValue + 0.15) % 1.0;
          double sparkOffset = (i * 0.02) + (math.sin(i * 123.45) * 0.01);
          double p = (headProgress - sparkOffset) % 1.0;
          if (p < 0) p += 1.0;
          
          final length = metric.length * p;
          final tangent = metric.getTangentForOffset(length);
          if (tangent != null) {
            final offsetDist = math.sin(animationValue * 50 + i * 42) * 6.0;
            final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
            final sparkPos = tangent.position + normal * offsetDist;
            
            final sparkSize = 1.0 + math.sin(animationValue * 40 + i * 11).abs() * 2.0;
            
            double alphaRatio = 1.0 - (i / numSparks);
            sparkPaint.color = warna.withValues(alpha: alphaRatio * 0.9);
            
            canvas.drawCircle(sparkPos, sparkSize, sparkPaint);
            
            // Core
            sparkPaint.color = Colors.white.withValues(alpha: alphaRatio);
            canvas.drawCircle(sparkPos, sparkSize * 0.6, sparkPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PendarPainter oldDelegate) {
    return oldDelegate.rotation != rotation || oldDelegate.warna != warna;
  }
}

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const MarqueeText({super.key, required this.text, required this.style});

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(constraints.maxWidth - (_controller.value * constraints.maxWidth * 2.5), 0),
                child: Text(
                  widget.text,
                  style: widget.style,
                  maxLines: 1,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
