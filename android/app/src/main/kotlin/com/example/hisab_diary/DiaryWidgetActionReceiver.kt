package com.example.hisab_diary

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class DiaryWidgetActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val prefs = HomeWidgetPlugin.getData(context)
        if (DiaryWidgetProvider.isLocked(prefs)) {
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java).send()
            return
        }
        val action = intent.data ?: return
        if (action.scheme != "hisabdiary" || action.host != "widget" ||
            action.getQueryParameter("date") != DiaryWidgetProvider.today() ||
            action.getQueryParameter("dbName") != prefs.getString("active_diary_db", null) ||
            action.getQueryParameter("householdId") != prefs.getString("active_household_id", null) ||
            action.getQueryParameter("householdName") != prefs.getString("active_household_name", null)) {
            DiaryWidgetProvider.updateAll(context)
            return
        }
        HomeWidgetBackgroundIntent.getBroadcast(context, action).send()
    }
}
