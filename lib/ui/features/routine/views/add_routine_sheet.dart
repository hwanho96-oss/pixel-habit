import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_habit/domain/data/routine_suggestions.dart';
import 'package:pixel_habit/domain/data/routine_tags.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/routine_checklist_item.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/l10n/habit_stat_l10n.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_chip.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_save_button.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_weekday_button.dart';
import 'package:pixel_habit/ui/core/widgets/soft_card.dart';
import 'package:pixel_habit/ui/core/widgets/stat_chip_selector.dart';
import 'package:pixel_habit/ui/features/routine/l10n/routine_form_l10n.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:uuid/uuid.dart';

class AddRoutineSheet extends StatefulWidget {
  const AddRoutineSheet({super.key, required this.viewModel});

  final RoutineViewModel viewModel;

  @override
  State<AddRoutineSheet> createState() => _AddRoutineSheetState();
}

class _AddRoutineSheetState extends State<AddRoutineSheet> {
  final _titleController = TextEditingController();
  final _checklistController = TextEditingController();
  final _uuid = const Uuid();

  String _suggestionCategory = RoutineSuggestions.student;
  final List<RoutineChecklistItem> _checklist = [];
  DateTime? _startDate;
  TimeOfDay? _reminderTime;
  final Set<int> _repeatWeekdays = {};
  final Set<String> _tags = {};
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
    _checklistController.dispose();
    super.dispose();
  }

  void _applySuggestion(String label) {
    _titleController.text = label;
    _titleController.selection = TextSelection.collapsed(offset: label.length);
  }

  void _addChecklistItem() {
    final title = _checklistController.text.trim();
    if (title.isEmpty) {
      return;
    }
    setState(() {
      _checklist.add(RoutineChecklistItem(id: _uuid.v4(), title: title));
      _checklistController.clear();
    });
  }

  void _toggleChecklistDone(int index, bool isDone) {
    setState(() {
      _checklist[index] = _checklist[index].copyWith(isDone: isDone);
    });
  }

  void _removeChecklistItem(int index) {
    setState(() => _checklist.removeAt(index));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      builder: _pickerThemeBuilder,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(
      () => _startDate = DateTime(picked.year, picked.month, picked.day),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
      builder: _pickerThemeBuilder,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() => _reminderTime = picked);
  }

  Widget _pickerThemeBuilder(BuildContext context, Widget? child) {
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: AppColors.accent,
          onPrimary: AppColors.textOnDark,
          surface: AppColors.textOnDark,
          onSurface: AppColors.text,
          secondary: AppColors.gold,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.textOnDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }

  void _clearDateTime() {
    setState(() {
      _startDate = null;
      _reminderTime = null;
    });
  }

  String _formatStartDate(DateTime date, Locale locale) {
    final localeName = locale.toLanguageTag();
    if (locale.languageCode == 'ko') {
      return DateFormat('M월 d일 (E)', localeName).format(date);
    }
    return DateFormat('MMM d (E)', localeName).format(date);
  }

  String _formatDateTime(AppLocalizations l10n, Locale locale) {
    if (_startDate == null && _reminderTime == null) {
      return l10n.dateTimeUnset;
    }

    final dateText = _startDate == null
        ? null
        : _formatStartDate(_startDate!, locale);
    final timeText = _reminderTime == null
        ? null
        : MaterialLocalizations.of(context)
              .formatTimeOfDay(_reminderTime!, alwaysUse24HourFormat: false);

    if (dateText != null && timeText != null) {
      return l10n.dateTimeCombined(dateText, timeText);
    }
    return dateText ?? timeText!;
  }

  Future<void> _submit() async {
    if (!_canSave) {
      return;
    }

    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
    final saved = await widget.viewModel.addRoutine(
      title: _titleController.text,
      checklist: List<RoutineChecklistItem>.from(_checklist),
      startDate: _startDate,
      reminderHour: _reminderTime?.hour,
      reminderMinute: _reminderTime?.minute,
      repeatWeekdays: Set<int>.from(_repeatWeekdays),
      tags: _tags.toList(),
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
        .showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context);
    final suggestionIds =
        RoutineSuggestions.byCategory[_suggestionCategory] ?? const <String>[];
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
                          l10n.addRoutineTitle,
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
                            title: l10n.sectionTitle,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _titleController,
                                  autofocus: true,
                                  style: textTheme.bodyLarge,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: l10n.routineNameHint,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final category
                                        in RoutineSuggestions.categories)
                                      PixelChip(
                                        label: l10n.suggestionCategoryLabel(
                                          category,
                                        ),
                                        selected:
                                            _suggestionCategory == category,
                                        onSelected: (_) {
                                          setState(
                                            () =>
                                                _suggestionCategory = category,
                                          );
                                        },
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final suggestionId in suggestionIds)
                                      PixelChip(
                                        label: l10n.suggestionLabel(
                                          suggestionId,
                                        ),
                                        selected: false,
                                        onSelected: (_) {
                                          _applySuggestion(
                                            l10n.suggestionLabel(suggestionId),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionFrame(
                            title: l10n.sectionChecklist,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _checklistController,
                                        style: textTheme.bodyMedium,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          hintText: l10n.checklistItemHint,
                                        ),
                                        onSubmitted: (_) => _addChecklistItem(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: _addChecklistItem,
                                      child: Text(l10n.addChecklistItem),
                                    ),
                                  ],
                                ),
                                if (_checklist.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  for (var i = 0; i < _checklist.length; i++)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: i == _checklist.length - 1
                                            ? 0
                                            : 8,
                                      ),
                                      child: Row(
                                        children: [
                                          PixelCheckbox(
                                            value: _checklist[i].isDone,
                                            onChanged: (value) =>
                                                _toggleChecklistDone(i, value),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              _checklist[i].title,
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                    decoration:
                                                        _checklist[i].isDone
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : TextDecoration.none,
                                                  ),
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: l10n.deleteChecklistItem,
                                            onPressed: () =>
                                                _removeChecklistItem(i),
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: AppColors.text.withValues(
                                                alpha: 0.45,
                                              ),
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionFrame(
                            title: l10n.sectionDateTime,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _formatDateTime(l10n, locale),
                                  style: textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    PixelChip(
                                      label: l10n.pickStartDate,
                                      selected: false,
                                      onSelected: (_) => _pickDate(),
                                    ),
                                    PixelChip(
                                      label: l10n.pickReminderTime,
                                      selected: false,
                                      onSelected: (_) => _pickTime(),
                                    ),
                                    if (_startDate != null ||
                                        _reminderTime != null)
                                      PixelChip(
                                        label: l10n.clearDateTime,
                                        selected: false,
                                        onSelected: (_) => _clearDateTime(),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionFrame(
                            title: l10n.sectionRepeat,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                PixelWeekdaySelector(
                                  selected: _repeatWeekdays,
                                  labels: l10n.weekdayLabels,
                                  onChanged: (next) {
                                    setState(() {
                                      _repeatWeekdays
                                        ..clear()
                                        ..addAll(next);
                                    });
                                  },
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.repeatEverydayHint,
                                  style: textTheme.labelSmall,
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
                          const SizedBox(height: 12),
                          _SectionFrame(
                            title: l10n.sectionTags,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final tagId in RoutineTags.all)
                                  PixelChip(
                                    label: l10n.tagLabel(tagId),
                                    selected: _tags.contains(tagId),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _tags.add(tagId);
                                        } else {
                                          _tags.remove(tagId);
                                        }
                                      });
                                    },
                                  ),
                              ],
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
    final textTheme = Theme.of(context).textTheme;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
