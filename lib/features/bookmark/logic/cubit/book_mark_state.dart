import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/news/data/models/news_model.dart';

class BookmarkState extends Equatable {
  final List<NewsModel> savedNews;

  const BookmarkState({required this.savedNews});

  factory BookmarkState.initial() {
    return const BookmarkState(savedNews: []);
  }

  BookmarkState copyWith({List<NewsModel>? savedNews}) {
    return BookmarkState(savedNews: savedNews ?? this.savedNews);
  }

  @override
  List<Object?> get props => [savedNews];
}
