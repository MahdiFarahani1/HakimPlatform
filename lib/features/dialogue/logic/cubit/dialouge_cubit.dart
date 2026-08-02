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

    final result = await repository.getDialogues(page: 1, perPage: 12);

    result.fold(
      (failure) => emit(DialougeError(failure.message)),
      (dialogues) => emit(
        DialougeSuccess(
          dialogues,
          page: 1,
          fetchMore: false,
          hasReachedMax: dialogues.length < 12,
        ),
      ),
    );
  }

  Future<void> fetchMoreDialogues() async {
    if (state is! DialougeSuccess) return;
    final currentState = state as DialougeSuccess;

    if (currentState.fetchMore || currentState.hasReachedMax) return;

    emit(currentState.copyWith(fetchMore: true));

    final nextPage = currentState.page + 1;
    final result = await repository.getDialogues(page: nextPage, perPage: 12);

    result.fold(
      (failure) => emit(currentState.copyWith(fetchMore: false)),
      (newDialogues) {
        final updatedList = List<DialogueModel>.from(currentState.dialogues)
          ..addAll(newDialogues);

        emit(
          currentState.copyWith(
            dialogues: updatedList,
            page: nextPage,
            fetchMore: false,
            hasReachedMax: newDialogues.isEmpty || newDialogues.length < 12,
          ),
        );
      },
    );
  }
}
