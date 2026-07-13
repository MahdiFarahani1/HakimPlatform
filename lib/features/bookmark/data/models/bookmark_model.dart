import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/news/data/models/news_model.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';

class BookmarkItem {
  final int id;
  final String title;
  final String? intro;
  final String image;
  final String category;
  final String createdAt;

  final Map<String, dynamic> extraData;
  BookmarkItem({
    required this.id,
    required this.title,
    this.intro,
    required this.image,
    required this.category,
    required this.createdAt,
    required this.extraData,
  });

  factory BookmarkItem.fromNews(NewsModel news) {
    return BookmarkItem(
      id: news.id,
      title: news.title,
      intro: news.intro,
      image: news.image,
      category: 'news',

      createdAt: news.createdAt,
      extraData: {'lan': news.languageName},
    );
  }

  factory BookmarkItem.fromBook(BookModel book) {
    return BookmarkItem(
      id: book.id,
      title: book.title,
      intro: book.title,
      image: book.image,
      category: 'book',
      createdAt: book.date,
      extraData: {'pdfUrl': book.pdf},
    );
  }

  factory BookmarkItem.fromVideo(VideoModel video) {
    return BookmarkItem(
      id: video.id,
      title: video.title,
      intro: video.description,
      image: video.image,
      category: 'video',
      createdAt: video.date,
      extraData: {'youtubeId': video.youtubeId},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'intro': intro,
      'image': image,
      'category': category,
      'createdAt': createdAt,
      'extraData': extraData,
    };
  }

  factory BookmarkItem.fromMap(Map<String, dynamic> map) {
    return BookmarkItem(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      intro: map['intro'],
      image: map['image'] ?? '',
      category: map['category'] ?? 'news',
      createdAt: map['createdAt'] ?? '',
      extraData: Map<String, dynamic>.from(map['extraData'] ?? {}),
    );
  }
}
