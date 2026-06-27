import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:waqti/main.dart';
import 'package:waqti/models/progress_provider.dart';
import 'package:waqti/models/curriculum.dart';

void main() {
  group('Curriculum Tests', () {
    test('has 5 units', () {
      expect(Curriculum.units.length, equals(5));
    });

    test('unit 1 is free', () {
      expect(Curriculum.units[0].isFree, isTrue);
    });

    test('unit 1 has 4 lessons', () {
      expect(Curriculum.units[0].lessons.length, equals(4));
    });

    test('all lessons have questions', () {
      for (final unit in Curriculum.units) {
        for (final lesson in unit.lessons) {
          expect(lesson.questions.isNotEmpty, isTrue,
              reason: 'Lesson ${lesson.id} has no questions');
        }
      }
    });

    test('time strings format correctly', () {
      final q = Curriculum.units[0].lessons[0].questions[0];
      expect(q.timeString, matches(RegExp(r'^\d{2}:\d{2}$')));
    });
  });

  group('ProgressProvider Tests', () {
    late ProgressProvider provider;

    setUp(() {
      provider = ProgressProvider();
    });

    test('starts with zero stars', () {
      expect(provider.totalStars, equals(0));
    });

    test('lesson not completed initially', () {
      expect(provider.isLessonCompleted('u1l1'), isFalse);
    });

    test('streak starts at zero', () {
      expect(provider.streakDays, equals(0));
    });
  });
}
