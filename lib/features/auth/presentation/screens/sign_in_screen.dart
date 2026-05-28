import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ── Country model (same as sign up) ───────────────────────────────────────────

class _Country {
  const _Country({required this.name, required this.flag, required this.dial});
  final String name;
  final String flag;
  final String dial;
}

const List<_Country> _countries = [
  _Country(name: 'Nigeria',      flag: '🇳🇬', dial: '+234'),
  _Country(name: 'Ghana',        flag: '🇬🇭', dial: '+233'),
  _Country(name: 'Kenya',        flag: '🇰🇪', dial: '+254'),
  _Country(name: 'South Africa', flag: '🇿🇦', dial: '+27'),
  _Country(name: 'United Kingdom', flag: '🇬🇧', dial: '+44'),
  _Country(name: 'United States', flag: '🇺🇸', dial: '+1'),
  _Country(name: 'Canada',       flag: '🇨🇦', dial: '+1'),
  _Country(name: 'India',        flag: '🇮🇳', dial: '+91'),
  _Country(name: 'France',       flag: '🇫🇷', dial: '+33'),
  _Country(name: 'Germany',      flag: '🇩🇪', dial: '+49'),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  _Country _selectedCountry = _countries.first;
  bool _passwordVisible = false;
  // ignore: prefer_final_fields
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
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onForgotPassword() {
    Navigator.of(context).pushNamed('/forgot-password');
  }

  void _onSignUp() {
    Navigator.of(context).pushReplacementNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, topPadding + 14, 16, 14),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priceet logo icon
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/icon_priceet_logo_signup.svg',
                    width: 32, height: 32,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontFamily: 'Outfit', fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF002367), height: 1.5,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Sign in to your Priceet account',
                  style: TextStyle(
                    fontFamily: 'Outfit', fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF002367), height: 1.5,
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
                    _FieldLabel('Phone Number'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Country picker
                        GestureDetector(
                          onTap: () => _showCountryPicker(context),
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
                                Text(_selectedCountry.flag,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 4),
                                Text(_selectedCountry.dial,
                                    style: const TextStyle(
                                      fontFamily: 'Outfit', fontSize: 14,
                                      color: Color(0xFF111827),
                                    )),
                                const SizedBox(width: 2),
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 16, color: Color(0xFF9CA3AF)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Enter your phone number'
                                : null,
                            style: const TextStyle(
                              fontFamily: 'Outfit', fontSize: 15,
                              color: Color(0xFF111827),
                            ),
                            decoration: _inputDec(
                              hint: '801 234 5678',
                              prefixIcon: _svgPrefix(
                                  'assets/images/icon_phone.svg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Password
                    _FieldLabel('Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter your password'
                          : null,
                      style: const TextStyle(
                        fontFamily: 'Outfit', fontSize: 15,
                        color: Color(0xFF111827),
                      ),
                      decoration: _inputDec(
                        hint: 'Min. 6 characters',
                        prefixIcon: _svgPrefix('assets/images/icon_lock.svg'),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: GestureDetector(
                            onTap: () => setState(
                                () => _passwordVisible = !_passwordVisible),
                            child: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18, color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Forgot password
                    GestureDetector(
                      onTap: _onForgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Outfit', fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF002367),
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
                              fontFamily: 'Outfit', fontSize: 14,
                              color: Color(0xFF6B7280), height: 1.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: _onSignUp,
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'Outfit', fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF002367), height: 1.5,
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
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002367),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF002367).withValues(alpha: 0.6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Sign In', style: TextStyle(
                        fontFamily: 'Outfit', fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white, height: 1.4,
                      )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountryPicker(
        selected: _selectedCountry,
        onSelect: (c) {
          Navigator.pop(context);
          setState(() => _selectedCountry = c);
        },
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────────

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

Widget _svgPrefix(String asset) => Padding(
  padding: const EdgeInsets.all(17),
  child: SvgPicture.asset(asset, width: 18, height: 18),
);

InputDecoration _inputDec({
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
    hintStyle: const TextStyle(
      fontFamily: 'Outfit', fontSize: 15, color: Color(0x80111827)),
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
    final filtered = _countries.where((c) =>
        c.name.toLowerCase().contains(_query.toLowerCase()) ||
        c.dial.contains(_query)).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Country', style: TextStyle(
              fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700,
              color: Color(0xFF002367),
            )),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search country...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Outfit', fontSize: 14,
                    color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.search,
                      size: 18, color: Color(0xFF9CA3AF)),
                  filled: true, fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x14000000))),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x14000000))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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
                  final isSelected = c.name == widget.selected.name;
                  return ListTile(
                    leading: Text(c.flag,
                        style: const TextStyle(fontSize: 24)),
                    title: Text(c.name,
                        style: const TextStyle(
                          fontFamily: 'Outfit', fontSize: 15)),
                    trailing: Text(c.dial, style: const TextStyle(
                      fontFamily: 'Outfit', fontSize: 14,
                      color: Color(0xFF6B7280))),
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
