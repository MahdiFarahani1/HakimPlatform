import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonLoaderVideos extends StatelessWidget {
  const SkeletonLoaderVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        duration: const Duration(milliseconds: 1500),
        highlightColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white12
            : Colors.white,
        baseColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade300,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: double.infinity,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10,
                          width: 100,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              height: 8,
                              width: 60,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 8,
                              width: 50,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
