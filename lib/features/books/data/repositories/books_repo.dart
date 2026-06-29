// lib/features/news/data/repositories/news_repository.dart
import 'package:flutter_application_1/features/books/data/data_source/books_datasource.dart';
import 'package:flutter_application_1/features/books/data/models/book_content_model.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/books/data/models/category_book.dart';

class BooksRepository {
  final BooksRemoteDataSource remoteDataSource;

  BooksRepository(this.remoteDataSource);

  Future<List<BookModel>> getAllBooks() async {
    return await remoteDataSource.getAllBooksData();
  }

  Future<List<BookCategoryModel>> getAllCategories() async {
    return await remoteDataSource.getBooksCategoryData();
  }

  Future<BookContentModel> getDetailsBooks({required int bookId}) async {
    return await remoteDataSource.getBookDetail(bookId);
  }
}
