package com.example.wallora

import android.app.WallpaperManager
import android.content.ComponentName
import android.content.Intent
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {

    private val channel = "wallora/live_wallpaper"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                // =========================================
                // LIVE WALLPAPER
                // =========================================

                "openLiveWallpaper" -> {

                    val videoUrl =
                        call.argument<String>(
                            "videoUrl"
                        ) ?: ""

                    if (videoUrl.isBlank()) {
                        result.error(
                            "VIDEO_URL_ERROR",
                            "Video URL is empty.",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    getSharedPreferences(
                        "wallora_settings",
                        MODE_PRIVATE
                    )
                        .edit()
                        .putString(
                            "videoUrl",
                            videoUrl
                        )
                        .apply()

                    try {
                        openWallpaperPicker()

                        result.success(true)
                    } catch (e: Exception) {
                        result.error(
                            "WALLPAPER_ERROR",
                            e.message
                                ?: "Unable to open live wallpaper.",
                            null
                        )
                    }
                }

                // =========================================
                // PHOTO WALLPAPER
                // =========================================

                "setPhotoWallpaper" -> {

                    val imageUrl =
                        call.argument<String>(
                            "imageUrl"
                        ) ?: ""

                    if (imageUrl.isBlank()) {
                        result.error(
                            "IMAGE_URL_ERROR",
                            "Image URL is empty.",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    setPhotoWallpaper(
                        imageUrl,
                        result
                    )
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // =====================================================
    // LIVE WALLPAPER
    // =====================================================

    private fun openWallpaperPicker() {

        try {

            val intent =
                Intent(
                    WallpaperManager
                        .ACTION_CHANGE_LIVE_WALLPAPER
                )

            intent.putExtra(
                WallpaperManager
                    .EXTRA_LIVE_WALLPAPER_COMPONENT,
                ComponentName(
                    this,
                    WalloraWallpaperService::class.java
                )
            )

            startActivity(intent)

        } catch (e: Exception) {

            val intent =
                Intent(
                    WallpaperManager
                        .ACTION_LIVE_WALLPAPER_CHOOSER
                )

            startActivity(intent)
        }
    }

    // =====================================================
    // PHOTO WALLPAPER
    // =====================================================

    private fun setPhotoWallpaper(
        imageUrl: String,
        result: MethodChannel.Result
    ) {

        thread {

            var connection: HttpURLConnection? =
                null

            try {

                // =========================================
                // DOWNLOAD IMAGE
                // =========================================

                val url = URL(imageUrl)

                connection =
                    url.openConnection()
                            as HttpURLConnection

                connection.connectTimeout = 15000
                connection.readTimeout = 30000
                connection.instanceFollowRedirects =
                    true
                connection.doInput = true

                connection.setRequestProperty(
                    "User-Agent",
                    "Wallora"
                )

                connection.connect()

                val responseCode =
                    connection.responseCode

                if (responseCode !in 200..299) {

                    throw Exception(
                        "Image download failed. HTTP $responseCode"
                    )
                }

                // =========================================
                // DECODE IMAGE
                // =========================================

                val bitmap =
                    connection.inputStream.use {
                            inputStream ->

                        BitmapFactory.decodeStream(
                            inputStream
                        )
                    }

                if (bitmap == null) {

                    throw Exception(
                        "Android could not decode the image."
                    )
                }

                // =========================================
                // SET WALLPAPER
                // =========================================

                val wallpaperManager =
                    WallpaperManager.getInstance(
                        applicationContext
                    )

                wallpaperManager.setBitmap(
                    bitmap,
                    null,
                    true,
                    WallpaperManager.FLAG_SYSTEM
                )

                bitmap.recycle()

                // =========================================
                // SUCCESS
                // =========================================

                runOnUiThread {

                    result.success(
                        mapOf(
                            "success" to true,
                            "message" to
                                    "Wallpaper applied successfully."
                        )
                    )
                }

            } catch (e: Exception) {

                e.printStackTrace()

                // =========================================
                // ERROR
                // =========================================

                runOnUiThread {

                    result.error(
                        "PHOTO_WALLPAPER_ERROR",
                        e.message
                            ?: e.javaClass.simpleName,
                        null
                    )
                }

            } finally {

                connection?.disconnect()
            }
        }
    }
}