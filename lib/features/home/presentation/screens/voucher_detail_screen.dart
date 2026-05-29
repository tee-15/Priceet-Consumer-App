import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Data models ────────────────────────────────────────────────────────────────

class VoucherDetail {
  const VoucherDetail({
    required this.title,
    required this.faceValue,
    required this.purchasePaid,
    required this.availableBalance,
    required this.lockedFunds,
    required this.nextUnlockAmount,
    required this.status,
    required this.purchaseDate,
    required this.currentDay,
    required this.totalDays,
    required this.progressPercent,
    required this.daysUntilGrace,
    required this.exclusionRule,
    required this.usageHistory,
    this.isExpiringSoon = false,
  });

  final String title;
  final String faceValue;
  final String purchasePaid;
  final String availableBalance;
  final String lockedFunds;
  final String nextUnlockAmount;
  final String status;
  final String purchaseDate;
  final int currentDay;
  final int totalDays;
  final double progressPercent; // 0.0 – 1.0
  final int daysUntilGrace;
  final String exclusionRule;
  final List<VoucherUsage> usageHistory;
  final bool isExpiringSoon;
}

class VoucherUsage {
  const VoucherUsage({
    required this.category,
    required this.date,
    required this.amount,
  });
  final String category;
  final String date;
  final String amount;
}

// ── Sample data ───────────────────────────────────────────────────────────────

final sampleVoucher90 = VoucherDetail(
  title: '90-Day Details',
  faceValue: '₦1,000,000',
  purchasePaid: '₦850,000',
  availableBalance: '₦200,000',
  lockedFunds: '₦650,000',
  nextUnlockAmount: '₦10,000',
  status: 'ACTIVE',
  purchaseDate: 'Mar 12, 2026',
  currentDay: 45,
  totalDays: 90,
  progressPercent: 0.35,
  daysUntilGrace: 45,
  exclusionRule: 'Bread items cannot be purchased using this voucher.',
  isExpiringSoon: false,
  usageHistory: const [
    VoucherUsage(
        category: 'Groceries', date: 'Apr 16, 3:03 PM', amount: '−₦50,000'),
    VoucherUsage(
        category: 'Electronics', date: 'Apr 24, 3:03 PM', amount: '−₦100,000'),
  ],
);

final sampleVoucher30 = VoucherDetail(
  title: '30-Day Details',
  faceValue: '₦50,000',
  purchasePaid: '₦50,000',
  availableBalance: '₦7,500',
  lockedFunds: '₦2,500',
  nextUnlockAmount: '₦2,500',
  status: 'ACTIVE',
  purchaseDate: 'Mar 29, 2026',
  currentDay: 28,
  totalDays: 30,
  progressPercent: 0.95,
  daysUntilGrace: 2,
  exclusionRule: 'Bread items cannot be purchased using this voucher.',
  isExpiringSoon: true,
  usageHistory: const [
    VoucherUsage(
        category: 'Snacks (No Bread)',
        date: 'Apr 21, 3:03 PM',
        amount: '−₦40,000'),
  ],
);

// ── Colors ─────────────────────────────────────────────────────────────────────
const _bgDark = Color(0xFF0D1B2E);
const _cardDark = Color(0xFF132238);
const _cardDarkBorder = Color(0xFF1E3352);
const _green = Color(0xFF00BC7D);
const _blueAccent = Color(0xFF4A80F0);
const _textMuted = Color(0xFF6B8299);
const _textWhite = Colors.white;

// ── Screen ─────────────────────────────────────────────────────────────────────

class VoucherDetailScreen extends StatefulWidget {
  const VoucherDetailScreen({super.key, this.voucher});
  final VoucherDetail? voucher;

  @override
  State<VoucherDetailScreen> createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final AnimationController _progressCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _progressAnim;

