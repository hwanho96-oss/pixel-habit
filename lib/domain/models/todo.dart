import 'package:pixel_habit/domain/models/habit_stat.dart';

/// 한 번만 하는 할 일. 반복·알림·메모는 없다.
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    this.date,
    this.stat,
    this.completed = false,
    this.xpReward = defaultXpReward,
  });

  /// 완료 시 더해지는 경험치. 골드는 루틴과 같은 고정 금액이다.
  static const int defaultXpReward = 10;

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime? date;
  final HabitStat? stat;
  final bool completed;
  final int xpReward;

  Todo copyWith({
    bool? completed,
    DateTime? date,
    HabitStat? stat,
    bool clearDate = false,
    bool clearStat = false,
  }) {
    return Todo(
      id: id,
      title: title,
      createdAt: createdAt,
      date: clearDate ? null : (date ?? this.date),
      stat: clearStat ? null : (stat ?? this.stat),
      completed: completed ?? this.completed,
      xpReward: xpReward,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'date': _formatDate(date),
      'stat': stat?.name,
      'completed': completed,
      'xpReward': xpReward,
    };
  }

  factory Todo.fromJson(Map<String, Object?> json) {
    return Todo(
      id: json['id']! as String,
      title: json['title']! as String,
      createdAt: DateTime.parse(json['createdAt']! as String),
      date: _parseDate(json['date']),
      stat: HabitStat.tryParse(json['stat']),
      completed: json['completed'] as bool? ?? false,
      xpReward: json['xpReward'] as int? ?? defaultXpReward,
    );
  }

  static DateTime? dateOnly(DateTime? value) {
    if (value == null) {
      return null;
    }
    return DateTime(value.year, value.month, value.day);
  }

  static String? _formatDate(DateTime? value) {
    final day = dateOnly(value);
    if (day == null) {
      return null;
    }
    final year = day.year.toString().padLeft(4, '0');
    final month = day.month.toString().padLeft(2, '0');
    final date = day.day.toString().padLeft(2, '0');
    return '$year-$month-$date';
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return null;
    }
    if (raw.length <= 10) {
      return DateTime(parsed.year, parsed.month, parsed.day);
    }
    final local = parsed.toLocal();
    return DateTime(local.year, local.month, local.day);
  }
}
