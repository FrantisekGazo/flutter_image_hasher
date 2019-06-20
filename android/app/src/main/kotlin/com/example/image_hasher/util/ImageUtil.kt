package com.example.image_hasher.util

import java.io.File
import java.io.FileOutputStream
import java.net.URL

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
