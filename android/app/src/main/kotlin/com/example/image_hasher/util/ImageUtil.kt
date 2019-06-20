package com.example.image_hasher.util

import android.util.Base64
import java.io.File
import java.io.FileOutputStream
import java.net.URL

/**
 * Provides methods for image download and hash calculation.
 */

/**
 * Downloads an image from this image URL [String] to the given [file].
 */
fun String.downloadTo(file: File) {
   URL(this).openStream().use { input ->
      FileOutputStream(file).use { output ->
         input.copyTo(output)
      }
   }
}

/**
 * Calculates a Base64 hash from this image [File].
 */
fun File.calculateBase64(): String {
   return Base64.encodeToString(readBytes(), Base64.DEFAULT)
}
