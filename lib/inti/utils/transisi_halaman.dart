import 'package:flutter/material.dart';

class TransisiPremium extends PageRouteBuilder {
  final Widget child;

  TransisiPremium({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animasi untuk layar yang baru masuk (Fade + Scale-up + ringan Slide-up)
            var slideIn = Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
            var fadeIn = Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            var scaleIn = Tween<double>(begin: 0.95, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            // Animasi untuk layar lama yang ditinggalkan (Fade-out + ringan Scale-down)
            var scaleOut = Tween<double>(begin: 1.0, end: 1.05)
                .animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic));
            var fadeOut = Tween<double>(begin: 1.0, end: 0.0)
                .animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn));

            return FadeTransition(
              opacity: fadeOut,
              child: ScaleTransition(
                scale: scaleOut,
                child: SlideTransition(
                  position: slideIn,
                  child: FadeTransition(
                    opacity: fadeIn,
                    child: ScaleTransition(
                      scale: scaleIn,
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          },
        );
}
