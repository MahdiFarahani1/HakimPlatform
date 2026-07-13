import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/error/api_call_handler.dart';
import 'package:flutter_application_1/core/error/failure.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';

class DialogueDataSource {
  final Dio dioClient;

  DialogueDataSource(this.dioClient);

  Future<Either<Failure, List<DialogueModel>>> getDialogues() {
    return safeApiCall(() async {
      final response = await dioClient.get(Api.dialogues);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => DialogueModel.fromJson(e)).toList();
    });
  }
}
