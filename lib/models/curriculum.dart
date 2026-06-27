// ─── Models ───────────────────────────────────────────────────────────────────

enum QuestionType { multipleChoice, setHands, listenAndChoose }

class TimeQuestion {
  final int hour;
  final int minute;
  final QuestionType type;
  final String prompt;

  const TimeQuestion({
    required this.hour,
    required this.minute,
    required this.type,
    required this.prompt,
  });

  String get timeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get arabicTimeString {
    final h = _arabicNumber(hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour));
    final period = hour < 12 ? 'صباحًا' : 'مساءً';
    if (minute == 0) return 'الساعة $h $period';
    if (minute == 30) return '$h والنصف $period';
    if (minute == 15) return '$h والربع $period';
    if (minute == 45) return '$h إلا ربعًا $period';
    final m = _arabicNumber(minute);
    return '$h و$m دقيقة $period';
  }

  static String _arabicNumber(int n) {
    const words = [
      '', 'الواحدة', 'الثانية', 'الثالثة', 'الرابعة', 'الخامسة',
      'السادسة', 'السابعة', 'الثامنة', 'التاسعة', 'العاشرة',
      'الحادية عشرة', 'الثانية عشرة'
    ];
    if (n >= 1 && n <= 12) return words[n];
    return n.toString();
  }
}

class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<TimeQuestion> questions;
  final bool isFree;

  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.questions,
    this.isFree = false,
  });
}

class Unit {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<Lesson> lessons;
  final bool isFree;

  const Unit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.lessons,
    this.isFree = false,
  });
}

// ─── Curriculum Data ──────────────────────────────────────────────────────────

