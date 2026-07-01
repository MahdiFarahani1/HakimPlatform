import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class NavigationCubit extends Cubit<int> {
  PageController pageController = PageController();

  NavigationCubit() : super(0);

  void changeNavState(int value) => emit(value);
}
