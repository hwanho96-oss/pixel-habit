import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/l10n/habit_stat_l10n.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';

/// 힘·지능·지혜를 작은 색 배지로 보여 준다.
class StatBadge extends StatelessWidget {
  const StatBadge({super.key, required this.stat});

  final HabitStat stat;

  Color get _color {
    return switch (stat) {
      HabitStat.strength => AppColors.statStrength,
      HabitStat.intelligence => AppColors.statIntelligence,
      HabitStat.wisdom => AppColors.statWisdom,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _color;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          l10n.habitStatLabel(stat),
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
