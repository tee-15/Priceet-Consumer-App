import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  static const int _pinLength = 4;

  final FocusNode _focusNode = FocusNode();
  String _pin = '';
  String? _firstPin;
  bool _isConfirming = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    // Auto-open keyboard on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
    Future.delayed(const Duration(milliseconds: 120), () {
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
          // TODO: save PIN securely
          Navigator.of(context).pushReplacementNamed('/account-created');
        } else {
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
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isPinFull = _pin.length == _pinLength;

    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset keeps layout stable when keyboard opens
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top nav bar ──────────────────────────────────────────────
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
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 20, color: Color(0xFF111827)),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              // Tap anywhere to re-open keyboard
              onTap: () => _focusNode.requestFocus(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Lock icon ────────────────────────────────────
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF002367),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Title ────────────────────────────────────────
                    Text(
                      _isConfirming ? 'Confirm your PIN' : 'Create your PIN',
                      style: const TextStyle(
                        fontFamily: 'Outfit', fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF002367), height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Subtitle ─────────────────────────────────────
                    Text(
                      _isConfirming
                          ? 'Re-enter your 4-digit PIN to confirm'
                          : 'Set a 4-digit PIN to secure your account',
                      style: const TextStyle(
                        fontFamily: 'Outfit', fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280), height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── PIN dots (left-aligned) ───────────────────────
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_pinLength, (i) {
                        final filled = i < _pin.length;
                        final hasError = _errorMessage != null;
                        return Container(
                          margin: EdgeInsets.only(right: i < _pinLength - 1 ? 16 : 0),
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: hasError
                                  ? const Color(0xFFDC2626)
                                  : filled
                                      ? const Color(0xFF002367)
                                      : const Color(0xFFE5E7EB),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: filled
                              ? Container(
                                  width: 12, height: 12,
                                  decoration: BoxDecoration(
                                    color: hasError
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFF002367),
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                        );
                      }),
                    ),

                    // ── Error message ────────────────────────────────
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 16, color: Color(0xFFDC2626)),
                            const SizedBox(width: 6),
                            Text(_errorMessage!, style: const TextStyle(
                              fontFamily: 'Outfit', fontSize: 13,
                              color: Color(0xFFDC2626),
                            )),
                          ],
                        ),
                      ),
                    ],

                    // ── Hidden text field that captures keyboard input ─
                    SizedBox(
                      width: 0, height: 0,
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
                            // Sync any direct input (paste, autofill)
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

          // ── Continue button ──────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: isPinFull ? _handleComplete : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPinFull
                      ? const Color(0xFF002367)
                      : const Color(0xFFD1D5DB),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Continue', style: TextStyle(
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
}
