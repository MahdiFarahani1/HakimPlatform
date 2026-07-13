import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/books/data/data_source/books_datasource.dart';
import 'package:flutter_application_1/features/books/data/models/book_content_model.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/books/data/models/category_book.dart';

class BooksRepository {
  final BooksRemoteDataSource remoteDataSource;

  BooksRepository(this.remoteDataSource);

  Future<Either<Failure, List<BookModel>>> getAllBooks() {
    return remoteDataSource.getAllBooksData();
  }

  Future<Either<Failure, List<BookCategoryModel>>> getAllCategories() {
    return remoteDataSource.getBooksCategoryData();
  }

  Future<Either<Failure, BookContentModel>> getDetailsBooks({
    required int bookId,
  }) {
    return remoteDataSource.getBookDetail(bookId);
  }
}
