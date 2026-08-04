import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/search/data/data_source/search_remote_datasource.dart';
import 'package:flutter_application_1/features/search/data/models/search_result_model.dart';

class SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepository(this.remoteDataSource);

  Future<Either<Failure, List<SearchResultModel>>> search(String query) {
    return remoteDataSource.search(query);
  }
}
