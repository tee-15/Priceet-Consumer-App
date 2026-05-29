import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.iconAsset,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.obscureText = false,
    this.inputFormatters,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? iconAsset;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.borderLight),
    );

    Widget? prefix;
    if (widget.prefixIcon != null) {
      prefix = widget.prefixIcon;
    } else if (widget.iconAsset != null) {
      prefix = Padding(
        padding: const EdgeInsets.all(17),
        child: SvgPicture.asset(
          widget.iconAsset!,
          width: 18,
          height: 18,
        ),
      );
    }

    Widget? suffix;
    if (widget.suffixIcon != null) {
      suffix = widget.suffixIcon;
    } else if (widget.obscureText) {
      suffix = Padding(
        padding: const EdgeInsets.only(right: 14),
        child: GestureDetector(
          onTap: () => setState(() => _obscureText = !_obscureText),
          child: Icon(
            _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 18,
            color: AppColors.lightText,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label.toUpperCase(), style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.hintText,
            filled: true,
            fillColor: AppColors.fieldBg,
            contentPadding: EdgeInsets.only(
              left: prefix != null ? 44 : 16,
              right: suffix != null ? 44 : 16,
              top: 14,
              bottom: 14,
            ),
            prefixIcon: prefix,
            prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 53),
            suffixIcon: suffix,
            suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 53),
            border: border,
            enabledBorder: border,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: AppColors.brandBlue, width: 1.5),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
