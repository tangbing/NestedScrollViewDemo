package com.example.platform_view

import android.content.Context
import android.view.View
import android.widget.TextView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class MyFlutterView(context: Context, messenger: BinaryMessenger, viewId: Int, args: Map<String, Any>?) : PlatformView, MethodChannel.MethodCallHandler{

    val textView: TextView = TextView(context);

    private var methodChannel: MethodChannel

    init {
        args.also {
            textView.text = it?.get("text") as String

        }
        methodChannel = MethodChannel(messenger, "com.flutter.guide.MyFlutterView");
        methodChannel.setMethodCallHandler(this)
    }

    // 返回要嵌入 Flutter 层次结构的Android View
    override fun getView(): View? {
        return textView;
    }

    // 释放此View时调用，此方法调用后 View 不可用，此方法需要清除所有对象引用，否则会造成内存泄漏
    override fun dispose() {
        methodChannel.setMethodCallHandler(null);
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {
            "setText" -> {
                val name = call.argument<String>("name")
                val age = call.argument<Int>("age")

                textView.text = when {
                    name != null && age != null -> "hello, $name"
                    else -> "Invalid parameters"
                }
                // 返回的数据
                result.success(null)
            }
            "getData" -> {
                val name = call.argument<String>("name") ?: "未知"
                val age = call.argument<Int>("age") ?: 0

                // 保持数据类型一致性
                val map = mapOf(
                        "name" to "hello,$name",
                        "age" to age.toLong() // 保持 Int 类型
                )
                result.success(map)
            }
            else -> result.notImplemented()
        }



//
//        if (call.method == "setText") {
//            val name = call.argument("name") as String?
//            val age = call.argument("age") as Int?
//
//            textView.text = "hello,$name,年龄：$age"
//        } else if (call.method == "getData") {
//            val name = call.argument("name") as String?
//            val age = call.argument("age") as Int?
//            var map = mapOf("name" to "hello,$name", "age" to "$age")
//            result.success(map)
//        } else {
//            result.notImplemented()
//        }
    }

}

