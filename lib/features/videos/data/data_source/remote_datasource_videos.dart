import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/features/videos/data/models/video_category_model.dart';

import 'package:flutter_application_1/features/videos/data/models/video_model.dart';

class VideosRemoteDataSource {
  final Dio dio;

  VideosRemoteDataSource(this.dio);
  Future<List<VideoModel>> getVideosData() async {
    try {
      final response = await dio.get(Api.videos);
      return (response.data['data'] as List)
          .map((e) => VideoModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VideoCategoryModel>> getVideosCategoryData() async {
    try {
      final response = await dio.get(Api.videoCategories);
      return (response.data['data'] as List)
          .map((e) => VideoCategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
