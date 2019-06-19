import 'package:meta/meta.dart';

///
/// Contains info about a successfully downloaded image.
///
class DownloadedImage {
  final String url;
  final String path;

  DownloadedImage({
    @required this.url,
    @required this.path,
  });
}
