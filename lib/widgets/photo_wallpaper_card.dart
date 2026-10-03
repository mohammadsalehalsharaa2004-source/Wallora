import 'package:flutter/material.dart';

import '../models/wallpaper_item.dart';
import '../photo_preview_page.dart';

class PhotoWallpaperCard extends StatefulWidget {
  final WallpaperItem wallpaper;
  final int index;

  const PhotoWallpaperCard({
    super.key,
    required this.wallpaper,
    required this.index,
  });

  @override
  State<PhotoWallpaperCard> createState() =>
      _PhotoWallpaperCardState();
}

class _PhotoWallpaperCardState
    extends State<PhotoWallpaperCard> {
  bool _pressed = false;

  // =====================================================
  // OPEN PHOTO
  // =====================================================

  void _openPhoto() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPreviewPage(
          wallpaper: widget.wallpaper,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPhoto,

      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
      },

      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },

      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,

        duration: const Duration(
          milliseconds: 120,
        ),

        curve: Curves.easeOut,

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),

            child: Stack(
              fit: StackFit.expand,
              children: [
                // =========================================
                // PHOTO
                // =========================================

                _buildPhoto(),

                // =========================================
                // GRADIENT
                // =========================================

                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,

                      stops: [
                        0.0,
                        0.50,
                        0.76,
                        1.0,
                      ],

                      colors: [
                        Color(0x11000000),
                        Colors.transparent,
                        Color(0x66000000),
                        Color(0xEE050509),
                      ],
                    ),
                  ),
                ),

                // =========================================
                // TOP BADGES
                // =========================================

                Positioned(
                  top: 11,
                  left: 11,
                  right: 11,

                  child: Row(
                    children: [
                      // PHOTO BADGE

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color:
                          Colors.black.withOpacity(0.50),

                          borderRadius:
                          BorderRadius.circular(20),

                          border: Border.all(
                            color: Colors.white
                                .withOpacity(0.12),
                          ),
                        ),

                        child: const Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              Icons.photo_rounded,
                              color: Colors.white70,
                              size: 12,
                            ),

                            SizedBox(width: 5),

                            Text(
                              'PHOTO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight:
                                FontWeight.w800,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // NEW BADGE

                      if (widget.wallpaper.isNew)
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF7657FF,
                            ),

                            borderRadius:
                            BorderRadius.circular(20),

                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF7657FF,
                                ).withOpacity(0.30),
                                blurRadius: 12,
                              ),
                            ],
                          ),

                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight:
                              FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // =========================================
                // BOTTOM
                // =========================================

                Positioned(
                  left: 14,
                  right: 12,
                  bottom: 13,

                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,

                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize:
                          MainAxisSize.min,

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              widget.wallpaper.title,

                              maxLines: 1,

                              overflow:
                              TextOverflow.ellipsis,

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.1,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  color: Colors.white54,
                                  size: 13,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  _categoryName(
                                    widget.wallpaper
                                        .category,
                                  ),

                                  style: const TextStyle(
                                    color:
                                    Colors.white54,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // OPEN BUTTON

                      Container(
                        width: 38,
                        height: 38,

                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.15),

                          shape: BoxShape.circle,

                          border: Border.all(
                            color: Colors.white
                                .withOpacity(0.20),
                          ),
                        ),

                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================
                // BORDER
                // =========================================

                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(24),

                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.08),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // PHOTO
  // =====================================================

  Widget _buildPhoto() {
    return Image.network(
      widget.wallpaper.mediaUrl,

      width: double.infinity,
      height: double.infinity,

      fit: BoxFit.cover,

      // ===============================================
      // LOADING
      // ===============================================

      loadingBuilder: (
          context,
          child,
          loadingProgress,
          ) {
        if (loadingProgress == null) {
          return child;
        }

        return Container(
          color: const Color(0xFF151822),

          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,

              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        );
      },

      // ===============================================
      // ERROR
      // ===============================================

      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return Container(
          color: const Color(0xFF151822),

          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white30,
              size: 36,
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // CATEGORY NAME
  // =====================================================

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
        return 'Wallpaper';
    }
  }
}