package com.example.image_hasher.data.model

import android.util.Base64
import org.json.JSONObject
import java.io.File

/**
 * Contains info about a successfully downloaded image.
 */
data class DownloadedImage(
       val url: String,
       val file: File,
       val hash: String = ""
) {

   fun toJson() = JSONObject(mapOf(
          "url" to url,
          "path" to file.path,
          "hash" to hash
   ))

   fun calculateBase64(): DownloadedImage {
      val base64 = Base64.encodeToString(file.readBytes(), Base64.DEFAULT)
      return DownloadedImage(url, file, base64)
   }
}
