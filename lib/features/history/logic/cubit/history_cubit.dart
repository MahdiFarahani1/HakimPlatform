import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/features/history/data/models/history_item.dart';
import 'package:flutter_application_1/features/history/data/repository/history_repository_impl.dart';
import 'package:flutter_application_1/features/history/logic/cubit/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _repository;

  HistoryCubit(this._repository) : super(const HistoryInitial());

  Future<void> loadHistory() async {
    try {
      final items = await _repository.getRecentItems();
      emit(HistoryLoaded(items));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> addItem(HistoryItem item) async {
    try {
      await _repository.saveItem(item);
      await loadHistory();
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> clearHistory() async {
    try {
      await _repository.clearHistory();
      emit(const HistoryLoaded([]));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
