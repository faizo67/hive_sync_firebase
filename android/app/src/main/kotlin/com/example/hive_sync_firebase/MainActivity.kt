package com.example.hive_sync_firebase // Replace with your actual package

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.BatteryManager
import android.os.Bundle
import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import java.text.SimpleDateFormat
import java.util.*
import kotlin.concurrent.fixedRateTimer

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "com.example.device/method"
    private val EVENT_CHANNEL = "com.example.device/clock"
    private val WIDGET_CHANNEL = "com.example.device/widget"

    private var clockTimer: Timer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 🔌 MethodChannel for Battery + Storage
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getBatteryLevel" -> {
                        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                        val level = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                        result.success(level)
                    }
                    "getStorageInfo" -> {
                        val file = Environment.getExternalStorageDirectory()
                        val total = file.totalSpace
                        val free = file.usableSpace
                        result.success(mapOf("total" to total, "free" to free))
                    }
                    else -> result.notImplemented()
                }
            }

        // 🔁 EventChannel for live clock
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    clockTimer = fixedRateTimer("clockTimer", initialDelay = 0, period = 1000) {
                        val currentTime = SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(Date())
                        events?.success(currentTime)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    clockTimer?.cancel()
                }
            })

        // ✅ NEW: MethodChannel to trigger Android widget update
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "updateWidget") {
                    val context = applicationContext
                    val intent = Intent(context, MyWidgetProvider::class.java).apply {
                        action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    }

                    val ids = AppWidgetManager.getInstance(context).getAppWidgetIds(
                        ComponentName(context, MyWidgetProvider::class.java)
                    )
                    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)

                    context.sendBroadcast(intent)
                    result.success("Widget updated")
                } else {
                    result.notImplemented()
                }
            }
    }
}
