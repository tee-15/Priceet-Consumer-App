import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_button.dart';

const String _dummyOtp = '123456';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> with TickerProviderStateMixin {
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

  // Shake animation controller for error feedback
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -10.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -8.0, end: 4.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 4.0, end: -4.0), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown == 0) {
        t.cancel();
        return;
      }
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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (_enteredCode == _dummyOtp) {
      Navigator.of(context).pushReplacementNamed('/add-address');
    } else {
      setState(() => _errorMessage = 'Incorrect code. Please try again.');
      // Trigger row shake
      _shakeController.forward(from: 0.0);
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  void _resend() {
    if (_countdown > 0) return;
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() => _errorMessage = null);
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A new code has been sent.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBackBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 24),
                    const Text(
                      'Enter verification code',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandBlue,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We sent a 6-digit code to your phone number',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Animated Shake container for OTP boxes ─────────────────
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_shakeAnimation.value, 0),
                          child: child,
                        );
                      },
                      child: Row(
                        children: List.generate(_otpLength, (i) {
                          final isLast = i == _otpLength - 1;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: isLast ? 0 : 10),
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
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                          const SizedBox(width: 6),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 13,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _resend,
                      child: Text(
                        _countdown > 0 ? 'Resend Code (${_countdown}s)' : 'Resend Code',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _countdown > 0 ? AppColors.lightText : AppColors.brandBlue,
                          height: 1.5,
                        ),
                      ),
                    ),
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
                          Icon(Icons.info_outline, size: 16, color: AppColors.brandBlue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Demo mode: use code 123456 to verify.',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                color: AppColors.brandBlue,
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
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: AppButton(
              label: 'Continue',
              isLoading: _isLoading,
              onPressed: _enteredCode.length == _otpLength ? _verify : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
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
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> with SingleTickerProviderStateMixin {
  late final AnimationController _popController;
  late final Animation<double> _popAnimation;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    );
    _popAnimation = CurvedAnimation(
      parent: _popController,
      curve: Curves.easeOutBack,
    );
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _popController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.controller.text.isNotEmpty) {
      _popController.forward(from: 0.9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (e) {
          if (e is KeyDownEvent &&
              e.logicalKey == LogicalKeyboardKey.backspace &&
              widget.controller.text.isEmpty) {
            widget.onBackspace();
          }
        },
        child: ScaleTransition(
          scale: _popAnimation,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: widget.onChanged,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.brandBlue,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.fieldBg,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: widget.hasError ? AppColors.error : AppColors.borderLight,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: widget.hasError ? AppColors.error : AppColors.borderLight,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: widget.hasError ? AppColors.error : AppColors.brandBlue,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
