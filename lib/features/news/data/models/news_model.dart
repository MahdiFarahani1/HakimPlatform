import 'package:flutter/material.dart';

class NewsModel {
  final int id;
  final String lang;
  final int categoryId;
  final String title;
  final String? intro;
  final String image;
  final String createdAt;

  NewsModel({
    required this.id,
    required this.lang,
    required this.categoryId,
    required this.title,
    this.intro,
    required this.image,
    required this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] is String
          ? int.parse(json['id'])
          : json['id'], 
      lang: json['lang'] ?? '',
      categoryId: json['category_id'] is String
          ? int.parse(json['category_id'])
          : json['category_id'],
      title: json['title'] ?? '',
      intro: json['intro'],
      image: json['file1'] ?? json['image'] ?? '', 
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lang': lang,
      'category_id': categoryId,
      'title': title,
      'intro': intro,
      'file1': image,
      'created_at': createdAt,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'] ?? 0,
      lang: map['lang'] ?? '',
      categoryId: map['category_id'] ?? 0,
      title: map['title'] ?? '',
      intro: map['intro'],
      image: map['file1'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  String get languageName {
    switch (lang) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'ku':
        return 'كوردی';
      default:
        return lang;
    }
  }

  Color get languageColor {
    switch (lang) {
      case 'ar':
        return const Color(0xFF10B981);
      case 'en':
        return const Color(0xFF3B82F6);
      case 'ku':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }
}
