class BookContentModel {
  final int id;
  final String title;
  final String number;
  final String summary;
  final String category;
  final String date;
  final String image;
  final String pdf;
  final String code;

  BookContentModel({
    required this.id,
    required this.title,
    required this.number,
    required this.summary,
    required this.category,
    required this.date,
    required this.image,
    required this.pdf,
    required this.code,
  });

  factory BookContentModel.fromJson(Map<String, dynamic> json) {
    return BookContentModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      number: json['number'] ?? '',
      summary: json['summary'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      image: json['image'] ?? '',
      pdf: json['pdf'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
