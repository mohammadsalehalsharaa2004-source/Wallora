import 'package:flutter/material.dart';

import '../data/wallpapers_data.dart';
import '../widgets/wallpaper_card.dart';

class GalaxyPage extends StatelessWidget {
  const GalaxyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final galaxyWallpapers =
    getWallpapersByCategory('galaxy');

    return Scaffold(
      backgroundColor: const Color(0xFF090B12),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

      body: galaxyWallpapers.isEmpty
          ? const _EmptyGalaxy()
          : GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),

        itemCount: galaxyWallpapers.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),

        itemBuilder: (context, index) {
          final wallpaper =
          galaxyWallpapers[index];

          return WallpaperCard(
            wallpaper: wallpaper,
            index: wallpapers.indexOf(wallpaper),
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