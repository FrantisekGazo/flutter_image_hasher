import 'package:flutter/material.dart';
import 'package:image_hasher/data/model/download_state.dart';
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
  final _imageUrlController = TextEditingController();
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
                  RaisedButton(
                    child: Text("Download"),
                    onPressed: value.inProgress ? null : _download,
                  ),
                  SizedBox(height: 16),
                  Text("TODO")
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
}
