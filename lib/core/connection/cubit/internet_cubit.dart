import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ================= STATE =================
enum InternetState { initial, connected, disconnected }

// ================= CUBIT =================
class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetCubit() : super(InternetState.initial) {
    _monitorConnectivity();
  }

  void _monitorConnectivity() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // در نسخه‌های جدید connectivity_plus خروجی یک لیست است
      if (results.contains(ConnectivityResult.none)) {
        emit(InternetState.disconnected);
      } else {
        emit(InternetState.connected);
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
