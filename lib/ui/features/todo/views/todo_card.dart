import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_pressable.dart';
import 'package:pixel_habit/ui/core/widgets/stat_badge.dart';
import 'package:pixel_habit/ui/features/todo/todo_date_label.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final completed = todo.completed;
    final schedule = todoScheduleLabel(
      todo,
      l10n,
      MaterialLocalizations.of(context),
    );

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: const ColoredBox(
        color: AppColors.statStrength,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete_outline, color: AppColors.textOnDark),
          ),
        ),
      ),
      child: PixelPressable(
        onTap: onToggle,
        pressedScale: 0.98,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.panelRaised,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(
              color: completed ? AppColors.gold : AppColors.panelBorder,
              width: completed ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PixelCheckbox(value: completed, onChanged: (_) => onToggle()),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textOnDark,
                        ),
                      ),
                      if (schedule != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          schedule,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.panelMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (todo.stat != null) ...[
                  const SizedBox(width: 8),
                  StatBadge(stat: todo.stat!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
