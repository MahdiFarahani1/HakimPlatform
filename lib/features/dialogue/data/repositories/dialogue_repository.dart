import 'package:flutter_application_1/features/dialogue/data/data_source/dialogue_datasource.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';

class DialogueRepository {
  final DialogueDataSource dataSource;

  DialogueRepository(this.dataSource);

  Future<List<DialogueModel>> getDialogues() async {
    return await dataSource.getDialogues();
  }
}
