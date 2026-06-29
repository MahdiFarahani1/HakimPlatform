class NewsHomeModel {
  final int id;
  final String title;
  final String excerpt;
  final String image;
  final String category;
  final String date;

  NewsHomeModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.image,
    required this.category,
    required this.date,
  });

  factory NewsHomeModel.fromJson(Map<String, dynamic> json) {
    return NewsHomeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      excerpt: json['excerpt'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
