import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/config/di.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/error_widget.dart';
import 'package:flutter_application_1/features/books/data/models/book_model.dart';
import 'package:flutter_application_1/features/books/data/models/category_book.dart';
import 'package:flutter_application_1/features/books/logic/book/book_cubit.dart';
import 'package:flutter_application_1/features/books/logic/pdf/pdf_cubit.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BooksCubit>()..getAllBooksData(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: context.appTheme.scaffoldGradient,
          ),

          child: BlocBuilder<BooksCubit, BooksState>(
            builder: (context, state) {
              final isLoading = state.status is BooksLoadingStatus;
              if (state.status is BooksErrorStatus) {
                return CustomErrorWidget(
                  onRetry: () {
                    context.read<BooksCubit>().getAllBooksData();
                  },
                );
              }

              return Skeletonizer(
                enabled: isLoading,
                child: Column(
                  children: [
                    _buildCategoriesSection(
                      context,
                      isLoading ? _dummyCategories : state.categories,
                      state.categoriesSelected,
                    ),
                    Expanded(
                      child: _buildBooksGrid(
                        context,
                        isLoading ? _dummyBooks : state.filteredBooks,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<BooksCubit, BooksState>(
        builder: (context, state) {
          int bookCount = 0;
          if (state.status is BooksLoadedStatus) {
            bookCount = state.filteredBooks.length;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Assets.icons.books.image(
                    width: 24,
                    height: 24,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "مكتبتي",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text(
                '$bookCount كتاب',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : const Color(0xFF1A1A2E),
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Assets.icons.bookArrowRight.image(
            width: 24,
            height: 24,
            color: AppColor.primaryBlue,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    List<BookCategoryModel> categories,
    int selectedIndex,
  ) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryChip(context, 'الكل', selectedIndex == 0, () {
              context.read<BooksCubit>().showAllBooks();
            });
          }

          final category = categories[index - 1];
          final isSelected = selectedIndex == index;

          return _buildCategoryChip(context, category.title, isSelected, () {
            context.read<BooksCubit>().getBooksByCategories(
              category.title,
              index,
            );
          });
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primaryBlue
                : Theme.of(context).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.primaryBlue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Assets.icons.octagonCheck.image(
                  color: AppColor.primaryOrange,
                  width: 14,
                  height: 14,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColor.primaryOrange
                      : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : const Color(0xFF1A1A2E)),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBooksGrid(BuildContext context, List<BookModel> books) {
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [Colors.grey.shade800, Colors.grey.shade900]
                      : [Colors.grey.shade50, Colors.grey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Assets.icons.bookOpenCover.image(
                width: 70,
                height: 70,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد كتب في هذا القسم',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم إضافة كتب جديدة قريباً',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ).animate().scale();
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCardItem(book: books[index]);
      },
    );
  }

  List<BookCategoryModel> get _dummyCategories => List.generate(
    5,
    (index) => BookCategoryModel(id: index, title: 'دسته‌بندی تست'),
  );

  List<BookModel> get _dummyBooks => List.generate(
    4,
    (index) => BookModel(
      id: index,
      title: 'عنوان کتاب تست شیک و مدرن',
      image: '',
      number: 'جلد ۱',
      category: 'تست',
      pdf: '',
      date: '1300/4/2',
      code: '',
    ),
  );
}

class BookCardItem extends StatelessWidget {
  final BookModel book;
  const BookCardItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<PdfCubit>()..checkFileExists(fileName: 'book_${book.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.grey.shade200,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    book.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                      child: Assets.icons.bookOpenCover.image(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryOrange.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Assets.icons.clockThree.image(
                            width: 10,
                            height: 10,
                            color: AppColor.primaryOrange,
                          ),
                          context.gap(3),
                          Text(
                            book.date,
                            style: const TextStyle(
                              color: AppColor.primaryOrange,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: BlocBuilder<PdfCubit, PdfState>(
                      builder: (context, state) {
                        if (state is PdfDownloaded) {
                          return Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Assets.icons.wishlistStar.image(
                                color: AppColor.primaryOrange,
                              ),
                            ),
                          );
                        }
                        if (state is PdfDownloading) {
                          double progress = state.progress;
                          return Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CircularProgressIndicator(
                              value: progress,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColor.primaryOrange,
                              ),
                              strokeWidth: 3,
                            ),
                          );
                        }
                        return InkWell(
                          onTap: () async {
                            print('a');
                            await BlocProvider.of<PdfCubit>(
                              context,
                            ).downloadPdf(
                              fileName: 'book_${book.id}',
                              url: book.pdf,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Assets.icons.arrowDownFromArc.image(
                              color: AppColor.primaryOrange,
                              width: 21,
                              height: 21,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF1A1A2E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColor.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                book.category ?? 'عمومی',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // دکمه مطالعه در پایین کارت
                    BlocBuilder<PdfCubit, PdfState>(
                      builder: (context, state) {
                        if (state is PdfDownloaded) {
                          return InkWell(
                            onTap: () {
                              context.read<PdfCubit>().openPdf();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: double.infinity,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColor.primaryBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'مطالعة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
