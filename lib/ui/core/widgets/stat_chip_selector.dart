import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_chip.dart';

/// 스탯을 하나만 고르거나, 없음을 고르는 칩.
class StatChipSelector extends StatelessWidget {
  const StatChipSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.noneLabel,
    required this.labelOf,
  });

  final HabitStat? value;
  final ValueChanged<HabitStat?> onChanged;
  final String noneLabel;
  final String Function(HabitStat stat) labelOf;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        PixelChip(
          label: noneLabel,
          selected: value == null,
          onSelected: (_) => onChanged(null),
        ),
        for (final stat in HabitStat.values)
          PixelChip(
            label: labelOf(stat),
            selected: value == stat,
            onSelected: (_) => onChanged(stat),
          ),
      ],
    );
  }
}
