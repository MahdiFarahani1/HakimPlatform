import 'package:flutter_application_1/features/videos/data/data_source/remote_datasource_videos.dart';
import 'package:flutter_application_1/features/videos/data/models/video_category_model.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';

class VideosRepository {
  final VideosRemoteDataSource remote;

  VideosRepository(this.remote);

  Future<List<VideoModel>> getVideosData() {
    return remote.getVideosData();
  }

  Future<List<VideoCategoryModel>> getCategoryVideosData() {
    return remote.getVideosCategoryData();
  }
}
