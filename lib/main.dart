import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'app_drawer.dart';
import 'data/wallpapers_data.dart';
import 'models/wallpaper_item.dart';

import 'pages/new_page.dart';
import 'pages/animals_page.dart';
import 'pages/galaxy_page.dart';
import 'pages/nature_page.dart';
import 'pages/cars_page.dart';
import 'pages/anime_page.dart';
import 'photo_pages/new_photos_page.dart';
import 'photo_pages/animals_photos_page.dart';
import 'photo_pages/galaxy_photos_page.dart';
import 'photo_pages/nature_photos_page.dart';
import 'photo_pages/cars_photos_page.dart';
import 'photo_pages/anime_photos_page.dart';
void main() {
  runApp(const WalloraApp());
}

// =====================================================
// APP
// =====================================================

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
        scaffoldBackgroundColor:
        const Color(0xFF090B12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7657FF),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// =====================================================
// CATEGORY MODEL
// =====================================================

class WallpaperCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const WallpaperCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

// =====================================================
// CATEGORIES
// =====================================================

const List<WallpaperCategory> categories = [
  WallpaperCategory(
    id: 'new',
    title: 'New',
    subtitle: 'Fresh wallpapers',
    icon: Icons.auto_awesome_rounded,
  ),
  WallpaperCategory(
    id: 'animals',
    title: 'Animals',
    subtitle: 'Wild & beautiful',
    icon: Icons.pets_rounded,
  ),
  WallpaperCategory(
    id: 'galaxy',
    title: 'Galaxy',
    subtitle: 'Beyond the stars',
    icon: Icons.public_rounded,
  ),
  WallpaperCategory(
    id: 'nature',
    title: 'Nature',
    subtitle: 'Peaceful landscapes',
    icon: Icons.landscape_rounded,
  ),
  WallpaperCategory(
    id: 'cars',
    title: 'Cars',
    subtitle: 'Speed & machines',
    icon: Icons.directions_car_rounded,
  ),
  WallpaperCategory(
    id: 'anime',
    title: 'Anime',
    subtitle: 'Animated worlds',
    icon: Icons.auto_awesome_rounded,
  ),
];

// =====================================================
// GET CATEGORY WALLPAPERS
// =====================================================

