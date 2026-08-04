import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/error/api_call_handler.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/search/data/models/search_result_model.dart';

class SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSource(this.dio);

  Future<Either<Failure, List<SearchResultModel>>> search(String query) {
    return safeApiCall(() async {
      final response = await dio.get(
        Api.search,
        queryParameters: {'q': query},
      );
      final Map<String, dynamic> body = response.data is Map<String, dynamic>
          ? response.data
          : {};
      final List dataList = body['data'] is List ? body['data'] : [];
      return dataList
          .map((item) => SearchResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
}
