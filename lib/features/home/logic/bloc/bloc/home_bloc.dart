import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/home/data/models/home_model.dart';
import 'package:flutter_application_1/features/home/data/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchHomeData>(_fetchHomeData);
  }

  Future<void> _fetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());

      final data = await repository.getHomeData();

      emit(HomeLoaded(data: data));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
