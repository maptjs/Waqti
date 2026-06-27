import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider extends ChangeNotifier {
  Map<String, bool> _completedLessons = {};
  Map<String, int> _lessonStars = {};
  int _streakDays = 0;
  int _totalStars = 0;
  DateTime? _lastPlayDate;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  int get streakDays => _streakDays;
  int get totalStars => _totalStars;
  Map<String, bool> get completedLessons => _completedLessons;

  bool isLessonCompleted(String lessonId) => _completedLessons[lessonId] ?? false;
  int getLessonStars(String lessonId) => _lessonStars[lessonId] ?? 0;

  bool isUnitCompleted(String unitId, List<String> lessonIds) {
    return lessonIds.every((id) => isLessonCompleted(id));
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final completedKeys = prefs.getStringList('completed_lessons') ?? [];
    _completedLessons = {for (var k in completedKeys) k: true};

    final starKeys = prefs.getStringList('lesson_star_keys') ?? [];
    _lessonStars = {};
    for (final k in starKeys) {
      _lessonStars[k] = prefs.getInt('stars_$k') ?? 0;
    }

    _streakDays = prefs.getInt('streak_days') ?? 0;
    _totalStars = prefs.getInt('total_stars') ?? 0;

    final lastPlay = prefs.getString('last_play_date');
    if (lastPlay != null) {
      _lastPlayDate = DateTime.tryParse(lastPlay);
      _checkStreakExpiry();
    }

    _isLoaded = true;
    notifyListeners();
  }

  void _checkStreakExpiry() {
    if (_lastPlayDate == null) return;
    final today = DateTime.now();
    final diff = today.difference(_lastPlayDate!).inDays;
    if (diff > 1) {
      _streakDays = 0;
    }
  }

  Future<void> completeLesson(String lessonId, int stars) async {
    final wasCompleted = _completedLessons[lessonId] ?? false;
    _completedLessons[lessonId] = true;

    final prevStars = _lessonStars[lessonId] ?? 0;
    if (stars > prevStars) {
      _totalStars += (stars - prevStars);
      _lessonStars[lessonId] = stars;
    }

    if (!wasCompleted) {
      _updateStreak();
    }

    await _save();
    notifyListeners();
  }

  void _updateStreak() {
    final today = DateTime.now();
    if (_lastPlayDate == null) {
      _streakDays = 1;
    } else {
      final diff = today.difference(_lastPlayDate!).inDays;
      if (diff == 0) {
        // same day, no change
      } else if (diff == 1) {
        _streakDays++;
      } else {
        _streakDays = 1;
      }
    }
    _lastPlayDate = today;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completed_lessons', _completedLessons.keys.toList());
    final starKeys = _lessonStars.keys.toList();
    await prefs.setStringList('lesson_star_keys', starKeys);
    for (final k in starKeys) {
      await prefs.setInt('stars_$k', _lessonStars[k] ?? 0);
    }
    await prefs.setInt('streak_days', _streakDays);
    await prefs.setInt('total_stars', _totalStars);
    if (_lastPlayDate != null) {
      await prefs.setString('last_play_date', _lastPlayDate!.toIso8601String());
    }
  }

  Future<void> reset() async {
    _completedLessons = {};
    _lessonStars = {};
    _streakDays = 0;
    _totalStars = 0;
    _lastPlayDate = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
