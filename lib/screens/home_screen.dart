import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/curriculum.dart';
import '../models/progress_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/zaid_mascot.dart';
import 'lesson_screen.dart';
import 'free_play_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [WaqtiTheme.skyBlue, WaqtiTheme.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      _buildZaidWelcome(),
                      const SizedBox(height: 16),
                      _buildFreePlayButton(context),
                      const SizedBox(height: 20),
                      _buildUnitsPath(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progress, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: WaqtiTheme.primaryBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Row(
            children: [
              // Streak
              _HeaderStat(
                icon: '🔥',
                value: '${progress.streakDays}',
                label: 'يوم',
              ),
              const Spacer(),
              const Text(
                'وقتي ⏰',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: WaqtiTheme.white,
                ),
              ),
              const Spacer(),
              // Stars
              _HeaderStat(
                icon: '⭐',
                value: '${progress.totalStars}',
                label: 'نجمة',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildZaidWelcome() {
    return Center(
      child: ZaidMascot(
        mood: ZaidMood.happy,
        size: 110,
        speechText: 'مرحباً! هل أنت مستعد لتعلّم الوقت؟ 🎉',
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildFreePlayButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FreePlayScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [WaqtiTheme.starGold, Color(0xFFFFB300)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: WaqtiTheme.starGold.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('🕐', style: TextStyle(fontSize: 28)),
            SizedBox(width: 12),
            Text(
              'العب بالساعة بحرية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: WaqtiTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildUnitsPath(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 4, bottom: 12),
          child: Text(
            'مسار التعلّم',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: WaqtiTheme.textDark,
            ),
          ),
        ),
        ...Curriculum.units.asMap().entries.map((entry) {
          final idx = entry.key;
          final unit = entry.value;
          return _UnitCard(unit: unit, unitIndex: idx)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 300 + idx * 100))
              .slideX(begin: idx.isEven ? -0.2 : 0.2, end: 0);
        }),
      ],
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: WaqtiTheme.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: WaqtiTheme.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _UnitCard extends StatelessWidget {
  final Unit unit;
  final int unitIndex;

  const _UnitCard({required this.unit, required this.unitIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progress, _) {
        final lessonIds = unit.lessons.map((l) => l.id).toList();
        final completedCount = lessonIds.where((id) => progress.isLessonCompleted(id)).length;
        final isLocked = unitIndex > 0 &&
            !progress.isUnitCompleted(
              Curriculum.units[unitIndex - 1].id,
              Curriculum.units[unitIndex - 1].lessons.map((l) => l.id).toList(),
            );
        final isFree = unitIndex == 0;
        final color = WaqtiTheme.unitColors[unitIndex % WaqtiTheme.unitColors.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: WaqtiTheme.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Unit header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(unit.emoji, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  unit.title,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: WaqtiTheme.textDark,
                                  ),
                                ),
                              ),
                              if (isFree)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: WaqtiTheme.mint,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'مجاني',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: WaqtiTheme.white,
                                    ),
                                  ),
                                ),
                              if (isLocked)
                                const Text('🔒', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          Text(
                            unit.subtitle,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: WaqtiTheme.textMid,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: unit.lessons.isEmpty ? 0 : completedCount / unit.lessons.length,
                              backgroundColor: color.withOpacity(0.15),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$completedCount / ${unit.lessons.length} دروس',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: WaqtiTheme.textMid,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Lessons list
              if (!isLocked)
                ...unit.lessons.asMap().entries.map((e) {
                  final lessonIdx = e.key;
                  final lesson = e.value;
                  final done = progress.isLessonCompleted(lesson.id);
                  final stars = progress.getLessonStars(lesson.id);
                  return _LessonRow(
                    lesson: lesson,
                    lessonIndex: lessonIdx,
                    unitColor: color,
                    isDone: done,
                    stars: stars,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(lesson: lesson, unitColor: color),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _LessonRow extends StatelessWidget {
  final Lesson lesson;
  final int lessonIndex;
  final Color unitColor;
  final bool isDone;
  final int stars;
  final VoidCallback onTap;

  const _LessonRow({
    required this.lesson,
    required this.lessonIndex,
    required this.unitColor,
    required this.isDone,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Lesson number badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDone ? unitColor : unitColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, color: WaqtiTheme.white, size: 18)
                    : Text(
                        '${lessonIndex + 1}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: unitColor,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: WaqtiTheme.textDark,
                    ),
                  ),
                  Text(
                    lesson.subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: WaqtiTheme.textMid,
                    ),
                  ),
                ],
              ),
            ),
            // Stars
            if (isDone)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return Text(
                    i < stars ? '⭐' : '☆',
                    style: const TextStyle(fontSize: 14),
                  );
                }),
              ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_left,
              color: unitColor.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
