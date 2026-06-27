import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/curriculum.dart';
import '../models/progress_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/analog_clock.dart';
import '../widgets/zaid_mascot.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Color unitColor;

  const LessonScreen({super.key, required this.lesson, required this.unitColor});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _finished = false;

  // For set-hands questions
  int _setHour = 12;
  int _setMinute = 0;

  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _resetQuestion();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  TimeQuestion get _current => widget.lesson.questions[_currentIndex];

  void _resetQuestion() {
    _selectedAnswer = null;
    _answered = false;
    if (_current.type == QuestionType.setHands) {
      _setHour = 12;
      _setMinute = 0;
    }
  }

  List<String> _generateChoices() {
    final correctTime = _current.timeString;
    final choices = <String>{correctTime};
    final rng = math.Random();
    while (choices.length < 4) {
      final h = rng.nextInt(12) + 1;
      final m = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55][rng.nextInt(12)];
      final t = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
      if (t != correctTime) choices.add(t);
    }
    return choices.toList()..shuffle();
  }

  void _onChoiceSelected(String choice) {
    if (_answered) return;
    final isCorrect = choice == _current.timeString;
    setState(() {
      _selectedAnswer = widget.lesson.questions[_currentIndex].timeString == choice ? 1 : 0;
      _answered = true;
      if (isCorrect) _correctCount++;
    });
  }

  void _onSetHandsConfirm() {
    if (_answered) return;
    final isCorrect = _setHour % 12 == _current.hour % 12 && _setMinute == _current.minute;
    setState(() {
      _answered = true;
      if (isCorrect) _correctCount++;
    });
  }

  void _next() {
    if (_currentIndex < widget.lesson.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _resetQuestion();
      });
    } else {
      _onFinish();
    }
  }

  Future<void> _onFinish() async {
    final stars = _correctCount == widget.lesson.questions.length
        ? 3
        : _correctCount >= widget.lesson.questions.length * 0.6
            ? 2
            : 1;
    _confetti.play();
    setState(() => _finished = true);
    await context.read<ProgressProvider>().completeLesson(widget.lesson.id, stars);
  }

  ZaidMood get _zaidMood {
    if (_finished) return ZaidMood.celebrating;
    if (!_answered) return ZaidMood.thinking;
    final correct = _current.timeString ==
        (_selectedAnswer == 1 ? _current.timeString : '');
    return correct ? ZaidMood.celebrating : ZaidMood.encouraging;
  }

  String get _zaidSpeech {
    if (_finished) {
      return _correctCount == widget.lesson.questions.length
          ? 'رائع! أحسنت! أنت بطل حقيقي! 🏆'
          : 'أحسنت! استمر في التدريب! 💪';
    }
    if (!_answered) return _current.prompt;
    final isCorrect = (_selectedAnswer == 1) ||
        (_current.type == QuestionType.setHands &&
            _setHour % 12 == _current.hour % 12 &&
            _setMinute == _current.minute);
    return isCorrect ? 'ممتاز! إجابة صحيحة! 🌟' : 'لا بأس! حاول مرة أخرى! 💙';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: WaqtiTheme.offWhite,
        body: Stack(
          children: [
            SafeArea(
              child: _finished ? _buildFinished() : _buildQuestion(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  WaqtiTheme.starGold,
                  WaqtiTheme.coral,
                  WaqtiTheme.mint,
                  WaqtiTheme.primaryBlue,
                  WaqtiTheme.lilac,
                ],
                numberOfParticles: 40,
                emissionFrequency: 0.08,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final total = widget.lesson.questions.length;
    return Column(
      children: [
        _buildTopBar(total),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                ZaidMascot(
                  mood: _answered ? (_correctCount > _currentIndex - 1 + (_answered ? 1 : 0) ? ZaidMood.celebrating : ZaidMood.encouraging) : ZaidMood.thinking,
                  size: 100,
                  speechText: _zaidSpeech,
                ),
                const SizedBox(height: 20),
                AnalogClock(
                  hour: _current.hour,
                  minute: _current.minute,
                  size: 210,
                ),
                const SizedBox(height: 24),
                if (_current.type == QuestionType.multipleChoice)
                  _buildChoices()
                else
                  _buildSetHands(),
                const SizedBox(height: 20),
                if (_answered) _buildNextButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(int total) {
    final progress = (_currentIndex + 1) / total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: widget.unitColor,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: WaqtiTheme.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  widget.lesson.title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: WaqtiTheme.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                '${_currentIndex + 1}/$total',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: WaqtiTheme.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: WaqtiTheme.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(WaqtiTheme.starGold),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoices() {
    final choices = _generateChoices();
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: choices.map((choice) {
        final isCorrect = choice == _current.timeString;
        Color bgColor = WaqtiTheme.white;
        Color borderColor = widget.unitColor.withOpacity(0.3);
        Color textColor = WaqtiTheme.textDark;

        if (_answered) {
          if (isCorrect) {
            bgColor = WaqtiTheme.mint.withOpacity(0.15);
            borderColor = WaqtiTheme.mint;
            textColor = WaqtiTheme.mint;
          } else if (_selectedAnswer == 0 && !isCorrect) {
            bgColor = WaqtiTheme.coral.withOpacity(0.08);
            borderColor = WaqtiTheme.coral.withOpacity(0.4);
          }
        }

        return GestureDetector(
          onTap: () => _onChoiceSelected(choice),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                choice,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSetHands() {
    final isCorrect = _answered &&
        _setHour % 12 == _current.hour % 12 &&
        _setMinute == _current.minute;

    return Column(
      children: [
        Text(
          'حرّك العقارب إلى: ${_current.timeString}',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: WaqtiTheme.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        InteractiveClock(
          initialHour: _setHour,
          initialMinute: _setMinute,
          size: 220,
          onTimeChanged: (h, m) {
            if (!_answered) setState(() { _setHour = h; _setMinute = m; });
          },
        ),
        const SizedBox(height: 12),
        Text(
          '${_setHour.toString().padLeft(2, '0')}:${_setMinute.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: _answered
                ? (isCorrect ? WaqtiTheme.mint : WaqtiTheme.coral)
                : widget.unitColor,
          ),
        ),
        if (!_answered) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onSetHandsConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.unitColor,
              foregroundColor: WaqtiTheme.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'تحقّق',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNextButton() {
    final isLast = _currentIndex == widget.lesson.questions.length - 1;
    return ElevatedButton(
      onPressed: _next,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.unitColor,
        foregroundColor: WaqtiTheme.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      child: Text(
        isLast ? 'أكمل الدرس 🎉' : 'التالي ←',
        style: const TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildFinished() {
    final stars = _correctCount == widget.lesson.questions.length
        ? 3
        : _correctCount >= widget.lesson.questions.length * 0.6
            ? 2
            : 1;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZaidMascot(
              mood: ZaidMood.celebrating,
              size: 140,
              speechText: _correctCount == widget.lesson.questions.length
                  ? 'مذهل! حصلت على كل النجوم! 🏆'
                  : 'أحسنت! استمر في التدريب! 💪',
            ).animate().scale(begin: const Offset(0.5, 0.5)).fadeIn(),
            const SizedBox(height: 32),
            Text(
              'انتهى الدرس!',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: WaqtiTheme.textDark,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Text(
                  i < stars ? '⭐' : '☆',
                  style: const TextStyle(fontSize: 44),
                ).animate(delay: Duration(milliseconds: 400 + i * 150)).scale(begin: const Offset(0, 0));
              }),
            ),
            const SizedBox(height: 12),
            Text(
              '$_correctCount من ${widget.lesson.questions.length} إجابات صحيحة',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                color: WaqtiTheme.textMid,
              ),
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.unitColor,
                foregroundColor: WaqtiTheme.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              child: const Text(
                'العودة للمسار',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
