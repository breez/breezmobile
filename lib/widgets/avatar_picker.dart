import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:breez/logger.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:image/image.dart' as DartImage;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatelessWidget {
  final String imagePath;
  final bool renderLoading;
  final Function(List<int> selectedImage) onImageSelected;
  final double radius;
  final int scaledWidth;
  final int renderedWidth;

  const AvatarPicker(
    this.imagePath,
    this.onImageSelected, {
    key,
    this.radius = 100.0,
    this.scaledWidth = -1,
    this.renderLoading = false,
    this.renderedWidth = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _pickImage(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: _getPickerWidget(context),
      ),
    );
  }

  Widget _getPickerWidget(BuildContext context) {
    final texts = context.texts();

    return Container(
      width: renderedWidth.roundToDouble(),
      height: renderedWidth.roundToDouble(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: imagePath == null
            ? Border.all(
                color: Colors.white,
                width: 2.0,
                style: BorderStyle.solid,
              )
            : null,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            imagePath == null
                ? const Color.fromRGBO(5, 93, 235, 0.8)
                : const Color.fromRGBO(51, 69, 96, 0.4),
            BlendMode.srcATop,
          ),
          image: imagePath == null
              ? const AssetImage("src/images/avatarbg.png")
              : FileImage(File(imagePath)),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("src/icon/camera.png"),
            color: Colors.white,
            width: 24.0,
            height: 24.0,
          ),
          Text(
            imagePath == null
                ? texts.avatar_picker_action_set_photo
                : texts.avatar_picker_action_change_photo,
            style: const TextStyle(
              fontSize: 10.0,
              color: Color.fromRGBO(255, 255, 255, 0.88),
              letterSpacing: 0.0,
              fontFamily: "IBMPlexSans",
            ),
          ),
        ],
      ),
    );
  }

  Future _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    XFile pickedFile =
        await picker.pickImage(source: ImageSource.gallery).catchError((err) {
      log.severe(err.toString());
    });
    final File file = File(pickedFile.path);
    return ImageCropper()
        .cropImage(
          sourcePath: file.path,
          cropStyle: CropStyle.circle,
          aspectRatio: const CropAspectRatio(
            ratioX: 1.0,
            ratioY: 1.0,
          ),
        )
        .then((croppedFile) => _readFile(context, File(croppedFile.path)));
  }

  void _readFile(BuildContext context, File file) {
    if (file == null) return;
    final texts = context.texts();
    file
        .readAsBytes()
        .then(_scaleAndFormatPNG)
        .then(onImageSelected)
        .catchError((e) => promptError(
              context,
              texts.avatar_picker_error_select_image,
              Text(e.toString()),
            ));
  }

  Uint8List _scaleAndFormatPNG(List<int> imageBytes) {
    const int scaledSize = 200;
    try {
      final image = DartImage.decodeImage(imageBytes);
      final resized = DartImage.copyResize(
        image,
        width: image.width < image.height ? -1 : scaledSize,
        height: image.width < image.height ? scaledSize : -1,
      );
      log.info(
          'trimmed.width ${resized.width} trimmed.height ${resized.height}');
      return DartImage.encodePng(resized);
    } catch (e) {
      rethrow;
    }
  }
}
