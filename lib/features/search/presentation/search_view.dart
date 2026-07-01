import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constans/app_color.dart';
import 'package:flutter_application_1/core/widgets/custom_loading.dart';
import 'package:flutter_application_1/core/utils/extension.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Sample data - می‌توانید با API واقعی جایگزین کنید
  final List<Map<String, dynamic>> _allItems = [
    {
      'id': 1,
      'title': 'Eiffel Tower',
      'category': 'Landmark',
      'location': 'Paris, France',
      'rating': 4.8,
      'image': '🗼',
      'color': 0xFFE8B86B,
    },
    {
      'id': 2,
      'title': 'Colosseum',
      'category': 'Historical',
      'location': 'Rome, Italy',
      'rating': 4.9,
      'image': '🏛️',
      'color': 0xFFD4A373,
    },
    {
      'id': 3,
      'title': 'Sagrada Familia',
      'category': 'Church',
      'location': 'Barcelona, Spain',
      'rating': 4.7,
      'image': '⛪',
      'color': 0xFFA8D5BA,
    },
    {
      'id': 4,
      'title': 'Machu Picchu',
      'category': 'Ancient City',
      'location': 'Cusco, Peru',
      'rating': 4.9,
      'image': '🏔️',
      'color': 0xFF6B8E7B,
    },
    {
      'id': 5,
      'title': 'Great Wall',
      'category': 'Fortification',
      'location': 'Beijing, China',
      'rating': 4.8,
      'image': '🧱',
      'color': 0xFFD9896A,
    },
    {
      'id': 6,
      'title': 'Taj Mahal',
      'category': 'Mausoleum',
      'location': 'Agra, India',
      'rating': 4.9,
      'image': '🕌',
      'color': 0xFFF4E4BA,
    },
    {
      'id': 7,
      'title': 'Statue of Liberty',
      'category': 'Monument',
      'location': 'New York, USA',
      'rating': 4.6,
      'image': '🗽',
      'color': 0xFF7CB9A8,
    },
    {
      'id': 8,
      'title': 'Sydney Opera',
      'category': 'Arts Centre',
      'location': 'Sydney, Australia',
      'rating': 4.7,
      'image': '🎭',
      'color': 0xFFE0AFA0,
    },
    {
      'id': 9,
      'title': 'Christ Redeemer',
      'category': 'Statue',
      'location': 'Rio, Brazil',
      'rating': 4.8,
      'image': '⛰️',
      'color': 0xFFB8D8D8,
    },
    {
      'id': 10,
      'title': 'Stonehenge',
      'category': 'Megalith',
      'location': 'Wiltshire, UK',
      'rating': 4.5,
      'image': '🪨',
      'color': 0xFFB0B0B0,
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
      _filterItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filterItems() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // تأخیر برای UX بهتر

    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems.where((item) {
          return item['title'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              item['category'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              item['location'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
        }).toList();
      }
      _isLoading = false;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _focusNode.unfocus();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: context.appTheme.scaffoldGradient,
          ),

          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discover',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: context.theme.brightness == Brightness.dark
                                    ? Colors.transparent
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.tune_rounded),
                            color: AppColor.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find the world\'s most amazing places',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.onPrimaryContainer,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.transparent
                                : (_focusNode.hasFocus
                                    ? AppColor.primaryBlue.withOpacity(0.2)
                                    : Colors.black.withOpacity(0.03)),
                            blurRadius: _focusNode.hasFocus ? 16 : 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        style: TextStyle(
                          fontSize: 16,
                          color: context.theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search destinations...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColor.primaryBlue,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: _clearSearch,
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: context.theme.brightness == Brightness.dark
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: context.theme.colorScheme.onPrimaryContainer,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recent & Trending Section (only when no search)
              if (_searchQuery.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Recent Searches',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: context.theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildRecentChip('🏔️  Mountains'),
                          _buildRecentChip('🏛️  Historical'),
                          _buildRecentChip('🏝️  Beaches'),
                          _buildRecentChip('🌆  City breaks'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Trending Destinations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: context.theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Results Section
              Expanded(
                child: _isLoading
                    ? const Center(child: CustomLoading())
                    : _filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search_off_rounded,
                                size: 36,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching for something else',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return _buildSearchResultCard(item);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchController.text = label.split(' ')[1];
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: context.theme.brightness == Brightness.dark
                ? Colors.white12
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: context.theme.brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.theme.brightness == Brightness.dark
                ? Colors.grey.shade300
                : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // ناوبری به صفحه جزئیات
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${item['title']}'),
            duration: const Duration(milliseconds: 500),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.theme.brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji/Icon as image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(item['color']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  item['image'],
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.theme.brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              item['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item['category']} • ${item['location']}',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.theme.brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['category'],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
