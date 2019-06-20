import 'package:flutter/material.dart';
import 'package:image_hasher/data/model/downloaded_image.dart';
import 'package:image_hasher/data/service/download_service.dart';
import 'package:image_hasher/ui/dialog_image.dart';

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
/// Shows an image url. When clicked, a dialog with the image is shown.
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
      onTap: () => _showImageDialog(context),
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ImageDialog(imagePath: image.path),
    );
  }
}