List<WallpaperItem> getWallpapersForCategory(
    WallpaperCategory category,
    WallpaperType type,
    ) {
  if (category.id == 'new') {
    return getNewWallpapers(
      type: type,
    );
  }

  return getWallpapersByCategory(
    category.id,
    type: type,
  );
}

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WallpaperType _selectedType =
      WallpaperType.video;

  bool get _showingVideos =>
      _selectedType == WallpaperType.video;

  void _changeType(
      WallpaperType type,
      ) {
    if (_selectedType == type) {
      return;
    }

    setState(() {
      _selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF090B12),
      drawer: const AppDrawer(),

      // =================================================
      // APP BAR
      // =================================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 86,
        titleSpacing: 4,
        title: const Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Wallora',
              style: TextStyle(
                fontSize: 28,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Bring your screen to life',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),

      // =================================================
      // BODY
      // =================================================

      body: ListView(
        physics:
        const BouncingScrollPhysics(),
        padding:
        const EdgeInsets.fromLTRB(
          16,
          4,
          16,
          35,
        ),
        children: [
          // ===============================================
          // LIVE / PHOTOS TOP BAR
          // ===============================================

          _WallpaperTypeBar(
            selectedType: _selectedType,
            onChanged: _changeType,
          ),

          const SizedBox(height: 25),

          // ===============================================
          // HEADER
          // ===============================================

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      _showingVideos
                          ? 'Live Wallpapers'
                          : 'Photos',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight:
                        FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _showingVideos
                          ? 'Animated wallpapers for your screen'
                          : 'Beautiful static wallpapers',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.05),
                  borderRadius:
                  BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white
                        .withOpacity(0.06),
                  ),
                ),
                child: Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Icon(
                      _showingVideos
                          ? Icons
                          .motion_photos_on_rounded
                          : Icons
                          .photo_rounded,
                      size: 14,
                      color: const Color(
                        0xFF9B87FF,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _showingVideos
                          ? 'LIVE'
                          : 'PHOTO',
                      style:
                      const TextStyle(
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w800,
                        letterSpacing: 1,
                        color:
                        Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ===============================================
          // CATEGORY CARDS
          // ===============================================

          AnimatedSwitcher(
            duration:
            const Duration(
              milliseconds: 280,
            ),
            switchInCurve:
            Curves.easeOut,
            switchOutCurve:
            Curves.easeIn,
            child: Column(
              key: ValueKey(
                _selectedType,
              ),
              children: categories.map(
                    (category) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 18,
                    ),
                    child:
                    CategoryPreviewCard(
                      category: category,
                      type:
                      _selectedType,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// LIVE / PHOTOS BAR
// =====================================================

class _WallpaperTypeBar
    extends StatelessWidget {
  final WallpaperType selectedType;
  final ValueChanged<WallpaperType>
  onChanged;

  const _WallpaperTypeBar({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final liveSelected =
        selectedType ==
            WallpaperType.video;

    return Container(
      height: 58,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF12151E),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color:
          Colors.white.withOpacity(0.07),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _TypeButton(
              title: 'Live',
              icon: Icons
                  .motion_photos_on_rounded,
              selected: liveSelected,
              onTap: () {
                onChanged(
                  WallpaperType.video,
                );
              },
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: _TypeButton(
              title: 'Photos',
              icon:
              Icons.photo_rounded,
              selected: !liveSelected,
              onTap: () {
                onChanged(
                  WallpaperType.image,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(16),
        child: AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 220,
          ),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
              begin:
              Alignment.topLeft,
              end: Alignment
                  .bottomRight,
              colors: [
                Color(
                  0xFF8064FF,
                ),
                Color(
                  0xFF6445ED,
                ),
              ],
            )
                : null,
            borderRadius:
            BorderRadius.circular(16),
            boxShadow: selected
                ? [
              BoxShadow(
                color:
                const Color(
                  0xFF7657FF,
                ).withOpacity(
                  0.25,
                ),
                blurRadius: 15,
                offset:
                const Offset(
                  0,
                  5,
                ),
              ),
            ]
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? Colors.white
                      : Colors.white38,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w700,
                    color: selected
                        ? Colors.white
                        : Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// CATEGORY PREVIEW CARD
// =====================================================

class CategoryPreviewCard
    extends StatefulWidget {
  final WallpaperCategory category;
  final WallpaperType type;

  const CategoryPreviewCard({
    super.key,
    required this.category,
    required this.type,
  });

  @override
  State<CategoryPreviewCard>
  createState() =>
      _CategoryPreviewCardState();
}

class _CategoryPreviewCardState
    extends State<CategoryPreviewCard> {
  VideoPlayerController? _controller;

  Timer? _timer;

  late List<WallpaperItem>
  _categoryWallpapers;

  int _currentIndex = 0;

  bool _isLoading = false;
  bool _hasError = false;
  bool _pressed = false;

  bool get _isVideo =>
      widget.type ==
          WallpaperType.video;

  @override
  void initState() {
    super.initState();

    _setupCategory();
  }

  void _setupCategory() {
    _categoryWallpapers =
        getWallpapersForCategory(
          widget.category,
          widget.type,
        );

    _currentIndex = 0;
    _hasError = false;

    if (_isVideo &&
        _categoryWallpapers.isNotEmpty) {
      _loadVideo(0);

      if (_categoryWallpapers.length >
          1) {
        _startTimer();
      }
    } else if (!_isVideo &&
        _categoryWallpapers.length > 1) {
      _startTimer();
    }
  }

  // =====================================================
  // AUTO CHANGE
  // =====================================================

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) {
        _showNextMedia();
      },
    );
  }

  void _showNextMedia() {
    if (_categoryWallpapers.length <=
        1) {
      return;
    }

    final nextIndex =
        (_currentIndex + 1) %
            _categoryWallpapers.length;

    if (_isVideo) {
      _loadVideo(nextIndex);
    } else {
      if (!mounted) return;

      setState(() {
        _currentIndex = nextIndex;
      });
    }
  }

  // =====================================================
  // LOAD VIDEO
  // =====================================================

  Future<void> _loadVideo(
      int index,
      ) async {
    if (!_isVideo ||
        _isLoading ||
        _categoryWallpapers.isEmpty) {
      return;
    }

    _isLoading = true;

    final oldController =
        _controller;

    final newController =
    VideoPlayerController.networkUrl(
      Uri.parse(
        _categoryWallpapers[index]
            .mediaUrl,
      ),
    );

    try {
      await newController.initialize();
      await newController
          .setLooping(true);
      await newController.setVolume(0);
      await newController.play();

      if (!mounted) {
        await newController.dispose();
        return;
      }

      setState(() {
        _controller =
            newController;
        _currentIndex = index;
        _hasError = false;
      });

      if (oldController != null) {
        await oldController.dispose();
      }
    } catch (e) {
      debugPrint(
        'Category preview error: $e',
      );

      await newController.dispose();

      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    } finally {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();

    super.dispose();
  }

  // =====================================================
  // OPEN CATEGORY
  // =====================================================

  void _openCategory() {
    Widget page;

    // ===================================================
    // LIVE WALLPAPERS
    // ===================================================

    if (_isVideo) {
      switch (widget.category.id) {
        case 'new':
          page = const NewPage();
          break;

        case 'animals':
          page = const AnimalsPage();
          break;

        case 'galaxy':
          page = const GalaxyPage();
          break;

        case 'nature':
          page = const NaturePage();
          break;

        case 'cars':
          page = const CarsPage();
          break;

        case 'anime':
          page = const AnimePage();
          break;

        default:
          return;
      }
    }

    // ===================================================
    // PHOTOS
    // ===================================================

    else {
      switch (widget.category.id) {
        case 'new':
          page = const NewPhotosPage();
          break;

        case 'animals':
          page = const AnimalsPhotosPage();
          break;

        case 'galaxy':
          page = const GalaxyPhotosPage();
          break;

        case 'nature':
          page = const NaturePhotosPage();
          break;

        case 'cars':
          page = const CarsPhotosPage();
          break;

        case 'anime':
          page = const AnimePhotosPage();
          break;

        default:
          return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  // =====================================================
  // CARD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final wallpaperCount =
        _categoryWallpapers.length;

    return GestureDetector(
      onTap: _openCategory,
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
        scale:
        _pressed ? 0.985 : 1,
        duration:
        const Duration(
          milliseconds: 120,
        ),
        curve: Curves.easeOut,
        child: Container(
          height: 225,
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.32),
                blurRadius: 24,
                offset:
                const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // MEDIA
                _buildPreview(),

                // GRADIENT
                const DecoratedBox(
                  decoration:
                  BoxDecoration(
                    gradient:
                    LinearGradient(
                      begin: Alignment
                          .topCenter,
                      end: Alignment
                          .bottomCenter,
                      stops: [
                        0.0,
                        0.40,
                        0.72,
                        1.0,
                      ],
                      colors: [
                        Color(
                          0x22000000,
                        ),
                        Colors.transparent,
                        Color(
                          0x77000000,
                        ),
                        Color(
                          0xF505060A,
                        ),
                      ],
                    ),
                  ),
                ),

                // TOP
                Positioned(
                  top: 15,
                  left: 15,
                  right: 15,
                  child: Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration:
                        BoxDecoration(
                          color: Colors
                              .black
                              .withOpacity(
                            0.46,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(
                            14,
                          ),
                          border:
                          Border.all(
                            color: Colors
                                .white
                                .withOpacity(
                              0.13,
                            ),
                          ),
                        ),
                        child: Icon(
                          widget
                              .category.icon,
                          color:
                          Colors.white,
                          size: 21,
                        ),
                      ),

                      const Spacer(),

                      _buildTypeBadge(),
                    ],
                  ),
                ),

                // BOTTOM
                Positioned(
                  left: 18,
                  right: 16,
                  bottom: 17,
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize:
                          MainAxisSize
                              .min,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              widget.category
                                  .subtitle
                                  .toUpperCase(),
                              style:
                              const TextStyle(
                                color: Color(
                                  0xFFB6A8FF,
                                ),
                                fontSize: 9,
                                fontWeight:
                                FontWeight
                                    .w800,
                                letterSpacing:
                                1.25,
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              widget.category
                                  .title,
                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontSize: 26,
                                height: 1,
                                fontWeight:
                                FontWeight
                                    .w800,
                                letterSpacing:
                                -0.5,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Row(
                              children: [
                                Icon(
                                  _isVideo
                                      ? Icons
                                      .motion_photos_on_outlined
                                      : Icons
                                      .photo_outlined,
                                  color: Colors
                                      .white54,
                                  size: 14,
                                ),

                                const SizedBox(
                                  width: 6,
                                ),

                                Text(
                                  _countText(
                                    wallpaperCount,
                                  ),
                                  style:
                                  const TextStyle(
                                    color: Colors
                                        .white54,
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .end,
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          if (_categoryWallpapers
                              .length >
                              1) ...[
                            _buildDots(),
                            const SizedBox(
                              height: 12,
                            ),
                          ],

                          Container(
                            width: 44,
                            height: 44,
                            decoration:
                            BoxDecoration(
                              color: Colors
                                  .white
                                  .withOpacity(
                                0.14,
                              ),
                              shape:
                              BoxShape.circle,
                              border:
                              Border.all(
                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.20,
                                ),
                              ),
                            ),
                            child:
                            const Icon(
                              Icons
                                  .arrow_forward_rounded,
                              color:
                              Colors.white,
                              size: 21,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // BORDER
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration:
                      BoxDecoration(
                        borderRadius:
                        BorderRadius
                            .circular(
                          28,
                        ),
                        border:
                        Border.all(
                          color: Colors
                              .white
                              .withOpacity(
                            0.08,
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
    );
  }

  // =====================================================
  // BADGE
  // =====================================================

  Widget _buildTypeBadge() {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color:
        Colors.black.withOpacity(0.48),
        borderRadius:
        BorderRadius.circular(30),
        border: Border.all(
          color:
          Colors.white.withOpacity(0.12),
        ),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          if (_isVideo)
            Container(
              width: 6,
              height: 6,
              decoration:
              const BoxDecoration(
                color:
                Color(0xFFFF4D67),
                shape: BoxShape.circle,
              ),
            )
          else
            const Icon(
              Icons.photo_rounded,
              size: 12,
              color: Colors.white70,
            ),

          const SizedBox(width: 6),

          Text(
            _isVideo
                ? 'LIVE'
                : 'PHOTO',
            style: const TextStyle(
              fontSize: 9,
              fontWeight:
              FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // COUNT
  // =====================================================

  String _countText(int count) {
    if (_isVideo) {
      return count == 1
          ? '1 live wallpaper'
          : '$count live wallpapers';
    }

    return count == 1
        ? '1 photo'
        : '$count photos';
  }

  // =====================================================
  // PREVIEW
  // =====================================================

  Widget _buildPreview() {
    if (_categoryWallpapers.isEmpty) {
      return _buildEmptyPreview();
    }

    if (_isVideo) {
      return _buildVideoPreview();
    }

    return _buildImagePreview();
  }

  // =====================================================
  // VIDEO PREVIEW
  // =====================================================

  Widget _buildVideoPreview() {
    if (_hasError) {
      return _buildEmptyPreview();
    }

    final controller =
        _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return Container(
        color:
        const Color(0xFF151822),
        child: const Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width:
        controller.value.size.width,
        height:
        controller.value.size.height,
        child: VideoPlayer(
          controller,
        ),
      ),
    );
  }

  // =====================================================
  // IMAGE PREVIEW
  // =====================================================

  Widget _buildImagePreview() {
    final wallpaper =
    _categoryWallpapers[
    _currentIndex];

    return AnimatedSwitcher(
      duration:
      const Duration(
        milliseconds: 450,
      ),
      child: Image.network(
        wallpaper.mediaUrl,
        key: ValueKey(
          wallpaper.mediaUrl,
        ),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,

        loadingBuilder: (
            context,
            child,
            loadingProgress,
            ) {
          if (loadingProgress ==
              null) {
            return child;
          }

          return Container(
            color: const Color(
              0xFF151822,
            ),
            child:
            const Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        },

        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _buildEmptyPreview();
        },
      ),
    );
  }

  // =====================================================
  // EMPTY PREVIEW
  // =====================================================

  Widget _buildEmptyPreview() {
    return Container(
      decoration:
      const BoxDecoration(
        gradient: LinearGradient(
          begin:
          Alignment.topLeft,
          end:
          Alignment.bottomRight,
          colors: [
            Color(0xFF171A27),
            Color(0xFF0D0F17),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          widget.category.icon,
          size: 64,
          color:
          Colors.white.withOpacity(
            0.08,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // DOTS
  // =====================================================

  Widget _buildDots() {
    final visibleCount =
    _categoryWallpapers.length > 5
        ? 5
        : _categoryWallpapers.length;

    if (visibleCount <= 0) {
      return const SizedBox.shrink();
    }

    final activeIndex =
        _currentIndex % visibleCount;

    return Row(
      mainAxisSize:
      MainAxisSize.min,
      children: List.generate(
        visibleCount,
            (index) {
          final active =
              index == activeIndex;

          return AnimatedContainer(
            duration:
            const Duration(
              milliseconds: 250,
            ),
            margin:
            const EdgeInsets.only(
              left: 4,
            ),
            width:
            active ? 15 : 5,
            height: 5,
            decoration:
            BoxDecoration(
              color: active
                  ? Colors.white
                  : Colors.white38,
              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),
          );
        },
      ),
    );
  }
}