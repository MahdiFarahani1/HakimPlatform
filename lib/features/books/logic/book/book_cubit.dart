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
    try {
      emit(state.copyWith(status: const BooksLoadingStatus()));

      final books = await repository.getAllBooks();
      final categories = await repository.getAllCategories();

      emit(
        state.copyWith(
          status: const BooksLoadedStatus(),
          allBooks: books,
          filteredBooks: books,
          categories: categories,
          categoriesSelected: 0,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BooksErrorStatus(e.toString())));
    }
  }

  // فیلتر کردن بر اساس دسته‌بندی
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
