import 'package:flutter_application_1/features/history/data/datasource/history_local_datasource.dart';
import 'package:flutter_application_1/features/history/data/models/history_item.dart';

class HistoryRepository {
  final HistoryLocalDatasource _datasource;

  HistoryRepository(this._datasource);

  Future<void> saveItem(HistoryItem item) async {
    await _datasource.saveItem(item);
  }

  Future<List<HistoryItem>> getRecentItems() async {
    return _datasource.getItems();
  }

  Future<void> clearHistory() async {
    await _datasource.clearAll();
  }
}
