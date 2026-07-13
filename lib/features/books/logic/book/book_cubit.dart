import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/books/data/models/category_book.dart';
import 'package:flutter_application_1/features/books/data/repositories/books_repo.dart';

part 'book_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final BooksRepository repository;

  BooksCubit(this.repository)
    : super(
        const BooksState(
          status: BooksInitialStatus(),
          categoriesSelected: 0,
          allBooks: [],
          filteredBooks: [],
          categories: [],
        ),
      );

  Future<void> getAllBooksData() async {
    emit(state.copyWith(status: const BooksLoadingStatus()));

    final booksResult = await repository.getAllBooks();

    await booksResult.fold(
      (failure) async {
        emit(state.copyWith(status: BooksErrorStatus(failure.message)));
      },
      (books) async {
        final categoriesResult = await repository.getAllCategories();

        categoriesResult.fold(
          (failure) {
            emit(state.copyWith(status: BooksErrorStatus(failure.message)));
          },
          (categories) {
            emit(
              state.copyWith(
                status: const BooksLoadedStatus(),
                allBooks: books,
                filteredBooks: books,
                categories: categories,
                categoriesSelected: 0,
              ),
            );
          },
        );
      },
    );
  }

  void getBooksByCategories(String catId, int categoryIndex) {
    if (state.allBooks.isEmpty) return;

    final filtered = state.allBooks
        .where((book) => book.category == catId)
        .toList();

    emit(
      state.copyWith(
        filteredBooks: filtered,
        categoriesSelected: categoryIndex,
        status: const BooksLoadedStatus(),
      ),
    );
  }

  void showAllBooks() {
    emit(
      state.copyWith(
        filteredBooks: state.allBooks,
        categoriesSelected: 0,
        status: const BooksLoadedStatus(),
      ),
    );
  }
}
