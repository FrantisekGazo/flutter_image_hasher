import 'package:meta/meta.dart';

///
/// Contains info about a successfully downloaded image.
///
class DownloadedImage {
  /// Image url.
  final String url;

  /// Path to the downloaded image file.
  final String path;

  /// Hash calculated from the image.
  /// Can be an empty String (for the download history).
  final String hash;

  DownloadedImage({
    @required this.url,
    @required this.path,
    @required this.hash,
  });

  DownloadedImage.fromJson(Map<String, dynamic> json)
      : this.url = json['url'],
        this.path = json['path'],
        this.hash = json['hash'];
}
