import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../editor_page.dart';
import '../models/wallpaper_item.dart';

class WallpaperCard extends StatefulWidget {
  final WallpaperItem wallpaper;
  final int index;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    required this.index,
  });

  @override
  State<WallpaperCard> createState() =>
      _WallpaperCardState();
}

class _WallpaperCardState extends State<WallpaperCard> {
  late final VideoPlayerController _controller;

  bool _isInitialized = false;
  bool _hasError = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.wallpaper.videoUrl),
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.setVolume(0);
      await _controller.play();

      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Wallpaper preview error: $e');

      if (!mounted) return;

      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openWallpaper() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorPage(
          wallpaperIndex: widget.index,
          videoUrl: widget.wallpaper.videoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openWallpaper,

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
                // VIDEO
                // =========================================

                _buildVideo(),

                // =========================================
                // DARK GRADIENT
                // =========================================

                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.0,
                        0.45,
                        0.72,
                        1.0,
                      ],
                      colors: [
                        Color(0x22000000),
                        Colors.transparent,
                        Color(0x55000000),
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
                      // LIVE

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.52),

                          borderRadius:
                          BorderRadius.circular(20),

                          border: Border.all(
                            color: Colors.white
                                .withOpacity(0.12),
                          ),
                        ),

                        child: const Row(
                          mainAxisSize:
                          MainAxisSize.min,

                          children: [
                            _LiveDot(),

                            SizedBox(width: 5),

                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight:
                                FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // NEW

                      if (widget.wallpaper.isNew)
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color:
                            const Color(0xFF7657FF),

                            borderRadius:
                            BorderRadius.circular(20),

                            boxShadow: [
                              BoxShadow(
                                color:
                                const Color(
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
                // BOTTOM CONTENT
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
                                  Icons
                                      .motion_photos_on_rounded,
                                  color:
                                  Colors.white54,
                                  size: 13,
                                ),

                                const SizedBox(
                                  width: 5,
                                ),

                                Text(
                                  _categoryName(
                                    widget.wallpaper
                                        .category,
                                  ),

                                  style:
                                  const TextStyle(
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

                      // ===================================
                      // OPEN BUTTON
                      // ===================================

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
                          Icons
                              .arrow_forward_rounded,
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
  // VIDEO
  // =====================================================

  Widget _buildVideo() {
    if (_hasError) {
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
    }

    if (!_isInitialized ||
        !_controller.value.isInitialized) {
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
    }

    return FittedBox(
      fit: BoxFit.cover,

      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,

        child: VideoPlayer(
          _controller,
        ),
      ),
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
        return 'Live Wallpaper';
    }
  }
}

// =====================================================
// ANIMATED LIVE DOT
// =====================================================

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() =>
      _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;

  @override
  void initState() {
    super.initState();

    _animation = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 900,
      ),
      lowerBound: 0.45,
      upperBound: 1,
    )
      ..repeat(
        reverse: true,
      );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,

      child: Container(
        width: 6,
        height: 6,

        decoration: const BoxDecoration(
          color: Color(0xFFFF4D67),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}