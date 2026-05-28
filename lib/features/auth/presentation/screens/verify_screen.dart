import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Dummy OTP — use 123456 in demo mode.
const String _dummyOtp = '123456';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 30;

  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  int _countdown = _resendSeconds;
  Timer? _timer;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown == 0) { t.cancel(); return; }
      setState(() => _countdown--);
    });
  }

  String get _enteredCode => _controllers.map((c) => c.text).join();

  void _onDigitEntered(int index, String value) {
    setState(() => _errorMessage = null);
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_enteredCode.length == _otpLength) _verify();
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verify() async {
    if (_enteredCode.length < _otpLength) return;
    setState(() { _isLoading = true; _errorMessage = null; });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (_enteredCode == _dummyOtp) {
      Navigator.of(context).pushReplacementNamed('/add-address');
    } else {
      setState(() => _errorMessage = 'Incorrect code. Please try again.');
      for (final c in _controllers) { c.clear(); }
      _focusNodes[0].requestFocus();
    }
  }

  void _resend() {
    if (_countdown > 0) return;
    for (final c in _controllers) { c.clear(); }
    _focusNodes[0].requestFocus();
    setState(() => _errorMessage = null);
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A new code has been sent.')),
    );
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
          // ── Top nav bar — back arrow + bottom border ─────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: topPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
            ),
            child: SizedBox(
              height: 53,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ── Priceet icon in grey box ─────────────────────
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
                    const SizedBox(height: 24),

                    // ── Title ────────────────────────────────────────
                    const Text(
                      'Enter verification code',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF002367),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Subtitle ─────────────────────────────────────
                    const Text(
                      'We sent a 6-digit code to your phone number',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── OTP boxes ────────────────────────────────────
                    Row(
                      children: List.generate(_otpLength, (i) {
                        final isLast = i == _otpLength - 1;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: isLast ? 0 : 14),
                            child: _OtpBox(
                              controller: _controllers[i],
                              focusNode: _focusNodes[i],
                              hasError: _errorMessage != null,
                              onChanged: (v) => _onDigitEntered(i, v),
                              onBackspace: () => _onBackspace(i),
                            ),
                          ),
                        );
                      }),
                    ),

                    // ── Error message ────────────────────────────────
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 16, color: Color(0xFFDC2626)),
                          const SizedBox(width: 6),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 13,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ── Resend ───────────────────────────────────────
                    GestureDetector(
                      onTap: _resend,
                      child: Text(
                        _countdown > 0
                            ? 'Resend Code (${_countdown}s)'
                            : 'Resend Code',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _countdown > 0
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF002367),
                          height: 1.5,
                        ),
                      ),
                    ),

                    // ── Demo hint ────────────────────────────────────
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFBFD0FF)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: Color(0xFF002367)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Demo mode: use code 123456 to verify.',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                color: Color(0xFF002367),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // ── Continue button ──────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verify,
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
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single OTP digit box ───────────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onBackspace,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (e) {
          if (e is KeyDownEvent &&
              e.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty) {
            onBackspace();
          }
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF002367),
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFDC2626)
                    : const Color(0x14000000),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFDC2626)
                    : const Color(0x14000000),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF002367),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
