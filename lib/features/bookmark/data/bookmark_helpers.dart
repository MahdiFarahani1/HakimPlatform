import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/bookmark/data/models/bookmark_model.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class BookmarkHelpers {
  BookmarkHelpers._();

  static ({Color color, String icon, String text}) getCategoryInfo(
    BookmarkItem item,
  ) {
    switch (item.category) {
      case 'video':
        return (
          color: const Color(0xFF8400FF),
          icon: Assets.icons.headphonesRhythm.path,
          text: 'فيديو',
        );
      case 'book':
        return (
          color: const Color(0xFF59C5A1),
          icon: Assets.icons.bookOpenCover.path,
          text: 'كتاب',
        );
      default:
        return (
          color: const Color(0xFF0062FF),
          icon: Assets.icons.newspaper.path,
          text: 'الأخبار',
        );
    }
  }

  static String getImageEmoji(BookmarkItem item) {
    switch (item.category) {
      case 'video':
        return '🎥';
      case 'book':
        return '📚';
      default:
        return '📰';
    }
  }
}
