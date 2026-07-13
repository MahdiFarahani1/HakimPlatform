import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/error/api_call_handler.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/books/data/models/book_content_model.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/books/data/models/category_book.dart';

class BooksRemoteDataSource {
  final Dio dio;

  BooksRemoteDataSource(this.dio);

  Future<Either<Failure, List<BookModel>>> getAllBooksData() {
    return safeApiCall(() async {
      final response = await dio.get(Api.books);
      return (response.data['data'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
    });
  }

  Future<Either<Failure, List<BookCategoryModel>>> getBooksCategoryData() {
    return safeApiCall(() async {
      final response = await dio.get(Api.bookCategories);
      return (response.data['data'] as List)
          .map((e) => BookCategoryModel.fromJson(e))
          .toList();
    });
  }

  Future<Either<Failure, BookContentModel>> getBookDetail(int bookId) {
    return safeApiCall(() async {
      final response = await dio.get(Api.bookDetails(bookId));
      final Map<String, dynamic> jsonResponse = response.data;
      return BookContentModel.fromJson(jsonResponse);
    });
  }
}
