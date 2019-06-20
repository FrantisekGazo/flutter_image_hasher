import 'package:flutter/material.dart';
import 'package:image_hasher/data/model/downloaded_image.dart';

///
/// Contains info about current state of an image download.
///
class DownloadState with ChangeNotifier {
  /// True if download is running.
  final bool inProgress;

  /// This will be set only after failed download.
  final String error;

  /// This will be set only after successful download.
  final DownloadedImage image;

  DownloadState({
    this.inProgress = false,
    this.error,
    this.image,
  });
}
