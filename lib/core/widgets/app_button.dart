import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.height = 52,
    this.borderRadius = 10,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double borderRadius;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      _scaleController.reverse();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      _scaleController.forward();
    }
  }

  void _handleTapCancel() {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      _scaleController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = widget.isDisabled || widget.onPressed == null || widget.isLoading;

    final defaultBgColor = widget.isOutlined
        ? Colors.transparent
        : (isButtonDisabled
            ? AppColors.divider
            : (widget.backgroundColor ?? AppColors.brandBlue));

    final defaultTextColor = widget.isOutlined
        ? (widget.textColor ?? AppColors.brandBlue)
        : (widget.textColor ?? AppColors.white);

    final borderSide = widget.isOutlined
        ? BorderSide(color: widget.textColor ?? AppColors.brandBlue, width: 1.5)
        : BorderSide.none;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: isButtonDisabled ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: defaultBgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.fromBorderSide(borderSide),
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                  ),
                )
              : Text(
                  widget.label,
                  style: AppTextStyles.buttonText.copyWith(
                    color: defaultTextColor,
                  ),
                ),
        ),
      ),
    );
  }
}
