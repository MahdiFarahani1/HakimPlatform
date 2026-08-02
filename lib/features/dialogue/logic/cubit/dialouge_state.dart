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
  final int page;
  final bool fetchMore;
  final bool hasReachedMax;

  const DialougeSuccess(
    this.dialogues, {
    this.page = 1,
    this.fetchMore = false,
    this.hasReachedMax = false,
  });

  DialougeSuccess copyWith({
    List<DialogueModel>? dialogues,
    int? page,
    bool? fetchMore,
    bool? hasReachedMax,
  }) {
    return DialougeSuccess(
      dialogues ?? this.dialogues,
      page: page ?? this.page,
      fetchMore: fetchMore ?? this.fetchMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dialogues, page, fetchMore, hasReachedMax];
}

final class DialougeError extends DialougeState {
  final String message;

  const DialougeError(this.message);

  @override
  List<Object> get props => [message];
}
