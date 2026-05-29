import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBackBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBackBar({
    super.key,
    this.title,
    this.onBackPressed,
  });

  final String? title;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: topPadding),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 53,
        child: NavigationToolbar(
          leading: IconButton(
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.darkText,
            ),
          ),
          middle: title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandBlue,
                  ),
                )
              : null,
          centerMiddle: true,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(53);
}
