import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Data model ─────────────────────────────────────────────────────────────────

class PaymentArgs {
  const PaymentArgs({
    required this.voucherType,
    required this.faceValue,
    required this.discount,
    required this.totalToPay,
    required this.planLabel,
    required this.walletBalance,
  });

  final String voucherType;   // e.g. "90-Day Plan"
  final double faceValue;     // e.g. 100000
  final double discount;      // e.g. 0.15
  final double totalToPay;    // e.g. 85000
  final String planLabel;     // e.g. "90-day Plan"
  final double walletBalance; // e.g. 1500000
}

// ── Screen ─────────────────────────────────────────────────────────────────────

class ConfirmPaymentScreen extends StatefulWidget {
  const ConfirmPaymentScreen({super.key, required this.args});
  final PaymentArgs args;

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen>
    with SingleTickerProviderStateMixin {
  bool _isPaying = false;

  late final AnimationController _ctrl;
  late final Animation<double> _summaryFade;
  late final Animation<Offset> _summarySlide;
  late final Animation<double> _methodFade;
  late final Animation<Offset> _methodSlide;
  late final Animation<double> _disclaimerFade;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));

    _summaryFade = CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.0, 0.55));
    _summarySlide = Tween<Offset>(
            begin: const Offset(0, 0.07), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic)));

    _methodFade = CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.2, 0.7));
    _methodSlide = Tween<Offset>(
            begin: const Offset(0, 0.07), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic)));

    _disclaimerFade = CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.4, 0.85));

    _btnFade = CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.55, 1.0));
    _btnSlide = Tween<Offset>(
            begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic)));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

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

  bool get _hasSufficientFunds =>
      widget.args.walletBalance >= widget.args.totalToPay;

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final a = widget.args;
    final discountAmt = a.faceValue * a.discount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 20,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Confirm Purchase',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: [
                // ── Summary dark card ──────────────────────────────
                ClipRect(
                  child: FadeTransition(
                    opacity: _summaryFade,
                    child: SlideTransition(
                      position: _summarySlide,
                      child: _SummaryCard(
                        args: a,
                        discountAmt: discountAmt,
                        fmtFn: _fmt,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // ── Payment Method ─────────────────────────────────
                ClipRect(
                  child: FadeTransition(
                    opacity: _methodFade,
                    child: SlideTransition(
                      position: _methodSlide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PAYMENT METHOD',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF6B7280),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _WalletMethodCard(
                            balance: _fmt(a.walletBalance),
                            hasSufficientFunds: _hasSufficientFunds,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // ── Disclaimer ─────────────────────────────────────────
                FadeTransition(
                  opacity: _disclaimerFade,
                  child: const _DisclaimerCard(),
                ),
                SizedBox(height: bottom + 100),
              ],
            ),
          ),
          // ── Pay button ───────────────────────────────────────
          ClipRect(
            child: FadeTransition(
              opacity: _btnFade,
              child: SlideTransition(
                position: _btnSlide,
                child: _PayButton(
                  label: 'Pay ${_fmt(a.totalToPay)}',
                  enabled: _hasSufficientFunds && !_isPaying,
                  isLoading: _isPaying,
                  onTap: _handlePay,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePay() async {
    setState(() => _isPaying = true);
    // Simulate processing
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _isPaying = false);
    _showSuccessSheet();
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SuccessSheet(
        amount: _fmt(widget.args.totalToPay),
        planLabel: widget.args.planLabel,
        onDone: () {
          Navigator.of(ctx).pop();
          // Pop back to vouchers list
          Navigator.of(context)
              .popUntil((route) => route.isFirst || route.settings.name == '/vouchers');
        },
      ),
    );
  }
}

// ── App Bar ────────────────────────────────────────────────────────────────────

// _AppBar removed – inlined directly into Scaffold.appBar above

// ── Summary Dark Card ──────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.args,
    required this.discountAmt,
    required this.fmtFn,
  });

  final PaymentArgs args;
  final double discountAmt;
  final String Function(double) fmtFn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2E),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Decorative circle top-right
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Voucher Value header
                const Text(
                  'VOUCHER VALUE',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B8299),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  fmtFn(args.faceValue),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1.0,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  args.planLabel,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF00BC7D),
                  ),
                ),
                const SizedBox(height: 20),
                // Divider
                Container(height: 1, color: const Color(0xFF1E3352)),
                const SizedBox(height: 18),
                // Price row
                _SummaryRow(
                  label: 'Price',
                  value: fmtFn(args.faceValue),
                  labelColor: const Color(0xFF9BAFC4),
                  valueColor: const Color(0xFFD1D9E2),
                ),
                const SizedBox(height: 10),
                // Discount row
                if (args.discount > 0) ...[
                  _SummaryRow(
                    label:
                        '${(args.discount * 100).toInt()}% Discount',
                    value: '−${fmtFn(discountAmt)}',
                    labelColor: const Color(0xFF00BC7D),
                    valueColor: const Color(0xFF00BC7D),
                  ),
                  const SizedBox(height: 16),
                ],
                // Divider
                Container(height: 1, color: const Color(0xFF1E3352)),
                const SizedBox(height: 14),
                // Total row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total to Pay',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      fmtFn(args.totalToPay),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: labelColor,
            )),
        Text(value,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            )),
      ],
    );
  }
}

