import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/history/data/models/history_type.dart';
import 'package:flutter_application_1/features/news/data/models/news_detail.dart';
import 'package:flutter_application_1/features/sounds/data/models/song.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';

class HistoryItem {
  final int id;
  final HistoryType type;
  final String title;
  final String image;
  final String openedAt;
  final Map<String, dynamic> extraData;

  const HistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.image,
    required this.openedAt,
    this.extraData = const {},
  });

  String get uniqueKey => '${type.name}_$id';

  factory HistoryItem.fromNewsDetail(NewsDetailModel news) {
    return HistoryItem(
      id: news.id,
      type: HistoryType.news,
      title: news.title,
      image: news.image,
      openedAt: DateTime.now().toIso8601String(),
      extraData: {'newsId': news.id},
    );
  }

  factory HistoryItem.fromBook(BookModel book) {
    return HistoryItem(
      id: book.id,
      type: HistoryType.book,
      title: book.title,
      image: book.image,
      openedAt: DateTime.now().toIso8601String(),
      extraData: {'pdfUrl': book.pdf},
    );
  }

  factory HistoryItem.fromVideo(VideoModel video) {
    return HistoryItem(
      id: video.id,
      type: HistoryType.video,
      title: video.title,
      image: video.image,
      openedAt: DateTime.now().toIso8601String(),
      extraData: {'youtubeId': video.youtubeId},
    );
  }

  factory HistoryItem.fromSong(Song song) {
    return HistoryItem(
      id: int.tryParse(song.id) ?? song.id.hashCode,
      type: HistoryType.audio,
      title: song.title,
      image: song.coverUrl,
      openedAt: DateTime.now().toIso8601String(),
      extraData: {
        'songId': song.id,
        'artist': song.artist,
        'audioUrl': song.audioUrl,
      },
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'image': image,
      'openedAt': openedAt,
      'extraData': extraData,
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] ?? 0,
      type: HistoryType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => HistoryType.news,
      ),
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      openedAt: map['openedAt'] ?? '',
      extraData: Map<String, dynamic>.from(map['extraData'] ?? {}),
    );
  }
}
