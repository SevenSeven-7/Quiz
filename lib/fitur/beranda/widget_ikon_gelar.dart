import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetIkonGelar extends ConsumerWidget {
  final String gelar;
  final Color warnaGelar;

  const WidgetIkonGelar({
    super.key,
    required this.gelar,
    required this.warnaGelar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget child;

    switch (gelar) {
      case 'Pemula':
        child = Icon(Icons.egg_alt, color: warnaGelar, size: 28);
        break;
      case 'Perunggu':
        child = Icon(Icons.military_tech, color: warnaGelar, size: 30);
        break;
      case 'Perak':
        child = Icon(Icons.shield, color: warnaGelar, size: 28);
        break;
      case 'Emas':
        child = Icon(Icons.emoji_events, color: warnaGelar, size: 32);
        break;
      case 'Platinum':
        child = Icon(Icons.diamond_outlined, color: warnaGelar, size: 32);
        break;
      case 'Berlian':
        child = Icon(Icons.diamond, color: warnaGelar, size: 34);
        break;
      case 'Legenda':
        child = const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 38);
        break;
      default:
        child = Icon(Icons.psychology, color: warnaGelar, size: 26);
    }

    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      color: Colors.transparent,
      child: child,
    );
  }
}
