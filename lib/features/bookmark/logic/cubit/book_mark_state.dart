import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/bookmark/data/models/bookmark_model.dart';

class BookmarkState extends Equatable {
  final List<BookmarkItem> savedItems;
  final List<BookmarkItem> filteredItems;
  final String selectedCategory;
  final String searchQuery;

  const BookmarkState({
    required this.savedItems,
    required this.filteredItems,
    this.selectedCategory = 'all',
    this.searchQuery = '',
  });

  factory BookmarkState.initial() {
    return const BookmarkState(
      savedItems: [],
      filteredItems: [],
      selectedCategory: 'all',
      searchQuery: '',
    );
  }

  BookmarkState copyWith({
    List<BookmarkItem>? savedItems,
    List<BookmarkItem>? filteredItems,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return BookmarkState(
      savedItems: savedItems ?? this.savedItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  int getCategoryCount(String category) {
    if (category == 'all') return savedItems.length;
    return savedItems.where((item) => item.category == category).length;
  }

  @override
  List<Object?> get props => [
        savedItems,
        filteredItems,
        selectedCategory,
        searchQuery,
      ];
}
