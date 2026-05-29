import 'package:flutter/material.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final TextEditingController _aiController = TextEditingController();
  bool _isGenerating = false;

  final List<Map<String, dynamic>> _activeLists = [
    {
      'title': 'Weekly Family Groceries',
      'itemCount': 4,
      'estimatedTotal': 45000,
    },
    {
      'title': 'Nigerian Breakfast',
      'itemCount': 4,
      'estimatedTotal': 15000,
    },
    {
      'title': 'Nigerian Breakfast',
      'itemCount': 4,
      'estimatedTotal': 15000,
    },
  ];

  void _generateList() {
    if (_aiController.text.trim().isEmpty) return;
    setState(() => _isGenerating = true);
    FocusScope.of(context).unfocus();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _activeLists.insert(0, {
          'title': _aiController.text,
          'itemCount': 0,
          'estimatedTotal': 0,
        });
        _aiController.clear();
      });
    });
  }

  String _fmt(num amount) {
    return '₦${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Lists',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // AI Generation Input Box
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.auto_awesome, color: Color(0xFF6B7280), size: 20),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _aiController,
                        decoration: const InputDecoration(
                          hintText: 'Ask AI to create a shopping list...',
                          hintStyle: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            color: Color(0xFF9CA3AF),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          color: Color(0xFF1F2937),
                        ),
                        onSubmitted: (_) => _generateList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: _isGenerating ? null : _generateList,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BC7D),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: _isGenerating
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Active Lists Header
              const Text(
                'Active Lists',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              // Lists Display
              Expanded(
                child: ListView.builder(
                  itemCount: _activeLists.length,
                  itemBuilder: (context, index) {
                    final list = _activeLists[index];
                    return _buildListRow(list);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListRow(Map<String, dynamic> list) {
    return InkWell(
      onTap: () {
        // Will navigate to list details when that design is ready
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.receipt_long_rounded, color: Color(0xFF6B7280), size: 24),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BC7D),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    list['title'],
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${list['itemCount']} items • Est. ${_fmt(list['estimatedTotal'])}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF), size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
