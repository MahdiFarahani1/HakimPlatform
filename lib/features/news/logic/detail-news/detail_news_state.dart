part of 'detail_news_cubit.dart';

abstract class NewsDetailState extends Equatable {
  const NewsDetailState();

  @override
  List<Object?> get props => [];
}

class NewsDetailInitial extends NewsDetailState {}

class NewsDetailLoading extends NewsDetailState {}

class NewsDetailSuccess extends NewsDetailState {
  final NewsDetailModel newsDetail;

  const NewsDetailSuccess(this.newsDetail);

  @override
  List<Object?> get props => [newsDetail];
}

class NewsDetailError extends NewsDetailState {
  final String message;

  const NewsDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
