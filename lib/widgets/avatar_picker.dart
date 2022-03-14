import 'dart:async';
import 'dart:io';

import 'package:breez/logger.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        padding: EdgeInsets.only(top: 16.0),
        child: _getPickerWidget(context),
      ),
    );
  }

  Widget _getPickerWidget(BuildContext context) {
    final texts = AppLocalizations.of(context);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("src/icon/camera.png"),
            color: Colors.white,
            width: 24.0,
            height: 24.0,
          ),
          Text(
            imagePath == null
                ? texts.avatar_picker_action_set_photo
                : texts.avatar_picker_action_change_photo,
            style: TextStyle(
              fontSize: 10.0,
              color: Color.fromRGBO(255, 255, 255, 0.88),
              letterSpacing: 0.0,
              fontFamily: "IBMPlexSans",
            ),
          ),
        ],
      ),
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
                ? Color.fromRGBO(5, 93, 235, 0.8)
                : Color.fromRGBO(51, 69, 96, 0.4),
            BlendMode.srcATop,
          ),
          image: imagePath == null
              ? AssetImage("src/images/avatarbg.png")
              : FileImage(File(imagePath)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future _pickImage(BuildContext context) async {
    final _picker = ImagePicker();
    PickedFile pickedFile =
        await _picker.getImage(source: ImageSource.gallery).catchError((err) {
      log.severe(err.toString());
    });
    final File file = File(pickedFile.path);
    return ImageCropper().cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.circle,
      aspectRatio: CropAspectRatio(
        ratioX: 1.0,
        ratioY: 1.0,
      ),
    ).then((file) => _readFile(context, file));
  }

  void _readFile(BuildContext context, File file) {
    if (file == null) return;
    final texts = AppLocalizations.of(context);
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

  List<int> _scaleAndFormatPNG(List<int> imageBytes) {
    DartImage.Image image = DartImage.decodeImage(imageBytes);
    DartImage.Image resized = DartImage.copyResize(
      image,
      width: image.width < image.height ? -1 : scaledWidth,
      height: image.width < image.height ? scaledWidth : -1,
    );
    DartImage.Image centered = DartImage.copyInto(
      DartImage.Image(scaledWidth, scaledWidth),
      resized,
      dstX: ((scaledWidth - resized.width) / 2).round(),
      dstY: ((scaledWidth - resized.height) / 2).round(),
    );
    final width = centered.width;
    final height = centered.height;
    log.info('trimmed.width $width trimmed.height $height');
    return DartImage.encodePng(centered);
  }
}
