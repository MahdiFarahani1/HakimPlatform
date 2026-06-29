class BookCategoryModel {
  final int id;
  final String title;

  BookCategoryModel({required this.id, required this.title});

  factory BookCategoryModel.fromJson(Map<String, dynamic> json) {
    return BookCategoryModel(id: json['id'] ?? 0, title: json['title'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}
