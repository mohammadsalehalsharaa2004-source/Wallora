package com.example.wallora

import android.media.MediaPlayer
import android.service.wallpaper.WallpaperService
import android.view.SurfaceHolder

class WalloraWallpaperService : WallpaperService() {

    override fun onCreateEngine(): Engine {
        return WalloraEngine()
    }

    inner class WalloraEngine : Engine() {

        private var mediaPlayer: MediaPlayer? = null
        private var isVisible = false

        override fun onSurfaceCreated(
            holder: SurfaceHolder
        ) {
            super.onSurfaceCreated(holder)

            startVideo(holder)
        }

        private fun startVideo(
            holder: SurfaceHolder
        ) {

            releasePlayer()

            // =========================================
            // قراءة رابط الفيديو المختار
            // =========================================

            val preferences =
                getSharedPreferences(
                    "wallora_settings",
                    MODE_PRIVATE
                )

            val videoUrl =
                preferences.getString(
                    "videoUrl",
                    ""
                ) ?: ""

            // =========================================
            // التأكد من وجود الرابط
            // =========================================

            if (videoUrl.isBlank()) {
                return
            }

            try {

                // =========================================
                // تشغيل فيديو R2 مباشرة
                // =========================================

                mediaPlayer =
                    MediaPlayer().apply {

                        setDataSource(
                            videoUrl
                        )

                        setSurface(
                            holder.surface
                        )

                        isLooping = true

                        setVolume(
                            0f,
                            0f
                        )

                        setOnPreparedListener { player ->

                            if (isVisible) {

                                try {
                                    player.start()
                                } catch (_: Exception) {
                                }
                            }
                        }

                        setOnErrorListener { _, what, extra ->

                            android.util.Log.e(
                                "WalloraWallpaper",
                                "MediaPlayer error: what=$what extra=$extra"
                            )

                            true
                        }

                        prepareAsync()
                    }

            } catch (e: Exception) {

                android.util.Log.e(
                    "WalloraWallpaper",
                    "Video error",
                    e
                )
            }
        }

        override fun onVisibilityChanged(
            visible: Boolean
        ) {

            super.onVisibilityChanged(
                visible
            )

            isVisible = visible

            mediaPlayer?.let { player ->

                try {

                    if (visible) {

                        if (!player.isPlaying) {
                            player.start()
                        }

                    } else {

                        if (player.isPlaying) {
                            player.pause()
                        }
                    }

                } catch (_: Exception) {
                }
            }
        }

        override fun onSurfaceDestroyed(
            holder: SurfaceHolder
        ) {

            releasePlayer()

            super.onSurfaceDestroyed(
                holder
            )
        }

        override fun onDestroy() {

            releasePlayer()

            super.onDestroy()
        }

        private fun releasePlayer() {

            mediaPlayer?.let { player ->

                try {

                    if (player.isPlaying) {
                        player.stop()
                    }

                } catch (_: Exception) {
                }

                try {

                    player.reset()
                    player.release()

                } catch (_: Exception) {
                }
            }

            mediaPlayer = null
        }
    }
}