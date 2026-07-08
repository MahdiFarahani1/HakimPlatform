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

  Future<List<CategoryModel>> getCategories() async {
    return await dataSource.getCategories();
  }

  Future<List<GalleryModel>> getGalleries() async {
    return await dataSource.getGalleries();
  }

  List<String> getDownloadedImages() {
    return localDataSource.getDownloadedImages();
  }

  Future<void> markImageAsDownloaded(String imageUrl) async {
    await localDataSource.markImageAsDownloaded(imageUrl);
  }

  Future<bool> downloadAndSaveImage(String imageUrl) async {
    final bytes = await dataSource.downloadImage(imageUrl);
    
    final result = await ImageGallerySaverPlus.saveImage(
      bytes,
      quality: 100,
      name: 'gallery_${DateTime.now().millisecondsSinceEpoch}',
    );

    final success = result['isSuccess'] == true;
    if (success) {
      await markImageAsDownloaded(imageUrl);
    }
    return success;
  }
}