// ── Wallet Method Card ─────────────────────────────────────────────────────────

class _WalletMethodCard extends StatelessWidget {
  const _WalletMethodCard({
    required this.balance,
    required this.hasSufficientFunds,
  });
  final String balance;
  final bool hasSufficientFunds;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF00BC7D).withValues(alpha: 0.50),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BC7D).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          // Wallet icon box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              size: 22,
              color: Color(0xFF00BC7D),
            ),
          ),
          const SizedBox(width: 14),
          // Name + balance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Priceet Wallet',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                    children: [
                      const TextSpan(text: 'Bal: '),
                      TextSpan(
                        text: balance,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: hasSufficientFunds
                              ? const Color(0xFF374151)
                              : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Selected checkmark
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF00BC7D),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Disclaimer Card ────────────────────────────────────────────────────────────

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC7D7FE)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 20,
            color: Color(0xFF4F6DF5),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'By purchasing this voucher, you agree to the time-based unlock schedule and expiration rules. Bread purchases are excluded.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF374151),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pay Button ─────────────────────────────────────────────────────────────────

class _PayButton extends StatefulWidget {
  const _PayButton({
    required this.label,
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });
  final String label;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  State<_PayButton> createState() => _PayButtonState();
}

class _PayButtonState extends State<_PayButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _pressScale = Tween<double>(begin: 1.0, end: 0.97).animate(
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
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
      child: GestureDetector(
        onTapDown:
            widget.enabled ? (_) => _pressCtrl.forward() : null,
        onTapUp: widget.enabled
            ? (_) {
                _pressCtrl.reverse();
                widget.onTap();
              }
            : null,
        onTapCancel:
            widget.enabled ? () => _pressCtrl.reverse() : null,
        child: AnimatedBuilder(
          animation: _pressScale,
          builder: (context, child) => Transform.scale(
            scale: _pressScale.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? const Color(0xFF002367)
                  : const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(16),
              boxShadow: widget.enabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF002367)
                            .withValues(alpha: 0.30),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            child: widget.isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: widget.enabled
                            ? Colors.white
                            : const Color(0xFF9CA3AF),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Success Bottom Sheet ───────────────────────────────────────────────────────

class _SuccessSheet extends StatefulWidget {
  const _SuccessSheet({
    required this.amount,
    required this.planLabel,
    required this.onDone,
  });
  final String amount;
  final String planLabel;
  final VoidCallback onDone;

  @override
  State<_SuccessSheet> createState() => _SuccessSheetState();
}

class _SuccessSheetState extends State<_SuccessSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scaleFade = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 32, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          // Animated checkmark
          ScaleTransition(
            scale: _scaleFade,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFF00BC7D).withValues(alpha: 0.3),
                    width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: Color(0xFF00BC7D),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Purchase Successful!',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your ${widget.planLabel} voucher worth ${widget.amount} has been activated.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: widget.onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BC7D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'View My Vouchers',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
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
}
