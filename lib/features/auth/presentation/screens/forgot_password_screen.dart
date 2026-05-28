import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  // ignore: prefer_final_fields
  bool _isLoading = false;

  static final _emailRegex =
      RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');

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
    Navigator.of(context).pushNamed(
      '/check-email',
      arguments: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final hasEmail = _emailController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
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

          // ── Scrollable content ───────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Lock icon ──────────────────────────────────────
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

                    // ── Title ──────────────────────────────────────────
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Outfit', fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF002367), height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Subtitle ───────────────────────────────────────
                    const Text(
                      "No worries! Enter your email address and we'll send you a link to reset your password.",
                      style: TextStyle(
                        fontFamily: 'Outfit', fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280), height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Email label ────────────────────────────────────
                    const Text(
                      'EMAIL ADDRESS',
                      style: TextStyle(
                        fontFamily: 'Outfit', fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.6, height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Email input ────────────────────────────────────
                    TextFormField(
                      controller: _emailController,
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
                      style: const TextStyle(
                        fontFamily: 'Outfit', fontSize: 15,
                        color: Color(0xFF111827),
                      ),
                      decoration: InputDecoration(
                        hintText: 'amara@example.com',
                        hintStyle: const TextStyle(
                          fontFamily: 'Outfit', fontSize: 15,
                          color: Color(0x80111827),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 44, vertical: 14),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(17),
                          child: SvgPicture.asset(
                            'assets/images/icon_email.svg',
                            width: 18, height: 18,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 44, minHeight: 53),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF002367), width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFDC2626)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFDC2626), width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom bar ───────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Send Reset Link button
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: (_isLoading || !hasEmail) ? null : _onSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasEmail
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
                    child: _isLoading
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Send Reset Link', style: TextStyle(
                            fontFamily: 'Outfit', fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white, height: 1.4,
                          )),
                  ),
                ),
                const SizedBox(height: 24),

                // Back to Sign In
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Center(
                    child: Text(
                      'Back to Sign In',
                      style: TextStyle(
                        fontFamily: 'Outfit', fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280), height: 1.5,
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
