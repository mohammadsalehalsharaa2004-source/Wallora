import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class EditorPage extends StatefulWidget {
  final int wallpaperIndex;
  final String videoUrl;

  const EditorPage({
    super.key,
    required this.wallpaperIndex,
    required this.videoUrl,
  });

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late VideoPlayerController _videoController;

  static const MethodChannel _wallpaperChannel =
  MethodChannel('wallora/live_wallpaper');

  bool _isApplying = false;
  bool _hasVideoError = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _videoController.initialize();

      await _videoController.setLooping(true);
      await _videoController.setVolume(0);
      await _videoController.play();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Wallora video error: $e');

      if (mounted) {
        setState(() {
          _hasVideoError = true;
        });
      }
    }
  }

  Future<void> _setLiveWallpaper() async {
    if (_isApplying) return;

    setState(() {
      _isApplying = true;
    });

    try {
      await _wallpaperChannel.invokeMethod(
        'openLiveWallpaper',
        {
          'videoUrl': widget.videoUrl,
        },
      );
    } on PlatformException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ: ${e.message ?? "غير معروف"}',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ: $e',
            textDirection: TextDirection.rtl,
          ),
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

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF080A0F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Wallora',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
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
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: _buildVideo(),
                ),
              ),
            ),

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
                  onPressed:
                  _isApplying ? null : _setLiveWallpaper,

                  icon: _isApplying
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(
                    Icons.wallpaper,
                  ),

                  label: Text(
                    _isApplying
                        ? 'جاري فتح الخلفية...'
                        : 'تعيين كخلفية',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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

  Widget _buildVideo() {
    if (_hasVideoError) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 45,
              color: Colors.white54,
            ),
            SizedBox(height: 12),
            Text(
              'تعذر تحميل الفيديو',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    if (!_videoController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _videoController.value.size.width,
        height: _videoController.value.size.height,
        child: VideoPlayer(
          _videoController,
        ),
      ),
    );
  }
}