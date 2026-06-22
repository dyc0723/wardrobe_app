pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localProps = rootProject.file("local.properties")
        if (localProps.exists()) {
            localProps.inputStream().use { properties.load(it) }
        }
        // Fallback to environment variable used by GitHub Actions
        System.getenv("FLUTTER_ROOT") ?: properties.getProperty("flutter.sdk")
            ?: throw GradleException("flutter.sdk not set in local.properties and FLUTTER_ROOT not set")
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
