import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ── Country model ──────────────────────────────────────────────────────────────

class _Country {
  const _Country({required this.name, required this.flag, required this.dial});
  final String name;
  final String flag;
  final String dial;
}

const List<_Country> _countries = [
  _Country(name: 'Nigeria', flag: '🇳🇬', dial: '+234'),
  _Country(name: 'Ghana', flag: '🇬🇭', dial: '+233'),
  _Country(name: 'Kenya', flag: '🇰🇪', dial: '+254'),
  _Country(name: 'South Africa', flag: '🇿🇦', dial: '+27'),
  _Country(name: 'United Kingdom', flag: '🇬🇧', dial: '+44'),
  _Country(name: 'United States', flag: '🇺🇸', dial: '+1'),
  _Country(name: 'Canada', flag: '🇨🇦', dial: '+1'),
  _Country(name: 'India', flag: '🇮🇳', dial: '+91'),
  _Country(name: 'France', flag: '🇫🇷', dial: '+33'),
  _Country(name: 'Germany', flag: '🇩🇪', dial: '+49'),
];

// ── Password strength helper ───────────────────────────────────────────────────

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

// ── Screen ─────────────────────────────────────────────────────────────────────

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

  _Country _selectedCountry = _countries.first;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _agreedToTerms = false;
  // ignore: prefer_final_fields
  bool _isLoading = false;
  _PasswordStrength _passwordStrength = _PasswordStrength.empty;

  // Email regex — RFC-5322 simplified
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
    Navigator.of(context).pushNamed('/verify');
  }

  void _onSignIn() {
    // TODO: navigate to sign in screen
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
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
                    _FormField(
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
                    _FormField(
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
                    _PhoneField(
                      controller: _phoneController,
                      selectedCountry: _selectedCountry,
                      onCountryChanged: (c) => setState(() => _selectedCountry = c),
                    ),
                    const SizedBox(height: 14),
                    _PasswordField(
                      label: 'Password',
                      hint: 'Min. 8 characters',
                      controller: _passwordController,
                      visible: _passwordVisible,
                      onToggle: () => setState(() => _passwordVisible = !_passwordVisible),
                      strength: _passwordStrength,
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
                    const SizedBox(height: 14),
                    _PasswordField(
                      label: 'Confirm Password',
                      hint: 'Re-enter password',
                      controller: _confirmPasswordController,
                      visible: _confirmPasswordVisible,
                      onToggle: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
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
          _BottomBar(
            isLoading: _isLoading,
            onSignUp: _onSignUp,
            onSignIn: _onSignIn,
            bottomPadding: bottomPadding,
          ),
        ],
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _SignUpHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPadding + 14, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0x1A002367))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/images/icon_priceet_logo_signup.svg', width: 32, height: 32),
          ),
          const SizedBox(height: 8),
          const Text('Create Account', style: TextStyle(
            fontFamily: 'Outfit', fontSize: 28, fontWeight: FontWeight.w700,
            color: Color(0xFF002367), height: 1.5, letterSpacing: -0.5,
          )),
          const SizedBox(height: 2),
          const Text('Join Priceet and start saving today', style: TextStyle(
            fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280), height: 1.5,
          )),
        ],
      ),
    );
  }
}

// ── Input decoration helper ────────────────────────────────────────────────────

InputDecoration _inputDecoration({
  required String hint,
  required Widget prefixIcon,
  Widget? suffixIcon,
}) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
    borderSide: BorderSide(color: Color(0x14000000)),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, color: Color(0x80111827)),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    contentPadding: const EdgeInsets.symmetric(horizontal: 44, vertical: 14),
    prefixIcon: prefixIcon,
    prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 53),
    suffixIcon: suffixIcon,
    suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 53),
    border: border,
    enabledBorder: border,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Color(0xFF002367), width: 1.5),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Color(0xFFDC2626)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Color(0xFFDC2626), width: 1.5),
    ),
  );
}

Widget _svgPrefix(String asset) => Padding(
  padding: const EdgeInsets.all(17),
  child: SvgPicture.asset(asset, width: 18, height: 18),
);

// ── Generic form field ─────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label, required this.hint,
    required this.controller, required this.iconAsset,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  final String label, hint, iconAsset;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
          style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, color: Color(0xFF111827)),
          decoration: _inputDecoration(
            hint: hint,
            prefixIcon: _svgPrefix(iconAsset),
          ),
        ),
      ],
    );
  }
}

// ── Password field with strength indicator ─────────────────────────────────────

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label, required this.hint,
    required this.controller, required this.visible,
    required this.onToggle, this.strength, this.validator,
  });

  final String label, hint;
  final TextEditingController controller;
  final bool visible;
  final VoidCallback onToggle;
  final _PasswordStrength? strength;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !visible,
          validator: validator,
          style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, color: Color(0xFF111827)),
          decoration: _inputDecoration(
            hint: hint,
            prefixIcon: _svgPrefix('assets/images/icon_lock.svg'),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: onToggle,
                child: Icon(
                  visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 18, color: const Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),
        ),
        if (strength != null && strength != _PasswordStrength.empty) ...[
          const SizedBox(height: 8),
          _PasswordStrengthBar(strength: strength!),
        ],
      ],
    );
  }
}

