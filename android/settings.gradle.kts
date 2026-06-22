pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localProps = rootProject.file("local.properties")
        if (localProps.exists()) {
            localProps.inputStream().use { properties.load(it) }
        }
        System.getenv("FLUTTER_ROOT") ?: properties.getProperty("flutter.sdk")
            ?: throw GradleException("flutter.sdk not found")
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
    id("com.android.application") version "8.3.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}

include(":app")
