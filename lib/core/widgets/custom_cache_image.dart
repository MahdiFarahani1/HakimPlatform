import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/core/widgets/custom_loading.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class CustomCacheImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Color? color;
  const CustomCacheImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        color: color,
        // زمانی که تصویر در حال دانلود است، این ویجت نمایش داده می‌شود
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CustomLoading()),
        ),
        // زمانی که دانلود عکس با خطا مواجه شود (مثلا اینترنت قطع باشد)
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Assets.icons.imageSlash.image(
              color: Colors.grey,
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
    );
  }
}
