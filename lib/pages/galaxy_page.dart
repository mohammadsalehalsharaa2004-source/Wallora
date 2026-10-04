import 'package:flutter/material.dart';

import '../models/wallpaper_item.dart';
import '../services/wallpaper_service.dart';
import '../widgets/wallpaper_card.dart';

class GalaxyPage extends StatefulWidget {
  const GalaxyPage({super.key});

  @override
  State<GalaxyPage> createState() =>
      _GalaxyPageState();
}

class _GalaxyPageState extends State<GalaxyPage> {
  late Future<List<WallpaperItem>>
  _galaxyWallpapersFuture;

  @override
  void initState() {
    super.initState();

    _loadWallpapers();
  }

  void _loadWallpapers() {
    _galaxyWallpapersFuture =
        WallpaperService.getByCategory(
          category: 'galaxy',
          type: WallpaperType.video,
        );
  }

  Future<void> _refreshWallpapers() async {
    setState(() {
      _loadWallpapers();
    });

    await _galaxyWallpapersFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF090B12),

      // ===================================================
      // APP BAR
      // ===================================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Galaxy',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Explore galaxy live wallpapers',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),

      // ===================================================
      // BODY
      // ===================================================

      body: FutureBuilder<List<WallpaperItem>>(
        future: _galaxyWallpapersFuture,
        builder: (
            context,
            snapshot,
            ) {
          // ===============================================
          // LOADING
          // ===============================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ===============================================
          // ERROR
          // ===============================================

          if (snapshot.hasError) {
            return _GalaxyError(
              error: snapshot.error.toString(),
              onRetry: () {
                setState(() {
                  _loadWallpapers();
                });
              },
            );
          }

          final galaxyWallpapers =
              snapshot.data ??
                  <WallpaperItem>[];

          // ===============================================
          // EMPTY
          // ===============================================

          if (galaxyWallpapers.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshWallpapers,
              child: const CustomScrollView(
                physics:
                AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyGalaxy(),
                  ),
                ],
              ),
            );
          }

          // ===============================================
          // WALLPAPERS
          // ===============================================

          return RefreshIndicator(
            onRefresh: _refreshWallpapers,
            child: GridView.builder(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding:
              const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                30,
              ),
              itemCount:
              galaxyWallpapers.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (
                  context,
                  index,
                  ) {
                final wallpaper =
                galaxyWallpapers[index];

                return WallpaperCard(
                  wallpaper: wallpaper,
                  index: index,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// EMPTY GALAXY
// =====================================================

class _EmptyGalaxy extends StatelessWidget {
  const _EmptyGalaxy();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.public_rounded,
              size: 55,
              color: Colors.white24,
            ),
            SizedBox(height: 16),
            Text(
              'No Galaxy Wallpapers Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'New galaxy wallpapers will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// ERROR
// =====================================================

class _GalaxyError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _GalaxyError({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 55,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to Load Wallpapers',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Could not connect to the wallpaper database.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white30,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}