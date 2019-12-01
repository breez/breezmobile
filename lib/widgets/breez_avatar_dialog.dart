import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as DartImage;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

int scaledWidth = 200;
var _transparentImage = DartImage.Image(scaledWidth, scaledWidth);

Widget breezAvatarDialog(BuildContext context, UserProfileBloc userBloc) {
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  BreezUserModel _currentSettings;

  final _nameInputController = TextEditingController();
  userBloc.userPreviewStream.listen((user) {
    _nameInputController.text = user.name;
    _currentSettings = user;
  });

  Future _pickImage(BuildContext context) async {
    return ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      ).then((file) {
        if (file != null) {
          file.readAsBytes().then(scaleAndFormatPNG).then((image) {
            userBloc.uploadImageSink.add(image);
          });
        }
      });
    }).catchError((err) {});
  }

  return AlertDialog(
    titlePadding: EdgeInsets.all(0.0),
    title: Stack(children: <Widget>[
      Container(
        height: 70.0,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
          color: theme.themeId == "BLUE"
              ? Theme.of(context).primaryColorDark
              : Theme.of(context).canvasColor,
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.only(
                  bottom: 20.0,
                  top: 26.0,
                ),
                child: AutoSizeText(
                  'RANDOM',
                  style: theme.whiteButtonStyle,
                  maxLines: 1,
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                  group: _autoSizeGroup,
                ),
                onPressed: () {
                  userBloc.randomizeSink.add(null);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
            StreamBuilder<BreezUserModel>(
                stream: userBloc.userPreviewStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return Padding(
                      child: BreezAvatar(snapshot.data.avatarURL, radius: 44.0),
                      padding: EdgeInsets.only(top: 26.0),
                    );
                  }
                }),
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.only(
                  bottom: 20.0,
                  top: 26.0,
                ),
                child: AutoSizeText(
                  'GALLERY',
                  style: theme.whiteButtonStyle,
                  maxLines: 1,
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                  group: _autoSizeGroup,
                ),
                onPressed: () {
                  _pickImage(context);
                },
              ),
            ),
          ],
        ),
      ),
    ]),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Theme(
            data: ThemeData(
                primaryColor: Theme.of(context).primaryTextTheme.body1.color,
                hintColor: Theme.of(context).primaryTextTheme.body1.color),
            child: TextField(
                style: Theme.of(context).primaryTextTheme.body1,
                controller: _nameInputController,
                decoration: InputDecoration(hintText: 'Enter your name'),
                onSubmitted: (text) {}),
          )
        ],
      ),
    ),
    actions: <Widget>[
      FlatButton(
        child: Text('CANCEL', style: Theme.of(context).primaryTextTheme.button),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: Text('SAVE', style: Theme.of(context).primaryTextTheme.button),
        onPressed: () {
          userBloc.userSink
              .add(_currentSettings.copyWith(name: _nameInputController.text));
          Navigator.of(context).pop();
        },
      ),
    ],
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.0), top: Radius.circular(13.0))),
  );
}

List<int> scaleAndFormatPNG(List<int> imageBytes) {
  DartImage.Image image = DartImage.decodeImage(imageBytes);
  DartImage.Image resized = DartImage.copyResize(image,
      width: image.width < image.height ? -1 : scaledWidth,
      height: image.width < image.height ? scaledWidth : -1);
  DartImage.Image centered = DartImage.copyInto(_transparentImage, resized,
      dstX: ((scaledWidth - resized.width) / 2).round(),
      dstY: ((scaledWidth - resized.height) / 2).round());
  return DartImage.encodePng(centered);
}
