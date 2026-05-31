import 'package:flutter/material.dart';
import '../../../../core/state/cart_manager.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum OrderType { delivery, pickup }
enum VehicleType { motorcycle, car, minivan }
enum PaymentMethod { wallet, vouchers }

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Store states
  final Map<String, OrderType> _storeOrderTypes = {};
  final Map<String, VehicleType> _storeVehicles = {};

  PaymentMethod _paymentMethod = PaymentMethod.wallet;
  
  // Voucher state
  Map<String, dynamic>? _selectedVoucher;
  final List<Map<String, dynamic>> _mockVouchers = [
    {'title': '90 days', 'balance': '₦200,000', 'discount': 12500.0},
    {'title': '30 days', 'balance': '₦7,500', 'discount': 2500.0},
  ];

  // Address state
  String _currentAddress = '12, Adeola Odeku St, Victoria Island, Lagos';

  final Map<VehicleType, double> _vehicleFees = {
    VehicleType.motorcycle: 1500,
    VehicleType.car: 3000,
    VehicleType.minivan: 5000,
  };

  final Map<VehicleType, String> _vehicleNames = {
    VehicleType.motorcycle: 'Motorcycle',
    VehicleType.car: 'Car',
    VehicleType.minivan: 'Mini-Van',
  };
  
  final Map<VehicleType, IconData> _vehicleIcons = {
    VehicleType.motorcycle: Icons.two_wheeler_rounded,
    VehicleType.car: Icons.directions_car_rounded,
    VehicleType.minivan: Icons.airport_shuttle_rounded,
  };

  @override
  void initState() {
    super.initState();
    _initStoreStates();
  }

  void _initStoreStates() {
    final stores = CartManager.instance.groupedByStore();
    for (var store in stores) {
      final name = store['storeName'] as String;
      _storeOrderTypes[name] ??= OrderType.delivery;
      _storeVehicles[name] ??= VehicleType.motorcycle;
    }
  }

  String _fmt(double amount) {
    if (amount <= 0) return '₦0';
    final str = amount.toInt().toString();
    final result = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result.write(',');
      result.write(str[i]);
      count++;
    }
    return '₦${result.toString().split('').reversed.join()}';
  }

  double get _totalDeliveryFee {
    double total = 0.0;
    for (final store in CartManager.instance.groupedByStore()) {
      final name = store['storeName'] as String;
      if (_storeOrderTypes[name] == OrderType.delivery) {
        final vehicle = _storeVehicles[name] ?? VehicleType.motorcycle;
        total += _vehicleFees[vehicle] ?? 0.0;
      }
    }
    return total;
  }

  double get _subtotal => CartManager.instance.totalPrice;
  
  double get _discount {
    if (_paymentMethod == PaymentMethod.vouchers && _selectedVoucher != null) {
      return (_selectedVoucher?['discount'] as num?)?.toDouble() ?? 0.0;
    }
    return 0.0;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
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
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: CartManager.instance,
        builder: (context, _) {
          try {
            // ensure new stores added while here get states initialized
            _initStoreStates(); 
            final storeGroups = CartManager.instance.groupedByStore();

            if (storeGroups.isEmpty) {
              return const Center(child: Text("Cart is empty"));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ...storeGroups.map((store) => _buildStoreSection(store)),
                      
                      _buildSectionTitle('Delivery Address'),
                      const SizedBox(height: 12),
                      _buildAddressCard(),
                      const SizedBox(height: 24),

                      _buildSectionTitle('Payment Method'),
                      const SizedBox(height: 12),
                      _buildPaymentMethods(),
                      const SizedBox(height: 24),

                      _buildSectionTitle('Order Summary'),
                      const SizedBox(height: 12),
                      _buildOrderSummary(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                _buildBottomCheckoutBar(),
              ],
            );
          } catch (e, stack) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('ERROR:\n$e\n$stack', style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
            );
          }
        }
      ),
    );
  }

  Widget _buildStoreSection(Map<String, dynamic> storeData) {
    final storeName = storeData['storeName']?.toString() ?? 'Store';
    final orderType = _storeOrderTypes[storeName] ?? OrderType.delivery;
    final items = storeData['items'] as List<CartItem>? ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF002367).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.storefront_outlined, color: Color(0xFF002367), size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                storeName,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const Spacer(),
              const Icon(Icons.location_on, color: Color(0xFF9CA3AF), size: 12),
              const SizedBox(width: 4),
              Text(
                storeData['distance']?.toString() ?? '0.8 mi',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Cart Items
          ...items.map((item) => _buildCheckoutItem(item)),
          const SizedBox(height: 24),
          const Text(
            'Fulfillment Method',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          _buildOrderTypeToggle(storeName),
          
          if (orderType == OrderType.delivery) ...[
            const SizedBox(height: 16),
            const Text(
              'Select Vehicle',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 8),
            _buildVehicleSelection(storeName),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckoutItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(item.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        CartManager.instance.removeItem(item.id, item.storeName);
                      },
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFD1D5DB),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₦${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                      ),
                    ),
                    _buildQuantitySelector(item),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyButton(Icons.remove, () {
            CartManager.instance.updateQuantity(item.id, item.storeName, -1);
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ),
          _buildQtyButton(Icons.add, () {
            CartManager.instance.updateQuantity(item.id, item.storeName, 1);
          }),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Icon(
          icon,
          size: 16,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF111827),
      ),
    );
  }

  Widget _buildOrderTypeToggle(String storeName) {
    final currentType = _storeOrderTypes[storeName] ?? OrderType.delivery;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleItem(
              title: 'Delivery',
              icon: Icons.local_shipping_outlined,
              isSelected: currentType == OrderType.delivery,
              onTap: () => setState(() => _storeOrderTypes[storeName] = OrderType.delivery),
            ),
          ),
          Expanded(
            child: _buildToggleItem(
              title: 'Pickup',
              icon: Icons.shopping_bag_outlined,
              isSelected: currentType == OrderType.pickup,
              onTap: () => setState(() => _storeOrderTypes[storeName] = OrderType.pickup),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF002367) : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF002367) : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelection(String storeName) {
    final currentVehicle = _storeVehicles[storeName] ?? VehicleType.motorcycle;
    
    return Row(
      children: VehicleType.values.map((vType) {
        final isSelected = currentVehicle == vType;
        final fee = _vehicleFees[vType] ?? 0.0;
        
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _storeVehicles[storeName] = vType),
            child: Container(
              margin: EdgeInsets.only(right: vType == VehicleType.minivan ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEef2ff) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF002367) : const Color(0xFFE5E7EB),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _vehicleIcons[vType] ?? Icons.directions_car,
                    size: 24,
                    color: isSelected ? const Color(0xFF002367) : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _vehicleNames[vType] ?? '',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF002367) : const Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _fmt(fee),
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? const Color(0xFF002367) : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Color(0xFF4B5563), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentAddress,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _showAddAddressSheet,
              child: const Text(
                '+ Add/Change Address',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00BC7D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddAddressSheet() {
    final controller = TextEditingController(text: _currentAddress);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24, 
            right: 24, 
            top: 24, 
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter New Address',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g., 14, Broad Street, Marina',
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF002367)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        _currentAddress = controller.text.trim();
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002367),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Address',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentOption(
          method: PaymentMethod.wallet,
          title: 'Priceet Wallet',
          subtitle: 'Balance: ₦45,000',
          icon: Icons.account_balance_wallet,
          iconColor: const Color(0xFF002367),
          actionWidget: GestureDetector(
            onTap: () {}, // top up logic
            child: const Text(
              'Top Up',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00BC7D),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          method: PaymentMethod.vouchers,
          title: 'Pay with Voucher',
          subtitle: _selectedVoucher != null 
            ? '${_selectedVoucher?['title'] ?? ''} applied'
            : '${_mockVouchers.length} Available',
          icon: Icons.local_activity,
          iconColor: const Color(0xFFF59E0B),
        ),
        if (_paymentMethod == PaymentMethod.vouchers) ...[
          const SizedBox(height: 24),
          const Text(
            'Apply Voucher',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: _mockVouchers.asMap().entries.map((entry) {
                final idx = entry.key;
                final v = entry.value;
                return _buildVoucherItem(v, showDivider: idx != _mockVouchers.length - 1);
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVoucherItem(Map<String, dynamic> v, {required bool showDivider}) {
    final isSelected = _selectedVoucher == v;
    return GestureDetector(
      onTap: () => setState(() => _selectedVoucher = v),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: Colors.transparent,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF002367) : const Color(0xFFD1D5DB),
                      width: isSelected ? 6 : 2,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        v['title']?.toString() ?? '',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Bal: ${v['balance']}',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 1, color: Color(0xFFF3F4F6), indent: 16, endIndent: 16),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    Widget? actionWidget,
    bool showVoucherSelector = false,
  }) {
    final isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() => _paymentMethod = method);
        if (showVoucherSelector && _selectedVoucher == null) {
          _showVoucherSheet();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEef2ff) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF002367) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          color: isSelected && showVoucherSelector && _selectedVoucher != null 
                            ? const Color(0xFF00BC7D) 
                            : const Color(0xFF6B7280),
                          fontWeight: isSelected && showVoucherSelector && _selectedVoucher != null 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (actionWidget != null) ...[
                  actionWidget,
                  const SizedBox(width: 16),
                ],
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF002367) : const Color(0xFFD1D5DB),
                      width: isSelected ? 6 : 2,
                    ),
                  ),
                ),
              ],
            ),
            if (showVoucherSelector && isSelected) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFD1D5DB)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showVoucherSheet,
                child: Row(
                  children: const [
                    Text(
                      'Change Voucher',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF002367),
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down, color: Color(0xFF002367)),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _showVoucherSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select a Voucher',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, color: Color(0xFF4B5563)),
                  )
                ],
              ),
              const SizedBox(height: 16),
              ..._mockVouchers.map((v) {
                final isSel = _selectedVoucher == v;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedVoucher = v);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFFEef2ff) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSel ? const Color(0xFF002367) : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_activity, color: isSel ? const Color(0xFF002367) : const Color(0xFFF59E0B)),
                        const SizedBox(width: 12),
                        Text(
                          v['title'],
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isSel ? const Color(0xFF002367) : const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }
    );
  }

  double get _total {
    double raw = _subtotal + _totalDeliveryFee - _discount + _taxes;
    return raw < 0 ? 0 : raw;
  }

  double get _taxes {
    return _subtotal * 0.075; // 7.5% mock tax
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', _fmt(_subtotal)),
          const SizedBox(height: 12),
          _buildSummaryRow('Delivery Fee', _fmt(_totalDeliveryFee)),
          const SizedBox(height: 12),
          _buildSummaryRow('Smart Optimization Savings', '-${_fmt(_discount)}', isDiscount: true),
          const SizedBox(height: 12),
          _buildSummaryRow('Taxes', _fmt(_taxes)),
          
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                _fmt(_total),
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF002367),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDiscount ? const Color(0xFF00BC7D) : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCheckoutBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total Estimate',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                Text(
                  _fmt(_total),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Finalize payment action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002367),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
