import 'package:flutter/material.dart';

// ── Filter state ───────────────────────────────────────────────────────────────

enum _SortOption { bestMatch, priceLowHigh, priceHighLow, distance }

enum _PriceRange { all, under25, from25to50, over50 }

// ── Entry point ────────────────────────────────────────────────────────────────

/// Shows the filter bottom sheet. Pass the search [controller] so the
/// input inside the sheet stays in sync with the search screen.
Future<void> showSearchFilterSheet(
  BuildContext context, {
  required TextEditingController controller,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _FilterSheet(controller: controller),
  );
}

// ── Sheet ──────────────────────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.controller});
  final TextEditingController controller;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  _SortOption _sort = _SortOption.bestMatch;
  _PriceRange _price = _PriceRange.all;

  void _reset() {
    setState(() {
      _sort = _SortOption.bestMatch;
      _price = _PriceRange.all;
    });
    widget.controller.clear();
  }

  void _apply() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Sheet card ─────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Color(0xF2FFFFFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 30,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(16, 14, 16, 24 + bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Search row ───────────────────────────────────────
                Row(
                  children: [
                    // Search input — fully typeable, shared controller
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6F8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.search_rounded,
                                size: 20, color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: widget.controller,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F2937),
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Search products...',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                textInputAction: TextInputAction.search,
                              ),
                            ),
                            // Clear X when text is present
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: widget.controller,
                              builder: (context, value, child) {
                                if (value.text.isEmpty) {
                                  return const SizedBox(width: 12);
                                }
                                return GestureDetector(
                                  onTap: () => widget.controller.clear(),
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 12),
                                    child: Icon(Icons.close_rounded,
                                        size: 18, color: Color(0xFF9CA3AF)),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Filter button — active state (navy)
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF002367),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26002367),
                            blurRadius: 12,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Cancel
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(color: Color(0xFFF3F4F6), height: 1),
                const SizedBox(height: 21),

                // ── Sort By ──────────────────────────────────────────
                const _FilterLabel(text: 'Sort By'),
                const SizedBox(height: 12),
                // Row 1: Best Match · Price: Low to High
                Row(
                  children: [
                    _SortChip(
                      label: 'Best Match',
                      icon: Icons.auto_awesome_rounded,
                      isActive: _sort == _SortOption.bestMatch,
                      activeColor: const Color(0xFF002367),
                      onTap: () =>
                          setState(() => _sort = _SortOption.bestMatch),
                    ),
                    const SizedBox(width: 8),
                    _SortChip(
                      label: 'Price: Low to High',
                      isActive: _sort == _SortOption.priceLowHigh,
                      activeColor: const Color(0xFF002367),
                      onTap: () =>
                          setState(() => _sort = _SortOption.priceLowHigh),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Row 2: Price: High to Low · Distance
                Row(
                  children: [
                    _SortChip(
                      label: 'Price: High to Low',
                      isActive: _sort == _SortOption.priceHighLow,
                      activeColor: const Color(0xFF002367),
                      onTap: () =>
                          setState(() => _sort = _SortOption.priceHighLow),
                    ),
                    const SizedBox(width: 8),
                    _SortChip(
                      label: 'Distance',
                      isActive: _sort == _SortOption.distance,
                      activeColor: const Color(0xFF002367),
                      onTap: () =>
                          setState(() => _sort = _SortOption.distance),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Price Range ──────────────────────────────────────
                const _FilterLabel(text: 'Price Range'),
                const SizedBox(height: 12),
                // Row 1: All Prices · Under ₦25 · ₦25 to ₦50
                Row(
                  children: [
                    _PriceChip(
                      label: 'All Prices',
                      isActive: _price == _PriceRange.all,
                      onTap: () => setState(() => _price = _PriceRange.all),
                    ),
                    const SizedBox(width: 8),
                    _PriceChip(
                      label: 'Under ₦25k',
                      isActive: _price == _PriceRange.under25,
                      onTap: () =>
                          setState(() => _price = _PriceRange.under25),
                    ),
                    const SizedBox(width: 8),
                    _PriceChip(
                      label: '₦25k–₦50k',
                      isActive: _price == _PriceRange.from25to50,
                      onTap: () =>
                          setState(() => _price = _PriceRange.from25to50),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Row 2: Over ₦50
                _PriceChip(
                  label: 'Over ₦50k',
                  isActive: _price == _PriceRange.over50,
                  onTap: () => setState(() => _price = _PriceRange.over50),
                ),

                const SizedBox(height: 24),

                // ── Action buttons ───────────────────────────────────
                Row(
                  children: [
                    // Reset
                    Expanded(
                      flex: 37,
                      child: GestureDetector(
                        onTap: _reset,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Apply Filters
                    Expanded(
                      flex: 63,
                      child: GestureDetector(
                        onTap: _apply,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF002367),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33002367),
                                blurRadius: 12,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
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

// ── Filter label ───────────────────────────────────────────────────────────────

class _FilterLabel extends StatelessWidget {
  const _FilterLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: Color(0xFF9CA3AF),
        letterSpacing: 0.65,
      ),
    );
  }
}

// ── Sort chip ──────────────────────────────────────────────────────────────────

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.10)
              : const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? activeColor.withValues(alpha: 0.30)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14,
                  color: isActive ? activeColor : const Color(0xFF6B7280)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isActive ? activeColor : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Price chip ─────────────────────────────────────────────────────────────────

class _PriceChip extends StatelessWidget {
  const _PriceChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  static const _activeColor = Color(0xFFD90000);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? _activeColor.withValues(alpha: 0.10)
              : const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? _activeColor.withValues(alpha: 0.30)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: _activeColor.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isActive ? _activeColor : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
