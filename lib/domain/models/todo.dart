import 'package:pixel_habit/domain/models/habit_stat.dart';

/// 한 번만 하는 할 일. 반복·알림·메모는 없다.
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    this.date,
    this.timeHour,
    this.timeMinute,
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

  /// 하루 안의 시. 분과 함께 있을 때만 시간으로 본다.
  final int? timeHour;
  final int? timeMinute;
  final HabitStat? stat;
  final bool completed;
  final int xpReward;

  bool get hasTime =>
      timeHour != null &&
      timeMinute != null &&
      timeHour! >= 0 &&
      timeHour! <= 23 &&
      timeMinute! >= 0 &&
      timeMinute! <= 59;

  Todo copyWith({
    bool? completed,
    DateTime? date,
    int? timeHour,
    int? timeMinute,
    HabitStat? stat,
    bool clearDate = false,
    bool clearTime = false,
    bool clearStat = false,
  }) {
    return Todo(
      id: id,
      title: title,
      createdAt: createdAt,
      date: clearDate ? null : (date ?? this.date),
      timeHour: clearTime ? null : (timeHour ?? this.timeHour),
      timeMinute: clearTime ? null : (timeMinute ?? this.timeMinute),
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
      'time': hasTime ? _formatTime(timeHour!, timeMinute!) : null,
      'stat': stat?.name,
      'completed': completed,
      'xpReward': xpReward,
    };
  }

  factory Todo.fromJson(Map<String, Object?> json) {
    final time = _parseTime(json['time']);
    return Todo(
      id: json['id']! as String,
      title: json['title']! as String,
      createdAt: DateTime.parse(json['createdAt']! as String),
      date: _parseDate(json['date']),
      timeHour: time?.hour,
      timeMinute: time?.minute,
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

  static String _formatTime(int hour, int minute) {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  static ({int hour, int minute})? _parseTime(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      return null;
    }
    final parts = raw.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }
    return (hour: hour, minute: minute);
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
