import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  const GlassCard({super.key, required this.child, this.radius = 16, this.padding = const EdgeInsets.all(12)});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0,6))],
          ),
          child: child,
        ),
      ),
    );
  }
}
