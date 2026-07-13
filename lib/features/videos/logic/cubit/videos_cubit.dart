import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';
import 'package:flutter_application_1/features/videos/data/repositories/repo_videos.dart';

part 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  final VideosRepository repository;

  VideosCubit(this.repository) : super(VideosLoading());

  Future<void> fetchVideos() async {
    emit(VideosLoading());

    final result = await repository.getVideosData();

    result.fold(
      (failure) => emit(VideosError(failure.message)),
      (videos) => emit(VideosSuccess(videos)),
    );
  }
}
