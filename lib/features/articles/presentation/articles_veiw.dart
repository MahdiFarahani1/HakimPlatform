import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/utils/extension.dart';
import 'package:flutter_application_1/core/widgets/custom_cache_image.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  int _selectedIndex = 0;

  final List<String> _categories = [
    'All',
    'Technology',
    'Design',
    'Business',
    'Health',
    'Travel',
  ];

  final List<Article> _allArticles = [
    Article(
      id: '1',
      title: 'The Future of Artificial Intelligence in 2025',
      subtitle:
          'How AI is transforming industries and creating new opportunities',
      category: 'Technology',
      readTime: '8 min read',
      date: '2 hours ago',
      imageAsset: '🤖',
      color: 0xFF8B5CF6,
      author: 'Sarah Johnson',
      likes: 1243,
      comments: 89,
      trending: true,
    ),
    Article(
      id: '2',
      title: 'Minimalist Design: Less is More',
      subtitle: 'Exploring the beauty of simplicity in modern design',
      category: 'Design',
      readTime: '5 min read',
      date: '5 hours ago',
      imageAsset: '🎨',
      color: 0xFFEC4899,
      author: 'Michael Chen',
      likes: 892,
      comments: 45,
      trending: false,
    ),
    Article(
      id: '3',
      title: '10 Startup Strategies That Actually Work',
      subtitle: 'Proven methods from successful entrepreneurs',
      category: 'Business',
      readTime: '12 min read',
      date: '1 day ago',
      imageAsset: '💼',
      color: 0xFF10B981,
      author: 'David Williams',
      likes: 2156,
      comments: 167,
      trending: true,
    ),
    Article(
      id: '4',
      title: 'Mental Health in Digital Age',
      subtitle: 'Finding balance between technology and wellbeing',
      category: 'Health',
      readTime: '6 min read',
      date: '3 days ago',
      imageAsset: '🧠',
      color: 0xFF3B82F6,
      author: 'Emily Rodriguez',
      likes: 734,
      comments: 52,
      trending: false,
    ),
    Article(
      id: '5',
      title: 'Hidden Gems: Travel Destinations 2025',
      subtitle: 'Off-the-beaten-path locations you need to visit',
      category: 'Travel',
      readTime: '10 min read',
      date: '4 days ago',
      imageAsset: '✈️',
      color: 0xFFF59E0B,
      author: 'Lisa Thompson',
      likes: 1567,
      comments: 123,
      trending: true,
    ),
    Article(
      id: '6',
      title: 'The Rise of Quantum Computing',
      subtitle: 'What you need to know about the next computing revolution',
      category: 'Technology',
      readTime: '9 min read',
      date: '1 week ago',
      imageAsset: '⚛️',
      color: 0xFF6366F1,
      author: 'Alex Kumar',
      likes: 987,
      comments: 67,
      trending: false,
    ),
    Article(
      id: '7',
      title: 'Color Psychology in UI Design',
      subtitle: 'How colors influence user behavior and decisions',
      category: 'Design',
      readTime: '7 min read',
      date: '1 week ago',
      imageAsset: '🎨',
      color: 0xFF06B6D4,
      author: 'Maria Garcia',
      likes: 645,
      comments: 34,
      trending: false,
    ),
    Article(
      id: '8',
      title: 'Sustainable Business Practices',
      subtitle: 'Building eco-friendly companies for the future',
      category: 'Business',
      readTime: '11 min read',
      date: '2 weeks ago',
      imageAsset: '🌱',
      color: 0xFF22C55E,
      author: 'James Wilson',
      likes: 523,
      comments: 41,
      trending: false,
    ),
  ];

  List<Article> get _filteredArticles {
    if (_selectedCategory == 'All') {
      return _allArticles;
    }
    return _allArticles
        .where((article) => article.category == _selectedCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory = _categories[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: context.appTheme.scaffoldGradient,
        ),
        child: CustomScrollView(
        slivers: [
          // App Bar with gradient
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),

          // Categories Tab Bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedCategory = category;
                        _selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                              )
                            : null,
                        color: isSelected
                            ? null
                            : context.theme.colorScheme.onPrimaryContainer,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : (context.theme.brightness == Brightness.dark
                                  ? Colors.white12
                                  : Colors.grey.shade200),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF7C3AED,
                                  ).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 400),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (context.theme.brightness == Brightness.dark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade600),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                        child: Text(category),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Stats Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_filteredArticles.length} articles',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.theme.brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: context.theme.brightness == Brightness.dark
                            ? Colors.white12
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sort_rounded,
                          size: 16,
                          color: Color(0xFF7C3AED),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Latest',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 16,
                          color: context.theme.brightness == Brightness.dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Articles Grid/List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final article = _filteredArticles[index];
                return _buildArticleCard(article);
              }, childCount: _filteredArticles.length),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildArticleCard(Article article) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        showArticleDetail(article);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: context.theme.brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Header Section
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(article.color),
                    Color(article.color).withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Stack(
                children: [
                  // Icon emoji
                  Center(
                    child: Text(
                      article.imageAsset,
                      style: const TextStyle(fontSize: 64),
                    ),
                  ),
                  // Category badge top right
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: 12,
                            color: Color(article.color),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            article.category,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(article.color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Trending badge
                  if (article.trending)
                    const Positioned(
                      top: 16,
                      left: 16,
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Trending',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: context.theme.brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.theme.brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Author and stats
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(article.color),
                              Color(article.color).withOpacity(0.5),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            article.author[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: context.theme.brightness == Brightness.dark
                                    ? Colors.grey.shade300
                                    : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                CustomCacheImage(
                                  imageUrl: Assets.icons.clockThree.path,
                                  width: 10,
                                  height: 10,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  article.readTime,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: context.theme.brightness == Brightness.dark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.circle,
                                  size: 4,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  article.date,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: context.theme.brightness == Brightness.dark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Like and comment counts
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatNumber(article.likes),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatNumber(article.comments),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Read more link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Read more',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(article.color),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Color(article.color),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showArticleDetail(Article article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.onPrimaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.theme.brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(article.color),
                            Color(article.color).withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          article.imageAsset,
                          style: const TextStyle(fontSize: 80),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Assets.icons.clockThree.image(
                          width: 10,
                          height: 10,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(article.readTime),
                        const SizedBox(width: 16),
                        const Icon(Icons.calendar_today, size: 14),
                        const SizedBox(width: 4),
                        Text(article.date),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      article.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: context.theme.brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

class Article {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String readTime;
  final String date;
  final String imageAsset;
  final int color;
  final String author;
  final int likes;
  final int comments;
  final bool trending;

  Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.readTime,
    required this.date,
    required this.imageAsset,
    required this.color,
    required this.author,
    required this.likes,
    required this.comments,
    required this.trending,
  });
}
