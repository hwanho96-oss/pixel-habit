import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/l10n/habit_stat_l10n.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_chip.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_save_button.dart';
import 'package:pixel_habit/ui/core/widgets/soft_card.dart';
import 'package:pixel_habit/ui/core/widgets/stat_chip_selector.dart';
import 'package:pixel_habit/ui/features/todo/view_models/todo_view_model.dart';

class AddTodoSheet extends StatefulWidget {
  const AddTodoSheet({super.key, required this.viewModel});

  final TodoViewModel viewModel;

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  final _titleController = TextEditingController();
  DateTime? _date;
  HabitStat? _stat;
  bool _saving = false;

  bool get _canSave => _titleController.text.trim().isNotEmpty && !_saving;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _submit() async {
    if (!_canSave) {
      return;
    }

    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
    final saved = await widget.viewModel.addTodo(
      title: _titleController.text,
      date: _date,
      stat: _stat,
    );

    if (!mounted) {
      return;
    }

    if (saved) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.todoSaveFailed)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final today = _today();
    final tomorrow = today.add(const Duration(days: 1));
    final maxHeight = MediaQuery.sizeOf(context).height * 0.92;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.addTodoTitle,
                          style: textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.cancel,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: AppColors.text),
                      ),
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 4),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SectionFrame(
                            title: l10n.sectionTodoName,
                            child: TextField(
                              key: const Key('todo_name_field'),
                              controller: _titleController,
                              autofocus: true,
                              style: textTheme.bodyLarge,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: l10n.todoNameHint,
                              ),
                              onSubmitted: (_) => _submit(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionFrame(
                            title: l10n.sectionTodoDate,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                PixelChip(
                                  label: l10n.choiceNone,
                                  selected: _date == null,
                                  onSelected: (_) =>
                                      setState(() => _date = null),
                                ),
                                PixelChip(
                                  label: l10n.dateToday,
                                  selected: _date == today,
                                  onSelected: (_) =>
                                      setState(() => _date = today),
                                ),
                                PixelChip(
                                  label: l10n.dateTomorrow,
                                  selected: _date == tomorrow,
                                  onSelected: (_) =>
                                      setState(() => _date = tomorrow),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionFrame(
                            title: l10n.sectionStat,
                            child: StatChipSelector(
                              value: _stat,
                              noneLabel: l10n.choiceNone,
                              labelOf: l10n.habitStatLabel,
                              onChanged: (stat) => setState(() => _stat = stat),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PixelSaveButton(
                    label: l10n.save,
                    enabled: _canSave,
                    onPressed: _canSave ? _submit : null,
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

class _SectionFrame extends StatelessWidget {
  const _SectionFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
