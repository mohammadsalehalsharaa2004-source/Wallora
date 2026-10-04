import 'package:flutter/material.dart';

import '../data/wallpapers_data.dart';
import '../widgets/wallpaper_card.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final newWallpapers = getNewWallpapers();

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
              'New',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Discover the latest live wallpapers',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),

      body: newWallpapers.isEmpty
          ? const _EmptyNew()
          : GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),

        itemCount: newWallpapers.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),

        itemBuilder: (context, index) {
          final wallpaper = newWallpapers[index];

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
// EMPTY NEW
// =====================================================

class _EmptyNew extends StatelessWidget {
  const _EmptyNew();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 55,
              color: Colors.white24,
            ),

            SizedBox(height: 16),

            Text(
              'No New Wallpapers Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 7),

            Text(
              'The latest Wallora wallpapers will appear here.',
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