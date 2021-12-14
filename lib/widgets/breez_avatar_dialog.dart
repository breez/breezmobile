import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as DartImage;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'flushbar.dart';

int scaledWidth = 200;
var _transparentImage = DartImage.Image(scaledWidth, scaledWidth);

Widget breezAvatarDialog(BuildContext context, UserProfileBloc userBloc) {
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  BreezUserModel _currentSettings;
  File _pickedImage;
  bool _isUploading = false;

  final _nameInputController = TextEditingController();
  userBloc.userPreviewStream.listen((user) {
    _nameInputController.text = user.name;
    _currentSettings = user;
  });

  Future<File> _pickImage() async {
    final _picker = ImagePicker();
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    final File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );
    return croppedFile;
  }

  return WillPopScope(
    onWillPop: () {
      return Future.value(!_isUploading);
    },
    child: StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0.0),
          title: Stack(children: <Widget>[
            Container(
              height: 70.0,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12.0))),
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
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(
                          bottom: 20.0,
                          top: 26.0,
                        ),
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
                        _pickedImage = null;
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
                        return Stack(
                          children: [
                            _isUploading
                                ? Padding(
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                    .primaryTextTheme
                                                    .button
                                                    .color),
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                    padding: EdgeInsets.only(top: 26.0),
                                  )
                                : SizedBox(),
                            Padding(
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: BreezAvatar(
                                    _pickedImage?.path ??
                                        snapshot.data.avatarURL,
                                    radius: 36.0,
                                  )),
                              padding: EdgeInsets.only(top: 26.0),
                            )
                          ],
                        );
                      }
                    },
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(
                          bottom: 20.0,
                          top: 26.0,
                        ),
                      ),
                      child: AutoSizeText(
                        'GALLERY',
                        style: theme.whiteButtonStyle,
                        maxLines: 1,
                        minFontSize: MinFontSize(context).minFontSize,
                        stepGranularity: 0.1,
                        group: _autoSizeGroup,
                      ),
                      onPressed: () async {
                        await _pickImage().then(
                          (file) {
                            setState(() {
                              _pickedImage = file;
                            });
                          },
                        );
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
                      primaryColor:
                          Theme.of(context).primaryTextTheme.bodyText2.color,
                      hintColor:
                          Theme.of(context).primaryTextTheme.bodyText2.color),
                  child: TextField(
                      enabled: !_isUploading,
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                      controller: _nameInputController,
                      decoration: InputDecoration(hintText: 'Enter your name'),
                      onSubmitted: (text) {}),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL',
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: _isUploading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
            ),
            TextButton(
              child: Text('SAVE',
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: _isUploading
                  ? null
                  : () async {
                      try {
                        var userName = _nameInputController.text;
                        if (_pickedImage != null) {
                          setState(() {
                            _isUploading = true;
                          });
                          await _uploadImage(_pickedImage, userBloc).then((_) {
                            setState(() {
                              _isUploading = false;
                            });
                          });
                        }
                        userBloc.userSink
                            .add(_currentSettings.copyWith(name: userName));
                        Navigator.of(context).pop();
                      } catch (e) {
                        setState(() {
                          _isUploading = false;
                          _pickedImage = null;
                        });
                        showFlushbar(
                          context,
                          message: "Failed to upload profile picture",
                        );
                      }
                    },
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.0), top: Radius.circular(13.0))),
        );
      },
    ),
  );
}

Future _uploadImage(File _pickedImage, UserProfileBloc userBloc) async {
  return _pickedImage
      .readAsBytes()
      .then(scaleAndFormatPNG)
      .then((imageBytes) async {
    var action = UploadProfilePicture(imageBytes);
    userBloc.userActionsSink.add(action);
    return action.future;
  });
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
