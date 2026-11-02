import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/sound/coin_sound.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_icon.dart';
import 'package:pixel_habit/ui/features/home/views/home_scene.dart';
import 'package:pixel_habit/ui/features/home/views/quest_panel.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/features/routine/views/add_routine_sheet.dart';
import 'package:pixel_habit/ui/features/todo/view_models/todo_view_model.dart';
import 'package:pixel_habit/ui/features/todo/views/add_todo_sheet.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.routines, required this.todos});

  final RoutineViewModel routines;
  final TodoViewModel todos;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _segment = 0;
  var _burst = 0;
  var _ready = false;
  var _lastGold = 0;
  CoinSound? _sound;

  @override
  void initState() {
    super.initState();
    widget.routines.addListener(_onProgress);
    _lastGold = widget.routines.progress.gold;
    _ready = !widget.routines.isLoading;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sound = context.read<CoinSound>();
  }

  @override
  void dispose() {
    widget.routines.removeListener(_onProgress);
    super.dispose();
  }

  void _onProgress() {
    final gold = widget.routines.progress.gold;
    if (!_ready) {
      if (!widget.routines.isLoading) {
        _ready = true;
        _lastGold = gold;
      }
      return;
    }
    final gain = gold - _lastGold;
    _lastGold = gold;
    if (gain > 0 && mounted) {
      setState(() => _burst++);
      _sound?.play();
    }
  }

  Future<void> _openAddSheet() {
    final sheet = _segment == 0
        ? AddRoutineSheet(viewModel: widget.routines)
        : AddTodoSheet(viewModel: widget.todos);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => sheet,
    );
  }

  Future<void> _confirmDelete({
    required String title,
    required String message,
    required String action,
    required Future<void> Function() onDelete,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(action),
            ),
          ],
        );
      },
    );
    if (shouldDelete ?? false) {
      await onDelete();
    }
  }

  Future<void> _deleteRoutine(Routine routine) {
    final l10n = AppLocalizations.of(context)!;
    return _confirmDelete(
      title: l10n.deleteRoutine,
      message: l10n.deleteRoutineConfirm,
      action: l10n.deleteRoutine,
      onDelete: () => widget.routines.deleteRoutine(routine.id),
    );
  }

  Future<void> _deleteTodo(Todo todo) {
    final l10n = AppLocalizations.of(context)!;
    return _confirmDelete(
      title: l10n.deleteTodo,
      message: l10n.deleteTodoConfirm,
      action: l10n.deleteTodo,
      onDelete: () => widget.todos.deleteTodo(todo.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showingTodos = _segment == 1;

    return ListenableBuilder(
      listenable: Listenable.merge([widget.routines, widget.todos]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.panel,
          floatingActionButton: FloatingActionButton(
            key: Key(showingTodos ? 'add_todo_button' : 'add_routine_button'),
            tooltip: showingTodos ? l10n.addTodo : l10n.addRoutine,
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.text,
            elevation: 2,
            shape: const CircleBorder(),
            onPressed: _openAddSheet,
            child: const PixelIcon(
              asset: PixelIcons.plus,
              size: 32,
              color: AppColors.text,
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final sceneHeight = (constraints.maxHeight * 0.42).clamp(
                0.0,
                340.0,
              );
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: sceneHeight,
                    child: HomeScene(
                      progress: widget.routines.progress,
                      burst: _burst,
                    ),
                  ),
                  Positioned(
                    top: sceneHeight - 20,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: QuestPanel(
                      routines: widget.routines,
                      todos: widget.todos,
                      segment: _segment,
                      onSegment: (index) => setState(() => _segment = index),
                      onDeleteRoutine: _deleteRoutine,
                      onDeleteTodo: _deleteTodo,
                      onToggleRoutine: (routine) =>
                          widget.routines.toggleCompleted(routine.id),
                      onToggleTodo: (todo) =>
                          widget.todos.toggleCompleted(todo.id),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
