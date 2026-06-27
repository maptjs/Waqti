import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/analog_clock.dart';
import '../widgets/zaid_mascot.dart';

class FreePlayScreen extends StatefulWidget {
  const FreePlayScreen({super.key});

  @override
  State<FreePlayScreen> createState() => _FreePlayScreenState();
}

class _FreePlayScreenState extends State<FreePlayScreen> {
  int _hour = 3;
  int _minute = 0;

  String _buildArabicTime() {
    final h = _hour == 0 ? 12 : (_hour > 12 ? _hour - 12 : _hour);
    final period = _hour < 12 ? 'صباحًا' : 'مساءً';

    String timeStr;
    if (_minute == 0) {
      timeStr = 'الساعة ${_arabicHour(h)} $period';
    } else if (_minute == 30) {
      timeStr = 'الساعة ${_arabicHour(h)} والنصف $period';
    } else if (_minute == 15) {
      timeStr = 'الساعة ${_arabicHour(h)} والربع $period';
    } else if (_minute == 45) {
      timeStr = 'الساعة ${_arabicHour((h % 12) + 1)} إلا ربعًا $period';
    } else if (_minute < 30) {
      timeStr = 'الساعة ${_arabicHour(h)} و$_minute دقيقة $period';
    } else {
      timeStr = 'الساعة ${_arabicHour(h)} و$_minute دقيقة $period';
    }
    return timeStr;
  }

  String _arabicHour(int h) {
    const words = ['', 'الواحدة', 'الثانية', 'الثالثة', 'الرابعة', 'الخامسة', 'السادسة', 'السابعة', 'الثامنة', 'التاسعة', 'العاشرة', 'الحادية عشرة', 'الثانية عشرة'];
    if (h >= 1 && h <= 12) return words[h];
    return h.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F5E9), WaqtiTheme.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // App bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: WaqtiTheme.mint,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_forward, color: WaqtiTheme.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          '🕐 العب بالساعة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: WaqtiTheme.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        ZaidMascot(
                          mood: ZaidMood.happy,
                          size: 110,
                          speechText: _buildArabicTime(),
                        ).animate().fadeIn(),
                        const SizedBox(height: 24),
                        InteractiveClock(
                          initialHour: _hour,
                          initialMinute: _minute,
                          size: 260,
                          onTimeChanged: (h, m) => setState(() {
                            _hour = h;
                            _minute = m;
                          }),
                        ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(delay: 200.ms),
                        const SizedBox(height: 24),
                        // Digital display
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: WaqtiTheme.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: WaqtiTheme.mint.withOpacity(0.4), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: WaqtiTheme.mint.withOpacity(0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            '${(_hour == 0 ? 12 : (_hour > 12 ? _hour - 12 : _hour)).toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: WaqtiTheme.primaryBlue,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: WaqtiTheme.skyBlue,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            _buildArabicTime(),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: WaqtiTheme.primaryBlue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Hint
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.touch_app, color: WaqtiTheme.textMid, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'اسحب العقارب لتغيير الوقت',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: WaqtiTheme.textMid,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
