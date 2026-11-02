import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/l10n/habit_stat_l10n.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';
import 'package:pixel_habit/ui/core/theme/home_assets.dart';
import 'package:pixel_habit/ui/core/widgets/gold_badge.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_icon.dart';

class HomeScene extends StatelessWidget {
  const HomeScene({super.key, required this.progress, required this.burst});

  final PlayerProgress progress;
  final int burst;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        const PixelAssetImage(path: HomeAssets.background, fit: BoxFit.cover),
        const Align(
          alignment: Alignment(0, 0.55),
          child: PixelAssetImage(
            path: HomeAssets.avatar,
            width: 148,
            height: 168,
          ),
        ),
        IgnorePointer(child: _SparkleBurst(token: burst)),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoldBadge(
                      key: const Key('gold_badge'),
                      amount: progress.gold,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          l10n.traineeLabel(progress.level),
                          textAlign: TextAlign.right,
                          style: AppTheme.pixel(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const _StatLegend(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatLegend extends StatelessWidget {
  const _StatLegend();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final stat in HabitStat.values) ...[
          _LegendItem(stat: stat, label: l10n.habitStatLabel(stat)),
          if (stat != HabitStat.wisdom) const SizedBox(width: 14),
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.stat, required this.label});

  final HabitStat stat;
  final String label;

  Color get _color {
    return switch (stat) {
      HabitStat.strength => AppColors.statStrength,
      HabitStat.intelligence => AppColors.statIntelligence,
      HabitStat.wisdom => AppColors.statWisdom,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PixelIcon(asset: PixelIcons.stat(stat), size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: AppColors.text, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// 체크할 때 아바타 주변 별이 0.3초 동안 커졌다가 사라진다.
class _SparkleBurst extends StatefulWidget {
  const _SparkleBurst({required this.token});

  final int token;

  @override
  State<_SparkleBurst> createState() => _SparkleBurstState();
}

class _SparkleBurstState extends State<_SparkleBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _spots = <Alignment>[
    Alignment(-0.42, 0.18),
    Alignment(0.46, 0.22),
    Alignment(-0.28, 0.78),
    Alignment(0.34, 0.74),
    Alignment(0.02, 0.02),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(covariant _SparkleBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token != oldWidget.token && widget.token > 0) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final running = _controller.isAnimating && t < 1;
        // 별 그림은 미리 올려 두고, 체크할 때만 키워서 보여 준다.
        final size = !running
            ? 16.0
            : t < 0.34
            ? 16.0
            : t < 0.67
            ? 24.0
            : 32.0;
        final opacity = !running
            ? 0.0
            : t < 0.45
            ? 1.0
            : ((1 - t) / 0.55).clamp(0.0, 1.0);
        return Stack(
          fit: StackFit.expand,
          children: [
            for (final spot in _spots)
              Align(
                alignment: spot,
                child: Opacity(
                  opacity: opacity,
                  child: PixelIcon(
                    asset: PixelIcons.star,
                    size: size,
                    color: AppColors.gold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
