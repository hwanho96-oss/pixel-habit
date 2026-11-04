import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/personality_node.dart';
import 'package:pixel_habit/domain/models/personality_trait.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';

/// 성격별 경험치·열린 노드·대표 칭호. 장비와 같은 shared_preferences 방식이다.
class PersonalityProvider extends ChangeNotifier {
  PersonalityProvider(this._storage);

  static const storageKey = 'personality_v1';
  static const catalogAsset = 'assets/data/personality_nodes.json';
  static const xpPerLevel = PlayerProgress.xpPerLevel;
  static const _maxStoredXp = 1 << 30;

  final LocalStorageService _storage;
  List<PersonalityNode> _nodes = const [];
  final Map<PersonalityTrait, int> _xp = {
    for (final trait in PersonalityTrait.values) trait: 0,
  };
  final Set<String> _opened = {};
  String? _titleId;

  // shortcut: 카탈로그는 프로세스에서 한 번만 파싱한다. 실행 중에 JSON을 바꾸면 다시 읽게 바꾼다.
  static List<PersonalityNode>? _catalog;

  List<PersonalityNode> get nodes => List.unmodifiable(_nodes);
  Set<String> get openedIds => Set.unmodifiable(_opened);
  String? get titleId => _titleId;

  int xpOf(PersonalityTrait trait) => _xp[trait] ?? 0;

  int levelOf(PersonalityTrait trait) => (xpOf(trait) ~/ xpPerLevel) + 1;

  PersonalityNode? nodeById(String id) {
    for (final node in _nodes) {
      if (node.id == id) {
        return node;
      }
    }
    return null;
  }

  Future<void> load() async {
    if (_catalog == null) {
      final raw = await rootBundle.loadString(catalogAsset);
      final decoded = jsonDecode(raw) as List<dynamic>;
      _catalog = [
        for (final entry in decoded)
          PersonalityNode.fromJson(Map<String, Object?>.from(entry as Map)),
      ];
    }
    _nodes = _catalog!;
    _readSaved();
    _unlockReady();
    await _save();
    notifyListeners();
  }

  /// 할 일 완료·해제로 성격 경험치를 주고 거둔다. 스탯이 없으면 아무 것도 하지 않는다.
  Future<void> applyTodoTraitXp({
    required HabitStat? stat,
    required int xpReward,
    required bool completed,
  }) async {
    final trait = PersonalityTrait.fromHabitStat(stat);
    if (trait == null || xpReward == 0) {
      return;
    }
    final next = completed
        ? _clampXp(xpOf(trait) + xpReward)
        : _clampXp(xpOf(trait) - xpReward);
    if (next == xpOf(trait)) {
      return;
    }
    _xp[trait] = next;
    _unlockReady();
    await _save();
    notifyListeners();
  }

  /// 이미 열린 노드만 대표 칭호로 고른다. 모르는 id는 무시한다.
  Future<void> setTitleId(String? id) async {
    if (id != null && !_opened.contains(id)) {
      return;
    }
    if (id == _titleId) {
      return;
    }
    _titleId = id;
    await _save();
    notifyListeners();
  }

  void _unlockReady() {
    var changed = true;
    while (changed) {
      changed = false;
      for (final node in _nodes) {
        if (_opened.contains(node.id) || !_meets(node)) {
          continue;
        }
        _opened.add(node.id);
        changed = true;
      }
    }
  }

  bool _meets(PersonalityNode node) {
    for (final requiredId in node.requires) {
      if (!_opened.contains(requiredId)) {
        return false;
      }
    }
    for (final trait in node.traits) {
      if (levelOf(trait) < node.level) {
        return false;
      }
    }
    return node.traits.isNotEmpty;
  }

  void _readSaved() {
    for (final trait in PersonalityTrait.values) {
      _xp[trait] = 0;
    }
    _opened.clear();
    _titleId = null;
    final saved = _storage.readString(storageKey);
    if (saved == null || saved.isEmpty) {
      return;
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(saved);
    } catch (_) {
      return;
    }
    if (decoded is! Map) {
      return;
    }
    final xp = decoded['xp'];
    if (xp is Map) {
      for (final trait in PersonalityTrait.values) {
        _xp[trait] = _nonNegativeInt(xp[trait.name]);
      }
    }
    final opened = decoded['opened'];
    if (opened is List) {
      final known = {for (final node in _nodes) node.id};
      _opened.addAll(
        opened.whereType<String>().where((id) => known.contains(id)),
      );
    }
    final title = decoded['titleId'];
    if (title is String && _opened.contains(title)) {
      _titleId = title;
    }
  }

  Future<void> _save() {
    return _storage.writeString(
      storageKey,
      jsonEncode({
        'xp': {for (final trait in PersonalityTrait.values) trait.name: xpOf(trait)},
        'opened': _opened.toList(),
        'titleId': _titleId,
      }),
    );
  }

  static int _clampXp(int value) {
    if (value < 0) {
      return 0;
    }
    if (value > _maxStoredXp) {
      return _maxStoredXp;
    }
    return value;
  }

  static int _nonNegativeInt(Object? value) {
    if (value is! num) {
      return 0;
    }
    final asInt = value.toInt();
    return asInt < 0 ? 0 : asInt;
  }
}
