import 'package:flutter/material.dart';

import '../data/wallpapers_data.dart';
import '../widgets/wallpaper_card.dart';

class CarsPage extends StatelessWidget {
  const CarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carsWallpapers =
    getWallpapersByCategory('cars');

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
              'Cars',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Explore car live wallpapers',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),

      body: carsWallpapers.isEmpty
          ? const _EmptyCars()
          : GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),

        itemCount: carsWallpapers.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),

        itemBuilder: (context, index) {
          final wallpaper =
          carsWallpapers[index];

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
// EMPTY CARS
// =====================================================

class _EmptyCars extends StatelessWidget {
  const _EmptyCars();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              Icons.directions_car_rounded,
              size: 55,
              color: Colors.white24,
            ),

            SizedBox(height: 16),

            Text(
              'No Car Wallpapers Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 7),

            Text(
              'New car wallpapers will appear here.',
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