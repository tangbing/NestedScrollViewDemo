package com.example.first_project

import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.exmaple.scard"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSdCardPath") {
                val path = getSdCardPath()
                result.success(path)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSdCardPath(): String {
        return Environment.getExternalStorageDirectory().absolutePath
    }

}
