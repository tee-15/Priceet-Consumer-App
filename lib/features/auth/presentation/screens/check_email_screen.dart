import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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

          // ── Centred content ──────────────────────────────────────────
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Green gradient circle with checkmark
                    Container(
                      width: 96, height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x4D16A34A),
                            blurRadius: 16,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Check your email',
                      style: TextStyle(
                        fontFamily: 'Outfit', fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF002367), height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle line 1
                    const Text(
                      "We've sent a password reset link to",
                      style: TextStyle(
                        fontFamily: 'Outfit', fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280), height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Email address (bold, brand blue)
                    Text(
                      email,
                      style: const TextStyle(
                        fontFamily: 'Outfit', fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF002367), height: 1.5,
                      ),
                      textAlign: TextAlign.center,
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
                // Back to Sign In button
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/signin', (route) => false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002367),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Back to Sign In', style: TextStyle(
                      fontFamily: 'Outfit', fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white, height: 1.4,
                    )),
                  ),
                ),
                const SizedBox(height: 24),

                // Try a different email
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Center(
                    child: Text(
                      'Try a different email',
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
