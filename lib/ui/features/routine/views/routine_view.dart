import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_coin.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_exp_bar.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_frame.dart';
import 'package:pixel_habit/ui/core/widgets/profile_avatar.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/features/routine/views/add_routine_sheet.dart';

class RoutineView extends StatelessWidget {
  const RoutineView({super.key, required this.viewModel});

  final RoutineViewModel viewModel;

  Future<void> _openAddSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddRoutineSheet(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabRoutine),
        centerTitle: true,
        actions: [
          IconButton(
            key: const Key('add_routine_button'),
            tooltip: l10n.addRoutine,
            onPressed: () => _openAddSheet(context),
            icon: const Icon(Icons.add, color: AppColors.gold, size: 28),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.night,
              AppColors.dungeon,
              AppColors.night,
            ],
          ),
        ),
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _StatusBanner(viewModel: viewModel),
                ),
                Expanded(
                  child: viewModel.routines.isEmpty
                      ? Center(
                          child: Text(
                            l10n.emptyRoutines,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.parchment),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: viewModel.routines.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final routine = viewModel.routines[index];
                            return _RoutineCard(
                              routine: routine,
                              showProfileHint: index == 0,
                              onToggle: () async {
                                await viewModel.toggleCompleted(routine.id);
                                if (!context.mounted) {
                                  return;
                                }
                                final xp = viewModel.lastGrantedXp;
                                final gold = viewModel.lastGrantedGold;
                                if (xp != null && gold != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.completedToast(xp, gold),
                                      ),
                                    ),
                                  );
                                }
                              },
                              onDelete: () => _confirmDelete(context, routine),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Routine routine) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.parchment,
          title: Text(l10n.deleteRoutine),
          content: Text(l10n.deleteRoutineConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                l10n.deleteRoutine,
                style: const TextStyle(color: AppColors.waxSeal),
              ),
            ),
          ],
        );
      },
    );
    if (shouldDelete ?? false) {
      await viewModel.deleteRoutine(routine.id);
    }
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.viewModel});

  final RoutineViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = viewModel.progress;

    return PixelFrame(
      color: AppColors.dungeon,
      borderColor: AppColors.antiqueGold,
      child: Row(
        children: [
          const ProfileAvatar(size: 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.myProfile,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppColors.parchment),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.levelLabel(progress.level),
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: AppColors.gold),
                      ),
                    ),
                    _GoldBadge(
                      key: const Key('gold_badge'),
                      amount: progress.gold,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PixelExpBar(
                  current: progress.xpIntoLevel,
                  max: PlayerProgress.xpPerLevel,
                  label: l10n.expLabel,
                  progressLabel: l10n.expProgress(
                    progress.xpIntoLevel,
                    PlayerProgress.xpPerLevel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldBadge extends StatefulWidget {
  const _GoldBadge({super.key, required this.amount});

  final int amount;

  @override
  State<_GoldBadge> createState() => _GoldBadgeState();
}

class _GoldBadgeState extends State<_GoldBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final CurvedAnimation _scaleCurve;
  late final CurvedAnimation _fadeCurve;
  late final Animation<double> _scale;
  late final Animation<double> _gainOpacity;
  int? _gain;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleCurve = CurvedAnimation(parent: _pulse, curve: Curves.easeOut);
    _fadeCurve = CurvedAnimation(
      parent: _pulse,
      curve: const Interval(0.45, 1),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.12), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 1.12, end: 1), weight: 65),
    ]).animate(_scaleCurve);
    _gainOpacity = Tween<double>(begin: 1, end: 0).animate(_fadeCurve);
    _pulse.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted && _gain != null) {
        setState(() => _gain = null);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _GoldBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final gained = widget.amount - oldWidget.amount;
    if (gained > 0) {
      _gain = gained;
      _pulse.forward(from: 0);
    } else if (gained < 0) {
      _gain = null;
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _scaleCurve.dispose();
    _fadeCurve.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amountStyle = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: AppColors.ink);

    return ScaleTransition(
      scale: _scale,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.gold,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.outline, width: 2),
          ),
          boxShadow: [
            BoxShadow(color: AppColors.outline, offset: Offset(2, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PixelCoin(),
              const SizedBox(width: 6),
              Text(l10n.goldAmount(widget.amount), style: amountStyle),
              if (_gain != null) ...[
                const SizedBox(width: 6),
                FadeTransition(
                  opacity: _gainOpacity,
                  child: Text(l10n.goldGain(_gain!), style: amountStyle),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutineCard extends StatefulWidget {
  const _RoutineCard({
    required this.routine,
    required this.showProfileHint,
    required this.onToggle,
    required this.onDelete,
  });

  final Routine routine;
  final bool showProfileHint;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  State<_RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<_RoutineCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!mounted || _pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final routine = widget.routine;
    final completed = routine.completedToday;

    return Dismissible(
      key: ValueKey(routine.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        widget.onDelete();
        return false;
      },
      background: const ColoredBox(
        color: AppColors.ruby,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: AppColors.parchment),
          ),
        ),
      ),
      child: Transform.rotate(
        angle: widget.showProfileHint ? -0.02 : 0.015,
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: widget.onToggle,
            child: PixelFrame(
              color: completed ? AppColors.parchmentFaded : AppColors.parchment,
              borderColor: completed ? AppColors.antiqueGold : AppColors.gold,
              child: Stack(
                children: [
                  Row(
                    children: [
                      PixelCheckbox(
                        value: completed,
                        onChanged: (_) => widget.onToggle(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(routine.title, style: textTheme.bodyLarge),
                            if (routine.note != null)
                              Text(routine.note!, style: textTheme.bodyMedium),
                            Text(
                              l10n.xpLabel(routine.xpReward),
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (completed)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: _WaxStamp(label: l10n.completedStamp),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WaxStamp extends StatelessWidget {
  const _WaxStamp({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Transform.rotate(
        angle: -0.4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.waxSeal.withValues(alpha: 0.14),
            border: Border.all(
              color: AppColors.waxSeal.withValues(alpha: 0.8),
              width: 2,
            ),
          ),
          child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: AppColors.waxSeal, fontSize: 9),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
