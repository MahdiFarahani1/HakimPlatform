// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';

import '../models/about_model.dart';

class AboutDatasourceRemote {
  final Dio dio;
  AboutDatasourceRemote(this.dio);
  Future<AboutModel> fetchAboutInfo() async {
    try {
      final response = await dio.get(Api.configurations);

      if (response.statusCode == 200) {
        return AboutModel.fromJson(response.data);
      } else {
        throw Exception('خطا در دریافت اطلاعات: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطا در ارتباط با سرور: $e');
    }
  }
}
