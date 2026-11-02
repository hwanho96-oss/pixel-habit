import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/routine_checklist_item.dart';

class Routine {
  const Routine({
    required this.id,
    required this.title,
    required this.xpReward,
    required this.avatarSeed,
    required this.createdAt,
    this.note,
    this.completedToday = false,
    this.lastCompletedAt,
    this.checklist = const [],
    this.startDate,
    this.reminderHour,
    this.reminderMinute,
    this.repeatWeekdays = const {},
    this.tags = const [],
    this.stat,
  });

  final String id;
  final String title;
  final String? note;
  final int xpReward;
  final int avatarSeed;
  final bool completedToday;
  final DateTime createdAt;
  final DateTime? lastCompletedAt;
  final List<RoutineChecklistItem> checklist;
  final DateTime? startDate;
  final int? reminderHour;
  final int? reminderMinute;
  final Set<int> repeatWeekdays;
  final List<String> tags;
  final HabitStat? stat;

  Routine copyWith({
    String? title,
    String? note,
    int? xpReward,
    int? avatarSeed,
    bool? completedToday,
    DateTime? lastCompletedAt,
    List<RoutineChecklistItem>? checklist,
    DateTime? startDate,
    int? reminderHour,
    int? reminderMinute,
    Set<int>? repeatWeekdays,
    List<String>? tags,
    HabitStat? stat,
    bool clearStartDate = false,
    bool clearReminder = false,
    bool clearStat = false,
  }) {
    return Routine(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      xpReward: xpReward ?? this.xpReward,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      completedToday: completedToday ?? this.completedToday,
      createdAt: createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      checklist: checklist ?? this.checklist,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      reminderHour: clearReminder ? null : (reminderHour ?? this.reminderHour),
      reminderMinute: clearReminder
          ? null
          : (reminderMinute ?? this.reminderMinute),
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      tags: tags ?? this.tags,
      stat: clearStat ? null : (stat ?? this.stat),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'xpReward': xpReward,
      'avatarSeed': avatarSeed,
      'completedToday': completedToday,
      'createdAt': createdAt.toIso8601String(),
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'checklist': checklist.map((item) => item.toJson()).toList(),
      'startDate': startDate?.toIso8601String(),
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
      'repeatWeekdays': repeatWeekdays.toList()..sort(),
      'tags': tags,
      'stat': stat?.name,
    };
  }

  factory Routine.fromJson(Map<String, Object?> json) {
    final checklistRaw = json['checklist'] as List<dynamic>?;
    final weekdaysRaw = json['repeatWeekdays'] as List<dynamic>?;
    final tagsRaw = json['tags'] as List<dynamic>?;

    return Routine(
      id: json['id']! as String,
      title: json['title']! as String,
      note: json['note'] as String?,
      xpReward: json['xpReward']! as int,
      avatarSeed: json['avatarSeed']! as int,
      completedToday: json['completedToday'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']! as String),
      lastCompletedAt: json['lastCompletedAt'] == null
          ? null
          : DateTime.parse(json['lastCompletedAt']! as String),
      checklist: checklistRaw == null
          ? const []
          : checklistRaw
                .map(
                  (item) => RoutineChecklistItem.fromJson(
                    Map<String, Object?>.from(item as Map),
                  ),
                )
                .toList(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate']! as String),
      reminderHour: json['reminderHour'] as int?,
      reminderMinute: json['reminderMinute'] as int?,
      repeatWeekdays: weekdaysRaw == null
          ? const {}
          : weekdaysRaw.map((day) => day as int).toSet(),
      tags: tagsRaw == null
          ? const []
          : tagsRaw.map((tag) => tag as String).toList(),
      stat: HabitStat.tryParse(json['stat']),
    );
  }
}
