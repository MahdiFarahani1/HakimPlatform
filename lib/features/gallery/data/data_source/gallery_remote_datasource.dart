import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/error/api_call_handler.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/gallery/data/models/category_gallery_model.dart';
import '../models/gallery_model.dart';

class GalleryDataSource {
  final Dio dio;
  GalleryDataSource(this.dio);

  Future<Either<Failure, Uint8List>> downloadImage(String imageUrl) {
    return safeApiCall(() async {
      final fullUrl = 'http://ammaralhakeem.com$imageUrl';
      final response = await dio.get(
        fullUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    });
  }

  Future<Either<Failure, List<CategoryModel>>> getCategories() {
    return safeApiCall(() async {
      final response = await dio.get('${Api.baseUrl}${Api.galleryCategories}');
      final List data = response.data['data'];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    });
  }

  Future<Either<Failure, List<GalleryModel>>> getGalleries() {
    return safeApiCall(() async {
      final response = await dio.get('${Api.baseUrl}${Api.galleries}');
      final List data = response.data['data'];
      return data.map((json) => GalleryModel.fromJson(json)).toList();
    });
  }
}
