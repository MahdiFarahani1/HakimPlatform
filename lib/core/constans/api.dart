class Api {
  Api._();
  static const String baseImageUrl = 'http://ammaralhakeem.com/';
  static const String baseUrl = 'http://ammaralhakeem.com/new2/api';

  static const String configurations = '/configurations';

  static const String menus = '/menus';

  static const String sliders = '/sliders';
  static const String news = '/news';
  static const String statements = '/statements';
  static const String dialogues = '/dialogues';

  static const String allNews = '/all-news';
  static const String newsCategories = '/news-categories';

  static const String books = '/books';
  static const String bookCategories = '/book-categories';

  static const String videos = '/videos';
  static const String videoCategories = '/video-categories';

  static const String galleries = '/galleries';
  static const String galleryCategories = '/gallery-categories';

  static const String sounds = '/sounds';

  static const String search = '/search';

  static const String notifications = '/notifications';

  static const String testimonials = '/content/testimonials';
  static const String teachers = '/content/teachers';
  static const String siteStats = '/content/site-stats';
  static const String heroSlides = '/content/hero-slides';
  static const String articles = '/content/articles';

  static String post(int id) => '/post/$id';

  static String bookDetails(int id) => '/books/$id';

  static String videoDetails(int id) => '/videos/$id';

  static String galleryDetails(int id) => '/galleries/$id';

  static String soundDetails(int id) => '/sounds/$id';

  static String teacherDetails(int id) => '/content/teachers/$id';

  static String articleDetails(int id) => '/content/articles/$id';

  static String searchQuery(String query) => '/search?q=$query';

  static String menuByLocation(String location) => '/menus?location=$location';

  static String allNewsByCategory(int categoryId, {int page = 1}) =>
      '/all-news?lang=ar&category_id=$categoryId&page=$page';

  static String booksArchive({int page = 1, int perPage = 12}) =>
      '/books?all=1&page=$page&per_page=$perPage';

  static String videosArchive({int page = 1, int perPage = 9}) =>
      '/videos?all=1&page=$page&per_page=$perPage';

  static String galleriesArchive({int page = 1, int perPage = 12}) =>
      '/galleries?all=1&page=$page&per_page=$perPage';
}
