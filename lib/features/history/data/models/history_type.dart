enum HistoryType {
  news,
  book,
  video,
  audio;

  String get label {
    switch (this) {
      case HistoryType.news:
        return 'الأخبار';
      case HistoryType.book:
        return 'كتاب';
      case HistoryType.video:
        return 'فيديو';
      case HistoryType.audio:
        return 'صوتيات';
    }
  }

  String get emoji {
    switch (this) {
      case HistoryType.news:
        return '📰';
      case HistoryType.book:
        return '📚';
      case HistoryType.video:
        return '🎥';
      case HistoryType.audio:
        return '🎵';
    }
  }
}
