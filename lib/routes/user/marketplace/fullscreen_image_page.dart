import 'dart:typed_data';

import 'package:flutter/material.dart';

class FullScreenPage extends StatelessWidget {
  final Uint8List _imageData;

  FullScreenPage(this._imageData);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: MemoryImage(_imageData), fit: BoxFit.cover),
      ),
    );
  }
}
