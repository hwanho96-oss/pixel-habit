import 'package:flutter/material.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_sprite_button.dart';

class PixelWeekdayButton extends StatelessWidget {
  const PixelWeekdayButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: PixelSpriteButton(
        expandWidth: true,
        height: 40,
        padding: EdgeInsets.zero,
        selected: selected,
        onPressed: () => onSelected(!selected),
        child: Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.cream,
            fontSize: 14,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class PixelWeekdaySelector extends StatelessWidget {
  const PixelWeekdaySelector({
    super.key,
    required this.selected,
    required this.labels,
    required this.onChanged,
  });

  /// Selected weekdays using [DateTime.monday]–[DateTime.sunday].
  final Set<int> selected;
  final List<String> labels;
  final ValueChanged<Set<int>> onChanged;

  static const weekdays = <int>[
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  @override
  Widget build(BuildContext context) {
    assert(labels.length == 7);

    return Row(
      children: [
        for (var i = 0; i < weekdays.length; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          PixelWeekdayButton(
            label: labels[i],
            selected: selected.contains(weekdays[i]),
            onSelected: (isSelected) {
              final next = Set<int>.from(selected);
              if (isSelected) {
                next.add(weekdays[i]);
              } else {
                next.remove(weekdays[i]);
              }
              onChanged(next);
            },
          ),
        ],
      ],
    );
  }
}
