import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/error/api_call_handler.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/videos/data/models/video_category_model.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';

class VideosRemoteDataSource {
  final Dio dio;

  VideosRemoteDataSource(this.dio);

  Future<Either<Failure, List<VideoModel>>> getVideosData() {
    return safeApiCall(() async {
      final response = await dio.get(Api.videos);
      return (response.data['data'] as List)
          .map((e) => VideoModel.fromJson(e))
          .toList();
    });
  }

  Future<Either<Failure, List<VideoCategoryModel>>> getVideosCategoryData() {
    return safeApiCall(() async {
      final response = await dio.get(Api.videoCategories);
      return (response.data['data'] as List)
          .map((e) => VideoCategoryModel.fromJson(e))
          .toList();
    });
  }
}
