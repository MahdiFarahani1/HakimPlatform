part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final HomeData data;
  final bool isBooksLoading;
  const HomeLoaded({required this.data, this.isBooksLoading = false});
  @override
  List<Object> get props => [data, isBooksLoading];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
