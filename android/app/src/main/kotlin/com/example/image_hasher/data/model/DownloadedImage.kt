package com.example.image_hasher.data.model

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
}
