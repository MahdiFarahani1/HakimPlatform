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

    final result = await repository.downloadAndSaveImage(imageUrl);

    result.fold(
      (failure) => emit(GalleryDetailFailure(
        downloadedImages: state.downloadedImages,
        error: failure.message,
      )),
      (success) {
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
      },
    );
  }
}
