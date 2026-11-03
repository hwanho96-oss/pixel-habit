import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/domain/models/item.dart';
import 'package:pixel_habit/ui/core/theme/home_assets.dart';

/// 홈과 아바타 탭이 같이 보는 장비. 상점은 아직 없다.
class EquipmentProvider extends ChangeNotifier {
  EquipmentProvider(this._storage);

  static const storageKey = 'equipment_v1';
  static const baseAsset = 'assets/avatar/base.png';
  static const catalogAsset = 'assets/data/items.json';

  /// 가진 배경이 없으면 홈에 쓰던 배경을 그대로 깐다.
  static const defaultBackgroundAsset = HomeAssets.background;

  final LocalStorageService _storage;
  List<Item> _items = const [];
  final Set<String> _owned = {};
  final Map<ItemCategory, String> _equipped = {};

  List<Item> get items => List.unmodifiable(_items);
  Set<String> get ownedIds => Set.unmodifiable(_owned);

  String? equippedId(ItemCategory category) => _equipped[category];

  String? layerAsset(ItemCategory category) {
    final id = _equipped[category];
    if (id == null) {
      return null;
    }
    return _item(id)?.asset;
  }

  String get backgroundAsset =>
      layerAsset(ItemCategory.background) ?? defaultBackgroundAsset;

  Future<void> load() async {
    final raw = await rootBundle.loadString(catalogAsset);
    final decoded = jsonDecode(raw) as List<dynamic>;
    _items = [
      for (final entry in decoded)
        Item.fromJson(Map<String, Object?>.from(entry as Map)),
    ];
    _readSaved();
    notifyListeners();
  }

  /// 상점이 생기기 전에 테스트와 이후 단계에서 소유만 올린다. 골드는 깎지 않는다.
  Future<void> addOwned(String id) async {
    if (_item(id) == null || !_owned.add(id)) {
      return;
    }
    await _save();
    notifyListeners();
  }

  Future<void> equip(String id) async {
    final item = _item(id);
    if (item == null || !_owned.contains(id)) {
      return;
    }
    if (_equipped[item.category] == id) {
      return;
    }
    _equipped[item.category] = id;
    await _save();
    notifyListeners();
  }

  Future<void> unequip(ItemCategory category) async {
    if (_equipped.remove(category) == null) {
      return;
    }
    await _save();
    notifyListeners();
  }

  Item? _item(String id) {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  void _readSaved() {
    final saved = _storage.readString(storageKey);
    if (saved == null || saved.isEmpty) {
      return;
    }
    // 깨진 저장값은 기본 맨몸으로 돌아간다.
    final Object? decoded;
    try {
      decoded = jsonDecode(saved);
    } catch (_) {
      return;
    }
    if (decoded is! Map) {
      return;
    }
    final owned = decoded['owned'];
    if (owned is List) {
      _owned
        ..clear()
        ..addAll(owned.whereType<String>().where((id) => _item(id) != null));
    }
    final equipped = decoded['equipped'];
    if (equipped is! Map) {
      return;
    }
    for (final category in ItemCategory.values) {
      final id = equipped[category.name];
      final item = id is String ? _item(id) : null;
      if (item != null && item.category == category && _owned.contains(id)) {
        _equipped[category] = id;
      }
    }
  }

  Future<void> _save() {
    return _storage.writeString(
      storageKey,
      jsonEncode({
        'owned': _owned.toList(),
        'equipped': {
          for (final entry in _equipped.entries) entry.key.name: entry.value,
        },
      }),
    );
  }
}
