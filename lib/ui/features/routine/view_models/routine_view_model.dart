import 'package:flutter/foundation.dart';
import 'package:pixel_habit/data/repositories/routine_repository.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:uuid/uuid.dart';

class RoutineViewModel extends ChangeNotifier {
  RoutineViewModel({
    required this._repository,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final RoutineRepository _repository;
  final Uuid _uuid;

  List<Routine> _routines = const [];
  PlayerProgress _progress = const PlayerProgress();
  bool _isLoading = false;
  String? _errorMessage;
  int? _lastGrantedXp;

  List<Routine> get routines => List.unmodifiable(_routines);
  PlayerProgress get progress => _progress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get lastGrantedXp => _lastGrantedXp;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final loaded = await _repository.loadRoutines();
      _routines = _resetIfNewDay(loaded);
      _progress = await _repository.loadProgress();
      await _repository.saveRoutines(_routines);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleCompleted(String id) async {
    final index = _routines.indexWhere((routine) => routine.id == id);
    if (index == -1) {
      return;
    }

    final routine = _routines[index];
    final now = DateTime.now();
    final willComplete = !routine.completedToday;
    final updated = routine.copyWith(
      completedToday: willComplete,
      lastCompletedAt: willComplete ? now : routine.lastCompletedAt,
    );

    _routines = [..._routines]..[index] = updated;
    if (willComplete) {
      _progress = _progress.copyWith(xp: _progress.xp + routine.xpReward);
      _lastGrantedXp = routine.xpReward;
    } else {
      _progress = _progress.copyWith(
        xp: (_progress.xp - routine.xpReward).clamp(0, 1 << 30),
      );
      _lastGrantedXp = null;
    }

    notifyListeners();
    await _repository.saveRoutines(_routines);
    await _repository.saveProgress(_progress);
  }

  Future<void> addRoutine({
    required String title,
    String? note,
    int xpReward = 15,
    int avatarSeed = 0,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final routine = Routine(
      id: _uuid.v4(),
      title: trimmed,
      note: note?.trim().isEmpty ?? true ? null : note!.trim(),
      xpReward: xpReward,
      avatarSeed: avatarSeed,
      createdAt: DateTime.now(),
    );
    _routines = [..._routines, routine];
    notifyListeners();
    await _repository.saveRoutines(_routines);
  }

  Future<void> deleteRoutine(String id) async {
    _routines = _routines.where((routine) => routine.id != id).toList();
    notifyListeners();
    await _repository.saveRoutines(_routines);
  }

  List<Routine> _resetIfNewDay(List<Routine> routines) {
    final today = DateTime.now();
    return routines.map((routine) {
      final last = routine.lastCompletedAt;
      final completedOnAnotherDay =
          routine.completedToday &&
          last != null &&
          !_isSameDay(last, today);
      if (completedOnAnotherDay) {
        return routine.copyWith(completedToday: false);
      }
      return routine;
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
