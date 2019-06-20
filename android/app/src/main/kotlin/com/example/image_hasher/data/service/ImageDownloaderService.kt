package com.example.image_hasher.data.service

import android.content.Context
import com.example.image_hasher.data.model.DownloadedImage
import java.io.File
import java.io.FileOutputStream
import java.net.URL

/**
 * handles image download.
 */
object ImageDownloaderService {

   private const val SP_NAME = "downloaded_images"
   private const val IMAGES_DIR_NAME = "images"

   /**
    * @return List of all downloaded images.
    */
   fun getAllDownloads(context: Context): List<DownloadedImage> {
      val sp = getSharedPreferences(context)
      return getAllDownloadedFiles(context)
             .map { DownloadedImage(sp.getString(it.name, ""), it) }
             // make sure there is a url
             .filter { it.url.isNotEmpty() }
   }

   /**
    * Downloads an image from from given [imageUrl] to a [File].
    *
    * @return [File] that contains the newly downloaded image.
    */
   fun download(context: Context, imageUrl: String): File {
      val alreadyDownloaded = findDownloadedImage(context, imageUrl)
      if (alreadyDownloaded != null) {
         return alreadyDownloaded.file
      } else {
         val newImageFile = getImageFile(context, getNewImageName(context))
         download(imageUrl, newImageFile)
         storeDownload(context, DownloadedImage(imageUrl, newImageFile))
         return newImageFile
      }
   }

   /**
    * Stores info about given downloaded [image], so that we can match it with a url.
    */
   private fun storeDownload(context: Context, image: DownloadedImage) {
      val sp = getSharedPreferences(context)
      sp.edit().putString(image.file.name, image.url).apply()
   }

   /**
    * Downloads an image from from given [imageUrl] to the given [file].
    */
   private fun download(imageUrl: String, file: File) {
      URL(imageUrl).openStream().use { input ->
         FileOutputStream(file).use { output ->
            input.copyTo(output)
         }
      }
   }

   /**
    * Checks if the image with given [imageUrl] was downloaded.
    *
    * @return [DownloadedImage] if it was already downloaded, otherwise null.
    */
   private fun findDownloadedImage(context: Context, imageUrl: String): DownloadedImage? {
      return getAllDownloads(context).find { it.url == imageUrl }
   }

   /**
    * @return List of all downloaded files in the image download folder.
    */
   private fun getAllDownloadedFiles(context: Context): List<File> {
      return getImagesDir(context)
             .walk()
             .toList()
             .filter { it.isFile }
   }

   /**
    * Prepares a new name that won't collide with the already downloaded image files.
    *
    * @return New file name.
    */
   private fun getNewImageName(context: Context): String {
      val max = getAllDownloadedFiles(context)
             .map { it.name.toInt() }
             .max() ?: 0
      return (max + 1).toString()
   }

   private fun getSharedPreferences(context: Context) = context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE)
   private fun getImagesDir(context: Context) = File(context.filesDir, IMAGES_DIR_NAME).apply { mkdir() }
   private fun getImageFile(context: Context, name: String) = File(getImagesDir(context), name)
}