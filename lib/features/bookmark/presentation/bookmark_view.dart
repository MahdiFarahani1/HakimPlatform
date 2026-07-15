import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_state.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_cubit.dart';
import 'package:flutter_application_1/features/bookmark/widgets/bookmark_card.dart';
import 'package:flutter_application_1/features/bookmark/widgets/bookmark_category_chips.dart';
import 'package:flutter_application_1/features/bookmark/widgets/bookmark_empty_state.dart';
import 'package:flutter_application_1/features/bookmark/widgets/bookmark_header.dart';
import 'package:flutter_application_1/features/bookmark/widgets/bookmark_search_bar.dart';
import 'package:flutter_application_1/features/bookmark/widgets/bookmark_stat_cards.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.appTheme.scaffoldGradient),
        child: SafeArea(
          child: BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: BookmarkHeader()),
                  SliverToBoxAdapter(
                    child: BookmarkStatCards(state: state),
                  ),
                  SliverToBoxAdapter(
                    child: BookmarkCategoryChips(
                      selectedCategory: state.selectedCategory,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BookmarkSearchBar(
                      searchQuery: state.searchQuery,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    sliver: state.filteredItems.isEmpty
                        ? const SliverToBoxAdapter(
                            child: BookmarkEmptyState(),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return BookmarkCard(
                                  item: state.filteredItems[index],
                                );
                              },
                              childCount: state.filteredItems.length,
                            ),
                          ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: context.screenHeight * 0.15),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
