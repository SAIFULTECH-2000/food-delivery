plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Firebase config
}

android {
    namespace = "com.example.fooddeliveryapp"
    compileSdk = 35// or flutter.compileSdkVersion if declared in gradle.properties
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.fooddeliveryapp" 
        minSdk = 23
        targetSdk = 34 // or flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
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
