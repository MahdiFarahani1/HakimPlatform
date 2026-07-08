// lib/features/dialogue/presentation/screens/dialogue_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/logic/search/search_cubit.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/empty_widget.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';
import 'package:flutter_application_1/features/dialogue/logic/cubit/dialouge_cubit.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_application_1/core/utils/extension.dart';

class DialogueScreen extends StatelessWidget {
  const DialogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchCubit<DialogueModel>()),

        BlocProvider(
          create: (context) => getIt<DialougeCubit>()..fetchDialogues(),
        ),
      ],

      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: context.appTheme.scaffoldGradient,
          ),
          child: Column(
            children: [
              SafeArea(child: _buildHeader(context)),
              Expanded(
                child: BlocConsumer<DialougeCubit, DialougeState>(
                  listener: (context, state) {
                    if (state is DialougeSuccess) {
                      context.read<SearchCubit<DialogueModel>>().clear(
                        state.dialogues,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is DialougeLoading || state is DialougeInitial) {
                      return _buildSkeletonLoader(context);
                    } else if (state is DialougeError) {
                      return CustomErrorWidget(
                        onRetry: () {
                          context.read<DialougeCubit>().fetchDialogues();
                        },
                      );
                    } else if (state is DialougeSuccess) {
                      if (state.dialogues.isEmpty) {
                        return _buildEmptyWidget();
                      }
                      return RefreshIndicator(
                        color: AppColor.primaryOrange,
                        onRefresh: () async {
                          context.read<DialougeCubit>().fetchDialogues();
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomSearchBar(
                                controller: controller,
                                onChanged: (value) {
                                  context
                                      .read<SearchCubit<DialogueModel>>()
                                      .search(
                                        query: value,
                                        source: state.dialogues,
                                        title: (d) => d.title,
                                      );
                                },
                                onClear: () {
                                  context
                                      .read<SearchCubit<DialogueModel>>()
                                      .clear(state.dialogues);
                                },
                              ),
                            ),

                            Expanded(
                              child:
                                  BlocBuilder<
                                    SearchCubit<DialogueModel>,
                                    SearchState<DialogueModel>
                                  >(
                                    builder: (context, stateSearch) {
                                      final dialogue = controller.text.isEmpty
                                          ? state.dialogues
                                          : stateSearch.results;
                                      if (dialogue.isEmpty) {
                                        return EmptySearchWidget(
                                          controller: controller,
                                        );
                                      }
                                      return AnimationLimiter(
                                        child: ListView.builder(
                                          padding: const EdgeInsets.fromLTRB(
                                            16,
                                            16,
                                            16,
                                            24,
                                          ),
                                          itemCount: controller.text.isEmpty
                                              ? state.dialogues.length
                                              : stateSearch.results.length,
                                          itemBuilder: (context, index) {
                                            return AnimationConfiguration.staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              child: SlideAnimation(
                                                verticalOffset: 40,
                                                child: FadeInAnimation(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 16,
                                                        ),
                                                    child: _DialogueCard(
                                                      dialogue: dialogue[index],
                                                      onTap: () {
                                                        // TODO: هدایت به صفحه جزئیات گفتگو
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: BlocBuilder<DialougeCubit, DialougeState>(
        builder: (context, state) {
          int total = 0;
          if (state is DialougeSuccess) {
            total = state.dialogues.length;
          }
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryBlue,
                      AppColor.primaryBlue.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.forum_rounded,
                  size: 28,
                  color: AppColor.primaryOrange,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الحوارات',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    total > 0 ? '$total حوار' : 'تحميل...',
                    style: TextStyle(
                      color: AppColor.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
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
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 12,
                          width: 200,
                          color: Colors.grey.shade300,
                        ),
                      ],
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

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد حوارات',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogueCard extends StatelessWidget {
  final DialogueModel dialogue;
  final VoidCallback onTap;

  const _DialogueCard({required this.dialogue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black26
                    : Colors.grey.shade200.withOpacity(0.8),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // تصویر با گرادیانت روی پایین برای خوانایی تاریخ
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 170,
                      width: double.infinity,
                      child: Image.network(
                        dialogue.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Assets.icons.imageSlash.image(
                              width: 60,
                              height: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0),
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (dialogue.date.isNotEmpty)
                      Positioned(
                        bottom: 10,
                        right: 12,
                        child: Row(
                          children: [
                            Assets.icons.calendar.image(
                              width: 14,
                              height: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dialogue.date,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // محتوای متنی
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dialogue.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dialogue.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColor.primaryBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Assets.icons.user.image(
                            width: 16,
                            height: 16,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dialogue.interviewer,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryBlue,
                            ),
                          ),
                        ),
                        Assets.icons.angleSmallLeft.image(
                          width: 16,
                          height: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
