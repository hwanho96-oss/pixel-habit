import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pixel_habit/data/repositories/routine_repository.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/domain/models/routine_checklist_item.dart';
import 'package:uuid/uuid.dart';

class RoutineViewModel extends ChangeNotifier {
  RoutineViewModel({required this._repository, Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final RoutineRepository _repository;
  final Uuid _uuid;
  final Completer<void> _progressReady = Completer<void>();

  /// 루틴과 할 일이 같은 골드를 만진다. 읽기·쓰기가 겹치지 않게 한 줄로 처리한다.
  Future<void> _rewardQueue = Future<void>.value();

  List<Routine> _routines = const [];
  PlayerProgress _progress = const PlayerProgress();
  bool _isLoading = false;
  String? _errorMessage;
  int? _lastGrantedXp;
  int? _lastGrantedGold;

  List<Routine> get routines => List.unmodifiable(_routines);
  PlayerProgress get progress => _progress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get lastGrantedXp => _lastGrantedXp;
  int? get lastGrantedGold => _lastGrantedGold;

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
      if (!_progressReady.isCompleted) {
        _progressReady.complete();
      }
      notifyListeners();
    }
  }

  /// 할 일 완료도 이 메서드로 골드와 경험치를 주고 거둔다.
  Future<void> applyCompletionReward({
    required bool completed,
    required int xpReward,
  }) {
    return _enqueue(() async {
      await _progressReady.future;
      _writeReward(completed: completed, xpReward: xpReward);
      notifyListeners();
      await _repository.saveProgress(_progress);
    });
  }

  Future<void> toggleCompleted(String id) {
    return _enqueue(() async {
      await _progressReady.future;
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
      _writeReward(completed: willComplete, xpReward: routine.xpReward);
      notifyListeners();
      await _repository.saveRoutines(_routines);
      await _repository.saveProgress(_progress);
    });
  }

  Future<bool> addRoutine({
    required String title,
    String? note,
    int xpReward = 15,
    int avatarSeed = 0,
    List<RoutineChecklistItem> checklist = const [],
    DateTime? startDate,
    int? reminderHour,
    int? reminderMinute,
    Set<int> repeatWeekdays = const {},
    List<String> tags = const [],
    HabitStat? stat,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    final routine = Routine(
      id: _uuid.v4(),
      title: trimmed,
      note: note?.trim().isEmpty ?? true ? null : note!.trim(),
      xpReward: xpReward,
      avatarSeed: avatarSeed,
      createdAt: DateTime.now(),
      checklist: List<RoutineChecklistItem>.unmodifiable(checklist),
      startDate: startDate,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      repeatWeekdays: Set<int>.unmodifiable(repeatWeekdays),
      tags: List<String>.unmodifiable(tags),
      stat: stat,
    );

    final previous = _routines;
    _routines = [..._routines, routine];
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.saveRoutines(_routines);
      return true;
    } catch (error) {
      _routines = previous;
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  /// 상점 결제. 모자라면 저장하지 않고 false.
  Future<bool> spendGold(int amount) {
    var spent = false;
    final scheduled = _enqueue(() async {
      await _progressReady.future;
      final next = _progress.trySpendGold(amount);
      if (next == null) {
        return;
      }
      spent = true;
      if (next.gold == _progress.gold) {
        return;
      }
      _progress = next;
      notifyListeners();
      await _repository.saveProgress(_progress);
    });
    return scheduled.then((_) => spent);
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
          routine.completedToday && last != null && !_isSameDay(last, today);
      if (completedOnAnotherDay) {
        return routine.copyWith(completedToday: false);
      }
      return routine;
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _writeReward({required bool completed, required int xpReward}) {
    if (completed) {
      _progress = _progress.grantCompletionReward(xpReward: xpReward);
      _lastGrantedXp = xpReward;
      _lastGrantedGold = PlayerProgress.goldPerCompletion;
    } else {
      _progress = _progress.revokeCompletionReward(xpReward: xpReward);
      _lastGrantedXp = null;
      _lastGrantedGold = null;
    }
  }

  Future<void> _enqueue(Future<void> Function() action) {
    final scheduled = _rewardQueue.then((_) => action());
    _rewardQueue = scheduled.then((_) {}, onError: (Object _, StackTrace _) {});
    return scheduled;
  }
}
