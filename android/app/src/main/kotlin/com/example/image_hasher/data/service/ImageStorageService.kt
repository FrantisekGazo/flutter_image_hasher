package com.example.image_hasher.data.service

import com.example.image_hasher.data.model.DownloadedImage
import java.io.File

/**
 * Handles image storage.
 */
interface ImageStorageService {

   /**
    * Stores info about given downloaded [image], so that we can match it with a url.
    */
   fun store(image: DownloadedImage)

   /**
    * Checks if the image with given [imageUrl] was downloaded.
    *
    * @return [DownloadedImage] if it was already downloaded, otherwise null.
    */
   fun find(imageUrl: String): DownloadedImage?

   /**
    * @return List of all downloaded images.
    */
   fun getAll(): List<DownloadedImage>

   /**
    * @return A new [File] that can be used for an image download
    */
   fun getNewImageFile(): File
}
