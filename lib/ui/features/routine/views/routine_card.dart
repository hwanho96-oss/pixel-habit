import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_pressable.dart';
import 'package:pixel_habit/ui/core/widgets/stat_badge.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.routine,
    required this.onToggle,
    required this.onDelete,
  });

  final Routine routine;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final completed = routine.completedToday;

    return Dismissible(
      key: ValueKey(routine.id),
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
                        routine.title,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textOnDark,
                        ),
                      ),
                      if (routine.note != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          routine.note!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.panelMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (routine.stat != null) ...[
                  const SizedBox(width: 8),
                  StatBadge(stat: routine.stat!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
