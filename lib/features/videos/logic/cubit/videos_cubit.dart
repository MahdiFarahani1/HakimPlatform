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
    try {
      final response = await repository.getVideosData();
      emit(VideosSuccess(response));
    } catch (e) {
      emit(VideosError(e.toString()));
    }
  }

  // void searchVideos(String query) {
  //   final currentState = state;
  //   if (currentState is VideosSuccess) {
  //     if (query.isEmpty) {
  //       emit(VideosSuccess(currentState.allVideos, searchQuery: query));
  //     } else {
  //       final filtered = currentState.allVideos.where((video) {
  //         return video.title.toLowerCase().contains(query.toLowerCase()) ||
  //             video.description.toLowerCase().contains(query.toLowerCase());
  //       }).toList();
  //       emit(
  //         VideosSuccess(
  //           currentState.allVideos,
  //           filteredVideos: filtered,
  //           searchQuery: query,
  //         ),
  //       );
  //     }
  //   }
  // }

  // void clearSearch() {
  //   final currentState = state;
  //   if (currentState is VideosSuccess) {
  //     emit(VideosSuccess(currentState.allVideos, searchQuery: ''));
  //   }
  // }
}
