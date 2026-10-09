package com.example.hisab_diary

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hisab_diary/privacy")
            .setMethodCallHandler { call, result ->
                if (call.method == "openPrivacyPolicy") {
                    try {
                        startActivity(Intent(Intent.ACTION_VIEW,
                            Uri.parse("https://sahil7103.github.io/Hisab-Diary/")))
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("privacy_unavailable", "Privacy policy could not be opened", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hisab_diary/reminders")
            .setMethodCallHandler { call, result ->
                if (call.method == "batterySettings") {
                    try {
                        startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                            Uri.parse("package:$packageName")))
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("settings_unavailable", "Phone settings are unavailable", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
