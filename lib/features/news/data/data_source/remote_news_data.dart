// lib/features/news/data/data_source/news_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/features/news/data/models/news_detail.dart';
import 'package:flutter_application_1/features/news/data/models/news_response_model.dart';

class NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSource(this.dio);

  Future<NewsResponseModel> getNews({int page = 1, String? lang}) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'lang': lang ?? ''};

      final response = await dio.get(
        '${Api.baseUrl}/all-news',
        queryParameters: queryParams,
      );

      return NewsResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<NewsDetailModel> fetchNewsDetail(int postId) async {
    final response = await dio.get('${Api.baseUrl}/post/$postId');

    // ✅ درست: response.data قبلاً یک Map هست
    // Dio خودکار JSON رو decode کرده
    final Map<String, dynamic> jsonResponse = response.data;

    if (jsonResponse['status'] == 'success') {
      return NewsDetailModel.fromJson(jsonResponse);
    } else {
      throw Exception('API status is not success: ${jsonResponse['status']}');
    }
  }
}
