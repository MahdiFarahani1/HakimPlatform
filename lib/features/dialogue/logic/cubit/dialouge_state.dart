part of 'dialouge_cubit.dart';

sealed class DialougeState extends Equatable {
  const DialougeState();

  @override
  List<Object> get props => [];
}

final class DialougeInitial extends DialougeState {}

final class DialougeLoading extends DialougeState {}

final class DialougeSuccess extends DialougeState {
  final List<DialogueModel> dialogues;

  const DialougeSuccess(this.dialogues);

  @override
  List<Object> get props => [dialogues];
}

final class DialougeError extends DialougeState {
  final String message;

  const DialougeError(this.message);

  @override
  List<Object> get props => [message];
}
