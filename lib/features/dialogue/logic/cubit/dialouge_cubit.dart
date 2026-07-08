import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';
import 'package:flutter_application_1/features/dialogue/data/repositories/dialogue_repository.dart';

part 'dialouge_state.dart';

class DialougeCubit extends Cubit<DialougeState> {
  final DialogueRepository repository;

  DialougeCubit(this.repository) : super(DialougeInitial());

  Future<void> fetchDialogues() async {
    emit(DialougeLoading());
    try {
      final dialogues = await repository.getDialogues();
      emit(DialougeSuccess(dialogues));
    } catch (e) {
      emit(DialougeError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
