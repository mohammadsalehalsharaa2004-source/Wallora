import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  // =====================================================
  // PRIVACY POLICY URL
  // =====================================================

  static final Uri _privacyPolicyUrl = Uri.parse(
    'https://YOUR-PRIVACY-POLICY-LINK.com',
  );

  // =====================================================
  // OPEN URL
  // =====================================================

  Future<void> _openPrivacyPolicy(
      BuildContext context,
      ) async {
    try {
      final opened = await launchUrl(
        _privacyPolicyUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && context.mounted) {
        _showError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context);
      }
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Unable to open Privacy Policy.',
        ),
      ),
    );
  }

  // =====================================================
  // PAGE
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B12),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Spacer(),

            // ===========================================
            // ICON
            // ===========================================

            Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                color: const Color(0xFF151822),
                borderRadius: BorderRadius.circular(28),

                border: Border.all(
                  color: Colors.white.withOpacity(0.07),
                ),
              ),

              child: const Icon(
                Icons.privacy_tip_outlined,
                size: 43,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 24),

            // ===========================================
            // TITLE
            // ===========================================

            const Text(
              'Your Privacy Matters',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Read the Wallora Privacy Policy to learn '
                  'how information, permissions, and services '
                  'are handled.',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 30),

            // ===========================================
            // OPEN BUTTON
            // ===========================================

            SizedBox(
              width: double.infinity,
              height: 56,

              child: ElevatedButton.icon(
                onPressed: () {
                  _openPrivacyPolicy(context);
                },

                icon: const Icon(
                  Icons.open_in_new_rounded,
                ),

                label: const Text(
                  'Open Privacy Policy',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(17),
                  ),
                ),
              ),
            ),

            const Spacer(),

            const Text(
              'Wallora • Version 1.0.0',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}