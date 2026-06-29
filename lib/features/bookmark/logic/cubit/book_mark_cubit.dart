import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_state.dart';
import 'package:flutter_application_1/features/news/data/models/news_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class BookmarkCubit extends HydratedCubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkState.initial());

  void toggleBookmark(NewsModel news) {
    final isExist = state.savedNews.any((item) => item.id == news.id);

    List<NewsModel> updatedList;
    if (isExist) {
      updatedList = state.savedNews
          .where((item) => item.id != news.id)
          .toList();
    } else {
      updatedList = [...state.savedNews, news];
    }

    emit(state.copyWith(savedNews: updatedList));
  }

  @override
  Map<String, dynamic>? toJson(BookmarkState state) {
    return {'news': state.savedNews.map((e) => e.toMap()).toList()};
  }

  @override
  BookmarkState? fromJson(Map<String, dynamic> json) {
    try {
      final newsJson = json['news'] as List?;
      final news = newsJson?.map((e) => NewsModel.fromMap(e)).toList() ?? [];

      return BookmarkState(savedNews: news);
    } catch (_) {
      return BookmarkState.initial();
    }
  }
}
