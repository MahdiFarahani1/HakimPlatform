part of 'about_cubit.dart';

class AboutState {
  AboutApiState apiState;
  bool isAr;
  AboutState({required this.apiState, required this.isAr});

  AboutState copyWith({AboutApiState? apiState, bool? isAr}) {
    return AboutState(
      apiState: apiState ?? this.apiState,
      isAr: isAr ?? this.isAr,
    );
  }
}

abstract class AboutApiState {}

class AboutInitial extends AboutApiState {}

class AboutLoading extends AboutApiState {}

class AboutLoaded extends AboutApiState {
  final AboutModel aboutData;
  AboutLoaded(this.aboutData);
}

class AboutError extends AboutApiState {
  final String message;
  AboutError(this.message);
}
