import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/features/gallery/data/models/category_gallery_model.dart';
import '../models/gallery_model.dart';

class GalleryDataSource {
  final Dio dio;
  GalleryDataSource(this.dio);

  Future<Uint8List> downloadImage(String imageUrl) async {
    try {
      final fullUrl = 'http://ammaralhakeem.com$imageUrl';
      final response = await dio.get(
        fullUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    } catch (e) {
      throw Exception('خطا در دانلود تصویر');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('${Api.baseUrl}${Api.galleryCategories}');
      final List data = response.data['data'];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('خطا در دریافت دسته‌بندی‌ها');
    }
  }

  Future<List<GalleryModel>> getGalleries() async {
    try {
      final response = await dio.get('${Api.baseUrl}${Api.galleries}');
      final List data = response.data['data'];
      return data.map((json) => GalleryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('خطا در دریافت گالری‌ها');
    }
  }
}
