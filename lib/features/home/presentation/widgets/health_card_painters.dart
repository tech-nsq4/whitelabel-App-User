import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Engraved geometric (Najdi-inspired) diamond lattice used as the health
/// card's background texture.
class NajdiPatternPainter extends CustomPainter {
  static const double _tile = 34;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    final thinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25;

    final cols = (size.width / _tile).ceil() + 1;
    final rows = (size.height / _tile).ceil() + 1;

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final ox = c * _tile;
        final oy = r * _tile;
        final diamond = Path()
          ..moveTo(ox + 17, oy + 1)
          ..lineTo(ox + 23.5, oy + 10.5)
          ..lineTo(ox + 33, oy + 17)
          ..lineTo(ox + 23.5, oy + 23.5)
          ..lineTo(ox + 17, oy + 33)
          ..lineTo(ox + 10.5, oy + 23.5)
          ..lineTo(ox + 1, oy + 17)
          ..lineTo(ox + 10.5, oy + 10.5)
          ..close();
        canvas.drawPath(diamond, paint);
        canvas.drawCircle(Offset(ox + 17, oy + 17), 3.4, paint);
        canvas.drawLine(
            Offset(ox, oy), Offset(ox + _tile, oy + _tile), thinPaint);
        canvas.drawLine(
            Offset(ox + _tile, oy), Offset(ox, oy + _tile), thinPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant NajdiPatternPainter oldDelegate) => false;
}

/// A deterministic mock QR code — visually convincing but not a real,
/// scannable code.
class QrMockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF0A1F1B);
    final unit = size.width / 21;

    void finder(double gx, double gy) {
      canvas.drawRect(
          Rect.fromLTWH(gx * unit, gy * unit, 6 * unit, 6 * unit), paint);
      final white = Paint()..color = Colors.white;
      canvas.drawRect(
          Rect.fromLTWH(
              (gx + 1) * unit, (gy + 1) * unit, 4 * unit, 4 * unit),
          white);
      canvas.drawRect(
          Rect.fromLTWH(
              (gx + 2) * unit, (gy + 2) * unit, 2 * unit, 2 * unit),
          paint);
    }

    finder(0, 0);
    finder(15, 0);
    finder(0, 15);

    final rand = math.Random(7);
    for (var gy = 0; gy < 21; gy++) {
      for (var gx = 0; gx < 21; gx++) {
        final inFinder =
            (gx < 7 && gy < 7) || (gx > 13 && gy < 7) || (gx < 7 && gy > 13);
        if (inFinder) continue;
        if (rand.nextDouble() < 0.42) {
          canvas.drawRect(
              Rect.fromLTWH(gx * unit, gy * unit, unit, unit), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant QrMockPainter oldDelegate) => false;
}
