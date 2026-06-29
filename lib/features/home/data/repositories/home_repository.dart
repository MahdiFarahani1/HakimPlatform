import 'package:flutter_application_1/features/home/data/data_source/home_data_remote.dart';
import 'package:flutter_application_1/features/home/data/models/home_model.dart';

class HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepository(this.remote);

  Future<HomeData> getHomeData() {
    return remote.getHomeData();
  }
}
