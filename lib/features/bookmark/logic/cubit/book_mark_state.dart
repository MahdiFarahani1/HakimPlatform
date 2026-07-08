import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/bookmark/data/models/bookmark_model.dart';

class BookmarkState extends Equatable {
  final List<BookmarkItem> savedItems;

  const BookmarkState({required this.savedItems});

  factory BookmarkState.initial() {
    return const BookmarkState(savedItems: []);
  }

  BookmarkState copyWith({List<BookmarkItem>? savedItems}) {
    return BookmarkState(savedItems: savedItems ?? this.savedItems);
  }

  @override
  List<Object?> get props => [savedItems];
}
