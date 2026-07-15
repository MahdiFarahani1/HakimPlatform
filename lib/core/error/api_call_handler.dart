import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/error/failure.dart';

Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on DioException catch (e) {
    return Left(_mapDioException(e));
  } on SocketException {
    return const Left(NetworkFailure());
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}

Failure _mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();

    case DioExceptionType.connectionError:
      return const NetworkFailure();

    case DioExceptionType.badResponse:
      return ServerFailure(
        message: _getServerErrorMessage(e.response?.statusCode),
        statusCode: e.response?.statusCode,
      );

    case DioExceptionType.cancel:
      return const UnexpectedFailure('تم إلغاء الطلب');

    default:
      return const UnexpectedFailure('حدث خطأ أثناء الاتصال بالخادم');
  }
}

String _getServerErrorMessage(int? statusCode) {
  switch (statusCode) {
    case 400:
      return 'طلب غير صالح';
    case 401:
      return 'غير مصرح لك بالوصول';
    case 403:
      return 'الوصول محظور';
    case 404:
      return 'المحتوى غير موجود';
    case 500:
      return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
    case 502:
      return 'خطأ في البوابة';
    case 503:
      return 'الخدمة غير متاحة حالياً';
    default:
      return 'حدث خطأ غير متوقع (${statusCode ?? "غير معروف"})';
  }
}
