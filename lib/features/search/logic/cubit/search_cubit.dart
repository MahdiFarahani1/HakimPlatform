import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/search/data/repositories/search_repository.dart';
import 'package:flutter_application_1/features/search/logic/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;
  String _currentQuery = '';

  SearchCubit(this.searchRepository) : super(const SearchInitial());

  String get currentQuery => _currentQuery;

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    _currentQuery = trimmedQuery;

    if (trimmedQuery.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(SearchLoading(trimmedQuery));

    final result = await searchRepository.search(trimmedQuery);

    result.fold(
      (failure) => emit(
        SearchError(
          message: failure.message,
          query: trimmedQuery,
        ),
      ),
      (results) {
        if (results.isEmpty) {
          emit(SearchEmpty(trimmedQuery));
        } else {
          emit(SearchSuccess(results: results, query: trimmedQuery));
        }
      },
    );
  }

  void clearSearch() {
    _currentQuery = '';
    emit(const SearchInitial());
  }
}
