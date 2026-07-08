import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/gallery/data/repositories/gallery_repo.dart';
import 'gallery_detail_state.dart';

class GalleryDetailCubit extends Cubit<GalleryDetailState> {
  final GalleryRepository repository;

  GalleryDetailCubit(this.repository)
      : super(GalleryDetailInitial(
          downloadedImages: repository.getDownloadedImages(),
        ));

  Future<void> downloadImage(String imageUrl) async {
    emit(GalleryDetailDownloading(downloadedImages: state.downloadedImages));
    try {
      final success = await repository.downloadAndSaveImage(imageUrl);
      if (success) {
        final updatedList = repository.getDownloadedImages();
        emit(GalleryDetailSuccess(
          downloadedImages: updatedList,
          message: 'تم حفظ الصورة في المعرض بنجاح ✓',
        ));
      } else {
        emit(GalleryDetailFailure(
          downloadedImages: state.downloadedImages,
          error: 'حدث خطأ أثناء حفظ الصورة',
        ));
      }
    } catch (e) {
      emit(GalleryDetailFailure(
        downloadedImages: state.downloadedImages,
        error: 'حدث خطأ أثناء تحميل الصورة',
      ));
    }
  }
}
