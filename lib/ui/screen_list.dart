import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_hasher/data/model/downloaded_image.dart';
import 'package:image_hasher/data/service/download_service.dart';

///
/// Shows list of all downloaded images.
///
class ImageListScreen extends StatelessWidget {
  final _downloadService = DownloadService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloads"),
      ),
      body: ValueListenableBuilder<List<DownloadedImage>>(
        valueListenable: _downloadService.downloadedImages,
        builder: (context, value, _) {
          if (value.isEmpty) {
            return Center(
              child: Text("No images were downloaded yet"),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < 0 || index > value.length - 1) {
                  return null;
                }

                return _DownloadedImageListItem(image: value[index]);
              },
            );
          }
        },
      ),
    );
  }
}

///
/// Shows and image url. When clicked, a dialog with the image is shown.
///
class _DownloadedImageListItem extends StatelessWidget {
  final DownloadedImage image;

  const _DownloadedImageListItem({
    @required this.image,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(image.url),
      onTap: () => _showImage(context),
    );
  }

  void _showImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(image.url),
// test image : content: Image.network("https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.gettyimages.com.au%2Fgi-resources%2Fimages%2Ffrontdoor%2Fcreative%2FPanoramicImagesRM%2FFD_image.jpg&f=1"),
          content: Image.file(File(image.path)),
        );
      },
    );
  }
}
