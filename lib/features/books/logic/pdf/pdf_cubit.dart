import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  final Dio dio;
  PdfCubit({required this.dio}) : super(PdfInitial());

  Future<String> _getLocalPath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    String getLocalPath(String fileName) => '${directory.path}/$fileName';
    return getLocalPath(fileName);
  }

  Future<void> checkFileExists({required String fileName}) async {
    try {
      final file = File(await _getLocalPath(fileName));

      if (await file.exists()) {
        emit(PdfDownloaded(await _getLocalPath(fileName)));
      } else {
        emit(PdfInitial());
      }
    } catch (e) {
      print('error : $e');

      emit(PdfError("خطا در بررسی وضعیت فایل"));
    }
  }

  Future<void> downloadPdf({
    required String fileName,
    required String url,
  }) async {
    try {
      emit(PdfDownloading(0.0));

      await dio.download(
        "http://ammaralhakeem.com/$url",
        await _getLocalPath(fileName),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = received / total;
            emit(PdfDownloading(progress));
          }
        },
      );

      emit(PdfDownloaded(await _getLocalPath(fileName)));
    } catch (e) {
      print('error : $e');
      emit(PdfError("دانلود با خطا مواجه شد. مجدداً تلاش کنید."));
    }
  }

  Future<void> openPdf() async {
    if (state is PdfDownloaded) {
      final path = (state as PdfDownloaded).filePath;
      final result = await OpenFile.open(path);

      if (result.type != ResultType.done) {
        emit(
          PdfError(
            "امکان باز کردن فایل وجود ندارد. نرم‌افزار مربوطه یافت نشد.",
          ),
        );
      }
    }
  }
}
