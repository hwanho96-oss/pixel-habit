import 'package:flutter/material.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/l10n/app_localizations.dart';
import 'package:pixel_habit/ui/core/theme/app_colors.dart';
import 'package:pixel_habit/ui/features/todo/view_models/todo_view_model.dart';
import 'package:pixel_habit/ui/features/todo/views/add_todo_sheet.dart';
import 'package:pixel_habit/ui/features/todo/views/todo_card.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key, required this.viewModel});

  final TodoViewModel viewModel;

  Future<void> _openAddSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddTodoSheet(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabTodo)),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_todo_button'),
        tooltip: l10n.addTodo,
        onPressed: () => _openAddSheet(context),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.todos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.emptyTodos,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: viewModel.todos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final todo = viewModel.todos[index];
              return TodoCard(
                todo: todo,
                onToggle: () async {
                  await viewModel.toggleCompleted(todo.id);
                  if (!context.mounted) {
                    return;
                  }
                  final xp = viewModel.lastGrantedXp;
                  final gold = viewModel.lastGrantedGold;
                  if (xp != null && gold != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.todoCompletedToast(xp, gold)),
                      ),
                    );
                  }
                },
                onDelete: () => _confirmDelete(context, todo),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Todo todo) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteTodo),
          content: Text(l10n.deleteTodoConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.deleteTodo),
            ),
          ],
        );
      },
    );
    if (shouldDelete ?? false) {
      await viewModel.deleteTodo(todo.id);
    }
  }
}
