import 'package:flutter/material.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_avatar.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_frame.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';

class AddRoutineSheet extends StatefulWidget {
  const AddRoutineSheet({super.key, required this.viewModel});

  final RoutineViewModel viewModel;

  @override
  State<AddRoutineSheet> createState() => _AddRoutineSheetState();
}

class _AddRoutineSheetState extends State<AddRoutineSheet> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  int _avatarSeed = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await widget.viewModel.addRoutine(
      title: _titleController.text,
      note: _noteController.text,
      avatarSeed: _avatarSeed,
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: PixelFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.addRoutineTitle, style: textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              autofocus: true,
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: l10n.routineNameHint,
                filled: true,
                fillColor: AppColors.parchmentDark,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.outline, width: 2),
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              style: textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: l10n.routineNoteHint,
                filled: true,
                fillColor: AppColors.parchmentDark,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.outline, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: List.generate(5, (index) {
                final selected = _avatarSeed == index;
                return GestureDetector(
                  onTap: () => setState(() => _avatarSeed = index),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected ? AppColors.gold : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: PixelAvatar(seed: index, size: 40),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel, style: textTheme.bodyLarge),
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.ink,
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: _submit,
                    child: Text(l10n.save, style: textTheme.bodyLarge),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
