import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/features/gallery/data/models/gallery_model.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class GalleryDetailScreen extends StatelessWidget {
  final GalleryModel gallery;

  const GalleryDetailScreen({super.key, required this.gallery});

  @override
  Widget build(BuildContext context) {
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
        decoration: BoxDecoration(gradient: context.appTheme.scaffoldGradient),

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 16, bottom: 10),
              child: Row(
                spacing: 8,

                children: [
                  _buildModernChip(
                    icon: Assets.icons.category.path,
                    label: gallery.category,
                    backgroundColor: AppColor.primaryOrange.withOpacity(0.1),
                    contentColor: AppColor.primaryOrange,
                  ),
                  _buildModernChip(
                    icon: Assets.icons.calendar.path,
                    label: gallery.date,
                    backgroundColor: AppColor.primaryBlue.withOpacity(0.1),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.9,
                ),
                itemCount: gallery.images.length,
                itemBuilder: (context, index) {
                  final imageUrl = gallery.images[index];
                  return GestureDetector(
                    onTap: () =>
                        _showFullImageGallery(context, gallery.images, index),
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

  // نمایش تصاویر به صورت اسلایدر تمام صفحه (Swipeable Gallery)
  void _showFullImageGallery(
    BuildContext context,
    List<String> images,
    int initialIndex,
  ) {
    final PageController pageController = PageController(
      initialPage: initialIndex,
    );

    // استفاده از ValueNotifier برای به‌روزرسانی شماره صفحه بدون نیاز به StatefulWidget
    final ValueNotifier<int> currentPage = ValueNotifier<int>(initialIndex);

    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.95),
        pageBuilder: (context, _, __) => Scaffold(
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
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // عملیات دانلود یا اشتراک گذاری
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.download_rounded, size: 18),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: PageView.builder(
            controller: pageController,
            itemCount: images.length,
            onPageChanged: (index) => currentPage.value = index,
            itemBuilder: (context, index) {
              final imageUrl = images[index];
              return Center(
                child: Hero(
                  // فعال شدن انیمیشن هیرو فقط برای عکسی که اول کلیک شده تا تداخل ایجاد نشود
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
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
