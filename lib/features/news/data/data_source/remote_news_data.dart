import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/error/api_call_handler.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/news/data/models/news_detail.dart';
import 'package:flutter_application_1/features/news/data/models/news_response_model.dart';

class NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSource(this.dio);

  Future<Either<Failure, NewsResponseModel>> getNews({
    int page = 1,
    String? lang,
  }) {
    return safeApiCall(() async {
      final queryParams = <String, dynamic>{'page': page, 'lang': lang ?? ''};

      final response = await dio.get(
        '${Api.baseUrl}/all-news',
        queryParameters: queryParams,
      );

      return NewsResponseModel.fromJson(response.data);
    });
  }

  Future<Either<Failure, NewsDetailModel>> fetchNewsDetail(int postId) {
    return safeApiCall(() async {
      final response = await dio.get('${Api.baseUrl}/post/$postId');

      final Map<String, dynamic> jsonResponse = response.data;

      if (jsonResponse['status'] == 'success') {
        return NewsDetailModel.fromJson(jsonResponse);
      } else {
        throw Exception('API status is not success: ${jsonResponse['status']}');
      }
    });
  }
}
