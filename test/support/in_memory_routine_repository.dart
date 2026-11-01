import 'package:pixel_habit/data/repositories/routine_repository.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';

class InMemoryRoutineRepository implements RoutineRepository {
  InMemoryRoutineRepository({
    List<Routine>? routines,
    PlayerProgress? progress,
  }) : _routines = List.of(routines ?? const []),
       _progress = progress ?? const PlayerProgress();

  List<Routine> _routines;
  PlayerProgress _progress;

  @override
  Future<List<Routine>> loadRoutines() async => List.of(_routines);

  @override
  Future<void> saveRoutines(List<Routine> routines) async {
    _routines = List.of(routines);
  }

  @override
  Future<PlayerProgress> loadProgress() async => _progress;

  @override
  Future<void> saveProgress(PlayerProgress progress) async {
    _progress = progress;
  }
}
