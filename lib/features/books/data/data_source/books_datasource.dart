import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/features/books/data/models/book_content_model.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/books/data/models/category_book.dart';

class BooksRemoteDataSource {
  final Dio dio;

  BooksRemoteDataSource(this.dio);
  Future<List<BookModel>> getAllBooksData() async {
    try {
      final response = await dio.get(Api.books);
      return (response.data['data'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookCategoryModel>> getBooksCategoryData() async {
    try {
      final response = await dio.get(Api.bookCategories);
      return (response.data['data'] as List)
          .map((e) => BookCategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<BookContentModel> getBookDetail(int bookId) async {
    try {
      final response = await dio.get(Api.bookDetails(bookId));
      final Map<String, dynamic> jsonResponse = response.data;

      return BookContentModel.fromJson(jsonResponse);
    } catch (e) {
      rethrow;
    }
  }
}
