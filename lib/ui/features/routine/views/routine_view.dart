import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/theme/app_theme.dart';
import 'package:pixel_habit/ui/core/widgets/gold_badge.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_exp_bar.dart';
import 'package:pixel_habit/ui/core/widgets/profile_avatar.dart';
import 'package:pixel_habit/ui/core/widgets/soft_card.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/features/routine/views/add_routine_sheet.dart';
import 'package:pixel_habit/ui/features/routine/views/routine_card.dart';

class RoutineView extends StatelessWidget {
  const RoutineView({super.key, required this.viewModel});

  final RoutineViewModel viewModel;

  Future<void> _openAddSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddRoutineSheet(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabRoutine)),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_routine_button'),
        tooltip: l10n.addRoutine,
        onPressed: () => _openAddSheet(context),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: _StatusBanner(viewModel: viewModel),
              ),
              Expanded(
                child: viewModel.routines.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.emptyRoutines,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        itemCount: viewModel.routines.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final routine = viewModel.routines[index];
                          return RoutineCard(
                            routine: routine,
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
    );
  }

  Future<void> _confirmDelete(BuildContext context, Routine routine) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteRoutine),
          content: Text(l10n.deleteRoutineConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.deleteRoutine),
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
    final textTheme = Theme.of(context).textTheme;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileAvatar(size: 72),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.myProfile, style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      l10n.levelLabel(progress.level),
                      style: AppTheme.pixel(fontSize: 24),
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
          const SizedBox(height: 12),
          GoldBadge(key: const Key('gold_badge'), amount: progress.gold),
        ],
      ),
    );
  }
}
