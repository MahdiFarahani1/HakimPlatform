part of 'search_cubit.dart';

class SearchState<T> extends Equatable {
  final String query;
  final List<T> results;

  const SearchState({this.query = '', this.results = const []});

  @override
  List<Object?> get props => [query, results];
}
