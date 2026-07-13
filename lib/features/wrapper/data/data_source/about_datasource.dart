import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/error/api_call_handler.dart';
import 'package:flutter_application_1/core/error/failure.dart';

import '../models/about_model.dart';

class AboutDatasourceRemote {
  final Dio dio;
  AboutDatasourceRemote(this.dio);

  Future<Either<Failure, AboutModel>> fetchAboutInfo() {
    return safeApiCall(() async {
      final response = await dio.get(Api.configurations);

      if (response.statusCode == 200) {
        return AboutModel.fromJson(response.data);
      } else {
        throw Exception('خطا در دریافت اطلاعات: ${response.statusCode}');
      }
    });
  }
}
