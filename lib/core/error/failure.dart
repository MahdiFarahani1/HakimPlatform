import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required String message, this.statusCode})
    : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure()
    : super('يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى');
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'حدث خطأ غير متوقع']);
}
