import 'package:flutter/material.dart';

import '../data/wallpapers_data.dart';
import '../models/wallpaper_item.dart';
import '../widgets/photo_wallpaper_card.dart';

class NaturePhotosPage extends StatelessWidget {
  const NaturePhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WallpaperItem> photos =
    getImagesByCategory('nature');

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
              'Nature Photos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Explore nature photo wallpapers',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),

      body: photos.isEmpty
          ? const _EmptyNaturePhotos()
          : GridView.builder(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),

        itemCount: photos.length,

        itemBuilder: (
            context,
            index,
            ) {
          final photo = photos[index];

          return PhotoWallpaperCard(
            wallpaper: photo,
            index: wallpapers.indexOf(photo),
          );
        },
      ),
    );
  }
}

// =====================================================
// EMPTY STATE
// =====================================================

class _EmptyNaturePhotos extends StatelessWidget {
  const _EmptyNaturePhotos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 82,
              height: 82,

              decoration: BoxDecoration(
                color: const Color(
                  0xFF7657FF,
                ).withOpacity(0.10),

                shape: BoxShape.circle,

                border: Border.all(
                  color: const Color(
                    0xFF7657FF,
                  ).withOpacity(0.15),
                ),
              ),

              child: const Icon(
                Icons.landscape_rounded,
                color: Color(0xFF9B87FF),
                size: 36,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Nature Photos Yet',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'New nature photo wallpapers will appear here.',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}