  VoucherDetail get _v => widget.voucher ?? sampleVoucher90;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    _fadeAnim =
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _progressAnim =
        CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOutCubic);
    _fadeCtrl.forward();
    Future.delayed(const Duration(milliseconds: 350),
        () { if (mounted) _progressCtrl.forward(); });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: _bgDark,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // ── Fixed dark top section ────────────────────────────
            _DarkTopSection(
              voucher: _v,
              topPadding: top,
            ),
            // ── White scrollable bottom sheet ─────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: ListView(
                  padding: const EdgeInsets.only(
                      top: 24, left: 16, right: 16, bottom: 40),
                  children: [
                    // Redemption Timeline
                    _TimelineCard(
                        voucher: _v, progressAnim: _progressAnim),
                    const SizedBox(height: 16),
                    // Exclusion Rule
                    _ExclusionCard(rule: _v.exclusionRule),
                    const SizedBox(height: 16),
                    // Usage History
                    _UsageHistorySection(history: _v.usageHistory),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dark top section ───────────────────────────────────────────────────────────
// Contains: appbar, face value, available/locked card, next unlock row

class _DarkTopSection extends StatelessWidget {
  const _DarkTopSection({
    required this.voucher,
    required this.topPadding,
  });
  final VoucherDetail voucher;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgDark,
      child: Stack(
        children: [
          // Decorative large circle top-right
          Positioned(
            right: -60,
            top: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.035),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: topPadding + 12, left: 20, right: 20, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── App Bar row ──────────────────────────────────
                Row(
                  children: [
                    _BackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 12),
                    Text(
                      voucher.title,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _textWhite,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // ── Face Value + Status ───────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: label + amount
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FACE VALUE',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _textMuted,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            voucher.faceValue,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: _textWhite,
                              letterSpacing: -0.8,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right: STATUS badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'STATUS',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _textMuted,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: _green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: _green.withValues(alpha: 0.50),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            voucher.status,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: _green,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // ── Available / Locked dark card ──────────────────
                Container(
                  decoration: BoxDecoration(
                    color: _cardDark,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _cardDarkBorder),
                  ),
                  child: Column(
                    children: [
                      // Available + Locked row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                        child: Row(
                          children: [
                            // Available Balance
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
                                          color: _green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'AVAILABLE BALANCE',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: _textMuted,
                                          letterSpacing: 0.7,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    voucher.availableBalance,
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: _green,
                                      letterSpacing: -0.5,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Vertical divider
                            Container(
                              width: 1,
                              height: 46,
                              color: _cardDarkBorder,
                            ),
                            const SizedBox(width: 16),
                            // Locked Funds
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'LOCKED FUNDS',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: _textMuted,
                                        letterSpacing: 0.7,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.25),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  voucher.lockedFunds,
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: _textWhite,
                                    letterSpacing: -0.4,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      Container(
                        height: 1,
                        color: _cardDarkBorder,
                      ),
                      // Next Unlock row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.trending_up_rounded,
                              size: 16,
                              color: _blueAccent,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'NEXT UNLOCK (TODAY)',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              voucher.nextUnlockAmount,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: _textWhite,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

// ── Back button ────────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}

// ── Redemption Timeline card ───────────────────────────────────────────────────

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.voucher,
    required this.progressAnim,
  });
  final VoucherDetail voucher;
  final Animation<double> progressAnim;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.date_range_rounded,
                  size: 17,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'REDEMPTION TIMELINE',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF374151),
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // ── Item 1: Purchased ─────────────────────────────────
          _TimelineRow(
            iconWidget: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_circle_rounded,
                  size: 20, color: Color(0xFF00BC7D)),
            ),
            showLine: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Purchased',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  voucher.purchaseDate,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Paid: ${voucher.purchasePaid}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Item 2: Current Progress ──────────────────────────
          _TimelineRow(
            iconWidget: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.show_chart_rounded,
                  size: 20, color: Color(0xFF4F6DF5)),
            ),
            showLine: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Current Progress',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: progressAnim,
                      builder: (context, child) => Text(
                        '${(voucher.progressPercent * 100 * progressAnim.value).toInt()}%',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4F6DF5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'DAY ${voucher.currentDay} OF ${voucher.totalDays}',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedBuilder(
                  animation: progressAnim,
                  builder: (context, child) => ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: voucher.progressPercent * progressAnim.value,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4F6DF5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Item 3: Expiry & Grace Period ─────────────────────
          _TimelineRow(
            iconWidget: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.timer_outlined,
                  size: 20, color: Color(0xFFF59E0B)),
            ),
            showLine: false,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expiry & Grace Period',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${voucher.daysUntilGrace} days until grace',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                if (voucher.isExpiringSoon) ...[  
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                    ),
                    child: const Text(
                      'EXPIRING SOON',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB45309),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single item row inside the timeline
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.iconWidget,
    required this.showLine,
    required this.content,
  });
  final Widget iconWidget;
  final bool showLine;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon column + connecting line
          SizedBox(
            width: 48,
            child: Column(
              children: [
                iconWidget,
                if (showLine)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: const Color(0xFFE5E7EB),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showLine ? 18 : 0, top: 4),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Exclusion Rule card ────────────────────────────────────────────────────────

class _ExclusionCard extends StatelessWidget {
  const _ExclusionCard({required this.rule});
  final String rule;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD6D6)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E4),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.shield_outlined,
                size: 17, color: Color(0xFFDC2626)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EXCLUSION RULE',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFDC2626),
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rule,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF374151),
                    height: 1.5,
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

// ── Usage History ──────────────────────────────────────────────────────────────

class _UsageHistorySection extends StatelessWidget {
  const _UsageHistorySection({required this.history});
  final List<VoucherUsage> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.history_rounded,
                  size: 17, color: Color(0xFF64748B)),
            ),
            const SizedBox(width: 10),
            const Text(
              'USAGE HISTORY',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF374151),
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Items card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Color(0xFFF3F4F6),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, i) =>
                _UsageHistoryRow(usage: history[i]),
          ),
        ),
      ],
    );
  }
}

class _UsageHistoryRow extends StatelessWidget {
  const _UsageHistoryRow({required this.usage});
  final VoucherUsage usage;

  static IconData _iconFor(String cat) {
    switch (cat.toLowerCase()) {
      case 'groceries':
        return Icons.shopping_basket_outlined;
      case 'electronics':
        return Icons.devices_outlined;
      case 'clothing':
        return Icons.checkroom_outlined;
      case 'food':
        return Icons.restaurant_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Icon(_iconFor(usage.category),
                size: 19, color: const Color(0xFF6B7280)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usage.category,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  usage.date,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Text(
            usage.amount,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
