package com.example.platform_view

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class MyPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val messenger: BinaryMessenger = binding.binaryMessenger
        binding.platformViewRegistry.registerViewFactory("plugins.flutter.io/custom_platform_view", MyFlutterViewFactory(messenger))
    }

    companion object {
        fun registerWith(registrar: PluginRegistry.Registrar) {
            registrar.platformViewRegistry()
                    .registerViewFactory("plugins.flutter.io/custom_platform_view",
                            MyFlutterViewFactory(registrar.messenger())
                            )
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        TODO("Not yet implemented")
    }

}

//// 注册PlatformView
//class MyFlutterViewFactory(val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
//    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
//        val flutterView = MyFlutterView(context, messenger, args as Map<String, Any>?)
//        return flutterView;
//    }
//
//}
