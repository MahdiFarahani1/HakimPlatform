import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/home/data/models/home_model.dart';
import 'package:flutter_application_1/features/home/data/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchHomeData>(_fetchHomeData);
    on<FetchBooksByCategory>(_booksDataByCategory);
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

  Future<void> _booksDataByCategory(
    FetchBooksByCategory event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;

      if (currentState is HomeLoaded) {
        emit(HomeLoaded(
          data: currentState.data,
          isBooksLoading: true,
        ));

        final books = await repository.getBooksByCategory();
        final List<BookModel> fillterBooks = books
            .where((element) => element.category == event.titleSelected)
            .toList();
        print('fillter List Books =$fillterBooks ');
        emit(HomeLoaded(
          data: currentState.data.copyWith(books: fillterBooks),
          isBooksLoading: false,
        ));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
