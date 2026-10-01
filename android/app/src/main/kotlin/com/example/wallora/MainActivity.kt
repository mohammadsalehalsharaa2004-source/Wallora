package com.example.wallora

import android.app.WallpaperManager
import android.content.ComponentName
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

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

                "openLiveWallpaper" -> {

                    val name =
                        call.argument<String>("name")
                            ?: "Wallora"

                    val fontSize =
                        call.argument<Double>("fontSize")
                            ?: 48.0

                    val color =
                        call.argument<Long>("color")
                            ?: 0xFFFFFFFFL

                    val glow =
                        call.argument<Boolean>("glow")
                            ?: true

                    val positionX =
                        call.argument<Double>("positionX")
                            ?: 80.0

                    val positionY =
                        call.argument<Double>("positionY")
                            ?: 200.0

                    val rotation =
                        call.argument<Double>("rotation")
                            ?: 0.0

                    // =====================================
                    // حفظ إعدادات المستخدم
                    // =====================================

                    getSharedPreferences(
                        "wallora_settings",
                        MODE_PRIVATE
                    )
                        .edit()
                        .putString(
                            "name",
                            name
                        )
                        .putFloat(
                            "fontSize",
                            fontSize.toFloat()
                        )
                        .putLong(
                            "color",
                            color
                        )
                        .putBoolean(
                            "glow",
                            glow
                        )
                        .putFloat(
                            "positionX",
                            positionX.toFloat()
                        )
                        .putFloat(
                            "positionY",
                            positionY.toFloat()
                        )
                        .putFloat(
                            "rotation",
                            rotation.toFloat()
                        )
                        .apply()

                    // =====================================
                    // تصدير الفيديو
                    // =====================================

                    val exporter =
                        WallpaperVideoExporter(
                            applicationContext
                        )

                    exporter.export(

                        onSuccess = {

                            runOnUiThread {

                                try {

                                    openWallpaperPicker()

                                    result.success(true)

                                } catch (e: Exception) {

                                    result.error(
                                        "WALLPAPER_ERROR",
                                        e.message,
                                        null
                                    )
                                }
                            }
                        },

                        onError = { error ->

                            runOnUiThread {

                                result.error(
                                    "EXPORT_ERROR",
                                    error,
                                    null
                                )
                            }
                        }
                    )
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // =============================================
    // فتح شاشة Live Wallpapers
    // =============================================

    private fun openWallpaperPicker() {

        try {

            // نطلب من Android فتح Wallora مباشرة
            val directIntent = Intent(
                WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER
            )

            directIntent.putExtra(
                WallpaperManager.EXTRA_LIVE_WALLPAPER_COMPONENT,
                ComponentName(
                    this,
                    WalloraWallpaperService::class.java
                )
            )

            startActivity(directIntent)

        } catch (e: Exception) {

            // Samsung أو الجهاز لم يقبل الفتح المباشر
            // نفتح قائمة Live Wallpapers العامة

            val chooserIntent = Intent(
                WallpaperManager.ACTION_LIVE_WALLPAPER_CHOOSER
            )

            startActivity(chooserIntent)
        }
    }
}