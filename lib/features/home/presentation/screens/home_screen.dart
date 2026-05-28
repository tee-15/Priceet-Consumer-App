import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ────────────────────────────────────────────────
            _TopBar(),
            // ── Scrollable content ─────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                children: const [
                  _Section(title: 'Products', child: _ProductsRow()),
                  SizedBox(height: 24),
                  _Section(title: 'Cheapest Near You', child: _CheapestList()),
                  SizedBox(height: 24),
                  _Section(title: 'Nearby Retailers', child: _RetailersRow()),
                  SizedBox(height: 24),
                  _Section(title: 'Vouchers', child: _VouchersList()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
      ),
    );
  }
}

// ── Top bar ────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0x14000000))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Address row
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0x1A002367),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.location_on_rounded,
                          color: Color(0xFF002367), size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DELIVERY TO', style: TextStyle(
                          fontFamily: 'Outfit', fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF), letterSpacing: 0.55,
                        )),
                        SizedBox(height: 2),
                        Row(children: [
                          Text('Downtown, NY 10001', style: TextStyle(
                            fontFamily: 'Outfit', fontSize: 15,
                            fontWeight: FontWeight.w700, color: Color(0xFF1F2937),
                          )),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              size: 16, color: Color(0xFF6B7280)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              // Notification bell
              Stack(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        color: Color(0xFF1F2937), size: 22),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD90000),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Search bar
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: const [
                BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: const Row(
              children: [
                SizedBox(width: 16),
                Icon(Icons.search_rounded, color: Color(0xFF9CA3AF), size: 20),
                SizedBox(width: 10),
                Text('Search for products, stores...', style: TextStyle(
                  fontFamily: 'Outfit', fontSize: 14,
                  fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section wrapper ────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(
                fontFamily: 'Outfit', fontSize: 16,
                fontWeight: FontWeight.w700, color: Color(0xFF1F2937),
              )),
              const Text('View All', style: TextStyle(
                fontFamily: 'Outfit', fontSize: 13,
                fontWeight: FontWeight.w700, color: Color(0xFF002367),
              )),
            ],
          ),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

// ── Products ───────────────────────────────────────────────────────────────────

class _ProductsRow extends StatelessWidget {
  const _ProductsRow();

  static const _items = [
    (name: 'Long Grain White Rice', unit: '5kg',      price: '₦3,100', store: 'Shoprite',     image: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=400&fit=crop', badge: true),
    (name: 'Fry Vegetable Oil',     unit: '2 Litres', price: '₦1,850', store: 'Jumbo Market', image: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop', badge: false),
    (name: 'Whole Wheat Bread',     unit: '700g loaf',price: '₦620',   store: 'Pick n Pay',   image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=400&fit=crop', badge: false),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _items.map((p) => Container(
          width: 150,
          height: 225,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 1))],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Image.network(
                  p.image,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 110,
                    color: const Color(0xFFF3F4F6),
                    child: const Icon(Icons.shopping_bag_outlined, size: 40, color: Color(0xFF9CA3AF)),
                  ),
                ),
                if (p.badge)
                  Positioned(top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFD90000), borderRadius: BorderRadius.circular(10)),
                      child: const Text('Priceet', style: TextStyle(fontFamily: 'Outfit', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                    )),
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF111827)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(p.unit, style: const TextStyle(fontFamily: 'Outfit', fontSize: 11, color: Color(0xFF9CA3AF))),
                  const SizedBox(height: 4),
                  Text(p.price, style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF002367))),
                  const SizedBox(height: 2),
                  Text(p.store, style: const TextStyle(fontFamily: 'Outfit', fontSize: 10, color: Color(0xFF9CA3AF))),
                ]),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

// ── Cheapest Near You ──────────────────────────────────────────────────────────

class _CheapestList extends StatelessWidget {
  const _CheapestList();

  static const _items = [
    (name: 'Organic Whole Milk',  store: 'FreshMart',   price: '₦3,500', image: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&h=400&fit=crop'),
    (name: 'Artisan Sourdough',   store: 'City Grocers', price: '₦3,000', image: 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400&h=400&fit=crop'),
    (name: 'Fresh Strawberries',  store: 'MegaStore',    price: '₦5,000', image: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&h=400&fit=crop'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _items.map((item) => Container(
          height: 110,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Row(children: [
            const SizedBox(width: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.shopping_basket_outlined, size: 32, color: Color(0xFF9CA3AF)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.name, style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFF002367)),
                  const SizedBox(width: 4),
                  Text('at ${item.store}', style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
                ]),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Text(item.price, style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF002367), letterSpacing: -0.45)),
            ),
          ]),
        )).toList(),
      ),
    );
  }
}

// ── Nearby Retailers ───────────────────────────────────────────────────────────

class _RetailersRow extends StatelessWidget {
  const _RetailersRow();

  static const _items = [
    (name: 'FreshMart',    distance: '0.8 mi', rating: '4.8', color: Color(0xFF4CAF50)),
    (name: 'City Grocers', distance: '1.2 mi', rating: '4.5', color: Color(0xFF2196F3)),
    (name: 'MegaStore',    distance: '3.2 mi', rating: '4.2', color: Color(0xFFFF5722)),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _items.map((r) => Container(
          width: 150,
          height: 219,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4))],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Container(
                height: 128, color: r.color.withValues(alpha: 0.15),
                alignment: Alignment.center,
                child: Icon(Icons.store_rounded, size: 48, color: r.color),
              ),
              Positioned(bottom: 6, left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 4),
                    Text(r.rating, style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
                  ]),
                )),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.name, style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF6B7280)),
                  const SizedBox(width: 3),
                  Text(r.distance, style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
                ]),
              ]),
            ),
          ]),
        )).toList(),
      ),
    );
  }
}

// ── Vouchers ───────────────────────────────────────────────────────────────────

class _VouchersList extends StatelessWidget {
  const _VouchersList();

  static const _items = [
    (title: '90-days Vouchers', amount: '₦1,000,000.00', expiry: '45 Days Left', color: Color(0xFF0F172B)),
    (title: '30-days Vouchers', amount: '₦50,000',       expiry: 'Expiring 2d',  color: Color(0xFFD90000)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _items.map((v) => Container(
          height: 116,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 4, offset: Offset(0, 1))],
          ),
          child: Row(children: [
            const SizedBox(width: 16),
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: v.color, borderRadius: BorderRadius.circular(14)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(v.title, style: const TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                const SizedBox(height: 6),
                Text(v.amount, style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF002367))),
                const SizedBox(height: 4),
                Text(v.expiry, style: const TextStyle(fontFamily: 'Outfit', fontSize: 11, color: Color(0xFF9CA3AF))),
              ],
            )),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF9CA3AF)),
            ),
          ]),
        )).toList(),
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
                      Icon(_items[i].icon, size: 22,
                          color: isActive ? const Color(0xFF002367) : const Color(0xFF9CA3AF)),
                      const SizedBox(height: 4),
                      Text(_items[i].label, style: TextStyle(
                        fontFamily: 'Outfit', fontSize: 10,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? const Color(0xFF002367) : const Color(0xFF9CA3AF),
                      )),
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