// ── Password strength bar ──────────────────────────────────────────────────────

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.strength});
  final _PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    final (label, color, filled) = switch (strength) {
      _PasswordStrength.weak   => ('Weak', const Color(0xFFDC2626), 1),
      _PasswordStrength.fair   => ('Fair', const Color(0xFFF59E0B), 2),
      _PasswordStrength.strong => ('Strong', const Color(0xFF16A34A), 3),
      _PasswordStrength.empty  => ('', Colors.transparent, 0),
    };
    return Row(
      children: [
        ...List.generate(3, (i) => Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
            decoration: BoxDecoration(
              color: i < filled ? color : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(
          fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w600, color: color,
        )),
      ],
    );
  }
}

// ── Phone field with country dropdown ─────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  final TextEditingController controller;
  final _Country selectedCountry;
  final ValueChanged<_Country> onCountryChanged;

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountryPicker(
        selected: selectedCountry,
        onSelect: (c) { Navigator.pop(context); onCountryChanged(c); },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Phone Number'),
        const SizedBox(height: 8),
        Row(
          children: [
            // Country selector button
            GestureDetector(
              onTap: () => _showPicker(context),
              child: Container(
                height: 53,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0x14000000)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Text(selectedCountry.dial, style: const TextStyle(
                      fontFamily: 'Outfit', fontSize: 14, color: Color(0xFF111827),
                    )),
                    const SizedBox(width: 2),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF9CA3AF)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, color: Color(0xFF111827)),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter your phone number' : null,
                decoration: _inputDecoration(
                  hint: '801 234 5678',
                  prefixIcon: _svgPrefix('assets/images/icon_phone.svg'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Country picker bottom sheet ────────────────────────────────────────────────

class _CountryPicker extends StatefulWidget {
  const _CountryPicker({required this.selected, required this.onSelect});
  final _Country selected;
  final ValueChanged<_Country> onSelect;

  @override
  State<_CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<_CountryPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _countries
        .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()) ||
            c.dial.contains(_query))
        .toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: Colors.white,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
            decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('Select Country', style: TextStyle(
            fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF002367),
          )),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search country...',
                hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 14, color: Color(0xFF9CA3AF)),
                prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
                filled: true, fillColor: const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x14000000))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x14000000))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF002367))),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 280,
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final c = filtered[i];
                final isSelected = c.dial == widget.selected.dial && c.name == widget.selected.name;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(c.name, style: const TextStyle(fontFamily: 'Outfit', fontSize: 15)),
                  trailing: Text(c.dial, style: const TextStyle(
                    fontFamily: 'Outfit', fontSize: 14, color: Color(0xFF6B7280),
                  )),
                  selected: isSelected,
                  selectedTileColor: const Color(0xFFF0F4FF),
                  onTap: () => widget.onSelect(c),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      ),
    );
  }
}

// ── Field label ────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w600,
      color: Color(0xFF6B7280), letterSpacing: 0.6, height: 1.5,
    ),
  );
}

// ── Terms checkbox ─────────────────────────────────────────────────────────────

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
          width: 20, height: 20,
          child: Checkbox(
            value: value, onChanged: onChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: const BorderSide(color: Color(0xFFD1D5DB), width: 2),
            activeColor: const Color(0xFF002367),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Outfit', fontSize: 13,
                  fontWeight: FontWeight.w500, color: Color(0xFF6B7280), height: 1.5),
              children: [
                const TextSpan(text: "I agree to Priceet's "),
                WidgetSpan(child: GestureDetector(
                  onTap: () {},
                  child: const Text('Terms of Service', style: TextStyle(
                    fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w600,
                    color: Color(0xFF002367), height: 1.5,
                  )),
                )),
                const TextSpan(text: ' and '),
                WidgetSpan(child: GestureDetector(
                  onTap: () {},
                  child: const Text('Privacy Policy', style: TextStyle(
                    fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w600,
                    color: Color(0xFF002367), height: 1.5,
                  )),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Bottom bar ─────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isLoading, required this.onSignUp,
    required this.onSignIn, required this.bottomPadding,
  });

  final bool isLoading;
  final VoidCallback onSignUp, onSignIn;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002367),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF002367).withValues(alpha: 0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: isLoading
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Sign Up', style: TextStyle(
                      fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700,
                      color: Colors.white, height: 1.4,
                    )),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have account? ', style: TextStyle(
                fontFamily: 'Outfit', fontSize: 14, color: Color(0xFF6B7280), height: 1.5,
              )),
              GestureDetector(
                onTap: onSignIn,
                child: const Text('Sign In', style: TextStyle(
                  fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w700,
                  color: Color(0xFF002367), height: 1.5,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
