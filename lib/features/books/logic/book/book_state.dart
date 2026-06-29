part of 'book_cubit.dart';

// وضعیت‌های مربوط به بخش‌های مختلف را از هم جدا کردیم
abstract class BooksUIStatus {
  const BooksUIStatus();
}

class BooksInitialStatus extends BooksUIStatus {
  const BooksInitialStatus();
}

class BooksLoadingStatus extends BooksUIStatus {
  const BooksLoadingStatus();
}

class BooksLoadedStatus extends BooksUIStatus {
  const BooksLoadedStatus();
}

class BooksErrorStatus extends BooksUIStatus {
  final String message;
  const BooksErrorStatus(this.message);
}

abstract class BookDetailStatus {
  const BookDetailStatus();
}

class BookDetailInitialStatus extends BookDetailStatus {
  const BookDetailInitialStatus();
}

class BookDetailLoadingStatus extends BookDetailStatus {
  const BookDetailLoadingStatus();
}

class BookDetailLoadedStatus extends BookDetailStatus {
  final dynamic detail;
  const BookDetailLoadedStatus({required this.detail});
}

class BookDetailErrorStatus extends BookDetailStatus {
  final String message;
  const BookDetailErrorStatus(this.message);
}

class BooksState {
  final BooksUIStatus status;
  final BookDetailStatus detailStatus;
  final int categoriesSelected;
  final List<BookModel> allBooks;
  final List<BookModel> filteredBooks;
  final List<BookCategoryModel> categories;

  const BooksState({
    required this.status,
    this.detailStatus = const BookDetailInitialStatus(),
    required this.categoriesSelected,
    required this.allBooks,
    required this.filteredBooks,
    required this.categories,
  });

  const BooksState.initial()
    : status = const BooksInitialStatus(),
      detailStatus = const BookDetailInitialStatus(),
      categoriesSelected = 0,
      allBooks = const [],
      filteredBooks = const [],
      categories = const [];

  BooksState copyWith({
    BooksUIStatus? status,
    BookDetailStatus? detailStatus,
    int? categoriesSelected,
    List<BookModel>? allBooks,
    List<BookModel>? filteredBooks,
    List<BookCategoryModel>? categories,
  }) {
    return BooksState(
      status: status ?? this.status,
      detailStatus: detailStatus ?? this.detailStatus,
      categoriesSelected: categoriesSelected ?? this.categoriesSelected,
      allBooks: allBooks ?? this.allBooks,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      categories: categories ?? this.categories,
    );
  }
}
