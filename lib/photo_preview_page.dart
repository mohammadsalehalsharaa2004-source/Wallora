import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/wallpaper_item.dart';

class PhotoPreviewPage extends StatefulWidget {
  final WallpaperItem wallpaper;

  const PhotoPreviewPage({
    super.key,
    required this.wallpaper,
  });

  @override
  State<PhotoPreviewPage> createState() =>
      _PhotoPreviewPageState();
}

class _PhotoPreviewPageState
    extends State<PhotoPreviewPage> {
  static const MethodChannel _wallpaperChannel =
  MethodChannel('wallora/live_wallpaper');

  bool _isApplying = false;

  // =====================================================
  // SET PHOTO WALLPAPER
  // =====================================================

  Future<void> _setPhotoWallpaper() async {
    if (_isApplying) {
      return;
    }

    setState(() {
      _isApplying = true;
    });

    try {
      await _wallpaperChannel.invokeMethod(
        'setPhotoWallpaper',
        {
          'imageUrl': widget.wallpaper.mediaUrl,
        },
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Wallpaper applied successfully',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on PlatformException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                'Unable to set wallpaper',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to set wallpaper: $e',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
      }
    }
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.wallpaper.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // =============================================
            // PHOTO PREVIEW
            // =============================================

            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  16,
                  6,
                  16,
                  12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                  BorderRadius.circular(26),
                  border: Border.all(
                    color:
                    Colors.white.withOpacity(0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(26),

                  child: Image.network(
                    widget.wallpaper.mediaUrl,

                    width: double.infinity,
                    height: double.infinity,

                    fit: BoxFit.cover,

                    // =====================================
                    // LOADING
                    // =====================================

                    loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                        ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Container(
                        color: const Color(
                          0xFF10131B,
                        ),
                        child: const Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                      );
                    },

                    // =====================================
                    // ERROR
                    // =====================================

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        color: const Color(
                          0xFF10131B,
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              Icon(
                                Icons
                                    .broken_image_outlined,
                                color: Colors.white38,
                                size: 48,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Unable to load photo',
                                style: TextStyle(
                                  color:
                                  Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // =============================================
            // BOTTOM AREA
            // =============================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                18,
              ),

              decoration: const BoxDecoration(
                color: Color(0xFF12151F),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),

              child: SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton.icon(
                  onPressed: _isApplying
                      ? null
                      : _setPhotoWallpaper,

                  icon: _isApplying
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons.wallpaper_rounded,
                  ),

                  label: Text(
                    _isApplying
                        ? 'Applying Wallpaper...'
                        : 'Set as Wallpaper',

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF7657FF),

                    foregroundColor: Colors.white,

                    disabledBackgroundColor:
                    const Color(0xFF7657FF)
                        .withOpacity(0.55),

                    disabledForegroundColor:
                    Colors.white70,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}