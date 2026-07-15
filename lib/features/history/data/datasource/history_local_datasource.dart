import 'dart:convert';
import 'package:flutter_application_1/features/history/data/models/history_item.dart';
import 'package:get_storage/get_storage.dart';

class HistoryLocalDatasource {
  final GetStorage _storage;
  static const String _storageKey = 'recently_opened_history';
  static const int _maxItems = 30;

  HistoryLocalDatasource(this._storage);

  Future<void> saveItem(HistoryItem item) async {
    final items = _readItems();

    items.removeWhere((existing) => existing.uniqueKey == item.uniqueKey);

    items.insert(0, item);

    final trimmed = items.length > _maxItems
        ? items.sublist(0, _maxItems)
        : items;

    await _writeItems(trimmed);
  }

  List<HistoryItem> getItems() {
    return _readItems();
  }

  Future<void> clearAll() async {
    await _storage.remove(_storageKey);
  }

  List<HistoryItem> _readItems() {
    final raw = _storage.read<String>(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((e) => HistoryItem.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeItems(List<HistoryItem> items) async {
    final encoded = jsonEncode(items.map((e) => e.toMap()).toList());
    await _storage.write(_storageKey, encoded);
  }
}
