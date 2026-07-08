import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/core/widgets/snackbar_common.dart';
import 'package:flutter_application_1/features/gallery/data/models/gallery_model.dart';
import 'package:flutter_application_1/features/gallery/logic/gallery_detail_cubit/gallery_detail_cubit.dart';
import 'package:flutter_application_1/features/gallery/logic/gallery_detail_cubit/gallery_detail_state.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class GalleryDetailScreen extends StatelessWidget {
  final GalleryModel gallery;

  const GalleryDetailScreen({super.key, required this.gallery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GalleryDetailCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                gallery.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1A1A1A),
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: context.appTheme.scaffoldGradient,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                      top: 16,
                      bottom: 10,
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        _buildModernChip(
                          icon: Assets.icons.category.path,
                          label: gallery.category,
                          backgroundColor: AppColor.primaryOrange.withOpacity(
                            0.1,
                          ),
                          contentColor: AppColor.primaryOrange,
                        ),
                        _buildModernChip(
                          icon: Assets.icons.calendar.path,
                          label: gallery.date,
                          backgroundColor: AppColor.primaryBlue.withOpacity(
                            0.1,
                          ),
                          contentColor: AppColor.primaryBlue,
                        ),
                        _buildModernChip(
                          icon: Assets.icons.images.path,
                          label: '${gallery.images.length} تصویر',
                          backgroundColor: Colors.red.withOpacity(0.1),
                          contentColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: gallery.images.length,
                      itemBuilder: (context, index) {
                        final imageUrl = gallery.images[index];
                        return GestureDetector(
                          onTap: () => _showFullImageGallery(
                            context,
                            gallery.images,
                            index,
                          ),
                          child: Hero(
                            tag: 'gallery_image_$index',
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CustomCacheImage(
                                  imageUrl: 'http://ammaralhakeem.com$imageUrl',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernChip({
    required String icon,
    required String label,
    required Color backgroundColor,
    required Color contentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: 14.5, height: 14.5, color: contentColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImageGallery(
    BuildContext context,
    List<String> images,
    int initialIndex,
  ) {
    final PageController pageController = PageController(
      initialPage: initialIndex,
    );

    final ValueNotifier<int> currentPage = ValueNotifier<int>(initialIndex);
    final galleryCubit = BlocProvider.of<GalleryDetailCubit>(context);

    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.95),
        pageBuilder: (routeContext, _, __) => BlocProvider.value(
          value: galleryCubit,
          child: BlocListener<GalleryDetailCubit, GalleryDetailState>(
            listener: (context, state) {
              if (state is GalleryDetailSuccess) {
                AppSnackBar.success(context, state.message);
              } else if (state is GalleryDetailFailure) {
                AppSnackBar.error(context, state.error);
              }
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                title: ValueListenableBuilder<int>(
                  valueListenable: currentPage,
                  builder: (context, value, child) {
                    return Text(
                      '${value + 1} از ${images.length}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(routeContext),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  ValueListenableBuilder<int>(
                    valueListenable: currentPage,
                    builder: (context, pageIndex, _) {
                      final currentUrl = images[pageIndex];
                      return BlocBuilder<
                        GalleryDetailCubit,
                        GalleryDetailState
                      >(
                        builder: (context, state) {
                          final isAlreadyDownloaded = state.downloadedImages
                              .contains(currentUrl);
                          final isDownloading =
                              state is GalleryDetailDownloading;

                          return IconButton(
                            onPressed: (isDownloading || isAlreadyDownloaded)
                                ? null
                                : () => context
                                      .read<GalleryDetailCubit>()
                                      .downloadImage(currentUrl),
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isAlreadyDownloaded
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              // استفاده از AnimatedSwitcher برای متحرک‌سازی جابه‌جایی فرزندان
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                // انیمیشن پیش‌فرض FadeTransition است، اما می‌توانید مقیاس آن را هم انیمیت کنید:
                                transitionBuilder:
                                    (
                                      Widget child,
                                      Animation<double> animation,
                                    ) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                // نکته کلیدی: هر فرزند باید یک Unique Key داشته باشد تا فلاتر بفهمد چه زمانی باید انیمیشن بزند
                                child: isDownloading
                                    ? const SizedBox(
                                        key: ValueKey('loading'),
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : isAlreadyDownloaded
                                    ? const Icon(
                                        key: ValueKey('checked'),
                                        Icons.check_circle_rounded,
                                        size: 18,
                                        color: Colors.greenAccent,
                                      )
                                    : const Icon(
                                        key: ValueKey('download'),
                                        Icons.download_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: PageView.builder(
                controller: pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  currentPage.value = index;
                },
                itemBuilder: (context, index) {
                  final imageUrl = images[index];
                  return Center(
                    child: Hero(
                      tag: initialIndex == index
                          ? 'gallery_image_$index'
                          : 'no_tag_$index',
                      child: InteractiveViewer(
                        panEnabled: true,
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: CustomCacheImage(
                          imageUrl: 'http://ammaralhakeem.com$imageUrl',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
