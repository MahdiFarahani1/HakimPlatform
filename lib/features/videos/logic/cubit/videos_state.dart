part of 'videos_cubit.dart';

sealed class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object> get props => [];
}

final class VideosLoading extends VideosState {}

final class VideosSuccess extends VideosState {
  final List<VideoModel> allVideos;

  const VideosSuccess(this.allVideos);

  @override
  List<Object> get props => [allVideos];
}

final class VideosError extends VideosState {
  final String message;

  const VideosError(this.message);
}
