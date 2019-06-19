import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_hasher/data/model/download_state.dart';
import 'package:image_hasher/data/model/downloaded_image.dart';
import 'package:image_hasher/data/service/download_service.dart';
import 'package:image_hasher/navigation/navigator.dart';

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
          IconButton(icon: Icon(Icons.list), onPressed: _navigateToListPage)
        ],
      ),
      body: ValueListenableBuilder<DownloadState>(
        valueListenable: _downloadService.downloadState,
        builder: (context, value, _) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(hintText: "Image URL"),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("Download"),
                          onPressed: value.inProgress ? null : _download,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    child: Text(value.error != null
                        ? "Error: ${value.error}"
                        : (value.image != null
                            ? "Image: ${value.image.path}"
                            : "nothing downloaded")),
                    onTap: value.image != null ? () => _showImage(value.image) : null,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToListPage() {
    MyNavigator.navigateToList(context);
  }

  Future _download() async {
    final url = _imageUrlController.text.trim();
    _downloadService.download(url);
  }

  void _showImage(DownloadedImage image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Image.file(File(image.path)),
        );
      },
    );
  }
}
