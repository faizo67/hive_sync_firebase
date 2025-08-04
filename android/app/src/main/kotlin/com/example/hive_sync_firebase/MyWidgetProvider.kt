package com.example.hive_sync_firebase  // Replace with your actual package

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import java.io.File
import java.io.FileInputStream

class MyWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)

        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            // ✅ Step 1: Read latest transaction from file
            val file = File(context.filesDir, "last_transaction.txt")
            val text = if (file.exists()) {
                try {
                    FileInputStream(file).bufferedReader().use { it.readText() }
                } catch (e: Exception) {
                    Log.e("Widget", "Error reading file: ${e.message}")
                    "Error loading transaction"
                }
            } else {
                "No transactions yet"
            }

            views.setTextViewText(R.id.transactionText, text)

            // ✅ Step 2: Tap on widget → Open Flutter app (MainActivity)
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // ✅ Step 3: Apply tap intent to widget (TextView or entire layout)
            views.setOnClickPendingIntent(R.id.transactionText, pendingIntent)
            // Or: views.setOnClickPendingIntent(R.id.widgetRootLayout, pendingIntent)

            // ✅ Step 4: Push final update
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
