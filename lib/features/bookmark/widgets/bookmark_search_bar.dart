import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/features/bookmark/logic/cubit/book_mark_cubit.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkSearchBar extends StatefulWidget {
  final String searchQuery;

  const BookmarkSearchBar({super.key, required this.searchQuery});

  @override
  State<BookmarkSearchBar> createState() => _BookmarkSearchBarState();
}

class _BookmarkSearchBarState extends State<BookmarkSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant BookmarkSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery &&
        widget.searchQuery != _controller.text) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.transparent : Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          onChanged: (value) {
            context.read<BookmarkCubit>().updateSearchQuery(value);
          },
          decoration: InputDecoration(
            hintText: 'البحث في المفضلة...',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            prefixIcon: Container(
              margin: const EdgeInsets.all(14),
              child: Assets.icons.search.image(
                color: const Color(0xFF9CA3AF),
                width: 16,
                height: 16,
              ),
            ),
            suffixIcon: widget.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Color(0xFF9CA3AF),
                    ),
                    onPressed: () {
                      _controller.clear();
                      context.read<BookmarkCubit>().clearSearch();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }
}
