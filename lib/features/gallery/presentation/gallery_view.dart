import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/core/widgets/custom_refresh_widget.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/features/gallery/logic/cubit/gallery_cubit.dart';
import 'package:flutter_application_1/features/gallery/presentation/gallery_detail_view.dart';
import 'package:flutter_application_1/features/gallery/widgets/gallery_loading.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => getIt<GalleryCubit>()..loadData(),
      child: Scaffold(
        body: BlocBuilder<GalleryCubit, GalleryState>(
          builder: (context, state) {
            if (state is GalleryLoading) {
              return const GallerySkeleton();
            } else if (state is GalleryError) {
              return CustomErrorWidget(
                onRetry: () {
                  context.read<GalleryCubit>().loadData();
                },
              );
            } else if (state is GalleryLoaded) {
              return SimpleRefreshIndicator(
                onRefresh: () => context.read<GalleryCubit>().loadData(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: context.appTheme.scaffoldGradient,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.onPrimaryContainer,
                          boxShadow: [
                            BoxShadow(
                              color: context.theme.brightness == Brightness.dark
                                  ? Colors.black.withOpacity(0.4)
                                  : Colors.grey.shade200,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.categories.length + 1,
                          itemBuilder: (context, index) {
                            final isSelected = index == 0
                                ? state.selectedCategoryId == 0
                                : state.selectedCategoryId ==
                                      state.categories[index - 1].id;

                            return GestureDetector(
                              onTap: () {
                                context.read<GalleryCubit>().filterByCategory(
                                  index == 0
                                      ? 0
                                      : state.categories[index - 1].id,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [
                                            AppColor.primaryBlue,
                                            AppColor.primaryBlue.withOpacity(
                                              0.6,
                                            ),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : context.appTheme.scaffoldGradient,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColor.primaryBlue
                                                .withOpacity(0.5),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                  border: isSelected
                                      ? null
                                      : (context.theme.brightness ==
                                                Brightness.light
                                            ? Border.all(
                                                color: Colors.grey.shade200,
                                                width: 1,
                                              )
                                            : null),
                                ),
                                child: Row(
                                  children: [
                                    if (isSelected) ...[
                                      Assets.icons.octagonCheck.image(
                                        width: 15,
                                        height: 15,
                                        color: AppColor.primaryOrange,
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Text(
                                      index == 0
                                          ? 'الكل'
                                          : state.categories[index - 1].title,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColor.primaryOrange
                                            : context.theme.splashColor,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: state.filteredGalleries.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(28),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.grey.shade50,
                                            Colors.grey.shade100,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300
                                                .withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(-4, -4),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.6),
                                          width: 2,
                                        ),
                                      ),
                                      child: Assets.icons.images.image(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    Text(
                                      "لا توجد أي صور في هذا التصنيف",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      'ستتم إضافة صور جديدة قريباً',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ).animate().scale()
                            : GridView.builder(
                                padding: const EdgeInsets.all(12),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.85,
                                    ),
                                itemCount: state.filteredGalleries.length,
                                itemBuilder: (context, index) {
                                  final gallery =
                                      state.filteredGalleries[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => GalleryDetailScreen(
                                            gallery: gallery,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CustomCacheImage(
                                              imageUrl:
                                                  'http://ammaralhakeem.com${gallery.image}',
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black.withOpacity(
                                                        0.8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 12,
                                              left: 12,
                                              right: 12,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    gallery.title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      letterSpacing: 0.3,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Assets.icons.messageImage
                                                          .image(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.8,
                                                                ),
                                                            width: 12,
                                                            height: 12,
                                                          ),

                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${gallery.images.length} تصویر',
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Assets.icons.calendar
                                                          .image(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.8,
                                                                ),
                                                            width: 12,
                                                            height: 12,
                                                          ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        gallery.date,
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (gallery.size == 'large' ||
                                                gallery.size == 'wide')
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    gallery.size == 'large'
                                                        ? Icons.crop_original
                                                        : Icons
                                                              .photo_size_select_large,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
