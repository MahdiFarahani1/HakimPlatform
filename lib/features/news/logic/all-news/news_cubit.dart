import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/news/data/models/news_model.dart';
import 'package:flutter_application_1/features/news/data/repositories/news_repo.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;

  NewsCubit(this.repository) : super(NewsInitial());

  final List<NewsModel> _allNews = [];
  int _currentPage = 1;
  bool _hasMore = true;
  String? _currentLang;

  Future<void> fetchNews({bool isRefresh = false}) async {
    if (isRefresh) {
      _allNews.clear();
      _currentPage = 1;
      _hasMore = true;
      emit(NewsLoading());
    } else if (state is NewsLoading) {
      return;
    }

    if (!_hasMore && !isRefresh) {
      return;
    }

    final result = await repository.getNews(
      page: _currentPage,
      lang: _currentLang,
    );

    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (response) {
        _allNews.addAll(response.data);
        _hasMore = _currentPage < response.lastPage;
        _currentPage++;

        emit(
          NewsSuccess(
            List.from(_allNews),
            hasMore: _hasMore,
            currentPage: response.currentPage,
            total: response.total,
          ),
        );
      },
    );
  }

  void filterByLanguage(String? lang) {
    _currentLang = lang == 'الكل' ? null : lang;
    _allNews.clear();
    _currentPage = 1;
    _hasMore = true;
    fetchNews(isRefresh: true);
  }

  void searchNews(String query) {
    if (state is NewsSuccess) {
      final currentState = state as NewsSuccess;
      if (query.isEmpty) {
        emit(
          NewsSuccess(
            currentState.allNews,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            total: currentState.total,
          ),
        );
      } else {
        final filtered = currentState.allNews.where((news) {
          return news.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(
          NewsSuccess(
            currentState.allNews,
            filteredNews: filtered,
            searchQuery: query,
            hasMore: currentState.hasMore,
            currentPage: currentState.currentPage,
            total: currentState.total,
          ),
        );
      }
    }
  }

  void clearSearch() {
    if (state is NewsSuccess) {
      final currentState = state as NewsSuccess;
      emit(
        NewsSuccess(
          currentState.allNews,
          searchQuery: '',
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          total: currentState.total,
        ),
      );
    }
  }
}
