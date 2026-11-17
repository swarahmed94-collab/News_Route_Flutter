package com.newsroute.news_app

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "news_route/article")
            .setMethodCallHandler { call, result ->
                if (call.method != "openUrl" && call.method != "shareUrl") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val url = call.argument<String>("url")
                val uri = url?.let { Uri.parse(it) }
                if (uri == null || (uri.scheme != "http" && uri.scheme != "https")) {
                    result.error("parameterInvalid", "parameterInvalid", null)
                    return@setMethodCallHandler
                }
                try {
                    if (call.method == "shareUrl") {
                        val shareIntent = Intent(Intent.ACTION_SEND).apply {
                            type = "text/plain"
                            putExtra(Intent.EXTRA_TEXT, url)
                        }
                        startActivity(Intent.createChooser(shareIntent, null))
                    } else {
                        startActivity(Intent(Intent.ACTION_VIEW, uri))
                    }
                    result.success(null)
                } catch (ex: Exception) {
                    result.error("unexpectedError", ex.message, null)
                }
            }
    }
}
