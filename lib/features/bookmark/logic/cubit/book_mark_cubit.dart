import 'package:flutter_application_1/features/bookmark/data/models/bookmark_model.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class BookmarkCubit extends HydratedCubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkState.initial());

  void toggleBookmark(BookmarkItem bookmarkItem) {
    final isExist = state.savedItems.any(
      (item) =>
          item.id == bookmarkItem.id && item.category == bookmarkItem.category,
    );

    List<BookmarkItem> updatedList;
    if (isExist) {
      updatedList = state.savedItems
          .where(
            (item) =>
                !(item.id == bookmarkItem.id &&
                    item.category == bookmarkItem.category),
          )
          .toList();
    } else {
      updatedList = [...state.savedItems, bookmarkItem];
    }

    emit(state.copyWith(savedItems: updatedList));
    _applyFilters();
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
    _applyFilters();
  }

  void _applyFilters() {
    final selectedCategory = state.selectedCategory;
    final searchQuery = state.searchQuery;

    final filtered = state.savedItems.where((item) {
      final matchesCategory =
          selectedCategory == 'all' || item.category == selectedCategory;

      final matchesSearch = searchQuery.isEmpty ||
          item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (item.intro?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false);

      return matchesCategory && matchesSearch;
    }).toList();

    emit(state.copyWith(filteredItems: filtered));
  }

  @override
  Map<String, dynamic>? toJson(BookmarkState state) {
    return {'items': state.savedItems.map((e) => e.toMap()).toList()};
  }

  @override
  BookmarkState? fromJson(Map<String, dynamic> json) {
    try {
      final itemsJson = json['items'] as List?;
      final items =
          itemsJson?.map((e) => BookmarkItem.fromMap(e)).toList() ?? [];

      return BookmarkState(savedItems: items, filteredItems: items);
    } catch (_) {
      return BookmarkState.initial();
    }
  }
}
