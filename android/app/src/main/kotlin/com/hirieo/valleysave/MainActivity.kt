package com.hirieo.valleysave

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rikka.shizuku.Shizuku
import java.io.File

class MainActivity : FlutterActivity() {
    private var binderAlive = false

    private val onBinderReceived = Shizuku.OnBinderReceivedListener { binderAlive = true }
    private val onBinderDead = Shizuku.OnBinderDeadListener { binderAlive = false }

    private val mainHandler = Handler(Looper.getMainLooper())

    companion object {
        private const val SAVES_PATH =
            "/storage/emulated/0/Android/data/com.chucklefish.stardewvalley/files/Saves"
        private const val ROOT_TIMEOUT_MS = 15_000L
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        try {
            Shizuku.addBinderReceivedListenerSticky(onBinderReceived)
            Shizuku.addBinderDeadListener(onBinderDead)
        } catch (_: Throwable) {
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "valleysave/apk_installer")
            .setMethodCallHandler { call, result ->
                if (call.method == "install") {
                    val path = call.argument<String>("path")
                    if (path == null) { result.error("NO_PATH", "No path provided", null); return@setMethodCallHandler }
                    try {
                        val file = File(path)
                        val uri = FileProvider.getUriForFile(this, "${packageName}.fileprovider", file)
                        val intent = Intent(Intent.ACTION_VIEW).apply {
                            setDataAndType(uri, "application/vnd.android.package-archive")
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        }
                        startActivity(intent)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("INSTALL_ERROR", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "valleysave/shizuku")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isAlive"  -> result.success(isShizukuAlive())
                    "openShizuku" -> result.success(openShizuku())
                    "openWirelessDebug" -> result.success(openWirelessDebug())
                    "sdkInt"   -> result.success(Build.VERSION.SDK_INT)
                    "checkRoot" -> Thread {
                        val ok = runSu("id")
                        mainHandler.post { result.success(ok) }
                    }.start()
                    "pullSavesAsRoot" -> {
                        val dst = call.argument<String>("dst")
                        if (dst == null) { result.error("NO_DST", null, null); return@setMethodCallHandler }
                        Thread {
                            val ok = runSu("cp -rfp \"$SAVES_PATH/.\" \"$dst/\"")
                            mainHandler.post { result.success(ok) }
                        }.start()
                    }
                    "pushSaveAsRoot" -> {
                        val src  = call.argument<String>("src")
                        val name = call.argument<String>("name")
                        if (src == null || name == null) { result.error("BAD_ARGS", null, null); return@setMethodCallHandler }
                        Thread {
                            val ok = runSu("cp -rfp \"$src\" \"$SAVES_PATH/$name\"")
                            mainHandler.post { result.success(ok) }
                        }.start()
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /** Ejecuta un comando como root con timeout. Compatible con API 24+. */
    private fun runSu(cmd: String): Boolean = try {
        val proc = Runtime.getRuntime().exec(arrayOf("su", "-c", cmd))
        val waiter = Thread { try { proc.waitFor() } catch (_: InterruptedException) {} }
        waiter.start()
        waiter.join(ROOT_TIMEOUT_MS)
        if (waiter.isAlive) { proc.destroyForcibly(); false }
        else proc.exitValue() == 0
    } catch (_: Exception) { false }

    private fun isShizukuAlive(): Boolean = try {
        binderAlive || Shizuku.pingBinder()
    } catch (_: Throwable) {
        false
    }

    /** Abre Shizuku directamente (sin diálogo de selección). */
    private fun openShizuku(): Boolean {
        val intent = packageManager.getLaunchIntentForPackage("moe.shizuku.privileged.api")
            ?: return false
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
        return true
    }

    /** Abre Opciones de desarrollador resaltando "Depuración inalámbrica". */
    private fun openWirelessDebug(): Boolean = try {
        val key = "toggle_adb_wireless"
        val intent = Intent("android.settings.APPLICATION_DEVELOPMENT_SETTINGS").apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            putExtra(":settings:fragment_args_key", key)
            putExtra(":settings:show_fragment_args", Bundle().apply {
                putString(":settings:fragment_args_key", key)
            })
        }
        startActivity(intent)
        true
    } catch (_: Throwable) {
        false
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            Shizuku.removeBinderReceivedListener(onBinderReceived)
            Shizuku.removeBinderDeadListener(onBinderDead)
        } catch (_: Throwable) {
        }
    }
}
