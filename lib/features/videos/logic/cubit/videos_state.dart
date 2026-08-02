part of 'videos_cubit.dart';

class VideosState extends Equatable {
  final VideosStatus videosStatus;
  final VideosCatStatus categoriesStatus;
  final int selectedCategoryId;
  final int page;
  final bool fetchMore;
  final bool hasReachedMax;

  const VideosState({
    this.videosStatus = const VideosLoading(),
    this.categoriesStatus = const VideosCatLoading(),
    this.selectedCategoryId = 0,
    this.page = 1,
    this.fetchMore = false,
    this.hasReachedMax = false,
  });

  VideosState copyWith({
    VideosStatus? videosStatus,
    VideosCatStatus? categoriesStatus,
    int? selectedCategoryId,
    int? page,
    bool? fetchMore,
    bool? hasReachedMax,
  }) {
    return VideosState(
      videosStatus: videosStatus ?? this.videosStatus,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      page: page ?? this.page,
      fetchMore: fetchMore ?? this.fetchMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        videosStatus,
        categoriesStatus,
        selectedCategoryId,
        page,
        fetchMore,
        hasReachedMax,
      ];
}

abstract class VideosStatus {
  const VideosStatus();
}

class VideosLoading extends VideosStatus {
  const VideosLoading();
}

class VideosSuccess extends VideosStatus {
  final List<VideoModel> allVideos;
  VideosSuccess(this.allVideos);
}

final class VideosError extends VideosStatus {
  final String message;
  VideosError(this.message);
}

abstract class VideosCatStatus {
  const VideosCatStatus();
}

final class VideosCatLoading extends VideosCatStatus {
  const VideosCatLoading();
}

final class VideosCatSuccess extends VideosCatStatus {
  final List<VideoCategoryModel> allVideos;
  VideosCatSuccess(this.allVideos);
}

final class VideosCatError extends VideosCatStatus {
  final String message;
  VideosCatError(this.message);
}
