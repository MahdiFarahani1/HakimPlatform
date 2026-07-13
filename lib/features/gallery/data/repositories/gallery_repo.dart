import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/gallery/data/data_source/gallery_local_datasource.dart';
import 'package:flutter_application_1/features/gallery/data/data_source/gallery_remote_datasource.dart';
import 'package:flutter_application_1/features/gallery/data/models/category_gallery_model.dart';
import 'package:flutter_application_1/features/gallery/data/models/gallery_model.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class GalleryRepository {
  final GalleryDataSource dataSource;
  final GalleryLocalDataSource localDataSource;

  GalleryRepository({
    required this.dataSource,
    required this.localDataSource,
  });

  Future<Either<Failure, List<CategoryModel>>> getCategories() {
    return dataSource.getCategories();
  }

  Future<Either<Failure, List<GalleryModel>>> getGalleries() {
    return dataSource.getGalleries();
  }

  List<String> getDownloadedImages() {
    return localDataSource.getDownloadedImages();
  }

  Future<void> markImageAsDownloaded(String imageUrl) async {
    await localDataSource.markImageAsDownloaded(imageUrl);
  }

  Future<Either<Failure, bool>> downloadAndSaveImage(String imageUrl) async {
    final result = await dataSource.downloadImage(imageUrl);

    return result.fold(
      (failure) => Left(failure),
      (bytes) async {
        try {
          final saveResult = await ImageGallerySaverPlus.saveImage(
            bytes,
            quality: 100,
            name: 'gallery_${DateTime.now().millisecondsSinceEpoch}',
          );

          final success = saveResult['isSuccess'] == true;
          if (success) {
            await markImageAsDownloaded(imageUrl);
          }
          return Right(success);
        } catch (e) {
          return Left(UnexpectedFailure('حدث خطأ أثناء حفظ الصورة'));
        }
      },
    );
  }
}
