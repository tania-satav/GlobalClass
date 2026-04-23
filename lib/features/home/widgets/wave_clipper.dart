import 'dart:math';
import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  final double progress;
  final double wavePhase;

  WaveClipper({
    required this.progress,
    required this.wavePhase,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    final waterHeight = size.height * (1 - progress);

    path.lineTo(0, waterHeight);

    for (double x = 0; x <= size.width; x++) {
      final y = waterHeight +
          sin((x / size.width * 2 * pi) + wavePhase) * 6;

      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) {
    return oldClipper.wavePhase != wavePhase ||
        oldClipper.progress != progress;
  }
}