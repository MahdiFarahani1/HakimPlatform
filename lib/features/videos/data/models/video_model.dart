class VideoModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String duration;
  final String youtubeId;
  final String category;
  final String date;
  final String views;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.youtubeId,
    required this.category,
    required this.date,
    required this.views,
    required this.duration,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      youtubeId: json['youtubeId'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      views: json['duration'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
}
