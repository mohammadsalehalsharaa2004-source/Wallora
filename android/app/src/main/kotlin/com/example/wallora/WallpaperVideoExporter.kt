package com.example.wallora

import android.content.Context
import android.graphics.Typeface
import android.net.Uri
import android.os.Handler
import android.os.Looper
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
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread
import kotlin.math.PI

class WallpaperVideoExporter(
    private val context: Context
) {

    private val mainHandler =
        Handler(Looper.getMainLooper())

    @OptIn(UnstableApi::class)
    fun export(
        onSuccess: (File) -> Unit,
        onError: (String) -> Unit
    ) {

        // =============================================
        // قراءة الإعدادات
        // =============================================

        val preferences =
            context.getSharedPreferences(
                "wallora_settings",
                Context.MODE_PRIVATE
            )

        val userName =
            preferences.getString(
                "name",
                ""
            ) ?: ""

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

        val videoUrl =
            preferences.getString(
                "videoUrl",
                ""
            ) ?: ""

        // =============================================
        // التأكد من وجود رابط
        // =============================================

        if (videoUrl.isBlank()) {
            onError("Video URL is empty.")
            return
        }

        // =============================================
        // ملف الفيديو المؤقت
        // =============================================

        val inputFile =
            File(
                context.cacheDir,
                "wallora_input.mp4"
            )

        // =============================================
        // التنزيل فقط على Background Thread
        // =============================================

        thread {

            try {

                if (inputFile.exists()) {
                    inputFile.delete()
                }

                downloadVideo(
                    videoUrl,
                    inputFile
                )

                if (
                    !inputFile.exists() ||
                    inputFile.length() <= 0
                ) {

                    mainHandler.post {
                        onError(
                            "Downloaded video is empty."
                        )
                    }

                    return@thread
                }

                // =============================================
                // مهم جداً:
                // الرجوع إلى Main Thread قبل Media3 Transformer
                // =============================================

                mainHandler.post {

                    try {

                        startTransformer(
                            inputFile = inputFile,
                            userName = userName,
                            fontSize = fontSize,
                            textColor = textColor,
                            glow = glow,
                            positionX = positionX,
                            positionY = positionY,
                            rotationRadians = rotationRadians,
                            onSuccess = onSuccess,
                            onError = onError
                        )

                    } catch (e: Exception) {

                        onError(
                            e.message
                                ?: "Failed to start Transformer."
                        )
                    }
                }

            } catch (e: Exception) {

                mainHandler.post {

                    onError(
                        e.message
                            ?: "Video download failed."
                    )
                }
            }
        }
    }

    // =============================================
    // Media3 Transformer
    // يجب تشغيله على Main Thread
    // =============================================

    @OptIn(UnstableApi::class)
    private fun startTransformer(
        inputFile: File,
        userName: String,
        fontSize: Float,
        textColor: Long,
        glow: Boolean,
        positionX: Float,
        positionY: Float,
        rotationRadians: Float,
        onSuccess: (File) -> Unit,
        onError: (String) -> Unit
    ) {

        // =============================================
        // تحويل مكان النص
        // Flutter: 0..1
        // Media3: -1..+1
        // =============================================

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

        // =============================================
        // تحويل الدوران
        // radians -> degrees
        // =============================================

        val rotationDegrees =
            (
                    rotationRadians *
                            180.0 /
                            PI
                    ).toFloat()

        // =============================================
        // ملف الفيديو النهائي
        // =============================================

        val outputFile =
            File(
                context.filesDir,
                "wallora_custom.mp4"
            )

        if (outputFile.exists()) {
            outputFile.delete()
        }

        // =============================================
        // المؤثرات
        // =============================================

        val videoEffects =
            mutableListOf<Effect>()

        // =============================================
        // النص اختياري
        // إذا الاسم فارغ لن يظهر أي نص
        // =============================================

        if (userName.isNotBlank()) {

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

            // حجم الخط
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

            // =============================================
            // موقع ودوران النص
            // =============================================

            val overlaySettings =
                StaticOverlaySettings.Builder()
                    .setOverlayFrameAnchor(
                        0f,
                        0f
                    )
                    .setBackgroundFrameAnchor(
                        mediaX,
                        mediaY
                    )
                    .setRotationDegrees(
                        rotationDegrees
                    )
                    .build()

            // =============================================
            // Text Overlay
            // =============================================

            val textOverlay =
                TextOverlay.createStaticTextOverlay(
                    overlayText,
                    overlaySettings
                )

            val overlays =
                mutableListOf<TextureOverlay>(
                    textOverlay
                )

            // =============================================
            // Neon Glow
            // =============================================

            if (glow) {
                // سنضيف الـ Neon الحقيقي لاحقاً.
            }

            val overlayEffect =
                OverlayEffect(
                    overlays
                )

            videoEffects.add(
                overlayEffect
            )
        }

        // =============================================
        // Effects
        // =============================================

        val effects =
            Effects(
                emptyList(),
                videoEffects
            )

        // =============================================
        // Media Item
        // =============================================

        val mediaItem =
            MediaItem.fromUri(
                Uri.fromFile(
                    inputFile
                )
            )

        // =============================================
        // Edited Media Item
        // =============================================

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

        // =============================================
        // Transformer
        // =============================================

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

                        override fun onCompleted(
                            composition: Composition,
                            exportResult: ExportResult
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

                        override fun onError(
                            composition: Composition,
                            exportResult: ExportResult,
                            exportException: ExportException
                        ) {

                            onError(
                                exportException.message
                                    ?: "Video export failed."
                            )
                        }
                    }
                )
                .build()

        // =============================================
        // بدء التصدير
        // =============================================

        transformer.start(
            editedMediaItem,
            outputFile.absolutePath
        )
    }

    // =============================================
    // تنزيل الفيديو من Cloudflare R2
    // =============================================

    private fun downloadVideo(
        videoUrl: String,
        destination: File
    ) {

        var connection:
                HttpURLConnection? = null

        try {

            val url =
                URL(videoUrl)

            connection =
                url.openConnection()
                        as HttpURLConnection

            connection.requestMethod =
                "GET"

            connection.connectTimeout =
                15000

            connection.readTimeout =
                60000

            connection.instanceFollowRedirects =
                true

            connection.connect()

            val responseCode =
                connection.responseCode

            if (responseCode !in 200..299) {

                throw Exception(
                    "Video download failed. HTTP $responseCode"
                )
            }

            connection.inputStream.use { input ->

                destination
                    .outputStream()
                    .use { output ->

                        input.copyTo(
                            output
                        )
                    }
            }

        } finally {

            connection?.disconnect()
        }
    }
}