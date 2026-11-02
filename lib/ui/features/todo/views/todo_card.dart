import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_pressable.dart';
import 'package:pixel_habit/ui/core/widgets/soft_card.dart';
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

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: const ColoredBox(
        color: AppColors.dark,
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
        child: SoftCard(
          highlighted: completed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PixelCheckbox(value: completed, onChanged: (_) => onToggle()),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todo.title, style: textTheme.bodyLarge),
                    if (todo.date != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        todoDateLabel(todo.date!, l10n),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.text.withValues(alpha: 0.68),
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (todo.stat != null) StatBadge(stat: todo.stat!),
                        Text(
                          l10n.xpLabel(todo.xpReward),
                          style: AppTheme.pixel(
                            fontSize: 16,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (completed) ...[
                const SizedBox(width: 8),
                _DonePill(label: l10n.completedStamp),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DonePill extends StatelessWidget {
  const _DonePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.all(Radius.circular(999)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: AppTheme.pixel(fontSize: 16, color: AppColors.textOnDark),
        ),
      ),
    );
  }
}
