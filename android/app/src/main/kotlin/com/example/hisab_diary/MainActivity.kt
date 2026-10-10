package com.example.hisab_diary

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import android.os.Bundle
import android.view.WindowManager
import es.antonborri.home_widget.HomeWidgetPlugin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private fun refreshPrivacy() {
        if (DiaryWidgetProvider.isLocked(HomeWidgetPlugin.getData(this))) {
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        refreshPrivacy()
    }

    override fun onPause() {
        refreshPrivacy()
        super.onPause()
    }

    override fun onResume() {
        super.onResume()
        refreshPrivacy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hisab_diary/device")
            .setMethodCallHandler { call, result ->
                if (call.method == "refreshPrivacy") {
                    refreshPrivacy()
                    DiaryWidgetProvider.updateAll(this)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
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
