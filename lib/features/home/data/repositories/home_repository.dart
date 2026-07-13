import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/home/data/data_source/home_data_remote.dart';
import 'package:flutter_application_1/features/home/data/models/home_model.dart';

class HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepository(this.remote);

  Future<Either<Failure, HomeData>> getHomeData() {
    return remote.getHomeData();
  }

  Future<Either<Failure, List<BookModel>>> getBooksByCategory() {
    return remote.getBooksByCategory();
  }
}
