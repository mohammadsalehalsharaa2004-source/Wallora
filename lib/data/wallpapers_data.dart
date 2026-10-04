import '../models/wallpaper_item.dart';

// =====================================================
// ALL WALLPAPERS
// =====================================================

const List<WallpaperItem> wallpapers = [


  WallpaperItem(
    title: 'Wallora Photo 1',
    mediaUrl:
    'https://pub-7d9abc40a084459788129f8e6f324b02.r2.dev/image.jfif',
    category: 'nature',
    type: WallpaperType.image,
    isNew: true,
  ),

  // ===================================================
  // LIVE WALLPAPERS
  // ===================================================

  WallpaperItem(
    title: 'Wallora 1',
    mediaUrl:
    'https://pub-7d9abc40a084459788129f8e6f324b02.r2.dev/111/eh1.mp4',
    category: 'galaxy',
    type: WallpaperType.video,
    isNew: true,
  ),

  WallpaperItem(
    title: 'Wallora 2',
    mediaUrl:
    'https://pub-7d9abc40a084459788129f8e6f324b02.r2.dev/111/eh%202.mp4',
    category: 'animals',
    type: WallpaperType.video,
    isNew: true,
  ),

  // ===================================================
  // PHOTOS
  // ===================================================
  //
  // لما ترفع صور على R2 أضفها بهذا الشكل:
  //
  // WallpaperItem(
  //   title: 'Nature Photo 1',
  //   mediaUrl:
  //       'https://YOUR-LINK/image.jpg',
  //   category: 'nature',
  //   type: WallpaperType.image,
  //   isNew: true,
  // ),
];

// =====================================================
// LIVE WALLPAPERS
// =====================================================

List<WallpaperItem> getVideoWallpapers() {
  return wallpapers
      .where(
        (wallpaper) => wallpaper.isVideo,
  )
      .toList();
}

// =====================================================
// PHOTOS
// =====================================================

List<WallpaperItem> getImageWallpapers() {
  return wallpapers
      .where(
        (wallpaper) => wallpaper.isImage,
  )
      .toList();
}

// =====================================================
// FILTER BY CATEGORY
// =====================================================

List<WallpaperItem> getWallpapersByCategory(
    String category, {
      WallpaperType? type,
    }) {
  return wallpapers.where(
        (wallpaper) {
      final sameCategory =
          wallpaper.category == category;

      final sameType =
          type == null ||
              wallpaper.type == type;

      return sameCategory && sameType;
    },
  ).toList();
}

// =====================================================
// NEW WALLPAPERS
// =====================================================

List<WallpaperItem> getNewWallpapers({
  WallpaperType? type,
}) {
  return wallpapers.where(
        (wallpaper) {
      final isNew = wallpaper.isNew;

      final sameType =
          type == null ||
              wallpaper.type == type;

      return isNew && sameType;
    },
  ).toList();
}

// =====================================================
// LIVE BY CATEGORY
// =====================================================

List<WallpaperItem> getVideosByCategory(
    String category,
    ) {
  return getWallpapersByCategory(
    category,
    type: WallpaperType.video,
  );
}

// =====================================================
// PHOTOS BY CATEGORY
// =====================================================

List<WallpaperItem> getImagesByCategory(
    String category,
    ) {
  return getWallpapersByCategory(
    category,
    type: WallpaperType.image,
  );
}