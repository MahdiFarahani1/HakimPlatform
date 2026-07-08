import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';

class DialogueDataSource {
  final Dio dioClient;

  DialogueDataSource(this.dioClient);

  Future<List<DialogueModel>> getDialogues() async {
    try {
      final response = await dioClient.get(Api.dialogues);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => DialogueModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
