import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/videos/data/models/video_category_model.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';
import 'package:flutter_application_1/features/videos/data/repositories/repo_videos.dart';

part 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  final VideosRepository repository;

  VideosCubit(this.repository) : super(const VideosState());

  Future<void> fetchData({int? categoryId}) async {
    final targetCategoryId = categoryId ?? state.selectedCategoryId;

    emit(
      state.copyWith(
        videosStatus: const VideosLoading(),
        selectedCategoryId: targetCategoryId,
        page: 1,
        fetchMore: false,
        hasReachedMax: false,
        categoriesStatus: state.categoriesStatus is VideosCatSuccess
            ? state.categoriesStatus
            : const VideosCatLoading(),
      ),
    );

    final videosResult = await repository.getVideosData(
      categoryId: targetCategoryId == 0 ? null : targetCategoryId,
      page: 1,
    );

    videosResult.fold(
      (failure) {
        emit(state.copyWith(videosStatus: VideosError(failure.message)));
      },
      (videos) {
        emit(
          state.copyWith(
            videosStatus: VideosSuccess(videos),
            page: 1,
            hasReachedMax: videos.length < 15,
          ),
        );
      },
    );

    if (state.categoriesStatus is! VideosCatSuccess) {
      final categoriesResult = await repository.getCategoryVideosData();

      categoriesResult.fold(
        (failure) {
          emit(
            state.copyWith(categoriesStatus: VideosCatError(failure.message)),
          );
        },
        (categories) {
          emit(state.copyWith(categoriesStatus: VideosCatSuccess(categories)));
        },
      );
    }
  }

  void filterByCategory(int categoryId) {
    if (state.selectedCategoryId == categoryId &&
        state.videosStatus is VideosSuccess) {
      return;
    }
    fetchData(categoryId: categoryId);
  }

  Future<void> fetchMoreData() async {
    if (state.fetchMore ||
        state.hasReachedMax ||
        state.videosStatus is! VideosSuccess) {
      return;
    }

    emit(state.copyWith(fetchMore: true));

    final nextPage = state.page + 1;
    final videosResult = await repository.getVideosData(
      categoryId: state.selectedCategoryId == 0
          ? null
          : state.selectedCategoryId,
      page: nextPage,
    );

    videosResult.fold(
      (failure) {
        emit(state.copyWith(fetchMore: false));
      },
      (videos) {
        final currentVideos = (state.videosStatus as VideosSuccess).allVideos;
        final updatedVideos = List<VideoModel>.from(currentVideos)..addAll(videos);

        emit(
          state.copyWith(
            videosStatus: VideosSuccess(updatedVideos),
            page: nextPage,
            fetchMore: false,
            hasReachedMax: videos.isEmpty || videos.length < 15,
          ),
        );
      },
    );
  }

  void changeCategory(int id) {
    filterByCategory(id);
  }
}
