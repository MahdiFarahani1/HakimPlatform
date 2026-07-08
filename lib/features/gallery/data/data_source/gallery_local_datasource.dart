import 'package:get_storage/get_storage.dart';

class GalleryLocalDataSource {
  final GetStorage _storage;
  static const String _storageKey = 'downloaded_gallery_images';

  GalleryLocalDataSource(this._storage);

  List<String> getDownloadedImages() {
    final List<dynamic>? list = _storage.read(_storageKey);
    return list?.cast<String>() ?? [];
  }

  Future<void> markImageAsDownloaded(String imageUrl) async {
    final currentList = getDownloadedImages();
    if (!currentList.contains(imageUrl)) {
      currentList.add(imageUrl);
      await _storage.write(_storageKey, currentList);
    }
  }
}
