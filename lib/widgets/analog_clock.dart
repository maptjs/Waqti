import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnalogClock extends StatelessWidget {
  final int hour;
  final int minute;
  final double size;
  final bool showNumbers;
  final bool animate;

  const AnalogClock({
    super.key,
    required this.hour,
    required this.minute,
    this.size = 200,
    this.showNumbers = true,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ClockPainter(
          hour: hour,
          minute: minute,
          showNumbers: showNumbers,
        ),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final int hour;
  final int minute;
  final bool showNumbers;

  _ClockPainter({
    required this.hour,
    required this.minute,
    required this.showNumbers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center + const Offset(4, 6), radius - 4, shadowPaint);

    // Draw clock face
    final facePaint = Paint()..color = WaqtiTheme.white;
    canvas.drawCircle(center, radius - 4, facePaint);

    // Draw border
    final borderPaint = Paint()
      ..color = WaqtiTheme.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06;
    canvas.drawCircle(center, radius - 4, borderPaint);

    // Draw outer ring decoration
    final ringPaint = Paint()
      ..color = WaqtiTheme.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.025;
    canvas.drawCircle(center, radius - 10, ringPaint);

    // Draw hour ticks
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final isMainTick = i % 3 == 0;
      final tickLength = isMainTick ? radius * 0.12 : radius * 0.07;
      final tickWidth = isMainTick ? radius * 0.04 : radius * 0.02;
      final tickStart = Offset(
        center.dx + (radius - 14) * math.cos(angle),
        center.dy + (radius - 14) * math.sin(angle),
      );
      final tickEnd = Offset(
        center.dx + (radius - 14 - tickLength) * math.cos(angle),
        center.dy + (radius - 14 - tickLength) * math.sin(angle),
      );
      final tickPaint = Paint()
        ..color = isMainTick ? WaqtiTheme.primaryBlue : WaqtiTheme.lightBlue
        ..strokeWidth = tickWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(tickStart, tickEnd, tickPaint);
    }

    // Draw numbers
    if (showNumbers) {
      for (int i = 1; i <= 12; i++) {
        final angle = (i * 30 - 90) * math.pi / 180;
        final numRadius = radius * 0.65;
        final numPos = Offset(
          center.dx + numRadius * math.cos(angle),
          center.dy + numRadius * math.sin(angle),
        );
        final tp = TextPainter(
          text: TextSpan(
            text: i.toString(),
            style: TextStyle(
              color: WaqtiTheme.textDark,
              fontSize: radius * 0.17,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, numPos - Offset(tp.width / 2, tp.height / 2));
      }
    }

    // Hour hand angle
    final hourAngle = ((hour % 12) * 30 + minute * 0.5 - 90) * math.pi / 180;
    // Minute hand angle
    final minuteAngle = (minute * 6 - 90) * math.pi / 180;

    // Draw minute hand
    _drawHand(canvas, center, minuteAngle, radius * 0.68, radius * 0.025,
        WaqtiTheme.coral);

    // Draw hour hand
    _drawHand(canvas, center, hourAngle, radius * 0.48, radius * 0.04,
        WaqtiTheme.primaryBlue);

    // Draw center dot
    final centerDotPaint = Paint()..color = WaqtiTheme.starGold;
    canvas.drawCircle(center, radius * 0.055, centerDotPaint);
    final centerDotInner = Paint()..color = WaqtiTheme.white;
    canvas.drawCircle(center, radius * 0.025, centerDotInner);
  }

  void _drawHand(Canvas canvas, Offset center, double angle, double length,
      double width, Color color) {
    final handPaint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    final tip = Offset(
      center.dx + length * math.cos(angle),
      center.dy + length * math.sin(angle),
    );

    // Small tail
    final tail = Offset(
      center.dx - (length * 0.18) * math.cos(angle),
      center.dy - (length * 0.18) * math.sin(angle),
    );

    canvas.drawLine(tail, tip, handPaint);
  }

  @override
  bool shouldRepaint(_ClockPainter old) =>
      old.hour != hour || old.minute != minute;
}

// ─── Interactive clock (drag-to-set hands) ───────────────────────────────────

class InteractiveClock extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final double size;
  final Function(int hour, int minute) onTimeChanged;

  const InteractiveClock({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.onTimeChanged,
    this.size = 260,
  });

  @override
  State<InteractiveClock> createState() => _InteractiveClockState();
}

class _InteractiveClockState extends State<InteractiveClock> {
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final localPos = details.localPosition;
    final angle = math.atan2(localPos.dy - center.dy, localPos.dx - center.dx);
    final degrees = (angle * 180 / math.pi + 90 + 360) % 360;

    // Determine if closer to minute or hour hand
    final hourDeg = ((_hour % 12) * 30 + _minute * 0.5 + 360) % 360;
    final minDeg = (_minute * 6 + 360) % 360;
    final distHour = _angleDiff(degrees, hourDeg);
    final distMin = _angleDiff(degrees, minDeg);

    if (distMin < distHour) {
      final newMinute = ((degrees / 6).round()) % 60;
      setState(() => _minute = newMinute);
    } else {
      final newHour = ((degrees / 30).round()) % 12;
      setState(() => _hour = newHour == 0 ? 12 : newHour);
    }
    widget.onTimeChanged(_hour, _minute);
  }

  double _angleDiff(double a, double b) {
    double diff = (a - b).abs();
    if (diff > 180) diff = 360 - diff;
    return diff;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) => _onPanUpdate(
          d, Size(widget.size, widget.size)),
      child: AnalogClock(
        hour: _hour,
        minute: _minute,
        size: widget.size,
      ),
    );
  }
}
