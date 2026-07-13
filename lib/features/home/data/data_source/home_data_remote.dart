import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/error/api_call_handler.dart';
import 'package:flutter_application_1/core/error/failure.dart';
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

  Future<Either<Failure, HomeData>> getHomeData() {
    return safeApiCall(() async {
      final responses = await Future.wait([
        dio.get(Api.sliders), 
        dio.get('${Api.news}?per_page=6'), 
        dio.get('${Api.videos}?limit=4'), 
        dio.get('${Api.books}?limit=4'), 
        dio.get('${Api.galleries}?limit=6'), 
        dio.get('${Api.dialogues}?limit=4'), 
        dio.get(Api.bookCategories), 
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
    });
  }

  Future<Either<Failure, List<BookModel>>> getBooksByCategory() {
    return safeApiCall(() async {
      final response = await dio.get(Api.books);
      return (response.data['data'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
    });
  }
}
