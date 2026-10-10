package com.example.hisab_diary

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class DiaryWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager,
                          ids: IntArray, widgetData: SharedPreferences) {
        ids.forEach { id -> render(context, manager, id, widgetData) }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE &&
            !intent.getBooleanExtra(HomeWidgetPlugin.TRIGGERED_FROM_HOME_WIDGET, false)) {
            val prefs = HomeWidgetPlugin.getData(context)
            val uri = actionUri(prefs, "refresh")
            if (!isLocked(prefs) && uri != null) {
                HomeWidgetBackgroundIntent.getBroadcast(context, uri).send()
            }
        }
    }

    override fun onAppWidgetOptionsChanged(context: Context, manager: AppWidgetManager,
                                          id: Int, newOptions: Bundle) {
        render(context, manager, id, HomeWidgetPlugin.getData(context))
    }

    private fun render(context: Context, manager: AppWidgetManager, id: Int,
                       prefs: SharedPreferences) {
        val snapshot = try { JSONObject(prefs.getString("diary_widget_snapshot", "") ?: "") }
            catch (_: Exception) { null }
        val labels = snapshot?.optJSONObject("labels")
        fun label(key: String, fallback: String) = labels?.optString(key, fallback) ?: fallback
        val locked = isLocked(prefs)
        val current = !locked && snapshot != null && snapshot.optString("date") == today() &&
            snapshot.optString("dbName") == prefs.getString("active_diary_db", null) &&
            snapshot.optString("householdId") == prefs.getString("active_household_id", null) &&
            snapshot.optString("householdName") == prefs.getString("active_household_name", null)
        val failed = try { prefs.getBoolean("diary_widget_error", false) }
            catch (_: Exception) { true }
        val open = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        val views = RemoteViews(context.packageName, R.layout.diary_widget)
        views.setTextViewText(R.id.widget_title,
            if (!locked && current) snapshot!!.optString("householdName")
            else label("widgetTitle", "Hisab Diary"))
        views.setTextViewText(R.id.widget_date,
            SimpleDateFormat("EEE, d MMM", Locale.getDefault()).format(Date()))
        views.setTextViewText(R.id.widget_open, label("widgetOpenDiary", "Open diary"))
        views.setTextViewText(R.id.widget_all_came, label("widgetAllCame", "All came"))
        views.setOnClickPendingIntent(R.id.widget_title, open)
        views.setOnClickPendingIntent(R.id.widget_open, open)
        views.setContentDescription(R.id.widget_refresh, label("widgetRefresh", "Refresh"))
        views.removeAllViews(R.id.widget_vendors)
        views.setViewVisibility(R.id.widget_all_came, View.GONE)
        views.setViewVisibility(R.id.widget_message, View.VISIBLE)
        views.setViewVisibility(R.id.widget_more, View.GONE)
        val refresh = actionUri(prefs, "refresh")
        views.setOnClickPendingIntent(R.id.widget_refresh,
            if (locked || refresh == null) open else actionPendingIntent(context, refresh))
        when {
            locked -> views.setTextViewText(R.id.widget_message,
                label("widgetLocked", "Diary locked. Open the app to unlock."))
            failed -> views.setTextViewText(R.id.widget_message,
                label("widgetError", "Could not update. Refresh or open your diary."))
            !current -> views.setTextViewText(R.id.widget_message,
                label("widgetRefresh", "Refresh"))
            else -> {
                val rows = snapshot!!.optJSONArray("vendors")
                if (rows == null || rows.length() == 0) {
                    views.setTextViewText(R.id.widget_message,
                        label("widgetNoDeliveries", "No deliveries scheduled today"))
                } else {
                    views.setViewVisibility(R.id.widget_message, View.GONE)
                    views.setViewVisibility(R.id.widget_all_came, View.VISIBLE)
                    actionUri(prefs, "allCame", snapshot)?.let {
                        views.setOnClickPendingIntent(R.id.widget_all_came, actionPendingIntent(context, it))
                    }
                    val height = manager.getAppWidgetOptions(id)
                        .getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 240)
                    val limit = ((height - 112) / 62).coerceIn(1, 8)
                    for (index in 0 until minOf(rows.length(), limit)) {
                        val vendor = rows.optJSONObject(index) ?: continue
                        val row = RemoteViews(context.packageName, R.layout.diary_widget_vendor)
                        row.setTextViewText(R.id.widget_vendor_name, vendor.optString("name"))
                        val status = when (vendor.optString("status")) {
                            "came" -> label("widgetCame", "Came")
                            "notCame" -> label("widgetAbsent", "Absent")
                            else -> label("widgetUnmarked", "Unmarked")
                        }
                        row.setTextViewText(R.id.widget_vendor_status, status)
                        row.setTextColor(R.id.widget_vendor_status, when (vendor.optString("status")) {
                            "came" -> 0xFF1E8A4C.toInt()
                            "notCame" -> 0xFFD2382C.toInt()
                            else -> 0xFF55607A.toInt()
                        })
                        row.setTextViewText(R.id.widget_vendor_came, label("widgetCame", "Came"))
                        row.setTextViewText(R.id.widget_vendor_absent, label("widgetAbsent", "Absent"))
                        row.setOnClickPendingIntent(R.id.widget_vendor_name, open)
                        for ((action, button) in listOf("came" to R.id.widget_vendor_came,
                                                        "absent" to R.id.widget_vendor_absent)) {
                            actionUri(prefs, action, snapshot, vendor.optInt("id"))?.let {
                                row.setOnClickPendingIntent(button, actionPendingIntent(context, it))
                            }
                        }
                        views.addView(R.id.widget_vendors, row)
                    }
                    if (rows.length() > limit) {
                        views.setViewVisibility(R.id.widget_more, View.VISIBLE)
                        views.setTextViewText(R.id.widget_more,
                            "+${rows.length() - limit} ${label("widgetMoreVendors", "more vendors")}")
                        views.setOnClickPendingIntent(R.id.widget_more, open)
                    }
                }
            }
        }
        manager.updateAppWidget(id, views)
    }

    companion object {
        fun today(): String = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        fun isLocked(prefs: SharedPreferences): Boolean =
            try { prefs.getBoolean("app_lock_enabled", true) } catch (_: Exception) { true }

        fun actionUri(prefs: SharedPreferences, action: String,
                      snapshot: JSONObject? = null, vendorId: Int? = null): Uri? {
            val dbName = prefs.getString("active_diary_db", null) ?: return null
            val householdId = prefs.getString("active_household_id", null) ?: return null
            val householdName = prefs.getString("active_household_name", null) ?: return null
            if (!dbName.matches(Regex("^hisab_diary(?:_household_[a-z0-9]+)?$"))) return null
            return Uri.Builder().scheme("hisabdiary").authority("widget")
                .appendQueryParameter("action", action)
                .appendQueryParameter("date", today())
                .appendQueryParameter("dbName", dbName)
                .appendQueryParameter("householdId", householdId)
                .appendQueryParameter("householdName", householdName)
                .apply {
                    snapshot?.let { appendQueryParameter("token", it.optString("token")) }
                    vendorId?.let { appendQueryParameter("vendorId", it.toString()) }
                }.build()
        }

        fun actionPendingIntent(context: Context, uri: Uri): PendingIntent =
            PendingIntent.getBroadcast(context, 0,
                Intent(context, DiaryWidgetActionReceiver::class.java).setData(uri),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, DiaryWidgetProvider::class.java))
            if (ids.isNotEmpty()) DiaryWidgetProvider().onUpdate(context, manager, ids,
                HomeWidgetPlugin.getData(context))
        }
    }
}
