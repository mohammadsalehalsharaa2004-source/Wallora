import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<_AdminWallpaper> _wallpapers = [];

  void _openAddWallpaper() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWallpaperPage(
          onAdd: (wallpaper) {
            setState(() {
              _wallpapers.insert(0, wallpaper);
            });
          },
        ),
      ),
    );
  }

  void _deleteWallpaper(int index) {
    final wallpaper = _wallpapers[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151821),
          title: const Text(
            'Delete Wallpaper?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${wallpaper.title}"?',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                setState(() {
                  _wallpapers.removeAt(index);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Wallpaper deleted',
                    ),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleWallpaper(
      int index,
      bool value,
      ) {
    setState(() {
      _wallpapers[index].isActive = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int liveCount = _wallpapers
        .where(
          (wallpaper) =>
      wallpaper.type == 'video',
    )
        .length;

    final int photoCount = _wallpapers
        .where(
          (wallpaper) =>
      wallpaper.type == 'image',
    )
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFF080A0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Wallora Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF7657FF)
                  .withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: _openAddWallpaper,
              icon: const Icon(
                Icons.add_rounded,
                color: Color(0xFF9C8AFF),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddWallpaper,
        backgroundColor: const Color(0xFF7657FF),
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Add Wallpaper',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            100,
          ),
          children: [
            // ==========================================
            // HEADER
            // ==========================================

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7657FF)
                        .withOpacity(0.28),
                    const Color(0xFF12151F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: const Row(
                children: [
                  ContainerIcon(
                    icon:
                    Icons.admin_panel_settings_rounded,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Manage Wallora wallpapers',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ==========================================
            // STATISTICS
            // ==========================================

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total',
                    value: '${_wallpapers.length}',
                    icon: Icons.wallpaper_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    title: 'Live',
                    value: '$liveCount',
                    icon: Icons.play_circle_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    title: 'Photos',
                    value: '$photoCount',
                    icon: Icons.image_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==========================================
            // WALLPAPERS HEADER
            // ==========================================

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Wallpapers',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${_wallpapers.length} items',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ==========================================
            // EMPTY STATE
            // ==========================================

            if (_wallpapers.isEmpty)
              _EmptyWallpapers(
                onAdd: _openAddWallpaper,
              ),

            // ==========================================
            // WALLPAPER LIST
            // ==========================================

            ...List.generate(
              _wallpapers.length,
                  (index) {
                final wallpaper =
                _wallpapers[index];

                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 12),
                  child: _WallpaperAdminCard(
                    wallpaper: wallpaper,
                    onDelete: () {
                      _deleteWallpaper(index);
                    },
                    onActiveChanged: (value) {
                      _toggleWallpaper(
                        index,
                        value,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// ADD WALLPAPER PAGE
// =====================================================

class AddWallpaperPage extends StatefulWidget {
  final void Function(_AdminWallpaper wallpaper)
  onAdd;

  const AddWallpaperPage({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddWallpaperPage> createState() =>
      _AddWallpaperPageState();
}

class _AddWallpaperPageState
    extends State<AddWallpaperPage> {
  final TextEditingController _titleController =
  TextEditingController();

  final TextEditingController _urlController =
  TextEditingController();

  String _selectedType = 'video';
  String _selectedCategory = 'animals';

  bool _isNew = false;
  bool _isActive = true;

  final List<String> _categories = [
    'animals',
    'galaxy',
    'nature',
    'cars',
    'anime',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();

    super.dispose();
  }

  void _addWallpaper() {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty) {
      _showMessage(
        'Please enter the wallpaper title',
      );
      return;
    }

    if (url.isEmpty) {
      _showMessage(
        'Please enter the media URL',
      );
      return;
    }

    final wallpaper = _AdminWallpaper(
      title: title,
      mediaUrl: url,
      type: _selectedType,
      category: _selectedCategory,
      isNew: _isNew,
      isActive: _isActive,
    );

    widget.onAdd(wallpaper);

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Add Wallpaper',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            35,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ========================================
              // TITLE
              // ========================================

              const _FieldTitle(
                title: 'Wallpaper title',
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: _inputDecoration(
                  hint: 'Example: Purple Galaxy',
                  icon: Icons.title_rounded,
                ),
              ),

              const SizedBox(height: 22),

              // ========================================
              // MEDIA URL
              // ========================================

              const _FieldTitle(
                title: 'Cloudflare R2 URL',
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: _inputDecoration(
                  hint:
                  'https://pub-....r2.dev/file.mp4',
                  icon: Icons.link_rounded,
                ),
              ),

              const SizedBox(height: 24),

              // ========================================
              // TYPE
              // ========================================

              const _FieldTitle(
                title: 'Wallpaper type',
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _typeButton(
                      title: 'Live',
                      icon:
                      Icons.play_circle_rounded,
                      value: 'video',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _typeButton(
                      title: 'Photo',
                      icon: Icons.image_rounded,
                      value: 'image',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ========================================
              // CATEGORY
              // ========================================

              const _FieldTitle(
                title: 'Category',
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                dropdownColor:
                const Color(0xFF171A24),
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: _inputDecoration(
                  hint: 'Select category',
                  icon: Icons.category_rounded,
                ),
                items: _categories.map(
                      (category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        _categoryName(category),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // ========================================
              // SETTINGS
              // ========================================

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF12151F),
                  borderRadius:
                  BorderRadius.circular(20),
                  border: Border.all(
                    color:
                    Colors.white.withOpacity(0.07),
                  ),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _isNew,
                      activeThumbColor:
                      const Color(0xFF7657FF),
                      title: const Text(
                        'New Wallpaper',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Also show it in New',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isNew = value;
                        });
                      },
                    ),
                    Divider(
                      height: 1,
                      color:
                      Colors.white.withOpacity(0.06),
                    ),
                    SwitchListTile(
                      value: _isActive,
                      activeThumbColor:
                      const Color(0xFF7657FF),
                      title: const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Show it to Wallora users',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ========================================
              // ADD BUTTON
              // ========================================

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: _addWallpaper,
                  icon: const Icon(
                    Icons.add_rounded,
                  ),
                  label: const Text(
                    'Add Wallpaper',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF7657FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeButton({
    required String title,
    required IconData icon,
    required String value,
  }) {
    final bool selected =
        _selectedType == value;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() {
          _selectedType = value;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        height: 72,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF7657FF)
              .withOpacity(0.18)
              : const Color(0xFF12151F),
          borderRadius:
          BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? const Color(0xFF7657FF)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? const Color(0xFF9C8AFF)
                  : Colors.white54,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.white60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white30,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.white38,
      ),
      filled: true,
      fillColor: const Color(0xFF12151F),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFF7657FF),
        ),
      ),
    );
  }

  String _categoryName(String category) {
    switch (category) {
      case 'animals':
        return 'Animals';

      case 'galaxy':
        return 'Galaxy';

      case 'nature':
        return 'Nature';

      case 'cars':
        return 'Cars';

      case 'anime':
        return 'Anime';

      default:
        return category;
    }
  }
}

// =====================================================
// WALLPAPER MODEL FOR ADMIN PREVIEW
// =====================================================

class _AdminWallpaper {
  final String title;
  final String mediaUrl;
  final String type;
  final String category;
  final bool isNew;

  bool isActive;

  _AdminWallpaper({
    required this.title,
    required this.mediaUrl,
    required this.type,
    required this.category,
    required this.isNew,
    required this.isActive,
  });
}

// =====================================================
// WALLPAPER CARD
// =====================================================

class _WallpaperAdminCard
    extends StatelessWidget {
  final _AdminWallpaper wallpaper;
  final VoidCallback onDelete;
  final ValueChanged<bool> onActiveChanged;

  const _WallpaperAdminCard({
    required this.wallpaper,
    required this.onDelete,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVideo =
        wallpaper.type == 'video';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF12151F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF7657FF)
                  .withOpacity(0.12),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Icon(
              isVideo
                  ? Icons.play_circle_rounded
                  : Icons.image_rounded,
              color: const Color(0xFF9C8AFF),
              size: 29,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  wallpaper.title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${isVideo ? 'Live' : 'Photo'}'
                      ' • '
                      '${_displayCategory(wallpaper.category)}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                if (wallpaper.isNew) ...[
                  const SizedBox(height: 7),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7657FF)
                          .withOpacity(0.18),
                      borderRadius:
                      BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Color(0xFFAA9CFF),
                        fontSize: 10,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          Column(
            children: [
              Switch(
                value: wallpaper.isActive,
                activeThumbColor:
                const Color(0xFF7657FF),
                onChanged: onActiveChanged,
              ),

              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _displayCategory(
      String category,
      ) {
    if (category.isEmpty) {
      return category;
    }

    return '${category[0].toUpperCase()}'
        '${category.substring(1)}';
  }
}

// =====================================================
// EMPTY STATE
// =====================================================

class _EmptyWallpapers extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyWallpapers({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF12151F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF7657FF)
                  .withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wallpaper_rounded,
              color: Color(0xFF9C8AFF),
              size: 34,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'No wallpapers yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Add your first photo or live wallpaper.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: const Text(
              'Add Wallpaper',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
              const Color(0xFF9C8AFF),
              side: const BorderSide(
                color: Color(0xFF7657FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// STAT CARD
// =====================================================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 17,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF12151F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF9C8AFF),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// FIELD TITLE
// =====================================================

class _FieldTitle extends StatelessWidget {
  final String title;

  const _FieldTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// =====================================================
// HEADER ICON
// =====================================================

class ContainerIcon extends StatelessWidget {
  final IconData icon;

  const ContainerIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF7657FF)
            .withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        color: const Color(0xFFAA9CFF),
        size: 30,
      ),
    );
  }
}