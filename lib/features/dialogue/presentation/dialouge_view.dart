import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/api.dart';
import 'package:flutter_application_1/core/widgets/custom_header.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/logic/search/search_cubit.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/empty_widget.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/features/dialogue/data/models/dialogue_model.dart';
import 'package:flutter_application_1/features/dialogue/logic/cubit/dialouge_cubit.dart';
import 'package:flutter_application_1/features/dialogue/widgets/content_modal.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_application_1/core/utils/extension.dart';

class DialogueScreen extends StatefulWidget {
  const DialogueScreen({super.key});

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(context),
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
                    }
                    if (state is DialougeError) {
                      return Center(
                        child: CustomErrorWidget(
                          message: state.message,
                          onRetry: () =>
                              context.read<DialougeCubit>().fetchDialogues(),
                        ),
                      );
                    }
                    if (state is DialougeSuccess) {
                      if (state.dialogues.isEmpty) {
                        return _buildEmptyWidget();
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: CustomSearchBar(
                              controller: _searchController,
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
                                _searchController.clear();
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
                                    final dialogues =
                                        _searchController.text.isEmpty
                                        ? state.dialogues
                                        : stateSearch.results;

                                    if (dialogues.isEmpty) {
                                      return EmptySearchWidget(
                                        controller: _searchController,
                                      );
                                    }

                                    return RefreshIndicator(
                                      color: AppColor.primaryOrange,
                                      onRefresh: () async {
                                        context
                                            .read<DialougeCubit>()
                                            .fetchDialogues();
                                      },
                                      child: NotificationListener<ScrollNotification>(
                                        onNotification: (scrollInfo) {
                                          if (scrollInfo.metrics.pixels >=
                                              scrollInfo.metrics.maxScrollExtent - 200) {
                                            if (_searchController.text.isEmpty) {
                                              context
                                                  .read<DialougeCubit>()
                                                  .fetchMoreDialogues();
                                            }
                                          }
                                          return false;
                                        },
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: AnimationLimiter(
                                                child: ListView.builder(
                                                  padding: const EdgeInsets.fromLTRB(
                                                    16,
                                                    8,
                                                    16,
                                                    24,
                                                  ),
                                                  itemCount: dialogues.length,
                                                  itemBuilder: (context, index) {
                                                    return AnimationConfiguration.staggeredList(
                                                      position: index,
                                                      duration: const Duration(
                                                        milliseconds: 450,
                                                      ),
                                                      child: SlideAnimation(
                                                        verticalOffset: 30.0,
                                                        child: FadeInAnimation(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  bottom: 16,
                                                                ),
                                                            child: _DialogueCard(
                                                              dialogue:
                                                                  dialogues[index],
                                                              onTap: () {
                                                                showInterviewInfoDialog(
                                                                  context,
                                                                  dialogues[index],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            if (state.fetchMore)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    color: AppColor.primaryOrange,
                                                    strokeWidth: 2.5,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          ),
                        ],
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
    return BlocBuilder<DialougeCubit, DialougeState>(
      builder: (context, state) {
        int total = 0;
        if (state is DialougeSuccess) {
          total = state.dialogues.length;
        }
        return CustomHeader(
          title: 'الحوارات',
          subtitle: state is DialougeLoading
              ? 'جاري التحميل...'
              : total > 0
                  ? '$total حوار متاح'
                  : 'لا توجد حوارات',
          icon: Assets.icons.comments.image(
            width: 26,
            height: 26,
            color: AppColor.primaryOrange,
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _DialogueCard(
              dialogue: DialogueModel(
                id: 0,
                title: 'هذا النص هو مثال لنص تجريبي طويل جداً',
                excerpt:
                    'هذا النص هو مثال لنص تجريبي طويل جداً لتوضيح شكل وتناسق الخطوط والفقرات داخل الكارت الذكي الخاص بالتطبيق الحالي.',
                image: '',
                date: '2026/07/11',
                interviewer: 'اسم المحاور هنا',
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: FadeInAnimation(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'لا توجد حوارات متاحة حالياً',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black38
                : Colors.grey.shade300.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: dialogue.image.isNotEmpty
                          ? CustomCacheImage(
                              imageUrl: "${Api.baseImageUrl}${dialogue.image}",
                            )
                          : _buildPlaceholder(),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (dialogue.date.isNotEmpty)
                      Positioned(
                        bottom: 12,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.icons.calendar.image(
                                width: 13,
                                height: 13,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                dialogue.date,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dialogue.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dialogue.excerpt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        height: 1,
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Assets.icons.user.image(
                              width: 16,
                              height: 16,
                              color: AppColor.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              dialogue.interviewer,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryBlue,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Assets.icons.angleSmallLeft.image(
                              width: 12,
                              height: 12,
                              color: Colors.grey.shade500,
                            ),
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
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: Assets.icons.imageSlash.image(
        width: 40,
        height: 40,
        color: Color(0xFF94A3B8),
      ),
    );
  }
}
