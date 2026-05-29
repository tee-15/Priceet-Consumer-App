import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  static final _emailRegex = RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');

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
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSend() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed(
          '/check-email',
          arguments: _emailController.text.trim(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final hasEmail = _emailController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBackBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.greyBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.lock_rounded,
                        color: AppColors.brandBlue,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandBlue,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "No worries! Enter your email address and we'll send you a link to reset your password.",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyText,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Email Address',
                      hint: 'amara@example.com',
                      controller: _emailController,
                      iconAsset: 'assets/images/icon_email.svg',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter your email address';
                        }
                        if (!_emailRegex.hasMatch(v.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Send Reset Link',
                  isLoading: _isLoading,
                  isDisabled: !hasEmail,
                  onPressed: _onSend,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Center(
                    child: Text(
                      'Back to Sign In',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
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
