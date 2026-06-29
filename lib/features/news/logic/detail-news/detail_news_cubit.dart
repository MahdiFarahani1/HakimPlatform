// lib/features/news/logic/cubit/news_detail_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/news/data/models/news_detail.dart';
import 'package:flutter_application_1/features/news/data/repositories/news_repo.dart';

part 'detail_news_state.dart';

class NewsDetailCubit extends Cubit<NewsDetailState> {
  final NewsRepository repository;

  NewsDetailCubit(this.repository) : super(NewsDetailInitial());

  // متد دریافت جزئیات خبر
  Future<void> fetchNewsDetail({required int postId}) async {
    try {
      // اگر حالت قبلی Error هست، باز هم emit Loading می‌کنیم
      if (state is! NewsDetailLoading) {
        emit(NewsDetailLoading());
      }

      final newsDetail = await repository.getDetailsNews(postId: postId);
      emit(NewsDetailSuccess(newsDetail));
    } catch (error) {
      emit(NewsDetailError(_getErrorMessage(error)));
    }
  }

  // متد برای ریست کردن وضعیت (مثلاً وقتی صفحه بسته می‌شه)
  void reset() {
    if (state is! NewsDetailInitial) {
      emit(NewsDetailInitial());
    }
  }

  // متد کمکی برای دریافت پیام خطای کاربرپسند
  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'يرجى التحقق من اتصال الإنترنت';
    } else if (errorString.contains('timeout')) {
      return 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
    } else if (errorString.contains('404')) {
      return 'الخبر غير موجود';
    } else if (errorString.contains('500')) {
      return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
    } else {
      return 'حدث خطأ أثناء تحميل الخبر';
    }
  }
}
