import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/features/wrapper/data/data_source/about_datasource.dart';
import 'package:flutter_application_1/features/wrapper/data/models/about_model.dart';

part 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  final AboutDatasourceRemote _apiService;

  AboutCubit(this._apiService)
    : super(AboutState(apiState: AboutLoading(), isAr: true));

  Future<void> fetchAboutInfo() async {
    emit(state.copyWith(apiState: AboutLoading()));

    final result = await _apiService.fetchAboutInfo();

    result.fold(
      (failure) => emit(state.copyWith(apiState: AboutError(failure.message))),
      (aboutData) => emit(state.copyWith(apiState: AboutLoaded(aboutData))),
    );
  }

  void changeLanguage(bool val) {
    emit(state.copyWith(isAr: val));

    if (state.apiState is AboutLoaded) {
      _reloadWithNewLanguage();
    }
  }

  Future<void> _reloadWithNewLanguage() async {
    emit(state.copyWith(apiState: AboutLoading()));

    final result = await _apiService.fetchAboutInfo();

    result.fold(
      (failure) => emit(state.copyWith(apiState: AboutError(failure.message))),
      (aboutData) => emit(state.copyWith(apiState: AboutLoaded(aboutData))),
    );
  }

  Future<void> refresh() async {
    await fetchAboutInfo();
  }
}
