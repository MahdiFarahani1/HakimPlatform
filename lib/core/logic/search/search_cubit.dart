import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit<T> extends Cubit<SearchState<T>> {
  SearchCubit() : super(const SearchState());

  void search({
    required String query,
    required List<T> source,
    required String Function(T) title,
  }) {
    final result = source.where((item) {
      return title(item).toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(SearchState(query: query, results: result));
  }

  void clear(List<T> source) {
    emit(SearchState(results: source));
  }
}
