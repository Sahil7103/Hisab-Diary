package com.example.hisab_diary

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

// Reschedule in the new local timezone even when the diary UI is not running.
class ReminderTimezoneReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_TIMEZONE_CHANGED &&
            intent.action != Intent.ACTION_TIME_CHANGED) return
        val pending = goAsync()
        val handler = Handler(Looper.getMainLooper())
        var engine: FlutterEngine? = null
        var finished = false
        fun finish() {
            if (finished) return
            finished = true
            engine?.destroy()
            pending.finish()
        }
        handler.postDelayed({ finish() }, 9000)
        try {
            val loader = FlutterInjector.instance().flutterLoader()
            loader.startInitialization(context.applicationContext)
            loader.ensureInitializationComplete(context.applicationContext, null)
            val worker = FlutterEngine(context.applicationContext)
            engine = worker
            MethodChannel(worker.dartExecutor.binaryMessenger, "hisab_diary/reminders")
                .setMethodCallHandler { call, result ->
                    if (call.method == "finished") {
                        result.success(null)
                        handler.post { finish() }
                    } else result.notImplemented()
                }
            worker.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(loader.findAppBundlePath(), "reminderTimezoneChanged"))
        } catch (error: Exception) {
            Log.w("HisabDiary", "Could not reschedule the local reminder")
            finish()
        }
    }
}
