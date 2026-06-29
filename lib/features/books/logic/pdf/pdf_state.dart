part of 'pdf_cubit.dart';

abstract class PdfState {}

class PdfInitial extends PdfState {}

class PdfDownloading extends PdfState {
  final double progress;
  PdfDownloading(this.progress);
}

class PdfDownloaded extends PdfState {
  final String filePath;
  PdfDownloaded(this.filePath);
}

class PdfError extends PdfState {
  final String message;
  PdfError(this.message);
}
