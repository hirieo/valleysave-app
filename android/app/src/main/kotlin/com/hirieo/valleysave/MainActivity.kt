package com.hirieo.valleysave

import android.content.Intent
import org.xmlpull.v1.XmlPullParser
import java.util.concurrent.atomic.AtomicReference
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.TimeUnit
import java.io.StringReader
import android.graphics.Point
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.Settings
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

    private var coopCalibrationOverlay: CoopCalibrationOverlay? = null
    private var coopCalibrationResult: MethodChannel.Result? = null
    private val coopSequenceCancelled = AtomicBoolean(false)
    private val coopProcess = AtomicReference<Process?>(null)
    private val coopProcessLock = Any()

    companion object {
        private const val COOP_PREFS_PATH =
            "/data/user/0/com.chucklefish.stardewvalley/shared_prefs/com.chucklefish.stardewvalley_preferences.xml"
        private const val GAME_PACKAGE = "com.chucklefish.stardewvalley"
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
                    // Sin este permiso, startActivity(ACTION_VIEW) sobre un APK no
                    // lanza excepcion pero tampoco abre el instalador en muchos
                    // fabricantes (Xiaomi, Samsung...) - queda en silencio, sin
                    // pantalla ni error, indistinguible de un exito real desde Dart
                    // (2026-07-21, bug reportado: "no veo que salga nada"). Se
                    // comprueba explicitamente y se manda a Ajustes si falta.
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                        !packageManager.canRequestPackageInstalls()
                    ) {
                        try {
                            val settingsIntent = Intent(
                                Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                                Uri.parse("package:$packageName"),
                            ).apply { addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) }
                            startActivity(settingsIntent)
                        } catch (_: Exception) {
                        }
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    try {
                        val file = File(path)
                        val uri = FileProvider.getUriForFile(this, "${packageName}.fileprovider", file)
                        val intent = Intent(Intent.ACTION_VIEW).apply {
                            setDataAndType(uri, "application/vnd.android.package-archive")
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INSTALL_ERROR", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "valleysave/game")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isInstalled" -> result.success(isGameInstalled())
                    "launch"      -> result.success(launchGame())
                    else -> result.notImplemented()
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
                    "hasOverlayPermission" -> result.success(
                        Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this),
                    )
                    "requestOverlayPermission" -> {
                        try {
                            val intent = Intent(
                                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:$packageName"),
                            )
                            startActivity(intent)
                            result.success(true)
                        } catch (_: Throwable) { result.success(false) }
                    }
                    "startCoopCalibration" -> {
                        val language = call.argument<String>("language") ?: "en"
                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || !Settings.canDrawOverlays(this)) {
                            result.success(mapOf("status" to "overlay_permission"))
                        } else if (!isGameInstalled()) {
                            result.success(mapOf("status" to "unsupported"))
                        } else if (!isShizukuAlive() || Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED) {
                            result.success(mapOf("status" to "shizuku_permission"))
                        } else {
                            cancelCoopCalibration()
                            coopCalibrationResult = result
                            val overlay = CoopCalibrationOverlay(this, language == "es") { response ->
                                coopCalibrationOverlay = null
                                val pending = coopCalibrationResult
                                coopCalibrationResult = null
                                pending?.success(response)
                            }
                            coopCalibrationOverlay = overlay
                            overlay.show()
                            if (coopCalibrationOverlay == null || !launchGame()) {
                                cancelCoopCalibration()
                            }
                        }
                    }
                    "runCoopTapSequence" -> {
                        val points = call.argument<List<Int>>("points")
                        val width = call.argument<Int>("width")
                        val height = call.argument<Int>("height")
                        val rotation = call.argument<Int>("rotation")
                        if (points == null || points.size != 10 || points.any { it < 0 } ||
                            width == null || height == null || rotation == null ||
                            width !in 240..10000 || height !in 240..10000 || rotation !in 0..3
                        ) {
                            result.error("BAD_ARGS", null, null)
                        } else if (!isShizukuAlive() || Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED) {
                            result.success(mapOf("status" to "shizuku_permission"))
                        } else {
                            coopSequenceCancelled.set(false)
                            Thread {
                                val status = runCoopTapSequence(points, width, height, rotation)
                                mainHandler.post { result.success(mapOf("status" to status)) }
                            }.start()
                        }
                    }
                    "cancelCoopTapSequence" -> {
                        synchronized(coopProcessLock) {
                            coopSequenceCancelled.set(true)
                            coopProcess.getAndSet(null)?.destroyForcibly()
                        }
                        result.success(true)
                    }
                    "readCoopPreferencesAsRoot" -> Thread {
                        val response = if (!isPrimaryAndroidUser() || !isGameInstalled()) {
                            mapOf("ok" to "false", "reason" to "unsupported")
                        } else readCoopPreferencesAsRoot()
                        mainHandler.post { result.success(response) }
                    }.start()
                    "writeCoopPreferencesAsRoot" -> {
                        val xml = call.argument<String>("xml")
                        val originalExists = call.argument<Boolean>("originalExists")
                        val originalHash = call.argument<String>("originalHash")
                        if (xml.isNullOrBlank() || originalExists == null ||
                            originalHash == null ||
                            (originalExists && !originalHash.matches(Regex("^[a-f0-9]{64}$"))) ||
                            (!originalExists && originalHash.isNotEmpty()) ||
                            xml.length > 256 * 1024 ||
                            !isValidCoopPreferencesXml(xml)
                        ) {
                            result.error("BAD_ARGS", null, null); return@setMethodCallHandler
                        }
                        Thread {
                            val response = if (!isPrimaryAndroidUser() || !isGameInstalled()) {
                                mapOf("ok" to "false", "reason" to "unsupported")
                            } else writeCoopPreferencesAsRoot(xml, originalExists, originalHash)
                            mainHandler.post { result.success(response) }
                        }.start()
                    }
                    "pullSavesAsRoot" -> {
                        val dst = call.argument<String>("dst")
                        if (dst == null) { result.error("NO_DST", null, null); return@setMethodCallHandler }
                        val savesPath = call.argument<String>("savesPath")
                        if (savesPath == null || !isSafeSavesPath(savesPath)) {
                            result.error("BAD_ARGS", null, null); return@setMethodCallHandler
                        }
                        Thread {
                            val ok = runSu("cp -rfp ${shellQuote("$savesPath/.")} ${shellQuote("$dst/")}")
                            mainHandler.post { result.success(ok) }
                        }.start()
                    }
                    "runProtectedScriptAsRoot" -> {
                        // El script ya viene completo desde Dart
                        // (AndroidProtectedCommands.replace) — preparar,
                        // respaldar, sustituir, verificar, revertir ante
                        // cualquier fallo (trap EXIT). Antes esto era un
                        // "cp -rfp" plano sin respaldo ni rollback
                        // (2026-07-21, activación — SIN verificar todavía
                        // en un dispositivo rooteado real, ver Dart).
                        val script = call.argument<String>("script")
                        if (script == null) {
                            result.error("BAD_ARGS", null, null); return@setMethodCallHandler
                        }
                        Thread {
                            val ok = runSu(script)
                            mainHandler.post { result.success(ok) }
                        }.start()
                    }
                    "deleteLocalAsRoot" -> {
                        val name = call.argument<String>("name")
                        val savesPath = call.argument<String>("savesPath")
                        if (name == null || !isSafeSaveName(name) ||
                            savesPath == null || !isSafeSavesPath(savesPath)
                        ) {
                            result.error("BAD_ARGS", null, null); return@setMethodCallHandler
                        }
                        Thread {
                            val ok = runSu("rm -rf ${shellQuote("$savesPath/$name")}")
                            mainHandler.post { result.success(ok) }
                        }.start()
                    }
                    "runRootCommand" -> {
                        // Solo lectura (ls / test) para detectar y explorar la
                        // carpeta de saves. El comando lo construye Dart
                        // (saves_folder_scan.dart) con rutas ya validadas.
                        val command = call.argument<String>("command")
                        if (command == null || command.length > 4096 || command.contains('\u0000')) {
                            result.error("BAD_ARGS", null, null); return@setMethodCallHandler
                        }
                        Thread {
                            val out = runSuOutput(command)
                            mainHandler.post { result.success(out) }
                        }.start()
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /** ¿Stardew Valley está instalado? getLaunchIntentForPackage es más fiable
     *  que canResolveActivity del plugin en Android 11+ (requiere el paquete en
     *  <queries>, ya declarado). */
    private fun isGameInstalled(): Boolean = try {
        packageManager.getLaunchIntentForPackage("com.chucklefish.stardewvalley") != null
    } catch (_: Throwable) { false }

    private fun isPrimaryAndroidUser(): Boolean = android.os.Process.myUid() / 100_000 == 0

    /** Lanza Stardew directamente por su launch intent (sin selector de apps). */
    private fun launchGame(): Boolean = try {
        val intent = packageManager.getLaunchIntentForPackage("com.chucklefish.stardewvalley")
        if (intent == null) {
            false
        } else {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            true
        }
    } catch (_: Throwable) { false }

    private fun cancelCoopCalibration() {
        coopCalibrationOverlay?.cancel()
        coopCalibrationOverlay = null
        val pending = coopCalibrationResult
        coopCalibrationResult = null
        pending?.success(mapOf("status" to "cancelled"))
    }

    /** Each tap is a separate, cancellable Shizuku shell process with fresh foreground/size checks. */
    private fun runCoopTapSequence(points: List<Int>, width: Int, height: Int, rotation: Int): String {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return "unsupported"
        val display = windowManager.defaultDisplay
        val currentSize = Point().also { display.getRealSize(it) }
        if (currentSize.x != width || currentSize.y != height || display.rotation != rotation) {
            return "display_changed"
        }
        val coordinates = ArrayList<Pair<Int, Int>>(5)
        for (index in 0 until 5) {
            val x = points[index * 2]
            val y = points[index * 2 + 1]
            if (x !in 0 until width || y !in 0 until height) return "invalid_points"
            coordinates.add(x to y)
        }
        // ↑↑↓↓←→←→? — groups calibrated by the user against the actual title screen.
        val sequence = listOf(0, 0, 1, 1, 2, 3, 2, 3, 4)
        for (target in sequence) {
            if (coopSequenceCancelled.get()) return "cancelled"
            val now = Point().also { display.getRealSize(it) }
            if (now.x != width || now.y != height || display.rotation != rotation) return "display_changed"
            val (x, y) = coordinates[target]
            val script = """
                set -eu
                FOCUS=${'$'}(dumpsys window 2>/dev/null | grep -E 'mCurrentFocus|mFocusedApp' | tail -n 1 || true)
                case "${'$'}FOCUS" in *com.chucklefish.stardewvalley*) ;; *) echo VS_NOT_FOREGROUND; exit 31;; esac
                SIZE=${'$'}(wm size | sed -n -e 's/^Override size: //p' -e 's/^Physical size: //p' | tail -n 1)
                test "${'$'}SIZE" = '${width}x${height}' || { echo VS_DISPLAY_CHANGED; exit 32; }
                input tap $x $y
                sleep 0.18
            """.trimIndent()
            val process = try {
                synchronized(coopProcessLock) {
                    if (coopSequenceCancelled.get()) return "cancelled"
                    Shizuku.newProcess(arrayOf("sh", "-c", script), null, null).also {
                        coopProcess.set(it)
                        if (coopSequenceCancelled.get()) it.destroyForcibly()
                    }
                }
            } catch (_: Throwable) { return "shizuku_error" }
            try {
                if (!process.waitFor(2_500, TimeUnit.MILLISECONDS)) {
                    process.destroyForcibly()
                    return "timeout"
                }
                val output = process.inputStream.bufferedReader().use { it.readText() }.trim()
                if (coopSequenceCancelled.get()) return "cancelled"
                if (process.exitValue() != 0) return when {
                    output.contains("VS_NOT_FOREGROUND") -> "not_foreground"
                    output.contains("VS_DISPLAY_CHANGED") -> "display_changed"
                    else -> "shizuku_error"
                }
            } catch (_: Throwable) {
                process.destroyForcibly()
                return if (coopSequenceCancelled.get()) "cancelled" else "shizuku_error"
            } finally {
                coopProcess.compareAndSet(process, null)
            }
        }
        return if (coopSequenceCancelled.get()) "cancelled" else "sent"
    }


    /** Nombres de save aceptados en cualquier comando shell root — mismo
     *  criterio que el lado Dart (`shizuku_service.dart`, `_isSafeSaveName`)
     *  y que la implementación alternativa: alfanumérico + `_.-`,
     *  nunca `.`/`..`. Defensa en profundidad — el lado Dart ya valida antes
     *  de invocar el canal, pero este método no debe confiar en que ningún
     *  caller futuro mantenga esa garantía (2026-07-18, tras confirmar en
     *  revisión que un `deleteLocalAsRoot` alternativo carecía de este guard). */
    private fun isSafeSaveName(name: String): Boolean =
        name.matches(Regex("^[A-Za-z0-9_.-]{1,160}$")) && name != "." && name != ".."

    /** Misma regla que `isValidSavesPath` en Dart (stardew_paths.dart):
     *  absoluta, sin segmentos `..`, solo `[A-Za-z0-9_./ -]`, 1..512 tras `/`. */
    private fun isSafeSavesPath(path: String): Boolean =
        path.matches(Regex("^/[A-Za-z0-9_./ -]{1,512}$")) &&
            !path.split("/").contains("..")

    private fun isValidCoopPreferencesXml(source: String): Boolean = try {
        val parser = android.util.Xml.newPullParser()
        parser.setInput(StringReader(source))
        var depth = 0
        var sawMap = false
        var coopFlags = 0
        var event = parser.eventType
        while (event != XmlPullParser.END_DOCUMENT) {
            when (event) {
                XmlPullParser.START_TAG -> {
                    if (depth == 0) {
                        if (parser.name != "map") return false
                        sawMap = true
                    } else if (depth == 1 &&
                        parser.getAttributeValue(null, "name") == "unlocked_multiplayer"
                    ) {
                        if (parser.name != "boolean" ||
                            parser.getAttributeValue(null, "value") != "true"
                        ) return false
                        coopFlags++
                    }
                    depth++
                }
                XmlPullParser.END_TAG -> depth--
            }
            event = parser.next()
        }
        sawMap && depth == 0 && coopFlags == 1
    } catch (_: Exception) {
        false
    }

    /** Lee preferencias solo con root y rechaza cambios mientras el juego está abierto. */
    private fun readCoopPreferencesAsRoot(): Map<String, String> {
        val script = """
            if pidof '$GAME_PACKAGE' >/dev/null 2>&1; then echo GAME_RUNNING; exit 23; fi
            if [ -f '$COOP_PREFS_PATH' ]; then
              printf '__VS_EXISTS__\n'
              sha256sum '$COOP_PREFS_PATH' | cut -d ' ' -f 1
              cat '$COOP_PREFS_PATH'
            else
              printf '__VS_MISSING__\n\n<map></map>'
            fi
        """.trimIndent()
        val (ok, output) = runSuCapture(script)
        val markerEnd = output.indexOf('\n')
        val hashEnd = if (markerEnd >= 0) output.indexOf('\n', markerEnd + 1) else -1
        val marker = if (markerEnd >= 0) output.substring(0, markerEnd) else ""
        val originalHash = if (hashEnd > markerEnd) {
            output.substring(markerEnd + 1, hashEnd).trim()
        } else ""
        return when {
            ok && hashEnd >= 0 && (marker == "__VS_EXISTS__" || marker == "__VS_MISSING__") -> mapOf(
                "ok" to "true",
                "exists" to (marker == "__VS_EXISTS__").toString(),
                "hash" to originalHash,
                "xml" to output.substring(hashEnd + 1),
            )
            output.contains("GAME_RUNNING") -> mapOf("ok" to "false", "reason" to "running")
            else -> mapOf("ok" to "false", "reason" to "unavailable")
        }
    }

    /** Respalda y sustituye el XML conservando owner, modo y contexto SELinux. */
    private fun writeCoopPreferencesAsRoot(
        xml: String,
        originalExists: Boolean,
        originalHash: String,
    ): Map<String, String> {
        val encoded = android.util.Base64.encodeToString(
            xml.toByteArray(Charsets.UTF_8), android.util.Base64.NO_WRAP,
        )
        val script = """
            set -eu
            P='$COOP_PREFS_PATH'
            D='${COOP_PREFS_PATH.substringBeforeLast('/')}'
            if pidof '$GAME_PACKAGE' >/dev/null 2>&1; then echo GAME_RUNNING; exit 23; fi
            test -d "${'$'}D"
            EXPECTED='$originalHash'
            if [ '${if (originalExists) "true" else "false"}' = true ]; then
              if [ ! -f "${'$'}P" ] || [ "${'$'}(sha256sum "${'$'}P" | cut -d ' ' -f 1)" != "${'$'}EXPECTED" ]; then echo PREF_CHANGED; exit 26; fi
            elif [ -e "${'$'}P" ]; then echo PREF_CHANGED; exit 26; fi
            T="${'$'}D/.valleysave-${'$'}${'$'}.tmp"
            B="${'$'}P.valleysave.${'$'}(date +%Y%m%d%H%M%S).${'$'}${'$'}.bak"
            MOVED=0
            CREATED=0
            cleanup() {
              STATUS=${'$'}?
              set +e
              if [ "${'$'}STATUS" -ne 0 ] && [ "${'$'}MOVED" -eq 1 ]; then
                if [ "${'$'}CREATED" -eq 1 ]; then rm -f "${'$'}P"; else cp -p --preserve=context "${'$'}B" "${'$'}P"; fi
              fi
              rm -f "${'$'}T" "${'$'}D/.valleysave-expected-${'$'}${'$'}" "${'$'}D/.valleysave-actual-${'$'}${'$'}"
              exit "${'$'}STATUS"
            }
            trap cleanup EXIT
            if [ -f "${'$'}P" ]; then
              cp -p --preserve=context "${'$'}P" "${'$'}B"
              cp -p --preserve=context "${'$'}P" "${'$'}T"
            else
              CREATED=1
              if [ -f "${'$'}D/startup_preferences" ]; then
                cp -p --preserve=context "${'$'}D/startup_preferences" "${'$'}T"
              elif [ -f "${'$'}D/ActivityThread.IDS.xml" ]; then
                cp -p --preserve=context "${'$'}D/ActivityThread.IDS.xml" "${'$'}T"
              else
                exit 25
              fi
              chmod 660 "${'$'}T"
            fi
            printf '%s' '$encoded' | base64 -d > "${'$'}T"
            test -s "${'$'}T"
            if pidof '$GAME_PACKAGE' >/dev/null 2>&1; then echo GAME_RUNNING; exit 23; fi
            if [ '${if (originalExists) "true" else "false"}' = true ]; then
              if [ ! -f "${'$'}P" ] || [ "${'$'}(sha256sum "${'$'}P" | cut -d ' ' -f 1)" != "${'$'}EXPECTED" ]; then echo PREF_CHANGED; exit 26; fi
            elif [ -e "${'$'}P" ]; then echo PREF_CHANGED; exit 26; fi
            if [ "${'$'}CREATED" -eq 1 ]; then
              if ln "${'$'}T" "${'$'}P"; then MOVED=1; rm "${'$'}T"; else echo PREF_CHANGED; exit 26; fi
            else
              mv "${'$'}T" "${'$'}P"
              MOVED=1
            fi
            printf '%s' '$encoded' | base64 -d | sha256sum | cut -d ' ' -f 1 > "${'$'}D/.valleysave-expected-${'$'}${'$'}"
            sha256sum "${'$'}P" | cut -d ' ' -f 1 > "${'$'}D/.valleysave-actual-${'$'}${'$'}"
            cmp -s "${'$'}D/.valleysave-expected-${'$'}${'$'}" "${'$'}D/.valleysave-actual-${'$'}${'$'}"
        """.trimIndent()
        val (ok, output) = runSuCapture(script)
        return when {
            ok -> mapOf("ok" to "true", "created" to (!originalExists).toString())
            output.contains("GAME_RUNNING") -> mapOf("ok" to "false", "reason" to "running")
            output.contains("PREF_CHANGED") -> mapOf("ok" to "false", "reason" to "changed")
            else -> mapOf("ok" to "false", "reason" to "write")
        }
    }


    /** Comillas simples POSIX con escape de comillas internas (`'` →
     *  `'\''`) — a diferencia de las comillas dobles usadas antes aquí,
     *  bloquea también `$()`, backticks y `\`, no solo word-splitting/
     *  globbing (2026-07-18, tras el revisión cruzada: comillas
     *  dobles no son suficientes para neutralizar un nombre hostil). */
    private fun shellQuote(value: String): String =
        "'" + value.replace("'", "'\\''") + "'"

    /** Ejecuta un comando como root con timeout. Compatible con API 24+. */
    private fun runSu(cmd: String): Boolean = try {
        val proc = Runtime.getRuntime().exec(arrayOf("su", "-c", cmd))
        val waiter = Thread { try { proc.waitFor() } catch (_: InterruptedException) {} }
        waiter.start()
        waiter.join(ROOT_TIMEOUT_MS)
        if (waiter.isAlive) { proc.destroyForcibly(); false }
        else proc.exitValue() == 0
    } catch (_: Exception) { false }

    /** Como [runSu] pero devuelve stdout (null si falla o agota el timeout). */
    private fun runSuOutput(cmd: String): String? = try {
        val proc = Runtime.getRuntime().exec(arrayOf("su", "-c", cmd))
        var text: String? = null
        val reader = Thread {
            try { text = proc.inputStream.bufferedReader().readText() } catch (_: Exception) {}
        }
        reader.start()
        reader.join(ROOT_TIMEOUT_MS)
        if (reader.isAlive) { proc.destroyForcibly(); null } else { proc.waitFor(); text }
    } catch (_: Exception) { null }

    private fun runSuCapture(cmd: String): Pair<Boolean, String> = try {
        val proc = Runtime.getRuntime().exec(arrayOf("su", "-c", "exec 2>&1\n$cmd"))
        val out = StringBuilder()
        val reader = Thread {
            try { proc.inputStream.bufferedReader().use { out.append(it.readText()) } }
            catch (_: Exception) {}
        }
        reader.start()
        val waiter = Thread { try { proc.waitFor() } catch (_: InterruptedException) {} }
        waiter.start()
        waiter.join(ROOT_TIMEOUT_MS)
        if (waiter.isAlive) {
            proc.destroyForcibly()
            reader.join(1_000)
            false to out.toString()
        } else {
            reader.join(1_000)
            (proc.exitValue() == 0) to out.toString()
        }
    } catch (_: Exception) { false to "" }


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
        cancelCoopCalibration()
        synchronized(coopProcessLock) {
            coopSequenceCancelled.set(true)
            coopProcess.getAndSet(null)?.destroyForcibly()
        }
        super.onDestroy()
        try {
            Shizuku.removeBinderReceivedListener(onBinderReceived)
            Shizuku.removeBinderDeadListener(onBinderDead)
        } catch (_: Throwable) {
        }
    }
}
