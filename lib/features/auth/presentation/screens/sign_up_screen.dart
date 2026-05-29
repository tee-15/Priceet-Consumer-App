import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/models/country.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/country_picker.dart';

enum _PasswordStrength { empty, weak, fair, strong }

_PasswordStrength _checkStrength(String password) {
  if (password.isEmpty) return _PasswordStrength.empty;
  if (password.length < 8) return _PasswordStrength.weak;
  final hasUpper = password.contains(RegExp(r'[A-Z]'));
  final hasDigit = password.contains(RegExp(r'[0-9]'));
  final hasSpecial = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  final score = (hasUpper ? 1 : 0) + (hasDigit ? 1 : 0) + (hasSpecial ? 1 : 0);
  if (score >= 2) return _PasswordStrength.strong;
  if (score == 1) return _PasswordStrength.fair;
  return _PasswordStrength.weak;
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Country _selectedCountry = kCountries.first;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  _PasswordStrength _passwordStrength = _PasswordStrength.empty;

  static final _emailRegex = RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    _passwordController.addListener(() {
      setState(() => _passwordStrength = _checkStrength(_passwordController.text));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please agree to the Terms of Service and Privacy Policy.'),
      ));
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed('/verify');
      }
    });
  }

  void _onSignIn() {
    Navigator.of(context).pushNamed('/signin');
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _SignUpHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Full Name',
                      hint: 'Amara Okafor',
                      controller: _nameController,
                      iconAsset: 'assets/images/icon_person.svg',
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter your full name' : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Email Address',
                      hint: 'amara@example.com',
                      controller: _emailController,
                      iconAsset: 'assets/images/icon_email.svg',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Enter your email address';
                        if (!_emailRegex.hasMatch(v.trim())) return 'Enter a valid email address';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
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
                    AppTextField(
                      label: 'Password',
                      hint: 'Min. 8 characters',
                      controller: _passwordController,
                      obscureText: true,
                      iconAsset: 'assets/images/icon_lock.svg',
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter a password';
                        if (v.length < 8) return 'Password must be at least 8 characters';
                        if (!v.contains(RegExp(r'[A-Z]')) &&
                            !v.contains(RegExp(r'[0-9]')) &&
                            !v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                          return 'Add at least one uppercase letter, number, or symbol';
                        }
                        return null;
                      },
                    ),
                    if (_passwordStrength != _PasswordStrength.empty) ...[
                      const SizedBox(height: 8),
                      _PasswordStrengthBar(strength: _passwordStrength),
                    ],
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Confirm Password',
                      hint: 'Re-enter password',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      iconAsset: 'assets/images/icon_lock.svg',
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Confirm your password';
                        if (v != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _TermsCheckbox(
                      value: _agreedToTerms,
                      onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // ── Bottom Bar ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Sign Up',
                  isLoading: _isLoading,
                  onPressed: _onSignUp,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have account? ',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: _onSignIn,
                      child: const Text(
                        'Sign In',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignUpHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPadding + 14, 16, 14),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: Color(0x1A002367))),
      ),
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
            child: SvgPicture.asset(
              'assets/images/icon_priceet_logo_signup.svg',
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create Account',
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
            'Join Priceet and start saving today',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.greyText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.strength});
  final _PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    final (label, color, filled) = switch (strength) {
      _PasswordStrength.weak => ('Weak', AppColors.error, 1),
      _PasswordStrength.fair => ('Fair', AppColors.warning, 2),
      _PasswordStrength.strong => ('Strong', AppColors.success, 3),
      _PasswordStrength.empty => ('', Colors.transparent, 0),
    };
    return Row(
      children: [
        ...List.generate(3, (i) => Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
            decoration: BoxDecoration(
              color: i < filled ? color : AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: const BorderSide(color: Color(0xFFD1D5DB), width: 2),
            activeColor: AppColors.brandBlue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.greyText,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "I agree to Priceet's "),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Terms of Service',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandBlue,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: ' and '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandBlue,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
