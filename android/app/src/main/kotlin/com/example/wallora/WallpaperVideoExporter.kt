package com.example.wallora

import android.content.Context
import android.graphics.Typeface
import android.net.Uri
import android.text.Spannable
import android.text.SpannableString
import android.text.style.ForegroundColorSpan
import android.text.style.RelativeSizeSpan
import android.text.style.StyleSpan

import androidx.annotation.OptIn
import androidx.media3.common.Effect
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.util.UnstableApi
import androidx.media3.effect.OverlayEffect
import androidx.media3.effect.StaticOverlaySettings
import androidx.media3.effect.TextOverlay
import androidx.media3.effect.TextureOverlay
import androidx.media3.transformer.Composition
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.Effects
import androidx.media3.transformer.ExportException
import androidx.media3.transformer.ExportResult
import androidx.media3.transformer.Transformer

import java.io.File
import java.io.FileOutputStream
import kotlin.math.PI

class WallpaperVideoExporter(
    private val context: Context
) {

    @OptIn(UnstableApi::class)
    fun export(
        onSuccess: (File) -> Unit,
        onError: (String) -> Unit
    ) {

        try {

            // =========================================
            // قراءة إعدادات المستخدم
            // =========================================

            val preferences =
                context.getSharedPreferences(
                    "wallora_settings",
                    Context.MODE_PRIVATE
                )

            val userName =
                preferences.getString(
                    "name",
                    "Wallora"
                ) ?: "Wallora"

            val fontSize =
                preferences.getFloat(
                    "fontSize",
                    48f
                )

            val textColor =
                preferences.getLong(
                    "color",
                    0xFFFFFFFFL
                )

            val glow =
                preferences.getBoolean(
                    "glow",
                    true
                )

            val positionX =
                preferences.getFloat(
                    "positionX",
                    0.5f
                )

            val positionY =
                preferences.getFloat(
                    "positionY",
                    0.5f
                )

            val rotationRadians =
                preferences.getFloat(
                    "rotation",
                    0f
                )

            // =========================================
            // تحويل الموقع
            //
            // Flutter:
            // X/Y من 0 إلى 1
            //
            // Media3:
            // X/Y من -1 إلى +1
            // =========================================

            val mediaX =
                (
                        positionX
                            .coerceIn(0f, 1f) *
                                2f
                        ) - 1f

            val mediaY =
                1f -
                        (
                                positionY
                                    .coerceIn(0f, 1f) *
                                        2f
                                )

            // =========================================
            // تحويل الدوران
            //
            // Flutter = radians
            // Media3 = degrees
            // =========================================

            val rotationDegrees =
                (
                        rotationRadians *
                                180.0 /
                                PI
                        ).toFloat()

            // =========================================
            // تجهيز الفيديو الأصلي
            // =========================================

            val inputFile =
                File(
                    context.cacheDir,
                    "wallora_input.mp4"
                )

            if (inputFile.exists()) {
                inputFile.delete()
            }

            context.resources
                .openRawResource(
                    R.raw.wallpaper1
                )
                .use { input ->

                    FileOutputStream(
                        inputFile
                    ).use { output ->

                        input.copyTo(
                            output
                        )
                    }
                }

            // =========================================
            // الفيديو النهائي
            // =========================================

            val outputFile =
                File(
                    context.filesDir,
                    "wallora_custom.mp4"
                )

            if (outputFile.exists()) {
                outputFile.delete()
            }

            // =========================================
            // تجهيز النص
            // =========================================

            val overlayText =
                SpannableString(
                    userName
                )

            // اللون
            overlayText.setSpan(
                ForegroundColorSpan(
                    textColor.toInt()
                ),
                0,
                overlayText.length,
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
            )

            // Bold
            overlayText.setSpan(
                StyleSpan(
                    Typeface.BOLD
                ),
                0,
                overlayText.length,
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
            )

            // =========================================
            // حجم الخط
            // =========================================

            val sizeScale =
                (
                        fontSize /
                                48f
                        ).coerceIn(
                        0.4f,
                        4.0f
                    )

            overlayText.setSpan(
                RelativeSizeSpan(
                    sizeScale
                ),
                0,
                overlayText.length,
                Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
            )

            // =========================================
            // إعداد مكان ودوران النص
            // =========================================

            val overlaySettings =
                StaticOverlaySettings.Builder()

                    // مركز النص
                    .setOverlayFrameAnchor(
                        0f,
                        0f
                    )

                    // مكان النص داخل الفيديو
                    .setBackgroundFrameAnchor(
                        mediaX,
                        mediaY
                    )

                    // دوران النص
                    .setRotationDegrees(
                        rotationDegrees
                    )

                    .build()

            // =========================================
            // إنشاء Text Overlay
            // =========================================

            val textOverlay =
                TextOverlay.createStaticTextOverlay(
                    overlayText,
                    overlaySettings
                )

            // =========================================
            // مهم:
            // OverlayEffect يحتاج List<TextureOverlay>
            // وليس List<TextOverlay>
            // =========================================

            val overlays =
                mutableListOf<TextureOverlay>(
                    textOverlay
                )

            // =========================================
            // Glow
            //
            // القيمة تصل من Flutter بشكل صحيح.
            // سنضيف تأثير Neon الحقيقي بعد التأكد
            // من الموقع والدوران.
            // =========================================

            if (glow) {
                // Neon Glow سيتم إضافته لاحقاً
            }

            // =========================================
            // Overlay Effect
            // =========================================

            val overlayEffect =
                OverlayEffect(
                    overlays
                )

            // =========================================
            // Effects
            // =========================================

            val effects =
                Effects(
                    emptyList(),
                    listOf<Effect>(
                        overlayEffect
                    )
                )

            // =========================================
            // Media Item
            // =========================================

            val mediaItem =
                MediaItem.fromUri(
                    Uri.fromFile(
                        inputFile
                    )
                )

            // =========================================
            // Edited Media Item
            // =========================================

            val editedMediaItem =
                EditedMediaItem.Builder(
                    mediaItem
                )
                    .setRemoveAudio(
                        true
                    )
                    .setEffects(
                        effects
                    )
                    .build()

            // =========================================
            // Transformer
            // =========================================

            val transformer =
                Transformer.Builder(
                    context
                )
                    .setVideoMimeType(
                        MimeTypes.VIDEO_H264
                    )
                    .addListener(

                        object :
                            Transformer.Listener {

                            // =========================
                            // نجاح التصدير
                            // =========================

                            override fun onCompleted(
                                composition:
                                Composition,

                                exportResult:
                                ExportResult
                            ) {

                                if (
                                    outputFile.exists() &&
                                    outputFile.length() > 0
                                ) {

                                    onSuccess(
                                        outputFile
                                    )

                                } else {

                                    onError(
                                        "Export finished but output file is empty."
                                    )
                                }
                            }

                            // =========================
                            // خطأ أثناء التصدير
                            // =========================

                            override fun onError(
                                composition:
                                Composition,

                                exportResult:
                                ExportResult,

                                exportException:
                                ExportException
                            ) {

                                onError(
                                    exportException
                                        .message
                                        ?: "Video export failed"
                                )
                            }
                        }
                    )
                    .build()

            // =========================================
            // بدء التصدير
            // =========================================

            transformer.start(
                editedMediaItem,
                outputFile.absolutePath
            )

        } catch (e: Exception) {

            onError(
                e.message
                    ?: "Unknown export error"
            )
        }
    }
}