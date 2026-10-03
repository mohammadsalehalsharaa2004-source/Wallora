import 'dart:ui';

import 'package:flutter/material.dart';

import 'settings_pages/settings_page.dart';
import 'settings_pages/about_page.dart';
import 'settings_pages/privacy_policy_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _openPage(
      BuildContext context,
      Widget page,
      ) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 290,
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,

      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),

        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),

          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF11131C)
                  .withOpacity(0.88),

              border: Border(
                right: BorderSide(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),

            child: SafeArea(
              child: Column(
                children: [
                  // =====================================
                  // HEADER
                  // =====================================

                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                      22,
                      24,
                      22,
                      24,
                    ),

                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 27,
                          backgroundColor:
                          Color(0xFF6C3BFF),

                          child: Icon(
                            Icons.wallpaper_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),

                        SizedBox(width: 14),

                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              'Wallora',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              'Live Wallpapers',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: Colors.white.withOpacity(0.08),
                  ),

                  const SizedBox(height: 12),

                  // =====================================
                  // HOME
                  // =====================================

                  _DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  // =====================================
                  // SETTINGS
                  // =====================================

                  _DrawerItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {
                      _openPage(
                        context,
                        const SettingsPage(),
                      );
                    },
                  ),

                  // =====================================
                  // ABOUT
                  // =====================================

                  _DrawerItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About Wallora',
                    onTap: () {
                      _openPage(
                        context,
                        const AboutPage(),
                      );
                    },
                  ),

                  // =====================================
                  // PRIVACY
                  // =====================================

                  _DrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      _openPage(
                        context,
                        const PrivacyPolicyPage(),
                      );
                    },
                  ),

                  const Spacer(),

                  Divider(
                    color: Colors.white.withOpacity(0.08),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(20),

                    child: Column(
                      children: [
                        Text(
                          'Wallora',
                          style: TextStyle(
                            color: Colors.white38,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 11,
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
      ),
    );
  }
}

// =====================================================
// DRAWER ITEM
// =====================================================

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 14,
            ),

            child: Row(
              children: [
                Icon(
                  icon,
                  size: 23,
                  color: Colors.white70,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Colors.white30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}