import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/videos/data/data_source/remote_datasource_videos.dart';
import 'package:flutter_application_1/features/videos/data/models/video_category_model.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';

class VideosRepository {
  final VideosRemoteDataSource remote;

  VideosRepository(this.remote);

  Future<Either<Failure, List<VideoModel>>> getVideosData() {
    return remote.getVideosData();
  }

  Future<Either<Failure, List<VideoCategoryModel>>> getCategoryVideosData() {
    return remote.getVideosCategoryData();
  }
}
