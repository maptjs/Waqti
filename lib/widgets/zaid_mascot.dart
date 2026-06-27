import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

enum ZaidMood { happy, thinking, celebrating, encouraging, neutral }

class ZaidMascot extends StatelessWidget {
  final ZaidMood mood;
  final double size;
  final String? speechText;
  final bool showSpeech;

  const ZaidMascot({
    super.key,
    this.mood = ZaidMood.happy,
    this.size = 120,
    this.speechText,
    this.showSpeech = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSpeech && speechText != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: const EdgeInsets.only(bottom: 4),
            constraints: BoxConstraints(maxWidth: size * 2.5),
            decoration: BoxDecoration(
              color: WaqtiTheme.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: WaqtiTheme.primaryBlue.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: WaqtiTheme.primaryBlue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              speechText!,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: WaqtiTheme.textDark,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          Center(
            child: CustomPaint(
              size: const Size(16, 8),
              painter: _BubbleTailPainter(),
            ),
          ),
          const SizedBox(height: 4),
        ],
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ZaidPainter(mood: mood),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .moveY(
              begin: 0,
              end: mood == ZaidMood.celebrating ? -10 : -5,
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
            )
            .then()
            .moveY(
              begin: -5,
              end: 0,
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = WaqtiTheme.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
    final border = Paint()
      ..color = WaqtiTheme.primaryBlue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ZaidPainter extends CustomPainter {
  final ZaidMood mood;
  _ZaidPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.15), width: r * 1.4, height: r * 1.6),
      Radius.circular(r * 0.35),
    );
    canvas.drawRRect(bodyRect, Paint()..color = WaqtiTheme.primaryBlue);

    final shinePaint = Paint()
      ..shader = LinearGradient(
        colors: [WaqtiTheme.lightBlue.withOpacity(0.45), Colors.transparent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bodyRect.outerRect);
    canvas.drawRRect(bodyRect, shinePaint);

    final panelRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.35), width: r * 0.85, height: r * 0.7),
      Radius.circular(r * 0.15),
    );
    canvas.drawRRect(panelRect, Paint()..color = WaqtiTheme.skyBlue);

    canvas.drawCircle(Offset(cx, cy + r * 0.3), r * 0.27, Paint()..color = WaqtiTheme.white);
    canvas.drawCircle(Offset(cx, cy + r * 0.3), r * 0.27,
        Paint()..color = WaqtiTheme.starGold..style = PaintingStyle.stroke..strokeWidth = 2);
    _miniHand(canvas, Offset(cx, cy + r * 0.3), r * 0.17, -60 * math.pi / 180, WaqtiTheme.primaryBlue);
    _miniHand(canvas, Offset(cx, cy + r * 0.3), r * 0.12, 30 * math.pi / 180, WaqtiTheme.coral);

    final headRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - r * 0.62), width: r * 1.3, height: r * 1.05),
      Radius.circular(r * 0.4),
    );
    canvas.drawRRect(headRect, Paint()..color = WaqtiTheme.primaryBlue);

    canvas.drawLine(Offset(cx, cy - r * 1.1), Offset(cx, cy - r * 1.35),
        Paint()..color = WaqtiTheme.starGold..strokeWidth = r * 0.07..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(cx, cy - r * 1.38), r * 0.11, Paint()..color = WaqtiTheme.starGold);

    final eyeY = cy - r * 0.7;
    _drawEye(canvas, Offset(cx - r * 0.27, eyeY), r * 0.17);
    _drawEye(canvas, Offset(cx + r * 0.27, eyeY), r * 0.17);
    _drawMouth(canvas, Offset(cx, cy - r * 0.4), r);

    final blush = Paint()..color = WaqtiTheme.coral.withOpacity(0.3);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - r * 0.48, cy - r * 0.42), width: r * 0.25, height: r * 0.15), blush);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + r * 0.48, cy - r * 0.42), width: r * 0.25, height: r * 0.15), blush);

    final arm = Paint()..color = WaqtiTheme.primaryBlue..strokeWidth = r * 0.22..strokeCap = StrokeCap.round;
    if (mood == ZaidMood.celebrating) {
      canvas.drawLine(Offset(cx - r * 0.7, cy), Offset(cx - r * 1.15, cy - r * 0.5), arm);
      canvas.drawLine(Offset(cx + r * 0.7, cy), Offset(cx + r * 1.15, cy - r * 0.5), arm);
    } else {
      canvas.drawLine(Offset(cx - r * 0.7, cy + r * 0.05), Offset(cx - r * 1.1, cy + r * 0.35), arm);
      canvas.drawLine(Offset(cx + r * 0.7, cy + r * 0.05), Offset(cx + r * 1.1, cy + r * 0.35), arm);
    }
    canvas.drawLine(Offset(cx - r * 0.3, cy + r * 0.95), Offset(cx - r * 0.33, cy + r * 1.3), arm);
    canvas.drawLine(Offset(cx + r * 0.3, cy + r * 0.95), Offset(cx + r * 0.33, cy + r * 1.3), arm);
  }

  void _miniHand(Canvas canvas, Offset c, double len, double angle, Color color) {
    canvas.drawLine(c, Offset(c.dx + len * math.cos(angle), c.dy + len * math.sin(angle)),
        Paint()..color = color..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  void _drawEye(Canvas canvas, Offset c, double r) {
    canvas.drawOval(Rect.fromCenter(center: c, width: r * 1.6, height: r * 1.6), Paint()..color = WaqtiTheme.white);
    canvas.drawCircle(c, r * 0.5, Paint()..color = WaqtiTheme.textDark);
    canvas.drawCircle(c + Offset(-r * 0.15, -r * 0.15), r * 0.18, Paint()..color = WaqtiTheme.white);
  }

  void _drawMouth(Canvas canvas, Offset c, double r) {
    final p = Paint()
      ..color = WaqtiTheme.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.065
      ..strokeCap = StrokeCap.round;
    final path = Path();
    switch (mood) {
      case ZaidMood.celebrating:
      case ZaidMood.happy:
        path.moveTo(c.dx - r * 0.28, c.dy);
        path.quadraticBezierTo(c.dx, c.dy + r * 0.25, c.dx + r * 0.28, c.dy);
        break;
      case ZaidMood.thinking:
        path.moveTo(c.dx - r * 0.2, c.dy + r * 0.05);
        path.lineTo(c.dx + r * 0.2, c.dy + r * 0.05);
        break;
      case ZaidMood.encouraging:
        path.moveTo(c.dx - r * 0.2, c.dy);
        path.quadraticBezierTo(c.dx, c.dy + r * 0.17, c.dx + r * 0.2, c.dy);
        break;
      case ZaidMood.neutral:
        path.moveTo(c.dx - r * 0.18, c.dy + r * 0.05);
        path.lineTo(c.dx + r * 0.18, c.dy + r * 0.05);
        break;
    }
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_ZaidPainter old) => old.mood != mood;
}
