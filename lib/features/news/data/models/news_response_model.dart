// lib/features/news/data/models/news_response_model.dart
import 'package:flutter_application_1/features/news/data/models/news_model.dart';

class NewsResponseModel {
  final List<NewsModel> data;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  NewsResponseModel({
    required this.data,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsResponseModel(
      data: (json['data'] as List)
          .map((item) => NewsModel.fromJson(item))
          .toList(),
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}
