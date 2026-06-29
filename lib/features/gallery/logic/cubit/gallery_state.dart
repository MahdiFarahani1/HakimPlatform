part of 'gallery_cubit.dart';

abstract class GalleryState {}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<CategoryModel> categories;
  final List<GalleryModel> galleries;
  final int selectedCategoryId;

  GalleryLoaded({
    required this.categories,
    required this.galleries,
    this.selectedCategoryId = 0,
  });

  List<GalleryModel> get filteredGalleries {
    if (selectedCategoryId == 0) return galleries;
    final category = categories.firstWhere(
      (cat) => cat.id == selectedCategoryId,
      orElse: () => categories.first,
    );
    return galleries
        .where((gallery) => gallery.category == category.title)
        .toList();
  }
}

class GalleryError extends GalleryState {
  final String message;
  GalleryError(this.message);
}
