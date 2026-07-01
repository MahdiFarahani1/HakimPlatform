import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/books/data/models/category_book.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';
import 'package:flutter_application_1/features/gallery/data/models/gallery_model.dart';
import 'package:flutter_application_1/features/home/data/models/slider_model.dart';
import 'package:flutter_application_1/features/news/data/models/news_home_model.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';

class HomeData {
  final List<SliderModel> sliders;
  final List<NewsHomeModel> news;
  final List<VideoModel> videos;
  final List<BookModel> books;
  final List<GalleryModel> galleries;
  final List<DialogueModel> dialogues;
  final List<BookCategoryModel> bookCategories;

  const HomeData({
    required this.sliders,
    required this.news,
    required this.videos,
    required this.books,
    required this.galleries,
    required this.dialogues,
    required this.bookCategories,
  });

  HomeData copyWith({
    List<SliderModel>? sliders,
    List<NewsHomeModel>? news,
    List<VideoModel>? videos,
    List<BookModel>? books,
    List<GalleryModel>? galleries,
    List<DialogueModel>? dialogues,
    List<BookCategoryModel>? bookCategories,
  }) {
    return HomeData(
      sliders: sliders ?? this.sliders,
      news: news ?? this.news,
      videos: videos ?? this.videos,
      books: books ?? this.books,
      galleries: galleries ?? this.galleries,
      dialogues: dialogues ?? this.dialogues,
      bookCategories: bookCategories ?? this.bookCategories,
    );
  }
}
