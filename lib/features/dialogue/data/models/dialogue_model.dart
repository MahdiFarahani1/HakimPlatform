class DialogueModel {
  final int id;
  final String title;
  final String excerpt;
  final String image;
  final String interviewer;
  final String date;

  DialogueModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.image,
    required this.interviewer,
    required this.date,
  });

  factory DialogueModel.fromJson(Map<String, dynamic> json) {
    return DialogueModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      excerpt: json['excerpt'] ?? '',
      image: json['image'] ?? '',
      interviewer: json['interviewer'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
