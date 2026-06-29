import 'package:flutter_application_1/features/gallery/data/data_source/gallery_remote_datasource.dart';
import 'package:flutter_application_1/features/gallery/data/models/category_gallery_model.dart';
import 'package:flutter_application_1/features/gallery/data/models/gallery_model.dart';

class GalleryRepository {
  final GalleryDataSource dataSource;
  GalleryRepository(this.dataSource);
  Future<List<CategoryModel>> getCategories() async {
    return await dataSource.getCategories();
  }

  Future<List<GalleryModel>> getGalleries() async {
    return await dataSource.getGalleries();
  }
}
