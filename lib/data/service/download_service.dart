import 'package:flutter/foundation.dart';
import 'package:image_hasher/data/model/download_state.dart';
import 'package:image_hasher/data/model/downloaded_image.dart';

///
/// Handles image download.
///
abstract class DownloadService {
  /// Starts the image download process from the given url.
  void download(String imageUrl);

  /// Current state of the download process.
  ValueListenable<DownloadState> get downloadState;

  /// List of all downloaded images.
  ValueListenable<List<DownloadedImage>> get downloadedImages;

  static DownloadService _instance = _DownloadServiceImpl();

  /// Provides a single instance of this service.
  factory DownloadService() => _instance;
}

/// Implementation of the [DownloadService].
class _DownloadServiceImpl implements DownloadService {
  final _state = ValueNotifier<DownloadState>(DownloadState());
  final _list = ValueNotifier<List<DownloadedImage>>([]);

  @override
  ValueListenable<DownloadState> get downloadState => _state;

  @override
  ValueListenable<List<DownloadedImage>> get downloadedImages => _list;

  @override
  void download(String imageUrl) {
    _state.value = DownloadState(inProgress: true);
  }
}
