import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/news/data/models/news_detail.dart';
import 'package:flutter_application_1/features/news/data/repositories/news_repo.dart';

part 'detail_news_state.dart';

class NewsDetailCubit extends Cubit<NewsDetailState> {
  final NewsRepository repository;

  NewsDetailCubit(this.repository) : super(NewsDetailInitial());

  Future<void> fetchNewsDetail({required int postId}) async {
    if (state is! NewsDetailLoading) {
      emit(NewsDetailLoading());
    }

    final result = await repository.getDetailsNews(postId: postId);

    result.fold(
      (failure) => emit(NewsDetailError(failure.message)),
      (newsDetail) => emit(NewsDetailSuccess(newsDetail)),
    );
  }

  void reset() {
    if (state is! NewsDetailInitial) {
      emit(NewsDetailInitial());
    }
  }
}
