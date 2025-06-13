pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // DÜZELTME: Android Gradle Plugin versiyonunu desteklenen 8.5.0'a sabitliyoruz.
    id("com.android.application") version "8.5.0" apply false
    // Kotlin versiyonunu da AGP ile uyumlu olan 1.9.23'e sabitliyoruz.
    id("org.jetbrains.kotlin.android") version "1.9.23" apply false
}

include(":app")

