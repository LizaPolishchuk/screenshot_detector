package com.example.screenshot_detector

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.akexorcist.screenshotdetection.ScreenshotDetectionDelegate

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ScreenshotDetectorPlugin */
class ScreenshotDetectorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    ScreenshotDetectionDelegate.ScreenshotDetectionListener {
    private lateinit var channel: MethodChannel
    private lateinit var screenshotDetectionDelegate: ScreenshotDetectionDelegate
    private lateinit var activity: Activity


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "screenshot_detector")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method.equals("initialize")) {
            screenshotDetectionDelegate = ScreenshotDetectionDelegate(activity, this)
            screenshotDetectionDelegate.startScreenshotDetection()

            result.success("initialize");
        } else if (call.method.equals("dispose")) {
            screenshotDetectionDelegate.stopScreenshotDetection()
            result.success("dispose");
        } else {
            result.notImplemented();
        }

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}

    override fun onScreenCaptured(path: String) {
        channel.invokeMethod("screenCaptured", path)
    }

}