class Curriculum {
  static final List<Unit> units = [
    Unit(
      id: 'unit1',
      title: 'أبطال الساعة',
      subtitle: 'تعلّم الساعات الكاملة',
      emoji: '⭐',
      isFree: true,
      lessons: [
        Lesson(
          id: 'u1l1',
          title: 'عقارب الساعة',
          subtitle: 'الدرس الأول',
          description: 'تعرّف على عقرب الساعات وعقرب الدقائق',
          isFree: true,
          questions: [
            TimeQuestion(hour: 3, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة الآن؟'),
            TimeQuestion(hour: 6, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 9, minute: 0, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 12, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة الآن؟'),
            TimeQuestion(hour: 1, minute: 0, type: QuestionType.setHands, prompt: 'حرّك العقارب للساعة الواحدة'),
          ],
        ),
        Lesson(
          id: 'u1l2',
          title: 'الساعة الواحدة حتى السادسة',
          subtitle: 'الدرس الثاني',
          description: 'تدرّب على قراءة الساعات من 1 إلى 6',
          isFree: true,
          questions: [
            TimeQuestion(hour: 1, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 2, minute: 0, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 4, minute: 0, type: QuestionType.setHands, prompt: 'حرّك العقارب للساعة الرابعة'),
            TimeQuestion(hour: 5, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة الآن؟'),
            TimeQuestion(hour: 6, minute: 0, type: QuestionType.setHands, prompt: 'اضبط الساعة على السادسة'),
          ],
        ),
        Lesson(
          id: 'u1l3',
          title: 'الساعة السابعة حتى الثانية عشرة',
          subtitle: 'الدرس الثالث',
          description: 'أكمل رحلتك في الساعات الكاملة',
          isFree: true,
          questions: [
            TimeQuestion(hour: 7, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 8, minute: 0, type: QuestionType.setHands, prompt: 'حرّك العقارب للثامنة'),
            TimeQuestion(hour: 10, minute: 0, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 11, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة الآن؟'),
            TimeQuestion(hour: 12, minute: 0, type: QuestionType.setHands, prompt: 'اضبط الساعة على الثانية عشرة'),
          ],
        ),
        Lesson(
          id: 'u1l4',
          title: 'مراجعة الساعات الكاملة',
          subtitle: 'الدرس الرابع',
          description: 'راجع كل ما تعلّمته',
          isFree: true,
          questions: [
            TimeQuestion(hour: 3, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 7, minute: 0, type: QuestionType.setHands, prompt: 'حرّك العقارب للسابعة'),
            TimeQuestion(hour: 11, minute: 0, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 2, minute: 0, type: QuestionType.setHands, prompt: 'اضبط على الثانية'),
            TimeQuestion(hour: 9, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة الآن؟'),
          ],
        ),
      ],
    ),
    Unit(
      id: 'unit2',
      title: 'النصف الجميل',
      subtitle: 'تعلّم النصف والنصف ونصف',
      emoji: '🌙',
      lessons: [
        Lesson(
          id: 'u2l1',
          title: 'والنصف',
          subtitle: 'الدرس الأول',
          description: 'تعرّف على الساعة والنصف',
          questions: [
            TimeQuestion(hour: 3, minute: 30, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 6, minute: 30, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 9, minute: 30, type: QuestionType.setHands, prompt: 'حرّك للتاسعة والنصف'),
            TimeQuestion(hour: 12, minute: 30, type: QuestionType.multipleChoice, prompt: 'كم الساعة الآن؟'),
          ],
        ),
        Lesson(
          id: 'u2l2',
          title: 'تدريب النصف',
          subtitle: 'الدرس الثاني',
          description: 'تدرّب أكثر على الساعة والنصف',
          questions: [
            TimeQuestion(hour: 1, minute: 30, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 4, minute: 30, type: QuestionType.setHands, prompt: 'حرّك للرابعة والنصف'),
            TimeQuestion(hour: 7, minute: 30, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 10, minute: 30, type: QuestionType.setHands, prompt: 'اضبط العاشرة والنصف'),
          ],
        ),
        Lesson(
          id: 'u2l3',
          title: 'مراجعة النصف',
          subtitle: 'الدرس الثالث',
          description: 'راجع الساعات والنصف',
          questions: [
            TimeQuestion(hour: 2, minute: 30, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 5, minute: 30, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 8, minute: 30, type: QuestionType.setHands, prompt: 'حرّك للثامنة والنصف'),
            TimeQuestion(hour: 11, minute: 30, type: QuestionType.multipleChoice, prompt: 'كم الساعة الآن؟'),
          ],
        ),
        Lesson(
          id: 'u2l4',
          title: 'بطل النصف',
          subtitle: 'الدرس الرابع',
          description: 'اختبار شامل للساعة والنصف',
          questions: [
            TimeQuestion(hour: 3, minute: 30, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 9, minute: 0, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 6, minute: 30, type: QuestionType.setHands, prompt: 'حرّك للسادسة والنصف'),
            TimeQuestion(hour: 12, minute: 0, type: QuestionType.multipleChoice, prompt: 'كم الساعة الآن؟'),
          ],
        ),
      ],
    ),
    Unit(
      id: 'unit3',
      title: 'مغامرة الربع',
      subtitle: 'والربع وإلا ربعًا',
      emoji: '🌟',
      lessons: [
        Lesson(
          id: 'u3l1',
          title: 'والربع',
          subtitle: 'الدرس الأول',
          description: 'تعلّم الساعة والربع',
          questions: [
            TimeQuestion(hour: 3, minute: 15, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 6, minute: 15, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 9, minute: 15, type: QuestionType.setHands, prompt: 'حرّك للتاسعة والربع'),
          ],
        ),
        Lesson(
          id: 'u3l2',
          title: 'إلا ربعًا',
          subtitle: 'الدرس الثاني',
          description: 'تعلّم الساعة إلا ربعًا',
          questions: [
            TimeQuestion(hour: 3, minute: 45, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 6, minute: 45, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 9, minute: 45, type: QuestionType.setHands, prompt: 'حرّك للعاشرة إلا ربعًا'),
          ],
        ),
        Lesson(
          id: 'u3l3',
          title: 'الربع والنصف معًا',
          subtitle: 'الدرس الثالث',
          description: 'امزج ما تعلّمته',
          questions: [
            TimeQuestion(hour: 2, minute: 15, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 4, minute: 45, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 7, minute: 30, type: QuestionType.setHands, prompt: 'حرّك للسابعة والنصف'),
          ],
        ),
        Lesson(
          id: 'u3l4',
          title: 'بطل الربع',
          subtitle: 'الدرس الرابع',
          description: 'اختبار شامل',
          questions: [
            TimeQuestion(hour: 1, minute: 15, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 5, minute: 45, type: QuestionType.multipleChoice, prompt: 'ما هذا الوقت؟'),
            TimeQuestion(hour: 11, minute: 30, type: QuestionType.setHands, prompt: 'حرّك للحادية عشرة والنصف'),
          ],
        ),
        Lesson(
          id: 'u3l5',
          title: 'مراجعة الوحدة',
          subtitle: 'الدرس الخامس',
          description: 'راجع كل الدروس',
          questions: [
            TimeQuestion(hour: 3, minute: 15, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 8, minute: 45, type: QuestionType.setHands, prompt: 'حرّك للتاسعة إلا ربعًا'),
            TimeQuestion(hour: 6, minute: 0, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
          ],
        ),
      ],
    ),
    Unit(
      id: 'unit4',
      title: 'عدّ بالخمسة',
      subtitle: 'الدقائق بالخمسات',
      emoji: '🚀',
      lessons: [
        Lesson(
          id: 'u4l1',
          title: 'خمس دقائق',
          subtitle: 'الدرس الأول',
          description: 'تعلّم الدقائق بالخمسة',
          questions: [
            TimeQuestion(hour: 3, minute: 5, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 7, minute: 25, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 1, minute: 35, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
          ],
        ),
        Lesson(
          id: 'u4l2',
          title: 'عشر وعشرون دقيقة',
          subtitle: 'الدرس الثاني',
          description: 'تدرّب على العشر والعشرين',
          questions: [
            TimeQuestion(hour: 4, minute: 10, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 9, minute: 20, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 2, minute: 40, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
          ],
        ),
        Lesson(
          id: 'u4l3',
          title: 'خمس وثلاثون وما بعدها',
          subtitle: 'الدرس الثالث',
          description: 'أكمل رحلة الخمسات',
          questions: [
            TimeQuestion(hour: 6, minute: 35, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 11, minute: 50, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 8, minute: 55, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
          ],
        ),
        Lesson(
          id: 'u4l4',
          title: 'مراجعة الخمسات',
          subtitle: 'الدرس الرابع',
          description: 'راجع كل الخمسات',
          questions: [
            TimeQuestion(hour: 3, minute: 5, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 7, minute: 40, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
            TimeQuestion(hour: 10, minute: 20, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
          ],
        ),
        Lesson(
          id: 'u4l5',
          title: 'بطل الخمسات',
          subtitle: 'الدرس الخامس',
          description: 'اختبار شامل',
          questions: [
            TimeQuestion(hour: 1, minute: 25, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 5, minute: 50, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 9, minute: 35, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
          ],
        ),
      ],
    ),
    Unit(
      id: 'unit5',
      title: 'أسياد الوقت',
      subtitle: 'أي دقيقة في الساعة',
      emoji: '👑',
      lessons: [
        Lesson(
          id: 'u5l1',
          title: 'الدقيقة بالدقيقة',
          subtitle: 'الدرس الأول',
          description: 'تعلّم قراءة أي دقيقة',
          questions: [
            TimeQuestion(hour: 11, minute: 43, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 2, minute: 51, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 7, minute: 17, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
          ],
        ),
        Lesson(
          id: 'u5l2',
          title: 'الأوقات الصعبة',
          subtitle: 'الدرس الثاني',
          description: 'تحدَّ نفسك مع الأوقات الصعبة',
          questions: [
            TimeQuestion(hour: 4, minute: 37, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 8, minute: 23, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
            TimeQuestion(hour: 1, minute: 58, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
          ],
        ),
        Lesson(
          id: 'u5l3',
          title: 'تحدي الساعة',
          subtitle: 'الدرس الثالث',
          description: 'تحدَّ الساعة بكل قوة',
          questions: [
            TimeQuestion(hour: 6, minute: 47, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 3, minute: 13, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
            TimeQuestion(hour: 10, minute: 29, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
          ],
        ),
        Lesson(
          id: 'u5l4',
          title: 'اختبار البطل',
          subtitle: 'الدرس الرابع',
          description: 'أثبت أنك سيد الوقت',
          questions: [
            TimeQuestion(hour: 9, minute: 41, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 5, minute: 3, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
            TimeQuestion(hour: 12, minute: 59, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
          ],
        ),
        Lesson(
          id: 'u5l5',
          title: 'التحدي النهائي',
          subtitle: 'الدرس الخامس',
          description: 'التحدي الأخير قبل التتويج',
          questions: [
            TimeQuestion(hour: 7, minute: 33, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 2, minute: 48, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 11, minute: 7, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
          ],
        ),
        Lesson(
          id: 'u5l6',
          title: 'سيد الوقت',
          subtitle: 'الدرس السادس',
          description: 'أنت الآن سيد الوقت!',
          questions: [
            TimeQuestion(hour: 4, minute: 22, type: QuestionType.multipleChoice, prompt: 'كم الساعة؟'),
            TimeQuestion(hour: 8, minute: 56, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
            TimeQuestion(hour: 1, minute: 39, type: QuestionType.multipleChoice, prompt: 'ما الوقت؟'),
            TimeQuestion(hour: 6, minute: 14, type: QuestionType.setHands, prompt: 'اضبط الساعة'),
          ],
        ),
      ],
    ),
  ];
}
