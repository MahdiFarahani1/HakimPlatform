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

      return BookmarkState(savedItems: items);
    } catch (_) {
      return BookmarkState.initial();
    }
  }
}
