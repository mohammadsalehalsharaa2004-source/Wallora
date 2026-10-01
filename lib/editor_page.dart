import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class EditorPage extends StatefulWidget {
  final int wallpaperIndex;

  const EditorPage({
    super.key,
    required this.wallpaperIndex,
  });

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late VideoPlayerController _videoController;

  final TextEditingController _nameController =
  TextEditingController();

  final GlobalKey _previewKey = GlobalKey();

  static const MethodChannel _wallpaperChannel =
  MethodChannel('wallora/live_wallpaper');

  String userName = 'Wallora';

  double fontSize = 48;
  double rotation = 0;

  Color textColor = Colors.white;

  bool glowEnabled = true;
  bool _isApplying = false;

  Offset textPosition = const Offset(80, 150);

  final List<Color> colors = [
    Colors.white,
    Colors.cyanAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
  ];

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(
      'assets/videos/wallpaper1.mp4',
    );

    _videoController.initialize().then((_) {
      _videoController.setLooping(true);
      _videoController.setVolume(0);
      _videoController.play();

      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _setLiveWallpaper() async {
    if (_isApplying) return;

    try {
      final renderBox =
      _previewKey.currentContext?.findRenderObject()
      as RenderBox?;

      if (renderBox == null) {
        return;
      }

      final previewSize = renderBox.size;

      if (previewSize.width <= 0 ||
          previewSize.height <= 0) {
        return;
      }

      // نحول موقع النص من Pixels إلى نسبة 0..1
      final normalizedX =
      (textPosition.dx / previewSize.width)
          .clamp(0.0, 1.0)
          .toDouble();

      final normalizedY =
      (textPosition.dy / previewSize.height)
          .clamp(0.0, 1.0)
          .toDouble();

      setState(() {
        _isApplying = true;
      });

      await _wallpaperChannel.invokeMethod(
        'openLiveWallpaper',
        {
          'name': userName,
          'fontSize': fontSize,
          'color': textColor.toARGB32(),
          'glow': glowEnabled,
          'positionX': normalizedX,
          'positionY': normalizedY,
          'rotation': rotation,
        },
      );
    } on PlatformException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ: ${e.message}',
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

  void _moveText(DragUpdateDetails details) {
    final renderBox =
    _previewKey.currentContext?.findRenderObject()
    as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final previewSize = renderBox.size;

    setState(() {
      final newPosition =
          textPosition + details.delta;

      // نمنع الاسم من الخروج بالكامل خارج المعاينة
      final maxX =
      (previewSize.width - 50)
          .clamp(0.0, double.infinity)
          .toDouble();

      final maxY =
      (previewSize.height - 50)
          .clamp(0.0, double.infinity)
          .toDouble();

      textPosition = Offset(
        newPosition.dx
            .clamp(0.0, maxX)
            .toDouble(),
        newPosition.dy
            .clamp(0.0, maxY)
            .toDouble(),
      );
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF080A0F),

      appBar: AppBar(
        backgroundColor:
        const Color(0xFF080A0F),

        elevation: 0,

        centerTitle: true,

        title: const Text(
          'Wallora Editor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            // =====================================
            // معاينة الخلفية
            // =====================================

            Expanded(
              flex: 5,
              child: Container(
                key: _previewKey,

                width: double.infinity,

                margin:
                const EdgeInsets.fromLTRB(
                  16,
                  5,
                  16,
                  10,
                ),

                decoration: BoxDecoration(
                  color: Colors.black,

                  borderRadius:
                  BorderRadius.circular(25),

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
                  BorderRadius.circular(25),

                  child: Stack(
                    fit: StackFit.expand,

                    children: [

                      // =============================
                      // الفيديو
                      // =============================

                      if (_videoController
                          .value.isInitialized)
                        FittedBox(
                          fit: BoxFit.cover,

                          child: SizedBox(
                            width: _videoController
                                .value.size.width,

                            height: _videoController
                                .value.size.height,

                            child: VideoPlayer(
                              _videoController,
                            ),
                          ),
                        )
                      else
                        const Center(
                          child:
                          CircularProgressIndicator(),
                        ),

                      // =============================
                      // طبقة خفيفة فوق الفيديو
                      // =============================

                      IgnorePointer(
                        child: Container(
                          color: Colors.black
                              .withOpacity(0.08),
                        ),
                      ),

                      // =============================
                      // الاسم
                      // =============================

                      Positioned(
                        left: textPosition.dx,
                        top: textPosition.dy,

                        child: GestureDetector(
                          behavior:
                          HitTestBehavior.translucent,

                          onPanUpdate: _moveText,

                          child: Transform.rotate(
                            angle: rotation,

                            child: Container(
                              padding:
                              const EdgeInsets.all(8),

                              child: Text(
                                userName,

                                textDirection:
                                TextDirection.ltr,

                                style: TextStyle(
                                  color: textColor,

                                  fontSize: fontSize,

                                  fontWeight:
                                  FontWeight.bold,

                                  shadows:
                                  glowEnabled
                                      ? [
                                    Shadow(
                                      color:
                                      textColor,
                                      blurRadius:
                                      10,
                                    ),
                                    Shadow(
                                      color:
                                      textColor,
                                      blurRadius:
                                      25,
                                    ),
                                    Shadow(
                                      color:
                                      textColor,
                                      blurRadius:
                                      40,
                                    ),
                                  ]
                                      : const [
                                    Shadow(
                                      color: Colors
                                          .black87,
                                      blurRadius:
                                      5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // =============================
                      // تعليمات
                      // =============================

                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 12,

                        child: IgnorePointer(
                          child: Container(
                            alignment:
                            Alignment.center,

                            child: Container(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration:
                              BoxDecoration(
                                color: Colors.black
                                    .withOpacity(0.40),

                                borderRadius:
                                BorderRadius
                                    .circular(20),
                              ),

                              child: const Text(
                                'اسحب الاسم لتحريكه',

                                textAlign:
                                TextAlign.center,

                                textDirection:
                                TextDirection.rtl,

                                style: TextStyle(
                                  color:
                                  Colors.white70,
                                  fontSize: 12,
                                ),
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

            // =====================================
            // لوحة التحكم
            // =====================================

            Expanded(
              flex: 5,

              child: Container(
                width: double.infinity,

                decoration:
                const BoxDecoration(
                  color: Color(0xFF12151F),

                  borderRadius:
                  BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),

                child: SingleChildScrollView(
                  physics:
                  const BouncingScrollPhysics(),

                  padding:
                  const EdgeInsets.fromLTRB(
                    18,
                    18,
                    18,
                    30,
                  ),

                  child: Column(
                    children: [

                      // =============================
                      // كتابة الاسم
                      // =============================

                      TextField(
                        controller:
                        _nameController,

                        textDirection:
                        TextDirection.rtl,

                        decoration:
                        InputDecoration(
                          hintText:
                          'اكتب اسمك...',

                          prefixIcon:
                          const Icon(
                            Icons.edit,
                          ),

                          filled: true,

                          fillColor:
                          Colors.white10,

                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius
                                .circular(15),

                            borderSide:
                            BorderSide.none,
                          ),
                        ),

                        onChanged: (value) {
                          setState(() {
                            userName =
                            value.trim().isEmpty
                                ? 'Wallora'
                                : value;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // =============================
                      // حجم الخط
                      // =============================

                      _sectionTitle(
                        icon:
                        Icons.format_size,
                        title:
                        'حجم الاسم',
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: fontSize,
                              min: 20,
                              max: 90,

                              onChanged:
                                  (value) {
                                setState(() {
                                  fontSize =
                                      value;
                                });
                              },
                            ),
                          ),

                          Container(
                            width: 48,
                            alignment:
                            Alignment.center,

                            padding:
                            const EdgeInsets
                                .symmetric(
                              vertical: 6,
                            ),

                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white10,

                              borderRadius:
                              BorderRadius
                                  .circular(10),
                            ),

                            child: Text(
                              fontSize
                                  .toInt()
                                  .toString(),

                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // =============================
                      // الدوران
                      // =============================

                      _sectionTitle(
                        icon:
                        Icons.rotate_right,
                        title:
                        'دوران الاسم',
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: rotation,

                              min: -0.8,
                              max: 0.8,

                              onChanged:
                                  (value) {
                                setState(() {
                                  rotation =
                                      value;
                                });
                              },
                            ),
                          ),

                          IconButton(
                            tooltip:
                            'إعادة الدوران',

                            onPressed: () {
                              setState(() {
                                rotation = 0;
                              });
                            },

                            icon:
                            const Icon(
                              Icons.refresh,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      // =============================
                      // الألوان
                      // =============================

                      _sectionTitle(
                        icon:
                        Icons.palette_outlined,
                        title:
                        'لون الاسم',
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      SizedBox(
                        height: 52,

                        child:
                        ListView.separated(
                          scrollDirection:
                          Axis.horizontal,

                          itemCount:
                          colors.length,

                          separatorBuilder:
                              (_, __) =>
                          const SizedBox(
                            width: 10,
                          ),

                          itemBuilder:
                              (context, index) {
                            final color =
                            colors[index];

                            final selected =
                                textColor ==
                                    color;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  textColor =
                                      color;
                                });
                              },

                              child:
                              AnimatedContainer(
                                duration:
                                const Duration(
                                  milliseconds:
                                  150,
                                ),

                                width: 46,
                                height: 46,

                                decoration:
                                BoxDecoration(
                                  color: color,

                                  shape:
                                  BoxShape.circle,

                                  border:
                                  Border.all(
                                    color: selected
                                        ? Colors
                                        .white
                                        : Colors
                                        .transparent,

                                    width: 3,
                                  ),

                                  boxShadow:
                                  selected
                                      ? [
                                    BoxShadow(
                                      color:
                                      color,
                                      blurRadius:
                                      14,
                                    ),
                                  ]
                                      : [],
                                ),

                                child: selected
                                    ? const Icon(
                                  Icons.check,
                                  color: Colors
                                      .black,
                                )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // =============================
                      // Neon Glow
                      // =============================

                      Container(
                        decoration:
                        BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.06),

                          borderRadius:
                          BorderRadius
                              .circular(16),

                          border: Border.all(
                            color: glowEnabled
                                ? textColor
                                .withOpacity(
                                0.45)
                                : Colors.white
                                .withOpacity(
                                0.05),
                          ),
                        ),

                        child: SwitchListTile(
                          value: glowEnabled,

                          onChanged: (value) {
                            setState(() {
                              glowEnabled =
                                  value;
                            });
                          },

                          secondary:
                          Icon(
                            Icons.auto_awesome,
                            color: glowEnabled
                                ? textColor
                                : Colors
                                .white54,
                          ),

                          title:
                          const Text(
                            'Neon Glow',

                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          subtitle:
                          const Text(
                            'إضافة توهج حول الاسم',

                            textDirection:
                            TextDirection.rtl,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // =============================
                      // زر تعيين الخلفية
                      // =============================

                      SizedBox(
                        width:
                        double.infinity,

                        height: 56,

                        child:
                        ElevatedButton.icon(
                          onPressed:
                          _isApplying
                              ? null
                              : _setLiveWallpaper,

                          icon: _isApplying
                              ? const SizedBox(
                            width: 22,
                            height: 22,

                            child:
                            CircularProgressIndicator(
                              strokeWidth:
                              2,
                            ),
                          )
                              : const Icon(
                            Icons.wallpaper,
                          ),

                          label: Text(
                            _isApplying
                                ? 'جاري تجهيز الخلفية...'
                                : 'تعيين كخلفية',

                            style:
                            const TextStyle(
                              fontSize: 17,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          style:
                          ElevatedButton
                              .styleFrom(
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white70,
        ),

        const SizedBox(
          width: 8,
        ),

        Text(
          title,
          textDirection:
          TextDirection.rtl,

          style: const TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}