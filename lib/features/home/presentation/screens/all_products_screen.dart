import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Product data model ─────────────────────────────────────────────────────────

enum _ProductOwner { priceet, retailer }

class _Product {
  const _Product({
    required this.name,
    required this.unit,
    required this.price,
    required this.originalPrice,
    required this.store,
    required this.image,
    required this.owner,
  });

  final String name;
  final String unit;
  final String price;
  final String? originalPrice; // null = no strikethrough
  final String store;
  final String image;
  final _ProductOwner owner;
}

// ── Product catalogue ──────────────────────────────────────────────────────────

const _products = [
  _Product(
    name: 'Long Grain White Rice',
    unit: '5kg',
    price: '₦3,100',
    originalPrice: '₦7,000',
    store: 'Shoprite',
    image: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=400&fit=crop',
    owner: _ProductOwner.priceet,
  ),
  _Product(
    name: 'Fry Vegetable Oil',
    unit: '2 Litres',
    price: '₦1,100',
    originalPrice: '₦3,000',
    store: 'Jumbo Market',
    image: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop',
    owner: _ProductOwner.priceet,
  ),
  _Product(
    name: 'Whole Wheat Bread',
    unit: '700g loaf',
    price: '₦620',
    originalPrice: '₦900',
    store: 'Pick n Pay',
    image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=400&fit=crop',
    owner: _ProductOwner.retailer,
  ),
  _Product(
    name: 'Organic Whole Milk',
    unit: '1 Litre',
    price: '₦3,500',
    originalPrice: null,
    store: 'FreshMart',
    image: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&h=400&fit=crop',
    owner: _ProductOwner.retailer,
  ),
  _Product(
    name: 'Fresh Strawberries',
    unit: '500g pack',
    price: '₦5,000',
    originalPrice: '₦6,500',
    store: 'MegaStore',
    image: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&h=400&fit=crop',
    owner: _ProductOwner.priceet,
  ),
  _Product(
    name: 'Artisan Sourdough',
    unit: '800g loaf',
    price: '₦3,000',
    originalPrice: null,
    store: 'City Grocers',
    image: 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400&h=400&fit=crop',
    owner: _ProductOwner.retailer,
  ),
  _Product(
    name: 'Basmati Rice',
    unit: '2kg',
    price: '₦2,400',
    originalPrice: '₦3,200',
    store: 'Shoprite',
    image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400&h=400&fit=crop',
    owner: _ProductOwner.priceet,
  ),
  _Product(
    name: 'Tomato Paste',
    unit: '400g tin',
    price: '₦850',
    originalPrice: null,
    store: 'Jumbo Market',
    image: 'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400&h=400&fit=crop',
    owner: _ProductOwner.retailer,
  ),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  int _currentTab = 0;
  _ProductOwner? _activeFilter; // null = show all

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  List<_Product> get _filtered {
    if (_activeFilter == null) return _products;
    return _products.where((p) => p.owner == _activeFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          _AppBar(onBack: () => Navigator.of(context).pop()),
          // ── Filter chips ─────────────────────────────────────────────
          _FilterBar(
            activeFilter: _activeFilter,
            onFilterChanged: (f) => setState(() => _activeFilter = f),
          ),
          // ── Grid ─────────────────────────────────────────────────────
          Expanded(
            child: _ProductGrid(products: _filtered),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
      ),
    );
  }
}

// ── App bar ────────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  const _AppBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: top + 10, bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        border: const Border(
          bottom: BorderSide(color: Color(0x14000000)),
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x05000000), blurRadius: 30, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Product',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter bar ─────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.activeFilter, required this.onFilterChanged});
  final _ProductOwner? activeFilter;
  final ValueChanged<_ProductOwner?> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isActive: activeFilter == null,
            onTap: () => onFilterChanged(null),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Priceet',
            isActive: activeFilter == _ProductOwner.priceet,
            onTap: () => onFilterChanged(_ProductOwner.priceet),
            isPriceet: true,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Retailers',
            isActive: activeFilter == _ProductOwner.retailer,
            onTap: () => onFilterChanged(_ProductOwner.retailer),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isPriceet = false,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isPriceet;

  @override
  Widget build(BuildContext context) {
    final activeColor = isPriceet ? const Color(0xFFD90000) : const Color(0xFF002367);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isActive ? activeColor : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

// ── Product grid ───────────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});
  final List<_Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: Color(0xFF9CA3AF),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 170 / 185,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => _ProductCard(product: products[index]),
    );
  }
}

// ── Product card ───────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final _Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 1)),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image + badge ──────────────────────────────────────────
          Stack(
            children: [
              Image.network(
                product.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 120,
                    color: const Color(0xFFF3F4F6),
                    child: const Center(
                      child: SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF002367),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: const Color(0xFFF3F4F6),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 36,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: _OwnerBadge(owner: product.owner, storeName: product.store),
              ),
            ],
          ),
          // ── Info ───────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.unit,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  // Price row — current + optional strikethrough
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF002367),
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          product.originalPrice!,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9CA3AF),
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    product.store,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Owner badge ────────────────────────────────────────────────────────────────

class _OwnerBadge extends StatelessWidget {
  const _OwnerBadge({required this.owner, required this.storeName});
  final _ProductOwner owner;
  final String storeName;

  @override
  Widget build(BuildContext context) {
    final isPriceet = owner == _ProductOwner.priceet;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: isPriceet
            ? const Color(0xFFD90000)
            : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: isPriceet
            ? null
            : Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isPriceet ? 0.18 : 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isPriceet) ...[
            const Icon(Icons.storefront_rounded, size: 10, color: Color(0xFF6B7280)),
            const SizedBox(width: 3),
          ],
          Text(
            isPriceet ? 'Priceet' : storeName,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isPriceet ? Colors.white : const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom nav ─────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.home_rounded,                    label: 'Home'),
    (icon: Icons.list_alt_rounded,                label: 'Lists'),
    (icon: Icons.shopping_cart_outlined,          label: 'Cart'),
    (icon: Icons.account_balance_wallet_outlined, label: 'Wallet'),
    (icon: Icons.person_outline_rounded,          label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final isActive = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 64,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _items[i].icon,
                        size: 22,
                        color: isActive
                            ? const Color(0xFF002367)
                            : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _items[i].label,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? const Color(0xFF002367)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
