class BookModel {
  final int id;

  final String title;
  final String image;
  final String pdf;
  final String category;
  final String date;
  final String code;
  final String number;

  BookModel({
    required this.id,
    required this.title,
    required this.image,
    required this.pdf,
    required this.category,
    required this.date,
    required this.code,
    required this.number,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      pdf: json['pdf'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      code: json['code'] ?? '',
      number: json['number'] ?? '',
    );
  }
}
