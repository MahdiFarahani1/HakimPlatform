import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/search/data/models/search_result_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  final String query;
  const SearchLoading(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchSuccess extends SearchState {
  final List<SearchResultModel> results;
  final String query;

  const SearchSuccess({required this.results, required this.query});

  @override
  List<Object?> get props => [results, query];
}

class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;
  final String query;

  const SearchError({required this.message, required this.query});

  @override
  List<Object?> get props => [message, query];
}
