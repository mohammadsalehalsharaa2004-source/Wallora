import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoplayPreviews = true;
  bool _mutePreviews = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B12),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          30,
        ),
        children: [
          // =============================================
          // GENERAL
          // =============================================

          const _SectionTitle(
            title: 'General',
          ),

          const SizedBox(height: 10),

          _SettingsContainer(
            children: [
              _SwitchSetting(
                icon: Icons.play_circle_outline_rounded,
                title: 'Autoplay Previews',
                subtitle:
                'Automatically play wallpaper previews',
                value: _autoplayPreviews,
                onChanged: (value) {
                  setState(() {
                    _autoplayPreviews = value;
                  });
                },
              ),

              const _SettingsDivider(),

              _SwitchSetting(
                icon: Icons.volume_off_rounded,
                title: 'Mute Preview Videos',
                subtitle:
                'Keep wallpaper previews silent',
                value: _mutePreviews,
                onChanged: (value) {
                  setState(() {
                    _mutePreviews = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 28),

          // =============================================
          // APP
          // =============================================

          const _SectionTitle(
            title: 'App',
          ),

          const SizedBox(height: 10),

          const _SettingsContainer(
            children: [
              _InfoSetting(
                icon: Icons.wallpaper_rounded,
                title: 'App',
                value: 'Wallora',
              ),

              _SettingsDivider(),

              _InfoSetting(
                icon: Icons.info_outline_rounded,
                title: 'Version',
                value: '1.0.0',
              ),
            ],
          ),

          const SizedBox(height: 28),

          // =============================================
          // STORAGE INFO
          // =============================================

          const _SectionTitle(
            title: 'Wallpapers',
          ),

          const SizedBox(height: 10),

          const _SettingsContainer(
            children: [
              _InfoSetting(
                icon: Icons.cloud_outlined,
                title: 'Wallpaper Source',
                value: 'Online',
              ),

              _SettingsDivider(),

              _InfoSetting(
                icon: Icons.hd_rounded,
                title: 'Wallpaper Type',
                value: 'Live',
              ),
            ],
          ),

          const SizedBox(height: 35),

          // =============================================
          // FOOTER
          // =============================================

          const Center(
            child: Column(
              children: [
                Icon(
                  Icons.wallpaper_rounded,
                  size: 30,
                  color: Colors.white24,
                ),

                SizedBox(height: 8),

                Text(
                  'Wallora',
                  style: TextStyle(
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Live Wallpapers',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 12,
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

// =====================================================
// SECTION TITLE
// =====================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
      ),

      child: Text(
        title,

        style: const TextStyle(
          color: Colors.white54,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// =====================================================
// SETTINGS CONTAINER
// =====================================================

class _SettingsContainer extends StatelessWidget {
  final List<Widget> children;

  const _SettingsContainer({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151822),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),

      child: Column(
        children: children,
      ),
    );
  }
}

// =====================================================
// SWITCH SETTING
// =====================================================

class _SwitchSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSetting({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        10,
        14,
      ),

      child: Row(
        children: [
          _SettingIcon(
            icon: icon,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// =====================================================
// INFO SETTING
// =====================================================

class _InfoSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoSetting({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      child: Row(
        children: [
          _SettingIcon(
            icon: icon,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ICON
// =====================================================

class _SettingIcon extends StatelessWidget {
  final IconData icon;

  const _SettingIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(13),
      ),

      child: Icon(
        icon,
        size: 21,
        color: Colors.white70,
      ),
    );
  }
}

// =====================================================
// DIVIDER
// =====================================================

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 72,
      ),

      child: Divider(
        height: 1,
        color: Colors.white.withOpacity(0.06),
      ),
    );
  }
}