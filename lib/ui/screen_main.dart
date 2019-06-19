import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_hasher/data/model/download_state.dart';
import 'package:image_hasher/data/model/downloaded_image.dart';
import 'package:image_hasher/data/service/download_service.dart';
import 'package:image_hasher/navigation/navigator.dart';
import 'package:image_hasher/ui/dialog_image.dart';

///
/// Shows main screen for image download
///
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _imageUrlController = TextEditingController(text: "https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.crestock.com%2Fimages%2Frandomimages%2F1658-6234203-Small.jpg&f=1");
  final _downloadService = DownloadService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloader"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _navigateToListPage,),
        ],
      ),
      body: ValueListenableBuilder<DownloadState>(
        valueListenable: _downloadService.downloadState,
        builder: (context, value, _) {
          return Stack(
            children: <Widget>[
              _buildBody(value),
              if (value.inProgress) _buildProgressOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressOverlay() {
    return Container(
      color: Colors.white54,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildBody(DownloadState value) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: "Image URL",
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => _imageUrlController.clear(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text("Download"),
                    onPressed: _download,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (value.image != null) _ImageHash(image: value.image),
            if (value.error != null) Text("Error: ${value.error}"),
          ],
        ),
      ),
    );
  }

  void _navigateToListPage() {
    MyNavigator.navigateToList(context);
  }

  Future _download() async {
    final url = _imageUrlController.text.trim();
    if (url.isNotEmpty) {
      _downloadService.download(url);
    }
  }
}

///
/// Shows a clickable image hash. When clicked, image dialog will be shown.
///
class _ImageHash extends StatelessWidget {
  final DownloadedImage image;

  const _ImageHash({
    @required this.image,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text("Image: ${image.path}"),
      onTap: () => _showImage(context),
    );
  }

  void _showImage(context) {
    showDialog(
      context: context,
      builder: (context) => ImageDialog(imagePath: image.path),
    );
  }
}
