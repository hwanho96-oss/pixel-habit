import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_chip.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_icon.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/features/routine/views/routine_card.dart';
import 'package:pixel_habit/ui/features/todo/view_models/todo_view_model.dart';
import 'package:pixel_habit/ui/features/todo/views/todo_card.dart';

class QuestPanel extends StatefulWidget {
  const QuestPanel({
    super.key,
    required this.routines,
    required this.todos,
    required this.segment,
    required this.onSegment,
    required this.onDeleteRoutine,
    required this.onDeleteTodo,
    required this.onToggleRoutine,
    required this.onToggleTodo,
  });

  final RoutineViewModel routines;
  final TodoViewModel todos;
  final int segment;
  final ValueChanged<int> onSegment;
  final ValueChanged<Routine> onDeleteRoutine;
  final ValueChanged<Todo> onDeleteTodo;
  final ValueChanged<Routine> onToggleRoutine;
  final ValueChanged<Todo> onToggleTodo;

  @override
  State<QuestPanel> createState() => _QuestPanelState();
}

class _QuestPanelState extends State<QuestPanel> {
  var _addingStarter = false;

  bool get _showingTodos => widget.segment == 1;

  Future<void> _addStarter(String title, HabitStat stat) async {
    if (_addingStarter) {
      return;
    }
    setState(() => _addingStarter = true);
    await widget.routines.addRoutine(title: title, stat: stat);
    if (mounted) {
      setState(() => _addingStarter = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final routineList = widget.routines.routines;
    final todoList = widget.todos.todos;
    final loading = widget.routines.isLoading || widget.todos.isLoading;
    final empty = _showingTodos ? todoList.isEmpty : routineList.isEmpty;
    final allDone =
        !empty &&
        (_showingTodos
            ? todoList.every((todo) => todo.completed)
            : routineList.every((routine) => routine.completedToday));
    final showRest =
        !empty && !allDone && widget.routines.progress.skippedYesterday();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: ColoredBox(
        color: AppColors.panel,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _SegmentBar(
                segment: widget.segment,
                routineLabel: l10n.tabRoutine,
                todoLabel: l10n.segmentTodo,
                onSegment: widget.onSegment,
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      children: [
                        if (allDone)
                          _Banner(
                            text: l10n.allQuestsDone,
                            icon: PixelIcons.star,
                          ),
                        if (showRest) _Banner(text: l10n.restedYesterday),
                        if (empty)
                          _EmptyQuest(
                            showingTodos: _showingTodos,
                            adding: _addingStarter,
                            onStarter: _addStarter,
                          )
                        else if (_showingTodos)
                          for (var i = 0; i < todoList.length; i++) ...[
                            if (i > 0) const SizedBox(height: 10),
                            TodoCard(
                              todo: todoList[i],
                              onToggle: () => widget.onToggleTodo(todoList[i]),
                              onDelete: () => widget.onDeleteTodo(todoList[i]),
                            ),
                          ]
                        else
                          for (var i = 0; i < routineList.length; i++) ...[
                            if (i > 0) const SizedBox(height: 10),
                            RoutineCard(
                              routine: routineList[i],
                              onToggle: () =>
                                  widget.onToggleRoutine(routineList[i]),
                              onDelete: () =>
                                  widget.onDeleteRoutine(routineList[i]),
                            ),
                          ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentBar extends StatelessWidget {
  const _SegmentBar({
    required this.segment,
    required this.routineLabel,
    required this.todoLabel,
    required this.onSegment,
  });

  final int segment;
  final String routineLabel;
  final String todoLabel;
  final ValueChanged<int> onSegment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SegmentButton(
            label: routineLabel,
            selected: segment == 0,
            onTap: () => onSegment(0),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SegmentButton(
            label: todoLabel,
            selected: segment == 1,
            onTap: () => onSegment(1),
          ),
        ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: selected ? AppColors.text : AppColors.panelMuted,
      fontWeight: FontWeight.w600,
    );

    return Material(
      color: selected ? AppColors.gold : Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(999)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(label, textAlign: TextAlign.center, style: style),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text, this.icon});

  final String text;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge
        ?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(text, textAlign: TextAlign.center, style: style),
          ),
          if (icon != null) ...[
            const SizedBox(width: 6),
            PixelIcon(asset: icon!, size: 16, color: AppColors.gold),
          ],
        ],
      ),
    );
  }
}

class _EmptyQuest extends StatelessWidget {
  const _EmptyQuest({
    required this.showingTodos,
    required this.adding,
    required this.onStarter,
  });

  final bool showingTodos;
  final bool adding;
  final Future<void> Function(String title, HabitStat stat) onStarter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    if (showingTodos) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 8),
        child: Text(
          l10n.emptyTodoGentle,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.textOnDark),
        ),
      );
    }

    final starters = <(String, HabitStat)>[
      (l10n.starterWater, HabitStat.wisdom),
      (l10n.starterStretch, HabitStat.strength),
      (l10n.starterRead, HabitStat.intelligence),
      (l10n.starterSleep, HabitStat.wisdom),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            l10n.emptyRoutineInvite,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.textOnDark),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final starter in starters)
                PixelChip(
                  label: starter.$1,
                  selected: false,
                  onSelected: adding
                      ? (_) {}
                      : (_) => onStarter(starter.$1, starter.$2),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
