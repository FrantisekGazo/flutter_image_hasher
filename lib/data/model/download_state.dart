import 'package:flutter/material.dart';
import 'package:image_hasher/data/model/downloaded_image.dart';

///
/// Contains info about current state of an image download.
///
class DownloadState with ChangeNotifier {
  final bool inProgress;
  final String error;
  final DownloadedImage image;

  DownloadState({
    this.inProgress = false,
    this.error,
    this.image,
  });
}
