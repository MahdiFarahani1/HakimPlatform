class VideoCategoryModel {
  final int id;
  final String title;

  VideoCategoryModel({required this.id, required this.title});

  factory VideoCategoryModel.fromJson(Map<String, dynamic> json) {
    return VideoCategoryModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}
