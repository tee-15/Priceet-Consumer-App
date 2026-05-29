import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'voucher_detail_screen.dart';
import 'buy_voucher_screen.dart';

// ── Data model ─────────────────────────────────────────────────────────────────

class _Voucher {
  const _Voucher({
    required this.type,
    required this.totalAmount,
    required this.purchaseValue,
    required this.availableAmount,
    required this.lockedAmount,
    required this.usedAmount,
    required this.unlockedPercent,
    required this.unlocksTodayAmount,
    required this.expiryLabel,
    required this.headerColor,
  });

  final String type;
  final String totalAmount;
  final String purchaseValue;
  final String availableAmount;
  final String lockedAmount;
  final String usedAmount;
  final double unlockedPercent; // 0.0 – 1.0
  final String unlocksTodayAmount;
  final String expiryLabel;
  final Color headerColor;
}

const _vouchers = [
  _Voucher(
    type: '90-Day Voucher',
    totalAmount: '₦1,000,000',
    purchaseValue: '₦850,000',
    availableAmount: '₦200,000',
    lockedAmount: '₦650,000',
    usedAmount: '₦150,000',
    unlockedPercent: 0.35,
    unlocksTodayAmount: '₦10,000',
    expiryLabel: '45 Days Left',
    headerColor: Color(0xFF0F172B),
  ),
  _Voucher(
    type: '30-Day Voucher',
    totalAmount: '₦50,000',
    purchaseValue: '₦50,000',
    availableAmount: '₦7,500',
    lockedAmount: '₦2,500',
    usedAmount: '₦40,000',
    unlockedPercent: 0.95,
    unlocksTodayAmount: '₦2,500',
    expiryLabel: 'Expiring: 2d',
    headerColor: Color(0xFFD90000),
  ),
];

/// Maps each voucher index to its detail data
final _voucherDetails = [
  sampleVoucher90,
  sampleVoucher30,
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
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
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ── Navy summary banner ──────────────────────────
                _SummaryBanner(),
                const SizedBox(height: 0),
                // ── Buy Voucher card ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Transform.translate(
                    offset: const Offset(0, -24),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondary) =>
                                const BuyVoucherScreen(),
                            transitionsBuilder:
                                (context, animation, secondary, child) {
                              final slide = Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ));
                              return SlideTransition(
                                  position: slide, child: child);
                            },
                            transitionDuration:
                                const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      child: const _BuyVoucherCard(),
                    ),
                  ),
                ),
                // ── Your Vouchers header ─────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Transform.translate(
                    offset: const Offset(0, -16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'YOUR VOUCHERS',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF99A1AF),
                            letterSpacing: 1.2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text(
                            '2 ACTIVE',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF314158),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ── Voucher cards ────────────────────────────────
                ...List.generate(_vouchers.length, (index) {
                  final v = _vouchers[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondary) =>
                                VoucherDetailScreen(
                                    voucher: _voucherDetails[index]),
                            transitionsBuilder:
                                (context, animation, secondary, child) {
                              final slide = Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ));
                              return SlideTransition(
                                  position: slide, child: child);
                            },
                            transitionDuration:
                                const Duration(milliseconds: 380),
                          ),
                        );
                      },
                      child: _VoucherCard(voucher: v),
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
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
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF3F4F6).withValues(alpha: 0.8),
          ),
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
              padding: const EdgeInsets.all(10),
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
          const SizedBox(width: 12),
          const Text(
            'Vouchers',
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

// ── Summary banner ─────────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 164,
      decoration: const BoxDecoration(
        color: Color(0xFF002367),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Decorative glow circle
          Positioned(
            right: -20,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 49, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label row
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 14,
                      color: Color(0xFF90A1B9),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'TOTAL AVAILABLE VOUCHERS',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF90A1B9),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Amount
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '₦385,000 ',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.9,
                        height: 1.1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        'NGN',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF62748E),
                          letterSpacing: 1.0,
                        ),
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

// ── Buy Voucher card ───────────────────────────────────────────────────────────

class _BuyVoucherCard extends StatelessWidget {
  const _BuyVoucherCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Green icon pill
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFD0FAE5).withValues(alpha: 0.5),
              ),
            ),
            child: const Icon(
              Icons.add_card_rounded,
              size: 22,
              color: Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 16),
          // Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Buy Voucher',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                  letterSpacing: -0.23,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'GET UP TO 15% OFF',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A7282),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }
}

// ── Voucher card ───────────────────────────────────────────────────────────────

class _VoucherCard extends StatelessWidget {
  const _VoucherCard({required this.voucher});
  final _Voucher voucher;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFF3F4F6).withValues(alpha: 0.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 30,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // ── Coloured header ────────────────────────────────────
          _VoucherHeader(voucher: voucher),
          // ── White body ─────────────────────────────────────────
          _VoucherBody(voucher: voucher),
        ],
      ),
    );
  }
}

// ── Voucher header ─────────────────────────────────────────────────────────────

class _VoucherHeader extends StatelessWidget {
  const _VoucherHeader({required this.voucher});
  final _Voucher voucher;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: voucher.headerColor,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        children: [
          // Top row: type + amount | expiry badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: type label + amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.type.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFCAD5E2),
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      voucher.totalAmount,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Right: expiry badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      voucher.expiryLabel.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.10),
          ),
          // Bottom row: Purchase Value label + amount
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PURCHASE VALUE',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  voucher.purchaseValue,
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
        ],
      ),
    );
  }
}

// ── Voucher body ───────────────────────────────────────────────────────────────

class _VoucherBody extends StatelessWidget {
  const _VoucherBody({required this.voucher});
  final _Voucher voucher;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Available / Locked split card
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0CE5E7EB),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Available
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00BC7D),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'AVAILABLE NOW',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6A7282),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        voucher.availableAmount,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF009966),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFE5E7EB),
                ),
                // Locked
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'LOCKED',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF99A1AF),
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD1D5DC),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        voucher.lockedAmount,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF99A1AF),
                          letterSpacing: -0.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Progress labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D293D),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'USED: ${voucher.usedAmount}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF99A1AF),
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Text(
                '${(voucher.unlockedPercent * 100).toInt()}% UNLOCKED',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00BC7D),
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          _ProgressBar(percent: voucher.unlockedPercent),
          const SizedBox(height: 16),
          // Unlocks Today banner
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFDBEAFE).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lock_open_rounded,
                      size: 15,
                      color: Color(0xFF1447E6),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'UNLOCKS TODAY',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1447E6),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                Text(
                  voucher.unlocksTodayAmount.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1447E6),
                    letterSpacing: 0.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Progress bar ───────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.percent});
  final double percent; // 0.0 – 1.0

  @override
  Widget build(BuildContext context) {
    // Used (dark navy) | Unlocked (green) | Locked (grey)
    // percent = used + unlocked fraction; we show used as ~15% of unlocked
    final usedFraction = percent * 0.40;
    final unlockedFraction = percent - usedFraction;
    final lockedFraction = 1.0 - percent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Used — dark navy
            Flexible(
              flex: (usedFraction * 1000).round(),
              child: Container(color: const Color(0xFF1D293D)),
            ),
            // Unlocked — green
            Flexible(
              flex: (unlockedFraction * 1000).round(),
              child: Container(color: const Color(0xFF00BC7D)),
            ),
            // Locked — light grey
            Flexible(
              flex: (lockedFraction * 1000).round(),
              child: Container(color: const Color(0xFFE5E7EB)),
            ),
          ],
        ),
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
