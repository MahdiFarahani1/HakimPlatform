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
    emit(HomeLoading());

    final result = await repository.getHomeData();

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeLoaded(data: data)),
    );
  }

  Future<void> _booksDataByCategory(
    FetchBooksByCategory event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;

    if (currentState is HomeLoaded) {
      emit(HomeLoaded(
        data: currentState.data,
        isBooksLoading: true,
      ));

      final result = await repository.getBooksByCategory();

      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (books) {
          final List<BookModel> filteredBooks = books
              .where((element) => element.category == event.titleSelected)
              .toList();

          emit(HomeLoaded(
            data: currentState.data.copyWith(books: filteredBooks),
            isBooksLoading: false,
          ));
        },
      );
    }
  }
}
