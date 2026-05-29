import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/widgets/status_modal.dart';

// ── Data models ──────────────────────────────────────────────────────────────

class StorePrice {
  const StorePrice({
    required this.storeName,
    required this.distance,
    required this.price,
    required this.isBestPrice,
    required this.isOutOfStock,
    required this.logoIcon,
  });

  final String storeName;
  final String distance;
  final double price;
  final bool isBestPrice;
  final bool isOutOfStock;
  final IconData logoIcon;
}

// ── Screen ───────────────────────────────────────────────────────────────────

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.name,
    required this.image,
    required this.unit,
    required this.basePrice,
    required this.isPriceetProduct,
    required this.storeName,
  });

  final String name;
  final String image;
  final String unit;
  final double basePrice;
  final bool isPriceetProduct;
  final String storeName;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _bottomBarSlide;
  late final List<Animation<Offset>> _itemSlides;

  late final List<StorePrice> _stores;
  int? _selectedStoreIndex;
  int _quantity = 1;
  @override
  void initState() {
    super.initState();
    _stores = _generateMockStores(widget.basePrice);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _bottomBarSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
    ));

    _itemSlides = List.generate(_stores.length, (i) {
      final start = 0.2 + (i * 0.1);
      final end = start + 0.4;
      return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, end > 1.0 ? 1.0 : end,
            curve: Curves.easeOutCubic),
      ));
    });

    _ctrl.forward();
  }

  List<StorePrice> _generateMockStores(double basePrice) {
    // Generate realistic variations around the base price
    return [
      StorePrice(
        storeName: 'FreshMart',
        distance: '0.8 mi',
        price: basePrice * 0.95, // 5% cheaper
        isBestPrice: true,
        isOutOfStock: false,
        logoIcon: Icons.storefront_rounded,
      ),
      StorePrice(
        storeName: 'City Grocers',
        distance: '1.2 mi',
        price: basePrice * 1.05, // 5% more expensive
        isBestPrice: false,
        isOutOfStock: false,
        logoIcon: Icons.local_grocery_store_rounded,
      ),
      StorePrice(
        storeName: 'MegaStore',
        distance: '3.5 mi',
        price: basePrice * 1.15,
        isBestPrice: false,
        isOutOfStock: false,
        logoIcon: Icons.shopping_basket_rounded,
      ),
      StorePrice(
        storeName: 'Spar',
        distance: '4.2 mi',
        price: basePrice * 1.5,
        isBestPrice: false,
        isOutOfStock: true,
        logoIcon: Icons.shopping_cart_rounded,
      ),
    ];
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _fmt(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    int c = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (c > 0 && c % 3 == 0) buf.write(',');
      buf.write(s[i]);
      c++;
    }
    return '₦${buf.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildProductInfo()),
          if (widget.isPriceetProduct) ...[
            SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: const Text(
                  'Price Comparison',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 40, // reduced padding since we use bottomNavigationBar
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final store = _stores[index];
                  return FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _itemSlides[index],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: store.isOutOfStock
                              ? null
                              : () {
                                  setState(() {
                                    _selectedStoreIndex = index;
                                  });
                                },
                          child: _StoreCard(
                            store: store,
                            fmtFn: _fmt,
                            isSelected: _selectedStoreIndex == index,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: _stores.length,
              ),
            ),
          ),
          ],
          if (!widget.isPriceetProduct) ...[
            SliverToBoxAdapter(child: _buildRetailerExtraInfo()),
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 40,
              ),
            ),
          ],
        ],
      ),
      // Bottom Actions moved to bottomNavigationBar for guaranteed rendering
      bottomNavigationBar: ClipRect(
        child: SlideTransition(
          position: _bottomBarSlide,
          child: _buildBottomActions(context),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.image,
              fit: BoxFit.cover,
            ),
            // Gradient overlay at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.isPriceetProduct ? const Color(0xFF00BC7D) : const Color(0xFF0F172B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.isPriceetProduct ? 'Priceet' : widget.storeName,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Premium ${widget.name.toLowerCase()} perfect for your daily meals, sourced from trusted local farms.',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _fmt(widget.basePrice),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF00BC7D),
                  ),
                ),
                if (widget.isPriceetProduct) ...[
                  const SizedBox(width: 12),
                  Text(
                    _fmt(widget.basePrice * 1.5),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                Text(
                  widget.unit,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRetailerExtraInfo() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Seller Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: const [
                  BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.storefront_rounded, color: Color(0xFF9CA3AF), size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sold by',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.storeName,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // ── Creative Premium Section: Customer Reviews & Distribution ──
            const Text(
              'Customer Reviews',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: const [
                  BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side: Large Score
                  Column(
                    children: [
                      const Text(
                        '4.8',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          height: 1.0,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                            color: const Color(0xFFFBBF24),
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '1,284 ratings',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Right side: Progress bars
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar(5, 0.85),
                        const SizedBox(height: 6),
                        _buildRatingBar(4, 0.10),
                        const SizedBox(height: 6),
                        _buildRatingBar(3, 0.03),
                        const SizedBox(height: 6),
                        _buildRatingBar(2, 0.01),
                        const SizedBox(height: 6),
                        _buildRatingBar(1, 0.01),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int star, double percent) {
    return Row(
      children: [
        Text(
          '$star',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4B5563),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFBBF24)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final finalPrice = widget.isPriceetProduct
        ? (_selectedStoreIndex != null ? _stores[_selectedStoreIndex!].price : widget.basePrice)
        : widget.basePrice;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      icon: const Icon(Icons.remove_rounded, size: 18),
                      color: const Color(0xFF1F2937),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                    SizedBox(
                      width: 24,
                      child: Text(
                        '$_quantity',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      color: const Color(0xFF1F2937),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      if (widget.isPriceetProduct && _selectedStoreIndex == null) {
                        StatusModal.show(
                          context,
                          type: StatusModalType.error,
                          title: 'No Store Selected',
                          message: 'Please select a store price from the list first.',
                          buttonText: 'Okay',
                        );
                      } else {
                        final storeTitle = widget.isPriceetProduct
                            ? _stores[_selectedStoreIndex!].storeName
                            : widget.storeName;
                        StatusModal.show(
                          context,
                          type: StatusModalType.success,
                          title: 'Added to List',
                          message: '$_quantity x ${widget.name} from $storeTitle has been added to your shopping list.',
                          buttonText: 'Continue',
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Add to List',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.isPriceetProduct && _selectedStoreIndex == null) {
                        StatusModal.show(
                          context,
                          type: StatusModalType.error,
                          title: 'No Store Selected',
                          message: 'Please select a store price from the list to add to cart.',
                          buttonText: 'Okay',
                        );
                      } else {
                        final storeTitle = widget.isPriceetProduct
                            ? _stores[_selectedStoreIndex!].storeName
                            : widget.storeName;
                        StatusModal.show(
                          context,
                          type: StatusModalType.success,
                          title: 'Added to Cart',
                          message: '$_quantity x ${widget.name} from $storeTitle was added to your cart for ${_fmt(finalPrice * _quantity)}.',
                          buttonText: 'Checkout',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002367),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add to Cart - ${_fmt(finalPrice * _quantity)}',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Store Card ───────────────────────────────────────────────────────────────

class _StoreCard extends StatelessWidget {
  const _StoreCard({
    required this.store,
    required this.fmtFn,
    required this.isSelected,
  });

  final StorePrice store;
  final String Function(double) fmtFn;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: const Color(0xFF00BC7D), width: 2.0)
            : store.isBestPrice
                ? Border.all(color: const Color(0xFF00BC7D).withValues(alpha: 0.3), width: 1.5)
                : Border.all(color: Colors.transparent, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 15,
            offset: Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(store.logoIcon, color: const Color(0xFF4B5563), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.storeName,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 14, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(
                      store.distance,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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
                fmtFn(store.price),
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: store.isOutOfStock
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF111827),
                  decoration: store.isOutOfStock
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              if (store.isBestPrice)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_offer_rounded,
                          size: 12, color: Color(0xFF00BC7D)),
                      SizedBox(width: 4),
                      Text(
                        'Best Price',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF00BC7D),
                        ),
                      ),
                    ],
                  ),
                )
              else if (store.isOutOfStock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 12, color: Color(0xFFDC2626)),
                      SizedBox(width: 4),
                      Text(
                        'Out of stock',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
