import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
  final _platformInteractor = _PlatformInteractor();

  _DownloadServiceImpl() {
    _updateDownloadedImages();
  }

  @override
  ValueListenable<DownloadState> get downloadState => _state;

  @override
  ValueListenable<List<DownloadedImage>> get downloadedImages => _list;

  @override
  void download(String imageUrl) async {
    _state.value = DownloadState(inProgress: true);
    try {
      final image = await _platformInteractor.downloadImageToFile(imageUrl);
      _state.value = DownloadState(image: image);
      _updateDownloadedImages();
    } on PlatformException catch (e) {
      _state.value = DownloadState(error: e.message);
    } on MissingPluginException catch (e) {
      _state.value =
          DownloadState(error: "${Platform.operatingSystem} isn't supported");
    } catch (e) {
      _state.value = DownloadState(error: "Unknown error");
      print("_DownloadServiceImpl#download failed");
      print(e);
    }
  }

  void _updateDownloadedImages() async {
    try {
      _list.value = await _platformInteractor.getDownloadedImages();
    } catch (e) {
      print("_DownloadServiceImpl#_updateDownloadedImages failed");
      print(e);
    }
  }
}

class _PlatformInteractor {
  static const CHANNEL_NAME = 'com.ventrata/image_download';
  static const METHOD_DOWNLOAD = "downloadImage";
  static const METHOD_GET_ALL = "getDownloads";

  static const platform = const MethodChannel(CHANNEL_NAME, JSONMethodCodec());

  Future<DownloadedImage> downloadImageToFile(String url) async {
    final result = await platform.invokeMethod(METHOD_DOWNLOAD, url);
    return DownloadedImage.fromJson(result);
  }

  Future<List<DownloadedImage>> getDownloadedImages() async {
    final List results = await platform.invokeMethod(METHOD_GET_ALL);
    return results.map((data) => DownloadedImage.fromJson(data)).toList();
  }
}
