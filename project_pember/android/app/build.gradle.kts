plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.project_pember"
    compileSdk = 35

    ndkVersion = "27.0.12077973" // ✅ Pakai versi yang diminta plugin firebase

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // compilerArgs += listOf("-Xlint:deprecation")
        isCoreLibraryDesugaringEnabled = true // ✅ Aktifkan desugaring
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.project_pember"
        minSdk = 23 // ✅ untuk firebase_auth dan firebase_core
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ...
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4") // ✅ Tambahkan ini
}