plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}
android {
    namespace = "com.medrpha_labs.app"
    compileSdk = 36
    ndkVersion = "27.0.12077973" // Explicit NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.medrpha_labs.app"
        // Ensure minSdk is 20 or higher for Google Maps. Assuming flutter.minSdkVersion >= 20.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // START: CRITICAL FIX FOR DUPLICATE CLASSES AND MAP INSTABILITY
    configurations.all {
        resolutionStrategy {
            // Fixes conflicts often arising from Google Maps/GMS and other transitive dependencies.
            // MUST use parentheses for Kotlin DSL: force("...")
            force("com.google.guava:listenablefuture:9999.0-empty-to-avoid-conflict-with-guava")
        }
    }
    // END: CRITICAL FIX FOR DUPLICATE CLASSES AND MAP INSTABILITY
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.4.0"))


    // TODO: Add the dependencies for Firebase products you want to use
    // When using the BoM, don't specify versions in Firebase dependencies
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}