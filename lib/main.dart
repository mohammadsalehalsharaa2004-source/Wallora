import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'editor_page.dart';

void main() {
  runApp(const WalloraApp());
}

class WalloraApp extends StatelessWidget {
  const WalloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallora',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B12),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wallora',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'اصنع خلفيتك بطريقتك',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: GridView.builder(
          itemCount: 6,

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.60,
          ),

          itemBuilder: (context, index) {
            return WallpaperCard(
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class WallpaperCard extends StatefulWidget {
  final int index;

  const WallpaperCard({
    super.key,
    required this.index,
  });

  @override
  State<WallpaperCard> createState() =>
      _WallpaperCardState();
}

class _WallpaperCardState
    extends State<WallpaperCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/videos/wallpaper${widget.index + 1}.mp4',
    );

    _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.setVolume(0);
      _controller.play();

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditorPage(
              wallpaperIndex: widget.index,
            ),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF151822),
          borderRadius: BorderRadius.circular(22),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),

          child: Stack(
            fit: StackFit.expand,
            children: [

              // الفيديو
              if (_controller.value.isInitialized)
                FittedBox(
                  fit: BoxFit.cover,

                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,

                    child: VideoPlayer(
                      _controller,
                    ),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(),
                ),

              // تدرج داكن
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),

              // زر القلب
              const Positioned(
                top: 12,
                right: 12,

                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black45,

                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              // LIVE
              Positioned(
                top: 13,
                left: 12,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 7,
                        color: Colors.redAccent,
                      ),

                      SizedBox(width: 5),

                      Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // اسم الخلفية
              Positioned(
                left: 13,
                right: 13,
                bottom: 14,

                child: Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      size: 22,
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: Text(
                        'Wallora ${widget.index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}