import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../progres/penyedia_progres.dart';
import '../../inti/utils/audio_helper.dart';

class WidgetIkonGelar extends ConsumerStatefulWidget {
  final String gelar;
  final Color warnaGelar;

  const WidgetIkonGelar({
    super.key,
    required this.gelar,
    required this.warnaGelar,
  });

  @override
  ConsumerState<WidgetIkonGelar> createState() => _WidgetIkonGelarState();
}

class _WidgetIkonGelarState extends ConsumerState<WidgetIkonGelar> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  Offset _tilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progress = ref.read(progressProvider);
      if (widget.gelar == 'Legenda' && !progress.hasSeenLegendaShake) {
        ref.read(progressProvider.notifier).markLegendaSeen();
      }
    });
  }

  void _onPanDown(DragDownDetails details) {
    AudioHelper.playClick();
    setState(() => _scale = 1.15); // Membesar saat ditekan
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Menghitung kemiringan 3D berdasarkan posisi jari relatif terhadap pusat ikon
    final x = (details.localPosition.dx - 23) / 23;
    final y = (details.localPosition.dy - 23) / 23;
    setState(() {
      _tilt = Offset(y.clamp(-1.0, 1.0), -x.clamp(-1.0, 1.0));
    });
  }

  void _onPanEnd() {
    setState(() {
      _scale = 1.0;
      _tilt = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (widget.gelar) {
      case 'Pemula':
        // Breathing
        child = Icon(Icons.egg_alt, color: widget.warnaGelar, size: 28)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.15, 1.15), duration: 2.seconds, curve: Curves.easeInOutSine);
        break;

      case 'Perunggu':
        // Heartbeat (deg-deg... delay...)
        child = Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.military_tech, color: widget.warnaGelar, size: 30),
            Icon(Icons.military_tech, color: Colors.white, size: 30)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: 2.seconds, delay: 1.seconds, color: Colors.white54),
          ],
        )
        .animate(onPlay: (c) => c.repeat())
        .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 150.ms, curve: Curves.easeOut)
        .then().scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1), duration: 150.ms, curve: Curves.easeIn)
        .then().scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 150.ms, curve: Curves.easeOut)
        .then().scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1), duration: 150.ms, curve: Curves.easeIn)
        .then(delay: 2.seconds);
        break;

      case 'Perak':
        // Gentle Hover
        child = Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shield, color: widget.warnaGelar, size: 28),
            Icon(Icons.shield, color: Colors.white, size: 28)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 2.seconds, color: Colors.white70),
          ],
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .slideY(begin: 0.1, end: -0.1, duration: 1500.ms, curve: Curves.easeInOutSine);
        break;

      case 'Emas':
        // Triumphant Bounce
        child = Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.emoji_events, color: widget.warnaGelar, size: 32)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: 1500.ms, color: Colors.white),
            Positioned(
              top: -4,
              right: -4,
              child: Icon(Icons.star_rounded, color: Colors.yellow[100], size: 12)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fade(duration: 500.ms)
                  .slideY(begin: 0.2, end: -0.2, duration: 2.seconds),
            ),
            Positioned(
              bottom: -2,
              left: -4,
              child: Icon(Icons.star_rounded, color: Colors.yellow[200], size: 10)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fade(duration: 700.ms)
                  .slideY(begin: 0.3, end: -0.3, duration: 1.seconds),
            )
          ],
        )
        .animate(onPlay: (c) => c.repeat())
        .slideY(begin: 0, end: -0.4, duration: 600.ms, curve: Curves.easeOutQuad)
        .then().slideY(begin: -0.4, end: 0, duration: 800.ms, curve: Curves.bounceOut)
        .then(delay: 1.seconds);
        break;

      case 'Platinum':
        // Glitch / Pulse
        child = Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 2)
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 1.seconds),
            Icon(Icons.diamond_outlined, color: widget.warnaGelar, size: 32),
            const Icon(Icons.bolt, color: Colors.white, size: 16)
               .animate(onPlay: (c) => c.repeat(reverse: true))
               .fadeIn(duration: 300.ms)
               .shimmer(color: Colors.cyanAccent, duration: 500.ms),
          ],
        )
        .animate(onPlay: (c) => c.repeat())
        .shake(hz: 12, duration: 300.ms, curve: Curves.easeInOut)
        .then(delay: 2.seconds);
        break;

      case 'Berlian':
        // Zero-Gravity Swing
        child = Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.diamond, color: widget.warnaGelar, size: 34)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(colors: [
                  Colors.cyanAccent,
                  Colors.purpleAccent,
                  Colors.lightBlueAccent,
                  Colors.cyanAccent,
                ], duration: 2.seconds),
            Positioned(
              top: -6,
              left: -2,
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.2, 1.2), duration: 600.ms)
                  .fade(),
            ),
            Positioned(
              bottom: 4,
              right: -4,
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 10)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.2, 1.2), duration: 800.ms)
                  .fade(),
            ),
          ],
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .rotate(begin: -0.05, end: 0.05, duration: 3.seconds, curve: Curves.easeInOutSine)
        .slideX(begin: -0.05, end: 0.05, duration: 4.seconds, curve: Curves.easeInOutSine)
        .slideY(begin: -0.05, end: 0.05, duration: 3500.ms, curve: Curves.easeInOutSine);
        break;

      case 'Legenda':
        // Power Eruption (Konstan)
        child = Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.redAccent.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 4),
                  BoxShadow(color: Colors.orangeAccent.withValues(alpha: 0.6), blurRadius: 8, spreadRadius: 1),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 500.ms),
            const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 38)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 400.ms),
            const Icon(Icons.emoji_events, color: Colors.amber, size: 24)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 1.seconds, color: Colors.white),
          ],
        )
        .animate(onPlay: (c) => c.repeat())
        .shake(hz: 6, duration: 2.seconds, curve: Curves.easeInOut);
        break;

      default:
        child = Icon(Icons.psychology, color: widget.warnaGelar, size: 26);
    }

    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective
      ..rotateX(_tilt.dx * 0.5)
      ..rotateY(_tilt.dy * 0.5);

    return GestureDetector(
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: (d) => _onPanEnd(),
      onPanCancel: _onPanEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: matrix,
        transformAlignment: Alignment.center,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }
}
