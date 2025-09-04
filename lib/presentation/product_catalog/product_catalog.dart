import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/skeleton_card_widget.dart';

/// Product Catalog screen for browsing dairy products with filtering and search
class ProductCatalog extends StatefulWidget {
  const ProductCatalog({Key? key}) : super(key: key);

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  final List<String> _wishlistItems = [];
  final List<Map<String, dynamic>> _cartItems = [];

  String _searchQuery = '';
  List<String> _selectedCategories = [];
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Mock data for dairy products
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "name": "Fresh Whole Milk",
      "description":
          "Premium quality whole milk from grass-fed cows, rich in nutrients and perfect for daily consumption.",
      "price": "\$4.99",
      "category": "Milk",
      "image":
          "https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.8,
      "priceValue": 4.99,
    },
    {
      "id": 2,
      "name": "Greek Yogurt",
      "description":
          "Creamy and thick Greek yogurt packed with protein and probiotics for a healthy lifestyle.",
      "price": "\$6.49",
      "category": "Curd",
      "image":
          "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.7,
      "priceValue": 6.49,
    },
    {
      "id": 3,
      "name": "Fresh Paneer",
      "description":
          "Soft and fresh cottage cheese made daily, perfect for Indian cuisine and healthy cooking.",
      "price": "\$8.99",
      "category": "Paneer",
      "image":
          "https://images.pexels.com/photos/5946080/pexels-photo-5946080.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.9,
      "priceValue": 8.99,
    },
    {
      "id": 4,
      "name": "Organic Butter",
      "description":
          "Creamy organic butter churned from the finest cream, perfect for cooking and spreading.",
      "price": "\$7.99",
      "category": "Butter",
      "image":
          "https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.6,
      "priceValue": 7.99,
    },
    {
      "id": 5,
      "name": "Pure Ghee",
      "description":
          "Traditional clarified butter with rich aroma and taste, perfect for authentic cooking.",
      "price": "\$12.99",
      "category": "Ghee",
      "image":
          "https://images.pexels.com/photos/4198019/pexels-photo-4198019.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.8,
      "priceValue": 12.99,
    },
    {
      "id": 6,
      "name": "Aged Cheddar Cheese",
      "description":
          "Premium aged cheddar with sharp flavor and smooth texture, perfect for gourmet dishes.",
      "price": "\$9.99",
      "category": "Cheese",
      "image":
          "https://images.pexels.com/photos/773253/pexels-photo-773253.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "Out of Stock",
      "rating": 4.7,
      "priceValue": 9.99,
    },
    {
      "id": 7,
      "name": "Low-Fat Milk",
      "description":
          "Nutritious low-fat milk with all the goodness of regular milk but with reduced fat content.",
      "price": "\$3.99",
      "category": "Milk",
      "image":
          "https://images.pexels.com/photos/248412/pexels-photo-248412.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.5,
      "priceValue": 3.99,
    },
    {
      "id": 8,
      "name": "Flavored Yogurt",
      "description":
          "Delicious strawberry flavored yogurt with real fruit pieces and natural sweetness.",
      "price": "\$5.49",
      "category": "Curd",
      "image":
          "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.4,
      "priceValue": 5.49,
    },
    {
      "id": 9,
      "name": "Salted Butter",
      "description":
          "Classic salted butter with perfect balance of cream and salt for everyday use.",
      "price": "\$6.99",
      "category": "Butter",
      "image":
          "https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.6,
      "priceValue": 6.99,
    },
    {
      "id": 10,
      "name": "Mozzarella Cheese",
      "description":
          "Fresh mozzarella cheese with creamy texture, perfect for pizzas and Italian dishes.",
      "price": "\$8.49",
      "category": "Cheese",
      "image":
          "https://images.pexels.com/photos/773253/pexels-photo-773253.jpeg?auto=compress&cs=tinysrgb&w=800",
      "availability": "In Stock",
      "rating": 4.8,
      "priceValue": 8.49,
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _displayedProducts = [];

  final List<String> _categories = [
    'All',
    'Milk',
    'Curd',
    'Paneer',
    'Butter',
    'Ghee',
    'Cheese',
  ];

  final List<String> _searchSuggestions = [
    'Fresh Milk',
    'Greek Yogurt',
    'Organic Butter',
    'Pure Ghee',
    'Fresh Paneer',
    'Cheddar Cheese',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
    _setupScrollListener();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  void _initializeData() {
    _filteredProducts = List.from(_allProducts);
    _loadInitialProducts();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreProducts();
      }
    });
  }

  void _loadInitialProducts() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _displayedProducts = _filteredProducts.take(_itemsPerPage).toList();
        _isLoading = false;
      });
    });
  }

  void _loadMoreProducts() {
    if (_isLoadingMore ||
        _displayedProducts.length >= _filteredProducts.length) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      final nextItems = _filteredProducts
          .skip(_displayedProducts.length)
          .take(_itemsPerPage)
          .toList();

      setState(() {
        _displayedProducts.addAll(nextItems);
        _isLoadingMore = false;
      });
    });
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (category == 'All') {
        _selectedCategories.clear();
      } else {
        if (_selectedCategories.contains(category)) {
          _selectedCategories.remove(category);
        } else {
          _selectedCategories.add(category);
        }
      }
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final nameMatch =
            (product["name"] as String).toLowerCase().contains(searchLower);
        final descMatch = (product["description"] as String)
            .toLowerCase()
            .contains(searchLower);
        if (!nameMatch && !descMatch) return false;
      }

      // Category filter
      if (_selectedCategories.isNotEmpty) {
        if (!_selectedCategories.contains(product["category"])) return false;
      }

      // Price range filter
      if (_activeFilters.containsKey('minPrice') &&
          _activeFilters.containsKey('maxPrice')) {
        final price = product["priceValue"] as double;
        if (price < _activeFilters['minPrice'] ||
            price > _activeFilters['maxPrice']) {
          return false;
        }
      }

      // Product type filter
      if (_activeFilters.containsKey('productTypes')) {
        final selectedTypes = _activeFilters['productTypes'] as List<String>;
        if (selectedTypes.isNotEmpty &&
            !selectedTypes.contains(product["category"])) {
          return false;
        }
      }

      // Availability filter
      if (_activeFilters.containsKey('inStockOnly') &&
          _activeFilters['inStockOnly'] == true) {
        if (product["availability"] != "In Stock") return false;
      }

      return true;
    }).toList();

    // Apply sorting
    if (_activeFilters.containsKey('sortBy')) {
      switch (_activeFilters['sortBy']) {
        case 'price_low':
          _filteredProducts.sort((a, b) =>
              (a["priceValue"] as double).compareTo(b["priceValue"] as double));
          break;
        case 'price_high':
          _filteredProducts.sort((a, b) =>
              (b["priceValue"] as double).compareTo(a["priceValue"] as double));
          break;
        case 'name':
          _filteredProducts.sort(
              (a, b) => (a["name"] as String).compareTo(b["name"] as String));
          break;
        case 'newest':
          _filteredProducts
              .sort((a, b) => (b["id"] as int).compareTo(a["id"] as int));
          break;
      }
    }

    _currentPage = 1;
    _displayedProducts = _filteredProducts.take(_itemsPerPage).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _onProductTap(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/product-detail', arguments: product);
  }

  void _onAddToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product["name"]} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.pushNamed(context, '/shopping-cart'),
        ),
      ),
    );
  }

  void _onWishlistToggle(Map<String, dynamic> product) {
    final productId = product["id"].toString();
    setState(() {
      if (_wishlistItems.contains(productId)) {
        _wishlistItems.remove(productId);
      } else {
        _wishlistItems.add(productId);
      }
    });
  }

  void _onShareProduct(Map<String, dynamic> product) async {
    final message =
        'Check out this amazing ${product["name"]} from Delhuan Dairy! ${product["description"]} - Only ${product["price"]}';
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not share product')),
      );
    }
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _applyFilters();
      _isLoading = false;
    });
  }

  int get _activeFilterCount {
    int count = 0;
    if (_activeFilters.containsKey('minPrice') ||
        _activeFilters.containsKey('maxPrice')) count++;
    if (_activeFilters.containsKey('productTypes') &&
        (_activeFilters['productTypes'] as List).isNotEmpty) count++;
    if (_activeFilters.containsKey('inStockOnly') &&
        _activeFilters['inStockOnly'] == true) count++;
    if (_activeFilters.containsKey('sortBy')) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomProductAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Search and Filter Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search Bar
                    SearchBarWidget(
                      onSearchChanged: _onSearchChanged,
                      onFilterTap: _showFilterBottomSheet,
                      filterCount: _activeFilterCount,
                      suggestions: _searchSuggestions,
                    ),
                    SizedBox(height: 16),
                    // Category Filter Chips
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = category == 'All'
                              ? _selectedCategories.isEmpty
                              : _selectedCategories.contains(category);
                          final count = category == 'All'
                              ? _allProducts.length
                              : _allProducts
                                  .where((p) => p["category"] == category)
                                  .length;

                          return FilterChipWidget(
                            label: category,
                            isSelected: isSelected,
                            count: count,
                            onTap: () => _onCategorySelected(category),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Product Grid
              Expanded(
                child: _isLoading
                    ? _buildSkeletonGrid()
                    : _displayedProducts.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: GridView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(16),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: _displayedProducts.length +
                                  (_isLoadingMore ? 2 : 0),
                              itemBuilder: (context, index) {
                                if (index >= _displayedProducts.length) {
                                  return SkeletonCardWidget();
                                }

                                final product = _displayedProducts[index];
                                final productId = product["id"].toString();

                                return ProductCardWidget(
                                  product: product,
                                  isInWishlist:
                                      _wishlistItems.contains(productId),
                                  onTap: () => _onProductTap(product),
                                  onAddToCart: () => _onAddToCart(product),
                                  onWishlistToggle: () =>
                                      _onWishlistToggle(product),
                                  onShare: () => _onShareProduct(product),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => SkeletonCardWidget(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            size: 64,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedCategories.clear();
                _activeFilters.clear();
                _applyFilters();
              });
            },
            child: Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}
