import 'package:equatable/equatable.dart';

abstract class GalleryDetailState extends Equatable {
  final List<String> downloadedImages;

  const GalleryDetailState({required this.downloadedImages});

  @override
  List<Object?> get props => [downloadedImages];
}

class GalleryDetailInitial extends GalleryDetailState {
  const GalleryDetailInitial({required super.downloadedImages});
}

class GalleryDetailDownloading extends GalleryDetailState {
  const GalleryDetailDownloading({required super.downloadedImages});
}

class GalleryDetailSuccess extends GalleryDetailState {
  final String message;

  const GalleryDetailSuccess({
    required super.downloadedImages,
    required this.message,
  });

  @override
  List<Object?> get props => [downloadedImages, message];
}

class GalleryDetailFailure extends GalleryDetailState {
  final String error;

  const GalleryDetailFailure({
    required super.downloadedImages,
    required this.error,
  });

  @override
  List<Object?> get props => [downloadedImages, error];
}
