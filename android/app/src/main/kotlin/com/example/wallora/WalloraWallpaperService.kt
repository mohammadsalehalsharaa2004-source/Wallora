package com.example.wallora

import android.media.MediaPlayer
import android.service.wallpaper.WallpaperService
import android.view.SurfaceHolder
import java.io.File

class WalloraWallpaperService : WallpaperService() {

    override fun onCreateEngine(): Engine {
        return WalloraEngine()
    }

    inner class WalloraEngine : Engine() {

        private var mediaPlayer: MediaPlayer? = null
        private var isVisible = false

        override fun onSurfaceCreated(holder: SurfaceHolder) {
            super.onSurfaceCreated(holder)

            startVideo(holder)
        }

        private fun startVideo(holder: SurfaceHolder) {

            releasePlayer()

            // الفيديو الذي تم تصديره من Media3
            val customVideo = File(
                filesDir,
                "wallora_custom.mp4"
            )

            if (customVideo.exists() && customVideo.length() > 0) {

                // ==========================================
                // تشغيل الفيديو المعدل الذي يحتوي النص
                // ==========================================

                mediaPlayer = MediaPlayer().apply {

                    setDataSource(
                        customVideo.absolutePath
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
                            player.start()
                        }
                    }

                    setOnErrorListener { _, _, _ ->

                        false
                    }

                    prepareAsync()
                }

            } else {

                // ==========================================
                // إذا لم يوجد الفيديو المعدل
                // نشغل الفيديو الأصلي
                // ==========================================

                mediaPlayer = MediaPlayer.create(
                    applicationContext,
                    R.raw.wallpaper1
                )

                mediaPlayer?.apply {

                    setSurface(
                        holder.surface
                    )

                    isLooping = true

                    setVolume(
                        0f,
                        0f
                    )

                    if (isVisible) {

                        try {
                            start()
                        } catch (_: Exception) {
                        }
                    }
                }
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