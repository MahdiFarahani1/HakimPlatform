import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/custom_loading.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/features/news/presentation/detail_news_view.dart';
import 'package:flutter_application_1/features/search/data/models/search_result_model.dart';
import 'package:flutter_application_1/features/search/logic/cubit/search_cubit.dart';
import 'package:flutter_application_1/features/search/logic/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();

  final List<String> _suggestedKeywords = [
    'العراق',
    'بيان',
    'عمار الحكيم',
    'لقاء',
    'زيارة',
    'تصريح',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
        context.read<SearchCubit>().search(widget.initialQuery!);
      }
    });

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    _focusNode.unfocus();
    context.read<SearchCubit>().search(query.trim());
  }

  void _clearSearch() {
    _searchController.clear();
    _focusNode.unfocus();
    HapticFeedback.lightImpact();
    context.read<SearchCubit>().clearSearch();
  }

  void _searchKeyword(String keyword) {
    _searchController.text = keyword;
    _onSearchSubmitted(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: context.appTheme.scaffoldGradient,
            ),
            child: Column(
              children: [
                // Header & Search Box Section
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'البحث',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ابحث في الأخبار والبيانات الصحفية والمحتوى',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.grey.shade400
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search input box
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.onPrimaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.transparent
                                  : (_focusNode.hasFocus
                                        ? AppColor.primaryBlue.withOpacity(0.15)
                                        : Colors.black.withOpacity(0.04)),
                              blurRadius: _focusNode.hasFocus ? 12 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CustomSearchBar(
                          controller: _searchController,
                          hintText:
                              'ابحث في الأخبار والبيانات الصحفية والمحتوى',
                          onClear: _clearSearch,
                          onSubmitted: () {
                            context.read<SearchCubit>().search(
                              _searchController.text,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state is SearchLoading) {
                        return const Center(child: CustomLoading());
                      }

                      if (state is SearchError) {
                        return CustomErrorWidget(
                          message: state.message,
                          onRetry: () {
                            context.read<SearchCubit>().search(state.query);
                          },
                        );
                      }

                      if (state is SearchEmpty) {
                        return _buildEmptyResultsView(state.query);
                      }

                      if (state is SearchSuccess) {
                        return _buildSearchResultsList(
                          state.results,
                          state.query,
                        );
                      }

                      // Default / Initial State
                      return _buildInitialView();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialView() {
    final bool isDark = context.theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'كلمات دلالية مقترحة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _suggestedKeywords.map((keyword) {
              return _buildKeywordChip(keyword);
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Search Tip Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.primaryBlue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColor.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'يمكنك البحث برقم الخبر، العنوان، أو كلمات مفتاحية للحصول على نتائج دقيقة.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark
                          ? Colors.grey.shade300
                          : const Color(0xFF334155),
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

  Widget _buildKeywordChip(String keyword) {
    final bool isDark = context.theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => _searchKeyword(keyword),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.north_west_rounded,
              size: 14,
              color: AppColor.primaryBlue,
            ),
            const SizedBox(width: 6),
            Text(
              keyword,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResultsView(String query) {
    final bool isDark = context.theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 40,
                color: AppColor.primaryBlue,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'لا توجد نتائج بحث',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'لم نجد أي نتائچ تطابق "$query"\nجرّب البحث باستخدام كلمات أخرى.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsList(
    List<SearchResultModel> results,
    String query,
  ) {
    final bool isDark = context.theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'تم العثور على ${results.length} نتيجة لـ "$query"',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
            physics: const BouncingScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return _buildSearchResultCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(SearchResultModel item) {
    final bool isDark = context.theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(newsId: item.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Type badge & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item.type.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.type,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                      ),
                    if (item.date.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.date,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Description preview if available
                if (item.cleanDescription.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.cleanDescription,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: isDark
                          ? Colors.grey.shade400
                          : const Color(0xFF475569),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 10),

                // Bottom row: Read more hint
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'عرض التفاصيل',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 10,
                      color: AppColor.primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
