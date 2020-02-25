import 'dart:async';

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
enum UPLOAD_STATE { UPLOAD_IN_PROGRESS }

Widget breezAvatarDialog(BuildContext context, UserProfileBloc userBloc) {
  UPLOAD_STATE _state;
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  BreezUserModel _currentSettings;
  List<int> _imageData;

  final _nameInputController = TextEditingController();
  userBloc.userPreviewStream.listen((user) {
    _nameInputController.text = user.name;
    _currentSettings = user;
  });

  Future _pickImage(BuildContext context, setState) async {
    return ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      ).then((file) {
        if (file != null) {
          file.readAsBytes().then(scaleAndFormatPNG).then((image) {
            setState(() {
              _imageData = image;
            });
          });
        }
      });
    }).catchError((err) {});
  }

  return WillPopScope(
    onWillPop: () => _onWillPop(_state),
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
                        _imageData = null;
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
                        if (_state == UPLOAD_STATE.UPLOAD_IN_PROGRESS) {
                          return Stack(
                            children: [
                              Padding(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context)
                                            .primaryTextTheme
                                            .button
                                            .color),
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                  ),
                                ),
                                padding: EdgeInsets.only(top: 26.0),
                              ),
                              Padding(
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: BreezAvatar(
                                      snapshot.data.avatarURL,
                                      radius: 36.0,
                                      bytes: _imageData,
                                    )),
                                padding: EdgeInsets.only(top: 26.0),
                              )
                            ],
                          );
                        }
                        return Padding(
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: BreezAvatar(
                                snapshot.data.avatarURL,
                                radius: 36.0,
                                bytes: _imageData,
                              )),
                          padding: EdgeInsets.only(top: 26.0),
                        );
                      }
                    },
                  ),
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
                        _pickImage(context, setState);
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
                          Theme.of(context).primaryTextTheme.body1.color,
                      hintColor:
                          Theme.of(context).primaryTextTheme.body1.color),
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
              child: Text('CANCEL',
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: _state == UPLOAD_STATE.UPLOAD_IN_PROGRESS
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
            ),
            FlatButton(
              child: Text('SAVE',
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: () async {
                if (_imageData != null) {
                  var action = UploadProfilePicture(_imageData);
                  userBloc.userActionsSink.add(action);
                  setState(() {
                    _state = UPLOAD_STATE.UPLOAD_IN_PROGRESS;
                  });
                  await action.future.then((_) async {
                    setState(() {
                      _state = null;
                    });
                    Navigator.of(context).pop();
                  }, onError: (error) {
                    setState(() {
                      _imageData = null;
                      _state = null;
                    });
                    return showFlushbar(
                      context,
                      message: "Failed to upload profile picture",
                    );
                  });
                }
                userBloc.userSink.add(
                    _currentSettings.copyWith(name: _nameInputController.text));
                Navigator.of(context).pop();
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

// Do not pop dialog if there's a upload in progress
Future<bool> _onWillPop(UPLOAD_STATE _state) async {
  if (_state == UPLOAD_STATE.UPLOAD_IN_PROGRESS) {
    return false;
  }
  return true;
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
