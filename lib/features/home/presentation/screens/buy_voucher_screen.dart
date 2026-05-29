import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Data ───────────────────────────────────────────────────────────────────────

class _VoucherType {
  const _VoucherType({
    required this.label,
    required this.badgeText,
    required this.badgeIsDiscount,
    required this.bullets,
    required this.discountPercent, // 0 = no discount
  });
  final String label;
  final String badgeText;
  final bool badgeIsDiscount;
  final List<String> bullets;
  final double discountPercent;
}

const _voucherTypes = [
  _VoucherType(
    label: '90-Day Voucher',
    badgeText: '15% DISCOUNT',
    badgeIsDiscount: true,
    discountPercent: 0.15,
    bullets: [
      '20% unlocks after Day 30',
      'Day 31–60: 1% unlocks daily',
      'Day 61+: 2% unlocks daily',
      'Valid for 90 days + 15 days grace',
    ],
  ),
  _VoucherType(
    label: '30-Day Voucher',
    badgeText: 'COST PRICE',
    badgeIsDiscount: false,
    discountPercent: 0.0,
    bullets: [
      '30% unlocks after Day 15',
      'Day 16+: 5% unlocks daily',
      'Valid for 30 days + 7 days grace',
    ],
  ),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class BuyVoucherScreen extends StatefulWidget {
  const BuyVoucherScreen({super.key});

  @override
  State<BuyVoucherScreen> createState() => _BuyVoucherScreenState();
}

class _BuyVoucherScreenState extends State<BuyVoucherScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final _amountController = TextEditingController(text: '100000');
  final _focusNode = FocusNode();

  // Entrance animations
  late final AnimationController _entranceCtrl;
  late final Animation<double> _sectionOneFade;
  late final Animation<Offset> _sectionOneSlide;
  late final Animation<double> _sectionTwoFade;
  late final Animation<Offset> _sectionTwoSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _sectionOneFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _entranceCtrl, curve: const Interval(0.0, 0.6)),
    );
    _sectionOneSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _entranceCtrl,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)),
    );

    _sectionTwoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _entranceCtrl, curve: const Interval(0.25, 0.8)),
    );
    _sectionTwoSlide =
        Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _entranceCtrl,
          curve: const Interval(0.25, 0.8, curve: Curves.easeOutCubic)),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _entranceCtrl, curve: const Interval(0.55, 1.0)),
    );
    _buttonSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _entranceCtrl,
          curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic)),
    );

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double get _faceValue {
    final raw = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(raw) ?? 0.0;
  }

  double get _youPay {
    final discount = _voucherTypes[_selectedIndex].discountPercent;
    return _faceValue * (1.0 - discount);
  }

  String _formatAmount(double amount) {
    if (amount <= 0) return '₦0';
    final s = amount.toStringAsFixed(0);
    // Insert commas
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buf.write(',');
      buf.write(s[i]);
      count++;
    }
    return '₦${buf.toString().split('').reversed.join()}';
  }

  String get _discountLabel {
    final pct = (_voucherTypes[_selectedIndex].discountPercent * 100).toInt();
    return pct > 0 ? 'YOU PAY ($pct% OFF)' : 'YOU PAY';
  }

  void _onSelectType(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                children: [
                  // ── Section 1: Choose Type ─────────────────────
                  FadeTransition(
                    opacity: _sectionOneFade,
                    child: SlideTransition(
                      position: _sectionOneSlide,
                      child: _buildSection1(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // ── Section 2: Enter Amount ────────────────────
                  FadeTransition(
                    opacity: _sectionTwoFade,
                    child: SlideTransition(
                      position: _sectionTwoSlide,
                      child: _buildSection2(),
                    ),
                  ),
                  SizedBox(height: bottom + 100),
                ],
              ),
            ),
            // ── Continue button (fixed bottom) ────────────────────
            FadeTransition(
              opacity: _buttonFade,
              child: SlideTransition(
                position: _buttonSlide,
                child: _buildContinueButton(bottom),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── App bar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: const Color(0xFFF3F4F6)),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 20,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
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
                  'Select Vouchers',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Section 1 ─────────────────────────────────────────────────────────────

  Widget _buildSection1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. CHOOSE TYPE',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B7280),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(_voucherTypes.length, (i) {
          final type = _voucherTypes[i];
          final isSelected = _selectedIndex == i;
          return Padding(
            padding: EdgeInsets.only(bottom: i < _voucherTypes.length - 1 ? 14 : 0),
            child: _VoucherTypeCard(
              type: type,
              isSelected: isSelected,
              onTap: () => _onSelectType(i),
            ),
          );
        }),
      ],
    );
  }

  // ── Section 2 ─────────────────────────────────────────────────────────────

  Widget _buildSection2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. ENTER AMOUNT',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B7280),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              // Face Value label
              const Text(
                'FACE VALUE',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              // Naira + amount input row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '₦',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: IntrinsicWidth(
                      child: TextField(
                        controller: _amountController,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          letterSpacing: -1.0,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Underline
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 16),
              // You Pay pill
              _YouPayPill(
                label: _discountLabel,
                amount: _formatAmount(_youPay),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }

  // ── Continue button ───────────────────────────────────────────────────────

  Widget _buildContinueButton(double bottomPadding) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24, 12, 24, 16 + bottomPadding),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: _faceValue > 0
              ? () {
                  // TODO: proceed to payment
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF002367),
            disabledBackgroundColor: const Color(0xFFD1D5DB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Voucher Type Card ──────────────────────────────────────────────────────────

class _VoucherTypeCard extends StatefulWidget {
  const _VoucherTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });
  final _VoucherType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_VoucherTypeCard> createState() => _VoucherTypeCardState();
}

class _VoucherTypeCardState extends State<_VoucherTypeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _pressScale = Tween<double>(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final type = widget.type;

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _pressScale,
        builder: (context, child) => Transform.scale(
          scale: _pressScale.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF0FDF8)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF00BC7D)
                  : const Color(0xFFE5E7EB),
              width: isSelected ? 2.0 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF00BC7D).withValues(alpha: 0.10)
                    : const Color(0x08000000),
                blurRadius: isSelected ? 20 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row + checkmark
              Row(
                children: [
                  Text(
                    type.label,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? const Color(0xFF111827)
                          : const Color(0xFF374151),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isSelected
                        ? Container(
                            key: const ValueKey('check'),
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00BC7D),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded,
                                size: 16, color: Colors.white),
                          )
                        : Container(
                            key: const ValueKey('empty'),
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFD1D5DB), width: 1.5),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: type.badgeIsDiscount
                      ? (isSelected
                          ? const Color(0xFF00BC7D).withValues(alpha: 0.15)
                          : const Color(0xFFE6FAF4))
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type.badgeText,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: type.badgeIsDiscount
                        ? const Color(0xFF00956A)
                        : const Color(0xFF6B7280),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Bullet list
              ...type.bullets.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.check_rounded,
                          size: 15,
                          color: isSelected
                              ? const Color(0xFF00BC7D)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          b,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF374151)
                                : const Color(0xFF6B7280),
                            height: 1.4,
                          ),
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
    );
  }
}

// ── You Pay Pill ───────────────────────────────────────────────────────────────

class _YouPayPill extends StatelessWidget {
  const _YouPayPill({required this.label, required this.amount});
  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF00BC7D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}
