import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/features/gallery/data/models/category_gallery_model.dart';
import 'package:flutter_application_1/features/gallery/data/models/gallery_model.dart';
import 'package:flutter_application_1/features/gallery/data/repositories/gallery_repo.dart';

part 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  final GalleryRepository repository;

  GalleryCubit(this.repository) : super(GalleryInitial());

  Future<void> loadData() async {
    emit(GalleryLoading());

    final categoriesResult = await repository.getCategories();

    await categoriesResult.fold(
      (failure) async => emit(GalleryError(failure.message)),
      (categories) async {
        final galleriesResult = await repository.getGalleries();

        galleriesResult.fold(
          (failure) => emit(GalleryError(failure.message)),
          (galleries) => emit(GalleryLoaded(
            categories: categories,
            galleries: galleries,
          )),
        );
      },
    );
  }

  void filterByCategory(int categoryId) {
    if (state is GalleryLoaded) {
      final currentState = state as GalleryLoaded;
      emit(
        GalleryLoaded(
          categories: currentState.categories,
          galleries: currentState.galleries,
          selectedCategoryId: categoryId,
        ),
      );
    }
  }
}
