import 'package:flutter/material.dart';

import '../data/wallpapers_data.dart';
import '../widgets/wallpaper_card.dart';

class NaturePage extends StatelessWidget {
  const NaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final natureWallpapers =
    getWallpapersByCategory('nature');

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
              'Nature',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Explore nature live wallpapers',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),

      body: natureWallpapers.isEmpty
          ? const _EmptyNature()
          : GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),

        itemCount: natureWallpapers.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),

        itemBuilder: (context, index) {
          final wallpaper =
          natureWallpapers[index];

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
// EMPTY NATURE
// =====================================================

class _EmptyNature extends StatelessWidget {
  const _EmptyNature();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              Icons.landscape_rounded,
              size: 55,
              color: Colors.white24,
            ),

            SizedBox(height: 16),

            Text(
              'No Nature Wallpapers Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 7),

            Text(
              'New nature wallpapers will appear here.',
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