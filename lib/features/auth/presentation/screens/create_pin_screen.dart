import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_button.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> with TickerProviderStateMixin {
  static const int _pinLength = 4;

  final FocusNode _focusNode = FocusNode();
  String _pin = '';
  String? _firstPin;
  bool _isConfirming = false;
  String? _errorMessage;

  // Shake animation controller for mismatch feedback
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

    // Auto-open keyboard on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    if (_pin.length >= _pinLength) return;
    setState(() {
      _pin += digit;
      _errorMessage = null;
    });
    if (_pin.length == _pinLength) _handleComplete();
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _handleComplete() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted) return;
      if (!_isConfirming) {
        setState(() {
          _firstPin = _pin;
          _pin = '';
          _isConfirming = true;
        });
        _focusNode.requestFocus();
      } else {
        if (_pin == _firstPin) {
          Navigator.of(context).pushReplacementNamed('/account-created');
        } else {
          // Trigger mismatch shake
          _shakeController.forward(from: 0.0);
          setState(() {
            _errorMessage = 'PINs do not match. Try again.';
            _pin = '';
            _isConfirming = false;
            _firstPin = null;
          });
          _focusNode.requestFocus();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isPinFull = _pin.length == _pinLength;

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      appBar: const AppBackBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
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
                    Text(
                      _isConfirming ? 'Confirm your PIN' : 'Create your PIN',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandBlue,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isConfirming
                          ? 'Re-enter your 4-digit PIN to confirm'
                          : 'Set a 4-digit PIN to secure your account',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Animated Shake and Scale PIN dots ─────────────────────────
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_shakeAnimation.value, 0),
                          child: child,
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_pinLength, (i) {
                          final filled = i < _pin.length;
                          return _PinDot(
                            filled: filled,
                            hasError: _errorMessage != null,
                          );
                        }),
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                    ],

                    // Hidden text field that captures keyboard input
                    SizedBox(
                      width: 0,
                      height: 0,
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (e) {
                          if (e is! KeyDownEvent) return;
                          if (e.logicalKey == LogicalKeyboardKey.backspace) {
                            _onBackspace();
                          }
                        },
                        child: TextField(
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(_pinLength),
                          ],
                          onChanged: (v) {
                            final newDigits = v.replaceAll(RegExp(r'\D'), '');
                            if (newDigits.length > _pin.length) {
                              final added = newDigits.substring(_pin.length);
                              for (final ch in added.split('')) {
                                _onDigit(ch);
                              }
                            } else if (newDigits.length < _pin.length) {
                              setState(() => _pin = newDigits);
                            }
                          },
                          decoration: const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(color: Colors.transparent),
                          cursorColor: Colors.transparent,
                          showCursor: false,
                        ),
                      ),
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
            child: AppButton(
              label: 'Continue',
              isDisabled: !isPinFull,
              onPressed: _handleComplete,
            ),
          ),
        ],
      ),
    );
  }
}

class _PinDot extends StatefulWidget {
  const _PinDot({required this.filled, required this.hasError});
  final bool filled;
  final bool hasError;

  @override
  State<_PinDot> createState() => _PinDotState();
}

class _PinDotState extends State<_PinDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    if (widget.filled) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _PinDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filled != oldWidget.filled) {
      if (widget.filled) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse(from: 1.0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.hasError
              ? AppColors.error
              : widget.filled
                  ? AppColors.brandBlue
                  : const Color(0xFFE5E7EB),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: widget.hasError ? AppColors.error : AppColors.brandBlue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
