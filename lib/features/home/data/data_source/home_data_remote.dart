import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/books/data/models/category_book.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';
import 'package:flutter_application_1/features/gallery/data/models/gallery_model.dart';
import 'package:flutter_application_1/features/home/data/models/home_model.dart';
import 'package:flutter_application_1/features/home/data/models/slider_model.dart';
import 'package:flutter_application_1/features/news/data/models/news_home_model.dart';
import 'package:flutter_application_1/features/videos/data/models/video_model.dart';

class HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSource(this.dio);
  Future<HomeData> getHomeData() async {
    try {
      final responses = await Future.wait([
        dio.get(Api.sliders), // 0
        dio.get('${Api.news}?per_page=6'), // 1
        dio.get('${Api.videos}?limit=4'), // 3
        dio.get('${Api.books}?limit=4'), // 4
        dio.get('${Api.galleries}?limit=6'), // 5
        dio.get('${Api.dialogues}?limit=4'), // 6
        dio.get(Api.bookCategories), // 7
      ]);

      return HomeData(
        sliders: (responses[0].data['data'] as List)
            .map((e) => SliderModel.fromJson(e))
            .toList(),

        news: (responses[1].data['data'] as List)
            .map((e) => NewsHomeModel.fromJson(e))
            .toList(),

        videos: (responses[2].data['data'] as List)
            .map((e) => VideoModel.fromJson(e))
            .toList(),

        books: (responses[3].data['data'] as List)
            .map((e) => BookModel.fromJson(e))
            .toList(),

        galleries: (responses[4].data['data'] as List)
            .map((e) => GalleryModel.fromJson(e))
            .toList(),

        dialogues: (responses[5].data['data'] as List)
            .map((e) => DialogueModel.fromJson(e))
            .toList(),

        bookCategories: (responses[6].data['data'] as List)
            .map((e) => BookCategoryModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookModel>> getBooksByCategory() async {
    try {
      final response = await dio.get(Api.books);
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((e) => BookModel.fromJson(e))
            .toList();
      }
      throw Exception('Failed to load books :: status code != 200');
    } catch (e) {
      throw Exception('$e');
    }
  }
}
