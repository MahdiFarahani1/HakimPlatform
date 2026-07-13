import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/news/data/data_source/remote_news_data.dart';
import 'package:flutter_application_1/features/news/data/models/news_detail.dart';
import 'package:flutter_application_1/features/news/data/models/news_response_model.dart';

class NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepository(this.remoteDataSource);

  Future<Either<Failure, NewsResponseModel>> getNews({
    int page = 1,
    String? lang,
  }) {
    return remoteDataSource.getNews(page: page, lang: lang);
  }

  Future<Either<Failure, NewsDetailModel>> getDetailsNews({
    required int postId,
  }) {
    return remoteDataSource.fetchNewsDetail(postId);
  }
}
