import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum StatusModalType { success, error }

class StatusModal extends StatefulWidget {
  const StatusModal({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.buttonText,
    this.onButtonPressed,
  });

  final StatusModalType type;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  /// Shows the status modal as a bottom sheet.
  /// Returns [true] if the user tapped the primary button, [null] if dismissed.
  static Future<bool?> show(
    BuildContext context, {
    required StatusModalType type,
    required String title,
    required String message,
    String buttonText = 'Continue',
    VoidCallback? onButtonPressed,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatusModal(
        type: type,
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
      ),
    );
  }

  @override
  State<StatusModal> createState() => _StatusModalState();
}

class _StatusModalState extends State<StatusModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.type == StatusModalType.success;
    final primaryColor = isSuccess ? const Color(0xFF00BC7D) : AppColors.brandRed;
    final bgColor = isSuccess ? const Color(0xFFE5F8F1) : const Color(0xFFFFEBEB);
    final icon = isSuccess ? Icons.check_circle_rounded : Icons.error_rounded;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          
          // Animated Icon
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Title
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          
          // Message
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          
          // Primary Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (widget.onButtonPressed != null) {
                  widget.onButtonPressed!();
                } else {
                  Navigator.of(context).pop(true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                widget.buttonText,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
