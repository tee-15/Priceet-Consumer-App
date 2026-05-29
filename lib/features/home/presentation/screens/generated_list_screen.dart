import 'package:flutter/material.dart';

class GeneratedListScreen extends StatefulWidget {
  const GeneratedListScreen({super.key});

  @override
  State<GeneratedListScreen> createState() => _GeneratedListScreenState();
}

class _GeneratedListScreenState extends State<GeneratedListScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'Weekly food list');

  final List<String> _suggestions = [
    'Weekly food list',
    'Baby food items',
    'Party groceries',
    'Healthy breakfast',
    'Pasta dinner',
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Grains',
      'items': [
        {
          'id': '1',
          'title': 'Whole Wheat Bread',
          'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=150', // placeholder
          'isAvailable': true,
          'price': '₦2,200',
          'store': 'FreshMart',
          'needsStoreSelection': false,
          'quantity': 2,
        },
      ]
    },
    {
      'title': 'Proteins',
      'items': [
        {
          'id': '2',
          'title': 'Free Range Eggs (Dozen)',
          'image': 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?w=150',
          'isAvailable': true,
          'price': null,
          'store': null,
          'marketAvg': '₦3,500',
          'needsStoreSelection': true,
          'quantity': 1,
        },
        {
          'id': '3',
          'title': 'Chicken Breast (1kg)',
          'image': 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=150',
          'isAvailable': true,
          'price': null,
          'store': null,
          'marketAvg': '₦4,200',
          'needsStoreSelection': true,
          'quantity': 2,
        },
      ]
    },
    {
      'title': 'Vegetables',
      'items': [
        {
          'id': '4',
          'title': 'Fresh Tomatoes',
          'image': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=150',
          'isAvailable': true,
          'price': null,
          'store': null,
          'marketAvg': '₦1,500',
          'needsStoreSelection': true,
          'quantity': 3,
        },
      ]
    },
  ];

  void _updateQuantity(String categoryTitle, String itemId, int delta) {
    setState(() {
      for (var category in _categories) {
        if (category['title'] == categoryTitle) {
          for (var item in category['items']) {
            if (item['id'] == itemId) {
              int current = item['quantity'] as int;
              if (current + delta > 0) {
                item['quantity'] = current + delta;
              }
            }
          }
        }
      }
    });
  }

  void _removeItem(String categoryTitle, String itemId) {
    setState(() {
      for (var category in _categories) {
        if (category['title'] == categoryTitle) {
          (category['items'] as List).removeWhere((item) => item['id'] == itemId);
        }
      }
    });
  }

  void _selectStoreForItem(String categoryTitle, String itemId, String storeName, String price) {
    setState(() {
      for (var category in _categories) {
        if (category['title'] == categoryTitle) {
          for (var item in category['items']) {
            if (item['id'] == itemId) {
              item['store'] = storeName;
              item['price'] = price;
              item['needsStoreSelection'] = false;
            }
          }
        }
      }
    });
  }

  void _applyStoreToAll(String storeName) {
    setState(() {
      for (var category in _categories) {
        for (var item in category['items']) {
          if (item['needsStoreSelection'] == true) {
            item['store'] = storeName;
            // Generate a mock price based on market avg or fallback
            String baseStr = item['marketAvg'] ?? '₦3,000';
            item['price'] = baseStr; // Just use market avg for the mock
            item['needsStoreSelection'] = false;
          }
        }
      }
    });
  }

  void _showStoreSelectionSheet(String categoryTitle, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StoreSelectionSheet(
        item: item,
        onSelect: (store, price) {
          _selectStoreForItem(categoryTitle, item['id'], store, price);
          Navigator.pop(context);
        },
        onSelectForAll: (store) {
          _applyStoreToAll(store);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 120),
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 32),
              ..._categories.map((category) => _buildCategorySection(category)),
            ],
          ),
          // Sticky Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Return the generated list name to the AI Chat screen
                    Navigator.of(context).pop('Weekly food list');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002367),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add to List',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Color(0xFF1F2937), size: 20),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Priceet AI',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF00BC7D),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'Online',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF00BC7D),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz, color: Color(0xFF9CA3AF)),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0xFFE5E7EB), height: 1),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What do you want to cook or buy?',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF002367),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _suggestions.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(Map<String, dynamic> category) {
    final items = category['items'] as List;
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category['title'],
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF002367),
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildProductCard(category['title'], item)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProductCard(String categoryTitle, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item['image'],
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF002367),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeItem(categoryTitle, item['id']),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.delete_outline, color: Color(0xFF9CA3AF), size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (item['isAvailable'] == true)
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00BC7D),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Available nearby',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Price or Select Store button
                    if (item['needsStoreSelection'] == true)
                      GestureDetector(
                        onTap: () => _showStoreSelectionSheet(categoryTitle, item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Select Store',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['price'] ?? '',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF002367),
                            ),
                          ),
                          Text(
                            'at ${item['store'] ?? ''}',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    // Quantity
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _updateQuantity(categoryTitle, item['id'], -1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              child: Text(
                                '-',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '${item['quantity']}',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF002367),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _updateQuantity(categoryTitle, item['id'], 1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreSelectionSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(String store, String price) onSelect;
  final Function(String store) onSelectForAll;

  const _StoreSelectionSheet({
    required this.item,
    required this.onSelect,
    required this.onSelectForAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title and close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Compare Prices',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF002367),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20, color: Color(0xFF1F2937)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Product header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item['image'],
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF002367),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Market Avg: ${item['marketAvg'] ?? '₦0'}',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFF3F4F6), height: 1),
          const SizedBox(height: 24),
          // Store List
          _buildStoreItem(
            name: 'FreshMart',
            distance: '1.2km',
            price: '₦3,400',
            tag: 'BEST PRICE',
            tagColor: const Color(0xFFDC2626),
            tagBg: const Color(0xFFFEE2E2),
          ),
          const SizedBox(height: 16),
          _buildStoreItem(
            name: 'SuperSave',
            distance: '2.5km',
            price: '₦3,500',
          ),
          const SizedBox(height: 16),
          _buildStoreItem(
            name: 'LocalGrocer',
            distance: '0.8km',
            price: '₦3,650',
            tag: 'FASTEST',
            tagColor: const Color(0xFFDC2626),
            tagBg: const Color(0xFFFEE2E2),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreItem({
    required String name,
    required String distance,
    required String price,
    String? tag,
    Color? tagColor,
    Color? tagBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF002367),
                          ),
                        ),
                        if (tag != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: tagBg,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: tagColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text(
                          '$distance • Available',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF002367),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => onSelect(name, price),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002367),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(70, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),
          // Buy everything from this store
          Center(
            child: OutlinedButton.icon(
              onPressed: () => onSelectForAll(name),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF002367),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              icon: const Icon(Icons.shopping_bag_outlined, size: 16),
              label: Text(
                'Buy all list items from $name',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
