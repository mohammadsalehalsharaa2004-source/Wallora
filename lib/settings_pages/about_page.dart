import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B12),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'About Wallora',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          35,
        ),
        child: Column(
          children: [
            // ==========================================
            // LOGO
            // ==========================================

            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF6C3BFF),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C3BFF)
                        .withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.wallpaper_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),

            const SizedBox(height: 20),

            // ==========================================
            // APP NAME
            // ==========================================

            const Text(
              'Wallora',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Live Wallpapers',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 35),

            // ==========================================
            // ABOUT CARD
            // ==========================================

            _AboutCard(
              icon: Icons.auto_awesome_rounded,
              title: 'About',
              child: const Text(
                'Wallora brings animated live wallpapers '
                    'to your device with a simple and modern '
                    'experience. Explore different categories, '
                    'preview wallpapers, and set your favorite '
                    'animation as your live wallpaper.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ==========================================
            // FEATURES CARD
            // ==========================================

            const _AboutCard(
              icon: Icons.wallpaper_rounded,
              title: 'Wallora Features',
              child: Column(
                children: [
                  _FeatureRow(
                    icon: Icons.play_circle_outline_rounded,
                    text: 'Animated live wallpapers',
                  ),
                  SizedBox(height: 15),
                  _FeatureRow(
                    icon: Icons.category_outlined,
                    text: 'Multiple wallpaper categories',
                  ),
                  SizedBox(height: 15),
                  _FeatureRow(
                    icon: Icons.visibility_outlined,
                    text: 'Live wallpaper previews',
                  ),
                  SizedBox(height: 15),
                  _FeatureRow(
                    icon: Icons.touch_app_rounded,
                    text: 'Simple wallpaper setup',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ==========================================
            // FOOTER
            // ==========================================

            const Text(
              'Made for Wallora',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// ABOUT CARD
// =====================================================

class _AboutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _AboutCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151822),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white70,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// =====================================================
// FEATURE ROW
// =====================================================

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white54,
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}