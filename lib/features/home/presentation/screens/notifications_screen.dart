import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Enums ──────────────────────────────────────────────────────────────────────

enum _NotifType { priceDrop, order, stock, promo, store }

enum _NotifFilter { all, unread, promos, orders }

// ── Model ──────────────────────────────────────────────────────────────────────

class _Notif {
  _Notif({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });

  final _NotifType type;
  final String title;
  final String body;
  final String time;
  bool isUnread;
}

// ── Data ───────────────────────────────────────────────────────────────────────

List<_Notif> _buildNotifs() => [
      _Notif(
        type: _NotifType.priceDrop,
        title: 'Massive Price Drop!',
        body: 'Premium Wagyu Beef just dropped by \$15 at FreshMart.',
        time: '2 mins ago',
        isUnread: true,
      ),
      _Notif(
        type: _NotifType.order,
        title: 'Order Delivered',
        body: 'Your grocery order from City Grocers has been successfully delivered.',
        time: '1 hour ago',
        isUnread: true,
      ),
      _Notif(
        type: _NotifType.stock,
        title: 'Back in Stock',
        body: "Organic Whole Milk is back in stock at MegaStore. Grab it before it's gone!",
        time: '5 hours ago',
        isUnread: false,
      ),
      _Notif(
        type: _NotifType.promo,
        title: 'Weekend Special',
        body: 'Get 20% off all fresh produce this weekend. Use code FRESH20.',
        time: '1 day ago',
        isUnread: false,
      ),
      _Notif(
        type: _NotifType.store,
        title: 'New Store Near You',
        body: 'A new organic market just opened 0.5 miles away. Check out their opening deals!',
        time: '2 days ago',
        isUnread: false,
      ),
    ];

// ── Screen ─────────────────────────────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Notif> _notifs = _buildNotifs();
  _NotifFilter _filter = _NotifFilter.all;

  int get _unreadCount => _notifs.where((n) => n.isUnread).length;

  List<_Notif> get _filtered {
    switch (_filter) {
      case _NotifFilter.all:
        return _notifs;
      case _NotifFilter.unread:
        return _notifs.where((n) => n.isUnread).toList();
      case _NotifFilter.promos:
        return _notifs
            .where((n) => n.type == _NotifType.priceDrop || n.type == _NotifType.promo)
            .toList();
      case _NotifFilter.orders:
        return _notifs.where((n) => n.type == _NotifType.order).toList();
    }
  }

  void _markAllRead() => setState(() {
        for (final n in _notifs) {
          n.isUnread = false;
        }
      });

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
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, top + 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back + title + mark read
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unread count badge
                    if (_unreadCount > 0)
                      Container(
                        height: 22,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD90000),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$_unreadCount',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const Spacer(),
                    // Mark Read
                    GestureDetector(
                      onTap: _markAllRead,
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF002367),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 11,
                              color: Color(0xFF002367),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Mark Read',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF002367),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterTab(
                        label: 'All',
                        isActive: _filter == _NotifFilter.all,
                        onTap: () => setState(() => _filter = _NotifFilter.all),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: 'Unread',
                        isActive: _filter == _NotifFilter.unread,
                        onTap: () => setState(() => _filter = _NotifFilter.unread),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: 'Promos',
                        isActive: _filter == _NotifFilter.promos,
                        onTap: () => setState(() => _filter = _NotifFilter.promos),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: 'Orders',
                        isActive: _filter == _NotifFilter.orders,
                        onTap: () => setState(() => _filter = _NotifFilter.orders),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── List ────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No notifications',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    itemCount: _filtered.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notif = _filtered[index];
                      return _NotifCard(
                        notif: notif,
                        onTap: () => setState(() => notif.isUnread = false),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Filter tab ─────────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF002367) : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isActive ? const Color(0xFF002367) : const Color(0xFFE5E7EB),
          ),
          boxShadow: isActive
              ? const [
                  BoxShadow(
                    color: Color(0x33002367),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

// ── Notification card ──────────────────────────────────────────────────────────

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.notif, required this.onTap});

  final _Notif notif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = notif.isUnread;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isUnread ? 1.0 : 0.82,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnread
                  ? const Color(0x1A002367)
                  : const Color(0xFFF3F4F6),
              width: 1,
            ),
            boxShadow: isUnread
                ? const [
                    BoxShadow(
                      color: Color(0x0F002367),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Icon pill ────────────────────────────────
                    _NotifIcon(type: notif.type),
                    const SizedBox(width: 14),
                    // ── Text ─────────────────────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title — right-padded to avoid dot overlap
                          Padding(
                            padding: EdgeInsets.only(
                              right: isUnread ? 18.0 : 0,
                            ),
                            child: Text(
                              notif.title,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: isUnread
                                    ? FontWeight.w800
                                    : FontWeight.w700,
                                color: isUnread
                                    ? const Color(0xFF1F2937)
                                    : const Color(0xFF4B5563),
                                letterSpacing: -0.4,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Body — wraps freely, no maxLines
                          Text(
                            notif.body,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6B7280),
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Timestamp
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: Color(0xFF9CA3AF),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                notif.time,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ── Unread dot — absolute top-right ──────────────────
              if (isUnread)
                Positioned(
                  top: 18,
                  right: 18,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD90000),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD90000).withValues(alpha: 0.45),
                          blurRadius: 8,
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

// ── Notification icon pill ─────────────────────────────────────────────────────

class _NotifIcon extends StatelessWidget {
  const _NotifIcon({required this.type});
  final _NotifType type;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color bg, Color fg) = switch (type) {
      _NotifType.priceDrop => (
          Icons.local_offer_outlined,
          const Color(0x1AD90000),
          const Color(0xFFD90000),
        ),
      _NotifType.order => (
          Icons.shopping_bag_outlined,
          const Color(0x1A10B981),
          const Color(0xFF10B981),
        ),
      _NotifType.stock => (
          Icons.notifications_outlined,
          const Color(0x1A002367),
          const Color(0xFF002367),
        ),
      _NotifType.promo => (
          Icons.local_offer_outlined,
          const Color(0x1AD90000),
          const Color(0xFFD90000),
        ),
      _NotifType.store => (
          Icons.storefront_outlined,
          const Color(0x1AF59E0B),
          const Color(0xFFF59E0B),
        ),
    };

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 22, color: fg),
    );
  }
}
