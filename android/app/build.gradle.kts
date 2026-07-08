import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystore = keystorePropertiesFile.exists()
val keystoreProperties = Properties().apply {
    if (hasKeystore) load(FileInputStream(keystorePropertiesFile))
}
val releaseStoreFile = if (hasKeystore) file(keystoreProperties["storeFile"] as String) else null
val releaseKeyAlias = if (hasKeystore) keystoreProperties["keyAlias"] as String else null

android {
    namespace = "com.hirieo.valleysave"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.hirieo.valleysave"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = maxOf(24, flutter.minSdkVersion)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasKeystore) {
                storeFile = releaseStoreFile
                storePassword = System.getenv("KEY_PASSWORD")
                keyAlias = releaseKeyAlias
                keyPassword = System.getenv("KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            // Sin key.properties (p. ej. clonando el repo en otra máquina) cae a
            // debug para que `flutter run --release` siga funcionando.
            signingConfig = if (hasKeystore) signingConfigs.getByName("release")
                             else signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // Para detectar el binder de Shizuku con listener fiable desde MainActivity
    // (el plugin shizuku_api las declara como `implementation`, no visibles aquí).
    implementation("dev.rikka.shizuku:api:13.1.0")
    implementation("dev.rikka.shizuku:provider:13.1.0")
}

flutter {
    source = "../.."
}
