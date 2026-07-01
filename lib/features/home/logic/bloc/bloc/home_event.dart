part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeData extends HomeEvent {}

class FetchBooksByCategory extends HomeEvent {
  final String titleSelected;
  const FetchBooksByCategory({required this.titleSelected});
}
