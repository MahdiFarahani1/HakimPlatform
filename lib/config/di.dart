import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/features/books/data/data_source/books_datasource.dart';
import 'package:flutter_application_1/features/books/data/repositories/books_repo.dart';
import 'package:flutter_application_1/features/books/logic/book/book_cubit.dart';
import 'package:flutter_application_1/features/books/logic/pdf/pdf_cubit.dart';
import 'package:flutter_application_1/features/gallery/data/data_source/gallery_remote_datasource.dart';
import 'package:flutter_application_1/features/gallery/data/repositories/gallery_repo.dart';
import 'package:flutter_application_1/features/gallery/logic/cubit/gallery_cubit.dart';
import 'package:flutter_application_1/features/home/data/data_source/home_data_remote.dart';
import 'package:flutter_application_1/features/home/data/repositories/home_repository.dart';
import 'package:flutter_application_1/features/news/data/data_source/remote_news_data.dart';
import 'package:flutter_application_1/features/news/data/repositories/news_repo.dart';
import 'package:flutter_application_1/features/news/logic/all-news/news_cubit.dart';
import 'package:flutter_application_1/features/videos/data/data_source/remote_datasource_videos.dart';
import 'package:flutter_application_1/features/videos/data/repositories/repo_videos.dart';
import 'package:flutter_application_1/features/videos/logic/cubit/videos_cubit.dart';
import 'package:flutter_application_1/features/wrapper/data/data_source/about_datasource.dart';
import 'package:flutter_application_1/features/wrapper/logic/cubit/about_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  // Services
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: Api.baseUrl));

    dio.interceptors.addAll([if (kDebugMode) _prettyLogger, _errorHandler]);

    return dio;
  });

  // Home Feature
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(getIt()),
  );

  getIt.registerLazySingleton<HomeRepository>(() => HomeRepository(getIt()));

  // Videos Feature
  getIt.registerLazySingleton<VideosRemoteDataSource>(
    () => VideosRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<VideosRepository>(
    () => VideosRepository(getIt()),
  );
  getIt.registerFactory<VideosCubit>(() => VideosCubit(getIt()));

  // News Feature
  getIt.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<NewsRepository>(() => NewsRepository(getIt()));
  getIt.registerFactory<NewsCubit>(() => NewsCubit(getIt()));

  // About
  getIt.registerLazySingleton<AboutDatasourceRemote>(
    () => AboutDatasourceRemote(getIt()),
  );
  getIt.registerFactory<AboutCubit>(() => AboutCubit(getIt()));

  // Gallery

  getIt.registerLazySingleton<GalleryDataSource>(
    () => GalleryDataSource(getIt()),
  );
  getIt.registerLazySingleton<GalleryRepository>(
    () => GalleryRepository(getIt()),
  );
  getIt.registerFactory<GalleryCubit>(() => GalleryCubit(getIt()));
  // Books
  getIt.registerLazySingleton<BooksRemoteDataSource>(
    () => BooksRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<BooksRepository>(
    () => BooksRepository(getIt<BooksRemoteDataSource>()),
  );

  getIt.registerFactory<BooksCubit>(() => BooksCubit(getIt<BooksRepository>()));
  getIt.registerFactory<PdfCubit>(() => PdfCubit(dio: getIt<Dio>()));
}

Interceptor get _prettyLogger => PrettyDioLogger(
  request: true,
  requestHeader: true,
  requestBody: true,
  responseHeader: false,
  responseBody: true,
  error: true,
  compact: true,
  maxWidth: 90,
  logPrint: (object) => debugPrint(object?.toString()),
);

Interceptor get _errorHandler => InterceptorsWrapper(
  onError: (error, handler) {
    if (kDebugMode) {
      debugPrint('❌ Dio Error: ${error.message}');
      debugPrint('📡 Status: ${error.response?.statusCode}');
    }
    return handler.next(error);
  },
);
