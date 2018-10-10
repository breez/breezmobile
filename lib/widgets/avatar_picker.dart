import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as DartImage;
import 'package:image_picker/image_picker.dart';
import 'package:breez/logger.dart';

class AvatarPicker extends StatelessWidget {
  static const _platform = const MethodChannel('com.breez.client/image-cropper');

  final String imagePath;
  final bool renderLoading;
  final Function(List<int> selectedImage) onImageSelected;
  final double radius;
  final int scaledWidth;
  final int renderedWidth;
  DartImage.Image _transparentImage;

  AvatarPicker(this.imagePath, this.onImageSelected,
      {key, this.radius = 100.0, this.scaledWidth = -1, this.renderLoading = false, this.renderedWidth = 100})
      : super(key: key) {
    _transparentImage = DartImage.Image(scaledWidth, scaledWidth);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _pickImage(context);
        },
        child: new Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: _getPickerWidget(),
        ));
  }

  _getPickerWidget() {
    Color _overlayColor = imagePath == null ? Color.fromRGBO(5, 93, 235, 0.8) : Color.fromRGBO(51, 69, 96, 0.4);
    var _posAvatar = imagePath == null ? AssetImage("src/images/avatarbg.png") : new FileImage(new File(imagePath));

    return new Container(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("src/icon/camera.png"),
              color: Colors.white,
              width: 24.0,
              height: 24.0,
            ),
            Text(
              imagePath == null ? "Set Photo" : "Change Photo",
              style: TextStyle(
                  fontSize: 10.0,
                  color: Color.fromRGBO(255, 255, 255, 0.88),
                  letterSpacing: 0.0,
                  fontFamily: "IBMPlexSans"),
            ),
          ],
        ),
        width: renderedWidth.roundToDouble(),
        height: renderedWidth.roundToDouble(),
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: imagePath == null ? Border.all(color: Colors.white, width: 2.0, style: BorderStyle.solid) : null,
            image: new DecorationImage(
                colorFilter: ColorFilter.mode(_overlayColor, BlendMode.srcATop),
                image: _posAvatar,
                fit: BoxFit.cover)));
  }

  Future _pickImage(BuildContext context) async {
    return ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      return AvatarPicker._platform.invokeMethod("start", {"filePath": file.path}).then((res) {
        if (res != null) {
          new File(res.toString())
              .readAsBytes()
              .then(scaleAndFormatPNG)
              .then(onImageSelected)
              .catchError((e) => promptError(context, "Failed to Select Image", Text(e.toString())));
        }
      });
    }).catchError((err) {
      log.severe(err.toString());
    });
  }

  List<int> scaleAndFormatPNG(List<int> imageBytes) {
    DartImage.Image image = DartImage.decodeImage(imageBytes);
    DartImage.Image resized = DartImage.copyResize(
        image, image.width < image.height ? -1 : scaledWidth, image.width < image.height ? scaledWidth : -1);
    DartImage.Image centered = DartImage.copyInto(_transparentImage, resized,
        dstX: ((scaledWidth - resized.width) / 2).round(), dstY: ((scaledWidth - resized.height) / 2).round());
    log.info('trimmed.width ${centered.width} trimmed.height ${centered.height}');
    return DartImage.encodePng(centered);
  }
}
