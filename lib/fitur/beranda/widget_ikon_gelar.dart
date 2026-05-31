import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../progres/penyedia_progres.dart';

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

class _WidgetIkonGelarState extends ConsumerState<WidgetIkonGelar> {
  bool _isFirstLegenda = false;

  @override
  void initState() {
    super.initState();
    // Mengecek apakah layar harus bergetar khusus saat mencapai Legenda pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progress = ref.read(progressProvider);
      if (widget.gelar == 'Legenda' && !progress.hasSeenLegendaShake) {
        setState(() {
          _isFirstLegenda = true;
        });
        ref.read(progressProvider.notifier).markLegendaSeen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (widget.gelar) {
      case 'Pemula':
        // Bentuk membumi, tidak ada cahaya, efek bounce berat
        child = Icon(Icons.workspace_premium_rounded, color: widget.warnaGelar, size: 28)
            .animate()
            .slideY(begin: -0.5, end: 0, duration: 800.ms, curve: Curves.bounceOut);
        break;

      case 'Perunggu':
        // Medali sederhana, efek kilauan logam (shimmer) menyapu
        child = Icon(Icons.workspace_premium_rounded, color: widget.warnaGelar, size: 30)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .shimmer(duration: 2.seconds, color: Colors.white54);
        break;

      case 'Perak':
        // Tameng tegas, berdetak membesar mengecil (pulse) & kilatan tajam
        child = Icon(Icons.workspace_premium_rounded, color: widget.warnaGelar, size: 28)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1), duration: 1.seconds)
            .shimmer(duration: 1.seconds, color: Colors.white70);
        break;

      case 'Emas':
        // Bintang berlapis bersinar dengan partikel/lens flare emas
        child = Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.workspace_premium_rounded, color: widget.warnaGelar, size: 32)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: 1500.ms, color: Colors.white),
            // Partikel 1
            Positioned(
              top: -4,
              right: -4,
              child: Icon(Icons.star_rounded, color: Colors.yellow[100], size: 12)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fade(duration: 500.ms)
                  .slideY(begin: 0.2, end: -0.2, duration: 2.seconds),
            ),
            // Partikel 2
            Positioned(
              bottom: -2,
              left: -4,
              child: Icon(Icons.star_rounded, color: Colors.yellow[200], size: 10)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fade(duration: 700.ms)
                  .slideY(begin: 0.3, end: -0.3, duration: 1.seconds),
            )
          ],
        );
        break;

      case 'Platinum':
        // Futuristik segi enam, hovering naik-turun, energi cyan memutar
        child = Stack(
          alignment: Alignment.center,
          children: [
            // Energi / glow di sekitar ikon
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 2)
                ],
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1.seconds),
            Icon(Icons.workspace_premium_rounded, color: widget.warnaGelar, size: 32),
            const Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
          ],
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .slideY(begin: -0.05, end: 0.05, duration: 2.seconds); // Hovering
        break;

      case 'Berlian':
        // Refraksi pelangi pada mahkota/berlian cyan + sparkles
        child = Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.workspace_premium_rounded, color: widget.warnaGelar, size: 34)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(colors: [
                  Colors.cyanAccent,
                  Colors.purpleAccent,
                  Colors.lightBlueAccent,
                  Colors.cyanAccent,
                ], duration: 2.seconds), // Refraksi prisma
            // Sparkles 1
            Positioned(
              top: -6,
              left: -2,
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.2, 1.2), duration: 600.ms)
                  .fade(),
            ),
            // Sparkles 2
            Positioned(
              bottom: 4,
              right: -4,
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 10)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.2, 1.2), duration: 800.ms)
                  .fade(),
            ),
          ],
        );
        break;

      case 'Legenda':
        // Sangat megah, aura api menyala, icon memakan ruang lebih besar
        child = Stack(
          alignment: Alignment.center,
          children: [
            // Aura Api Latar (Bergetar seperti api)
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
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.4, 1.4), duration: 400.ms),
            // Elemen dasar (Lidah api)
            const Icon(Icons.workspace_premium_rounded, color: Colors.orangeAccent, size: 38)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 300.ms),
            // Elemen utama (Piala / Mahkota Emas)
            const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 24),
          ],
        );
        
        // Eksekusi efek Layar Bergetar (Screen Shake) khusus hanya sekali saat baru mendapatkannya
        if (_isFirstLegenda) {
          child = child
              .animate()
              .shake(hz: 8, duration: 1500.ms, curve: Curves.elasticOut); // Layar/Ikon bergetar drastis
        }
        break;

      default:
        child = Icon(Icons.psychology_rounded, color: widget.warnaGelar, size: 26);
    }

    // Dibungkus container transparan agar ukurannya konsisten dan tidak loncat-loncat
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      child: child,
    );
  }
}
