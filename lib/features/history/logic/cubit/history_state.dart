import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/history/data/models/history_item.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoaded extends HistoryState {
  final List<HistoryItem> items;

  const HistoryLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
