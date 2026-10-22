package com.hirieo.valleysave

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import rikka.shizuku.Shizuku
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

/** Per-run calibration. Coordinates are collected from the actual title screen and never persisted. */
internal class CoopCalibrationOverlay(
    private val context: Context,
    private val spanish: Boolean,
    private val onFinished: (Map<String, Any>) -> Unit,
) {
    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val points = ArrayList<Int>(10)
    private val completed = AtomicBoolean(false)
    private val handler = Handler(Looper.getMainLooper())
    @Volatile private var gameWasForeground = false
    private var initialWidth = 0
    private var initialHeight = 0
    private var initialRotation = 0
    private val labels = if (spanish) {
        listOf("hoja marcada W (↑)", "hoja marcada V (↓)", "hojas sobre S (←)", "hoja junto a Y (→)", "botón ?")
    } else {
        listOf("the W leaf (↑)", "the V leaf (↓)", "leaves above S (←)", "the leaf by Y (→)", "the ? button")
    }
    private var root: FrameLayout? = null
    private val cancelTimeout = Runnable { finish(mapOf("status" to "timeout")) }

    fun show() {
        val initialDisplay = windowManager.defaultDisplay
        val initialSize = android.graphics.Point()
        initialDisplay.getRealSize(initialSize)
        initialWidth = initialSize.x
        initialHeight = initialSize.y
        initialRotation = initialDisplay.rotation
        val overlay = FrameLayout(context)
        overlay.setBackgroundColor(Color.TRANSPARENT)
        val guide = GuideView(context)
        overlay.addView(guide, FrameLayout.LayoutParams(-1, -1))

        val panel = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(dp(18), dp(12), dp(18), dp(10))
            background = GradientDrawable().apply {
                setColor(Color.argb(225, 20, 24, 21))
                cornerRadius = dp(14).toFloat()
                setStroke(dp(1), Color.argb(190, 179, 219, 133))
            }
        }
        val title = TextView(context).apply {
            text = if (spanish) "Calibrar menú cooperativo" else "Calibrate co-op menu"
            setTextColor(Color.WHITE)
            textSize = 17f
            typeface = Typeface.DEFAULT_BOLD
            gravity = Gravity.CENTER
        }
        val instruction = TextView(context).apply {
            text = stepText()
            setTextColor(Color.WHITE)
            textSize = 14f
            gravity = Gravity.CENTER
            setPadding(0, dp(8), 0, dp(8))
        }
        val cancel = Button(context).apply {
            text = if (spanish) "Cancelar" else "Cancel"
            setOnClickListener { finish(mapOf("status" to "cancelled")) }
        }
        val confirm = Button(context).apply {
            text = if (spanish) "Confirmar y enviar toques" else "Confirm and send taps"
            visibility = View.GONE
            setOnClickListener { finish(mapOf("status" to "ready")) }
        }
        panel.addView(title, LinearLayout.LayoutParams(-1, -2))
        panel.addView(instruction, LinearLayout.LayoutParams(-1, -2))
        panel.addView(confirm, LinearLayout.LayoutParams(-1, -2))
        panel.addView(cancel, LinearLayout.LayoutParams(-1, -2))
        panel.setOnTouchListener { _, _ -> true }
        overlay.addView(panel, FrameLayout.LayoutParams(-1, -2, Gravity.BOTTOM))
        overlay.setOnTouchListener { _, event ->
            if (event.action == MotionEvent.ACTION_UP && points.size < labels.size * 2) {
                val current = windowManager.defaultDisplay
                val size = android.graphics.Point()
                current.getRealSize(size)
                if (size.x != initialWidth || size.y != initialHeight || current.rotation != initialRotation) {
                    finish(mapOf("status" to "display_changed"))
                    return@setOnTouchListener true
                }
                points.add(event.rawX.toInt())
                points.add(event.rawY.toInt())
                instruction.text = stepText()
                if (points.size == labels.size * 2) confirm.visibility = View.VISIBLE
                guide.invalidate()
            }
            true
        }
        root = overlay
        try {
            windowManager.addView(overlay, WindowManager.LayoutParams(
                -1, -1,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
                android.graphics.PixelFormat.TRANSLUCENT,
            ).apply { gravity = Gravity.TOP or Gravity.START })
            overlay.postDelayed(cancelTimeout, 60_000L)
            val watchStartedAt = SystemClock.elapsedRealtime()
            overlay.postDelayed({ watchForeground(watchStartedAt) }, 800L)
        } catch (_: Throwable) {
            finish(mapOf("status" to "overlay_error"))
        }
    }

    fun cancel() = finish(mapOf("status" to "cancelled"))

    private fun watchForeground(startedAt: Long) {
        if (completed.get()) return
        Thread {
            val foreground = try {
                val process = Shizuku.newProcess(
                    arrayOf("sh", "-c", "dumpsys window 2>/dev/null | grep -E 'mCurrentFocus|mFocusedApp' | tail -n 1"),
                    null,
                    null,
                )
                if (!process.waitFor(900, TimeUnit.MILLISECONDS)) {
                    process.destroyForcibly()
                    false
                } else {
                    process.exitValue() == 0 && process.inputStream.bufferedReader().use { it.readText() }
                        .contains("com.chucklefish.stardewvalley")
                }
            } catch (_: Throwable) { false }
            handler.post {
                if (completed.get()) return@post
                if (foreground) {
                    gameWasForeground = true
                    handler.postDelayed({ watchForeground(startedAt) }, 900L)
                } else if (gameWasForeground || SystemClock.elapsedRealtime() - startedAt > 10_000L) {
                    finish(mapOf("status" to "not_foreground"))
                } else {
                    handler.postDelayed({ watchForeground(startedAt) }, 900L)
                }
            }
        }.start()
    }

    private fun stepText(): String {
        val index = points.size / 2
        return when {
            index < labels.size -> (if (spanish) "Toca " else "Tap ") + labels[index] + "  (${index + 1}/${labels.size})"
            else -> if (spanish) {
                "Revisa los puntos. Mantén Stardew en el título y confirma para enviar los toques."
            } else {
                "Review the points. Keep Stardew on its title screen and confirm to send the taps."
            }
        }
    }

    private fun finish(result: Map<String, Any>) {
        if (!completed.compareAndSet(false, true)) return
        root?.removeCallbacks(cancelTimeout)
        root?.let { try { windowManager.removeView(it) } catch (_: Throwable) {} }
        root = null
        if (result["status"] == "ready") {
            val display = windowManager.defaultDisplay
            val size = android.graphics.Point()
            display.getRealSize(size)
            if (size.x != initialWidth || size.y != initialHeight || display.rotation != initialRotation) {
                onFinished(mapOf("status" to "display_changed"))
            } else {
                onFinished(result + mapOf("points" to points.toList(), "width" to initialWidth, "height" to initialHeight, "rotation" to initialRotation))
            }
        } else onFinished(result)
    }

    private fun dp(value: Int) = (value * context.resources.displayMetrics.density).toInt()

    private inner class GuideView(context: Context) : View(context) {
        private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        override fun onDraw(canvas: Canvas) {
            super.onDraw(canvas)
            canvas.drawColor(Color.argb(28, 0, 0, 0))
            val location = IntArray(2)
            getLocationOnScreen(location)
            for (index in 0 until points.size / 2) {
                val x = points[index * 2].toFloat()
                val y = points[index * 2 + 1].toFloat()
                paint.color = Color.argb(190, 245, 210, 74)
                paint.style = Paint.Style.STROKE
                paint.strokeWidth = dp(2).toFloat()
                canvas.drawCircle(x - location[0], y - location[1], dp(14).toFloat(), paint)
                paint.style = Paint.Style.FILL
                paint.color = Color.argb(220, 245, 210, 74)
                canvas.drawCircle(x - location[0], y - location[1], dp(3).toFloat(), paint)
            }
            paint.color = Color.WHITE
            paint.textSize = dp(13).toFloat()
            paint.typeface = Typeface.DEFAULT_BOLD
            val text = if (spanish) "Vuelve al título de Stardew y toca la hoja indicada" else "Return to Stardew's title screen and tap the indicated leaf"
            canvas.drawText(text, dp(16).toFloat(), dp(30).toFloat(), paint)
        }
    }
}
