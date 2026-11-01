import 'dart:convert';

import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> loadRoutines();

  Future<void> saveRoutines(List<Routine> routines);

  Future<PlayerProgress> loadProgress();

  Future<void> saveProgress(PlayerProgress progress);
}

class LocalRoutineRepository implements RoutineRepository {
  LocalRoutineRepository(this._storage);

  static const _routinesKey = 'routines_v1';
  static const _progressKey = 'player_progress_v1';

  final LocalStorageService _storage;

  @override
  Future<List<Routine>> loadRoutines() async {
    final raw = _storage.readString(_routinesKey);
    if (raw == null || raw.isEmpty) {
      return List<Routine>.from(_seedRoutines());
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Routine.fromJson(Map<String, Object?>.from(item as Map)))
        .toList();
  }

  @override
  Future<void> saveRoutines(List<Routine> routines) {
    final payload = jsonEncode(routines.map((routine) => routine.toJson()).toList());
    return _storage.writeString(_routinesKey, payload);
  }

  @override
  Future<PlayerProgress> loadProgress() async {
    final raw = _storage.readString(_progressKey);
    if (raw == null || raw.isEmpty) {
      return const PlayerProgress();
    }
    return PlayerProgress.fromJson(
      Map<String, Object?>.from(jsonDecode(raw) as Map),
    );
  }

  @override
  Future<void> saveProgress(PlayerProgress progress) {
    return _storage.writeString(_progressKey, jsonEncode(progress.toJson()));
  }

  List<Routine> _seedRoutines() {
    final now = DateTime.now();
    return [
      Routine(
        id: 'seed-morning',
        title: '아침 수련',
        note: '물 한 잔과 스트레칭',
        xpReward: 15,
        avatarSeed: 0,
        createdAt: now,
      ),
      Routine(
        id: 'seed-body',
        title: '체력 퀘스트',
        note: '가벼운 운동 20분',
        xpReward: 25,
        avatarSeed: 1,
        createdAt: now,
      ),
      Routine(
        id: 'seed-study',
        title: '마법 공부',
        note: '집중 학습 30분',
        xpReward: 20,
        avatarSeed: 2,
        createdAt: now,
      ),
      Routine(
        id: 'seed-rest',
        title: '휴식 의식',
        note: '화면 끄고 정리',
        xpReward: 10,
        avatarSeed: 3,
        createdAt: now,
      ),
    ];
  }
}
