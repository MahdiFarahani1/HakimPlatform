import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';

class AboutSkeletonLoading extends StatelessWidget {
  const AboutSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Header Skeleton
          Container(
            width: double.infinity,
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.primaryBlue, AppColor.primaryOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(),
                const SizedBox(height: 16),
                Container(
                      width: 200,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(),
                const SizedBox(height: 8),
                Container(
                      width: 150,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(),
                const SizedBox(height: 12),
                Container(
                      width: 100,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Title Skeleton
                Row(
                  children: [
                    Container(
                          width: 80,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(),
                    const SizedBox(width: 8),
                    Container(
                          width: 120,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(),
                const SizedBox(height: 24),
                // Description Card Skeleton
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      Container(
                            width: double.infinity,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(),
                      const SizedBox(height: 12),
                      ...List.generate(
                        4,
                        (_) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child:
                              Container(
                                    width: double.infinity,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .shimmer(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child:
                                Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .shimmer(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child:
                                Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .shimmer(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Pillars Skeleton
                ...List.generate(
                  3,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .shimmer(),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                      width: 150,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .shimmer(),
                                const SizedBox(height: 8),
                                Container(
                                      width: 200,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .shimmer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
