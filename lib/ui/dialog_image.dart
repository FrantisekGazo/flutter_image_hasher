import 'dart:io';

import 'package:flutter/material.dart';

///
/// Shows the given [imagePath] in a dialog.
///
class ImageDialog extends StatelessWidget {
  final String imagePath;

  const ImageDialog({
    @required this.imagePath,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Image.file(File(imagePath)),
    );
  }
}
