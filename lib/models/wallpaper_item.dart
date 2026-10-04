enum WallpaperType {
  video,
  image,
}

class WallpaperItem {
  final String title;

  // رابط الملف سواء فيديو أو صورة
  final String mediaUrl;

  final String category;
  final bool isNew;
  final WallpaperType type;

  const WallpaperItem({
    required this.title,
    required this.mediaUrl,
    required this.category,
    required this.type,
    this.isNew = false,
  });

  bool get isVideo =>
      type == WallpaperType.video;

  bool get isImage =>
      type == WallpaperType.image;

  // مؤقتًا حتى تبقى الأكواد القديمة شغالة
  String get videoUrl => mediaUrl;
}