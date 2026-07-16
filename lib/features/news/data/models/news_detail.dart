class NewsDetailModel {
  final int id;
  final String title;
  final String summary;
  final String content;
  final String image;
  final String imgTitle;
  final String category;
  final String date;
  final List<String> moreImages;

  const NewsDetailModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.image,
    required this.imgTitle,
    required this.category,
    required this.date,
    required this.moreImages,
  });

  factory NewsDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    List<String> moreImagesList = [];
    if (data['more_images'] != null && data['more_images'] is List) {
      moreImagesList = List<String>.from(data['more_images']);
    }

    return NewsDetailModel(
      id: data['id'] as int,
      title: data['title'] as String,
      summary: data['summary'] as String? ?? '',
      content: data['content'] as String,
      image: data['image'] as String,
      imgTitle: data['img_title'] as String? ?? '',
      category: data['category'] as String,
      date: data['date'] as String,
      moreImages: moreImagesList,
    );
  }

  bool get hasMoreImages => moreImages.isNotEmpty;
}
