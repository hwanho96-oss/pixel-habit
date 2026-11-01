class RoutineChecklistItem {
  const RoutineChecklistItem({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  final String id;
  final String title;
  final bool isDone;

  RoutineChecklistItem copyWith({
    String? title,
    bool? isDone,
  }) {
    return RoutineChecklistItem(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  factory RoutineChecklistItem.fromJson(Map<String, Object?> json) {
    return RoutineChecklistItem(
      id: json['id']! as String,
      title: json['title']! as String,
      isDone: json['isDone'] as bool? ?? false,
    );
  }
}
