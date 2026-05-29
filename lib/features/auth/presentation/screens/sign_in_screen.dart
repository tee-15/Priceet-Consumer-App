import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/models/country.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/country_picker.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Country _selectedCountry = kCountries.first;
  bool _isLoading = false;

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
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Simulate API sign in delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  void _onForgotPassword() {
    Navigator.of(context).pushNamed('/forgot-password');
  }

  void _onSignUp() {
    Navigator.of(context).pushReplacementNamed('/signup');
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CountryPicker(
        selected: _selectedCountry,
        onSelect: (c) {
          Navigator.pop(context);
          setState(() => _selectedCountry = c);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, topPadding + 14, 16, 14),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priceet logo icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.greyBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/icon_priceet_logo_signup.svg',
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandBlue,
                    height: 1.5,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Sign in to your Priceet account',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.brandBlue,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Form ────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phone number
                    AppTextField(
                      label: 'Phone Number',
                      hint: '801 234 5678',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter your phone number' : null,
                      prefixIcon: GestureDetector(
                        onTap: () => _showCountryPicker(context),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            border: Border(right: BorderSide(color: AppColors.borderLight)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 4),
                              Text(
                                _selectedCountry.dial,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  color: AppColors.darkText,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: AppColors.lightText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    AppTextField(
                      label: 'Password',
                      hint: 'Min. 6 characters',
                      controller: _passwordController,
                      obscureText: true,
                      iconAsset: 'assets/images/icon_lock.svg',
                      validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null,
                    ),
                    const SizedBox(height: 12),

                    // Forgot password
                    GestureDetector(
                      onTap: _onForgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandBlue,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Don't have an account
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              color: AppColors.greyText,
                              height: 1.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: _onSignUp,
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.brandBlue,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Sign In button ───────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: AppButton(
              label: 'Sign In',
              isLoading: _isLoading,
              onPressed: _onSignIn,
            ),
          ),
        ],
      ),
    );
  }
}
