import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Data model ─────────────────────────────────────────────────────────────────

class _Retailer {
  const _Retailer({
    required this.name,
    required this.distance,
    required this.rating,
    required this.categories,
    required this.image,
  });

  final String name;
  final String distance;
  final String rating;
  final String categories;
  final String image;
}

const _retailers = [
  _Retailer(
    name: 'FreshMart',
    distance: '0.8 mi',
    rating: '4.8',
    categories: 'Grocery • Fresh Produce • Bakery',
    image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=300&fit=crop',
  ),
  _Retailer(
    name: 'City Grocers',
    distance: '1.2 mi',
    rating: '4.5',
    categories: 'Grocery • Fresh Produce • Bakery',
    image: 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=400&h=300&fit=crop',
  ),
  _Retailer(
    name: 'MegaStore',
    distance: '3.5 mi',
    rating: '4.2',
    categories: 'Grocery • Electronics • Clothing',
    image: 'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?w=400&h=300&fit=crop',
  ),
  _Retailer(
    name: 'Shoprite',
    distance: '0.5 mi',
    rating: '4.6',
    categories: 'Grocery • Fresh Produce • Deli',
    image: 'https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=400&h=300&fit=crop',
  ),
  _Retailer(
    name: 'Jumbo Market',
    distance: '1.8 mi',
    rating: '4.3',
    categories: 'Grocery • Bulk Foods • Organic',
    image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=300&fit=crop',
  ),
  _Retailer(
    name: 'Pick n Pay',
    distance: '2.1 mi',
    rating: '4.4',
    categories: 'Grocery • Fresh Produce • Bakery',
    image: 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=400&h=300&fit=crop',
  ),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class NearbyRetailersScreen extends StatefulWidget {
  const NearbyRetailersScreen({super.key});

  @override
  State<NearbyRetailersScreen> createState() => _NearbyRetailersScreenState();
}

class _NearbyRetailersScreenState extends State<NearbyRetailersScreen> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          _AppBar(onBack: () => Navigator.of(context).pop()),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _retailers.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final retailer = _retailers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RetailerDetailsScreen(
                          name: retailer.name,
                          image: retailer.image,
                          distance: retailer.distance,
                          rating: retailer.rating,
                        ),
                      ),
                    );
                  },
                  child: _RetailerCard(retailer: retailer),
                );
              },
            ),
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
      padding: EdgeInsets.only(
          top: top + 10, bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        border: const Border(
          bottom: BorderSide(color: Color(0x14000000)),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 30,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
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
            'Nearby Retailers',
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

// ── Retailer card ──────────────────────────────────────────────────────────────

class _RetailerCard extends StatelessWidget {
  const _RetailerCard({required this.retailer});
  final _Retailer retailer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Store image ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 112,
                height: 96,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      retailer.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF002367),
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.store_rounded,
                            size: 36,
                            color: Color(0xFF9CA3AF),
                          ),
                        );
                      },
                    ),
                    // Gradient overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.20),
                          ],
                        ),
                      ),
                    ),
                    // Star rating badge — bottom left
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        height: 19,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 10,
                              color: Color(0xFFFBBF24),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              retailer.rating,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ── Store info ───────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 22, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    retailer.name,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        retailer.distance,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    retailer.categories,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Chevron
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF9CA3AF),
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

  static const _navItems = [
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
            children: List.generate(_navItems.length, (i) {
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
                        _navItems[i].icon,
                        size: 22,
                        color: isActive
                            ? const Color(0xFF002367)
                            : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _navItems[i].label,
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
