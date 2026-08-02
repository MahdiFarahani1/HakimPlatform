import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/dialogue/data/data_source/dialogue_datasource.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';

class DialogueRepository {
  final DialogueDataSource dataSource;

  DialogueRepository(this.dataSource);

  Future<Either<Failure, List<DialogueModel>>> getDialogues({
    int page = 1,
    int perPage = 12,
    String lang = 'ar',
  }) {
    return dataSource.getDialogues(
      page: page,
      perPage: perPage,
      lang: lang,
    );
  }
}
