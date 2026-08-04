import 'package:flutter_application_1/core/utils/html_parser.dart';

class SearchResultModel {
  final int id;
  final String title;
  final String type;
  final String date;
  final String description;
  final String link;
  final String rawDate;

  SearchResultModel({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.description,
    required this.link,
    required this.rawDate,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      rawDate: json['raw_date'] ?? '',
    );
  }

  String get cleanDescription {
    if (description.isEmpty) return '';
    final text = htmlToText(description);
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
