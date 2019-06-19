package com.example.image_hasher

import android.os.Bundle
import com.example.image_hasher.data.service.ImageDownloaderService

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject
import java.lang.Exception

class MainActivity : FlutterActivity() {
   companion object {
      private const val CHANNEL_NAME = "com.ventrata/image_download"
      private const val METHOD_DOWNLOAD = "downloadImage"
      private const val METHOD_GET_ALL = "getDownloads"
   }

   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      GeneratedPluginRegistrant.registerWith(this)

      MethodChannel(flutterView, CHANNEL_NAME, JSONMethodCodec.INSTANCE).setMethodCallHandler { call, result ->
         when (call.method) {
            METHOD_DOWNLOAD -> {
               GlobalScope.launch {
                  // FIXME : check network
                  try {
                     val imageUrl = call.arguments as String
                     val imageFile = ImageDownloaderService.download(applicationContext, imageUrl)
                     result.success(imageFile.path)
                  } catch (e: Exception) {
                     result.error("Download failed", e.localizedMessage, null)
                  }
               }
            }
            METHOD_GET_ALL -> {
               val downloads = ImageDownloaderService.getAllDownloads(applicationContext)
               val json = JSONArray(downloads.map {
                  JSONObject(mapOf(
                         "url" to it.imageUrl,
                         "path" to it.file.path
                  ))
               })
               result.success(json)
            }
            else -> result.notImplemented()
         }
      }
   }
}
