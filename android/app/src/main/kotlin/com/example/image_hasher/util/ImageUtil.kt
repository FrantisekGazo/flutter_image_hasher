package com.example.image_hasher.util

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import java.io.File
import java.io.FileOutputStream
import java.net.URL
import android.graphics.ColorMatrixColorFilter
import android.graphics.ColorMatrix
import android.graphics.Paint


/**
 * Downloads an image from this image URL [String] to the given [file].
 *
 * @return The given [file].
 */
fun String.downloadTo(file: File): File {
   URL(this).openStream().use { input ->
      FileOutputStream(file).use { output ->
         input.copyTo(output)
      }
   }
   return file
}

/**
 * Converts this image file to Black&White.
 *
 * @return The modified [File].
 */
fun File.toBlackAndWhite(): File {
   val bitmap = BitmapFactory.decodeFile(path).toBlackAndWhite()
   FileOutputStream(this).use { output ->
      bitmap.compress(Bitmap.CompressFormat.PNG, 0, output)
   }
   return this
}

/**
 * Convert this [Bitmap] to Black&White.
 *
 * @return New [Bitmap].
 */
private fun Bitmap.toBlackAndWhite(): Bitmap {
   val newBitmap = Bitmap.createBitmap(width, height, config)
   val canvas = Canvas(newBitmap)
   val paint = Paint()
   val cm = ColorMatrix().apply { setSaturation(0f) }
   paint.colorFilter = ColorMatrixColorFilter(cm)
   canvas.drawBitmap(this, 0f, 0f, paint)
   return newBitmap
}
