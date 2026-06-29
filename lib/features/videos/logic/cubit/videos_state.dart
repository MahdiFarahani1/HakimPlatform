part of 'videos_cubit.dart';

sealed class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object> get props => [];
}

final class VideosLoading extends VideosState {}

final class VideosSuccess extends VideosState {
  final List<VideoModel> allVideos;
  final List<VideoModel> filteredVideos;
  final String searchQuery;

  const VideosSuccess(
    this.allVideos, {
    List<VideoModel>? filteredVideos,
    this.searchQuery = '',
  }) : filteredVideos = filteredVideos ?? allVideos;

  List<VideoModel> get displayVideos => filteredVideos;

  @override
  List<Object> get props => [allVideos, filteredVideos, searchQuery];
}

final class VideosError extends VideosState {
  final String message;

  const VideosError(this.message);
}
