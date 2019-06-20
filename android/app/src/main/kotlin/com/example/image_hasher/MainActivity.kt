package com.example.image_hasher

import android.content.Context
import android.os.Bundle
import com.example.image_hasher.data.model.DownloadedImage
import com.example.image_hasher.data.service.ImageStorageService
import com.example.image_hasher.data.service.ImageStorageServiceImpl

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.lang.Exception
import android.net.ConnectivityManager
import com.example.image_hasher.util.calculateBase64
import com.example.image_hasher.util.downloadTo
import java.lang.IllegalStateException

class MainActivity : FlutterActivity() {

   companion object {
      private const val CHANNEL_NAME = "com.ventrata/image_download"
      private const val METHOD_DOWNLOAD = "downloadImage"
      private const val METHOD_GET_ALL = "getDownloads"
   }

   private val imageStorage: ImageStorageService by lazy {
      ImageStorageServiceImpl(applicationContext)
   }

   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      GeneratedPluginRegistrant.registerWith(this)

      MethodChannel(flutterView, CHANNEL_NAME, JSONMethodCodec.INSTANCE)
             .setMethodCallHandler { call, result ->
                when (call.method) {
                   METHOD_DOWNLOAD -> {
                      GlobalScope.launch {
                         try {
                            val imageUrl = call.arguments as String
                            val image = getDownloadedImage(imageUrl)
                            result.success(image.toJson())
                         } catch (e: Exception) {
                            result.error("Download failed", e.localizedMessage, null)
                         }
                      }
                   }
                   METHOD_GET_ALL -> {
                      val images = imageStorage.getAll()
                      result.success(images.map { it.toJson() })
                   }
                   else -> result.notImplemented()
                }
             }
   }

   /**
    * Downloads an image from given [url] or retrieves it from cache.
    * INFO: Must be run on background thread because it accesses the internet.
    */
   private fun getDownloadedImage(url: String): DownloadedImage {
      val alreadyDownloaded = imageStorage.find(url)
      if (alreadyDownloaded != null) {
         return alreadyDownloaded
      } else {
         if (!isNetworkConnected()) {
            throw IllegalStateException("Missing internet connection!")
         }

         val newImageFile = imageStorage.getNewImageFile()
         url.downloadTo(newImageFile)
         val hash = newImageFile.calculateBase64()
         val image = DownloadedImage(url, newImageFile, hash)
         imageStorage.store(image)
         return image
      }
   }

   private fun isNetworkConnected(): Boolean {
      val cm = application.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
      return cm.activeNetworkInfo != null
   }
}
