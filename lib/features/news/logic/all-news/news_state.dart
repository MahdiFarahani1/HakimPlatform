// lib/features/news/logic/cubit/news_state.dart
part of 'news_cubit.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsSuccess extends NewsState {
  final List<NewsModel> allNews;
  final List<NewsModel> filteredNews;
  final String searchQuery;
  final bool hasMore;
  final int currentPage;
  final int total;

  const NewsSuccess(
    this.allNews, {
    List<NewsModel>? filteredNews,
    this.searchQuery = '',
    required this.hasMore,
    required this.currentPage,
    required this.total,
  }) : filteredNews = filteredNews ?? allNews;

  List<NewsModel> get displayNews => filteredNews;

  List<String> get languages {
    final langs = allNews.map((n) => n.languageName).toSet().toList();
    return ['الكل', ...langs];
  }

  @override
  List<Object> get props => [
    allNews,
    filteredNews,
    searchQuery,
    hasMore,
    currentPage,
    total,
  ];
}

final class NewsError extends NewsState {
  final String message;
  const NewsError(this.message);
}
