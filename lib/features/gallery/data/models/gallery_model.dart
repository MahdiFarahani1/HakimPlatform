class GalleryModel {
  final int id;
  final String title;
  final String category;
  final String date;
  final String image;
  final List<String> images;
  final String size;

  GalleryModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.image,
    required this.images,
    required this.size,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      image: json['image'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      size: json['size'] ?? '',
    );
  }
}
