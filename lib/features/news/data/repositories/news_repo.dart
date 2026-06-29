// lib/features/news/data/repositories/news_repository.dart
import 'package:flutter_application_1/features/news/data/data_source/remote_news_data.dart';
import 'package:flutter_application_1/features/news/data/models/news_detail.dart';
import 'package:flutter_application_1/features/news/data/models/news_response_model.dart';

class NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepository(this.remoteDataSource);

  Future<NewsResponseModel> getNews({int page = 1, String? lang}) async {
    return await remoteDataSource.getNews(page: page, lang: lang);
  }

  Future<NewsDetailModel> getDetailsNews({required int postId}) async {
    return await remoteDataSource.fetchNewsDetail(postId);
  }
}
