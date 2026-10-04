import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/wallpaper_item.dart';

class WallpaperService {
  WallpaperService._();

  static final SupabaseClient _supabase =
      Supabase.instance.client;

  // =====================================================
  // GET ALL ACTIVE WALLPAPERS
  // =====================================================

  static Future<List<WallpaperItem>>
  getActiveWallpapers() async {
    final response = await _supabase
        .from('wallpapers')
        .select()
        .eq('is_active', true)
        .order(
      'created_at',
      ascending: false,
    );

    return response
        .map<WallpaperItem>(
      _wallpaperFromMap,
    )
        .toList();
  }

  // =====================================================
  // GET LIVE WALLPAPERS
  // =====================================================

  static Future<List<WallpaperItem>>
  getLiveWallpapers() async {
    final response = await _supabase
        .from('wallpapers')
        .select()
        .eq('is_active', true)
        .eq('type', 'video')
        .order(
      'created_at',
      ascending: false,
    );

    return response
        .map<WallpaperItem>(
      _wallpaperFromMap,
    )
        .toList();
  }

  // =====================================================
  // GET PHOTO WALLPAPERS
  // =====================================================

  static Future<List<WallpaperItem>>
  getPhotoWallpapers() async {
    final response = await _supabase
        .from('wallpapers')
        .select()
        .eq('is_active', true)
        .eq('type', 'image')
        .order(
      'created_at',
      ascending: false,
    );

    return response
        .map<WallpaperItem>(
      _wallpaperFromMap,
    )
        .toList();
  }

  // =====================================================
  // GET BY CATEGORY
  // =====================================================

  static Future<List<WallpaperItem>>
  getByCategory({
    required String category,
    required WallpaperType type,
  }) async {
    final response = await _supabase
        .from('wallpapers')
        .select()
        .eq('is_active', true)
        .eq(
      'category',
      category,
    )
        .eq(
      'type',
      type == WallpaperType.video
          ? 'video'
          : 'image',
    )
        .order(
      'created_at',
      ascending: false,
    );

    return response
        .map<WallpaperItem>(
      _wallpaperFromMap,
    )
        .toList();
  }

  // =====================================================
  // GET NEW WALLPAPERS
  // =====================================================

  static Future<List<WallpaperItem>>
  getNewWallpapers({
    required WallpaperType type,
  }) async {
    final response = await _supabase
        .from('wallpapers')
        .select()
        .eq('is_active', true)
        .eq('is_new', true)
        .eq(
      'type',
      type == WallpaperType.video
          ? 'video'
          : 'image',
    )
        .order(
      'created_at',
      ascending: false,
    );

    return response
        .map<WallpaperItem>(
      _wallpaperFromMap,
    )
        .toList();
  }

  // =====================================================
  // CONVERT SUPABASE ROW TO WALLPAPER ITEM
  // =====================================================

  static WallpaperItem _wallpaperFromMap(
      Map<String, dynamic> data,
      ) {
    return WallpaperItem(
      title: data['title'] as String,
      mediaUrl: data['media_url'] as String,
      category: data['category'] as String,
      isNew: data['is_new'] as bool? ?? false,
      type: data['type'] == 'video'
          ? WallpaperType.video
          : WallpaperType.image,
    );
  }
}