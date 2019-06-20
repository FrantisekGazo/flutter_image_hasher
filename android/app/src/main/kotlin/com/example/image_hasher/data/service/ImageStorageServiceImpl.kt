package com.example.image_hasher.data.service

import android.content.Context
import com.example.image_hasher.data.model.DownloadedImage
import java.io.File

/**
 * Implementation of the [ImageStorageService].
 */
class ImageStorageServiceImpl(private val context: Context) : ImageStorageService {

   companion object {
      private const val SP_NAME = "downloaded_images"
      private const val IMAGES_DIR_NAME = "images"
   }

   /** [SharedPreferences] for additional information about downloaded images. */
   private val sp = context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE)
   /** Directory for all downloaded images. */
   private val imagesDir by lazy { File(context.filesDir, IMAGES_DIR_NAME).apply { mkdir() } }

   override fun store(image: DownloadedImage) {
      sp.edit().putString(image.file.name, image.url).apply()
   }

   override fun getAll(): List<DownloadedImage> {
      return getAllFiles()
             .map { DownloadedImage(sp.getString(it.name, ""), it) }
             // make sure there is a url
             .filter { it.url.isNotEmpty() }
   }

   override fun find(imageUrl: String): DownloadedImage? {
      return getAll().find { it.url == imageUrl }
   }

   override fun getNewImageFile(): File {
      val max = getAllFiles()
             .map { it.name.toInt() }
             .max() ?: 0
      val name = (max + 1).toString()
      return getImageFile(name)
   }

   /**
    * @return An image file with given name. (This doesn't ensure it exists)
    */
   private fun getImageFile(name: String) = File(imagesDir, name)

   /**
    * @return List of all downloaded files in the image download folder.
    */
   private fun getAllFiles(): List<File> {
      return imagesDir.walk()
             .toList()
             .filter { it.isFile }
   }
}