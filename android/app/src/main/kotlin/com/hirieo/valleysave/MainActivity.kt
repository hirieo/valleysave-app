package com.hirieo.valleysave

import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rikka.shizuku.Shizuku
import java.io.File

class MainActivity : FlutterActivity() {
    private var binderAlive = false

    // El binder de Shizuku llega de forma asíncrona; con este listener nos
    // enteramos aunque Shizuku se active con la app ya abierta.
    private val onBinderReceived = Shizuku.OnBinderReceivedListener { binderAlive = true }
    private val onBinderDead = Shizuku.OnBinderDeadListener { binderAlive = false }

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
                    "isAlive" -> result.success(isShizukuAlive())
                    "openShizuku" -> result.success(openShizuku())
                    "openWirelessDebug" -> result.success(openWirelessDebug())
                    "sdkInt" -> result.success(Build.VERSION.SDK_INT)
                    else -> result.notImplemented()
                }
            }
    }

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
