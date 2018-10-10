import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/widgets/breez_avatar.dart';
import 'package:image/image.dart' as DartImage;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';

int scaledWidth = 200;
var _transparentImage = DartImage.Image(scaledWidth, scaledWidth);

Widget breezAvatarDialog(BuildContext context, UserProfileBloc userBloc) {
  BreezUserModel _currentSettings;

  final _nameInputController = TextEditingController();
  userBloc.userPreviewStream.listen((user) {
    _nameInputController.text = user.name;
    _currentSettings = user;
  });

  Future _pickImage(BuildContext context) async {
    const _platform = const MethodChannel('com.breez.client/image-cropper');
    return ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      return _platform
          .invokeMethod("start", {"filePath": file.path}).then((res) {
        if (res != null) {
          new File(res.toString())
              .readAsBytes()
              .then(scaleAndFormatPNG)
              .then((image) {
            userBloc.uploadImageSink.add(image);
          });
        }
      });
    }).catchError((err) {});
  }

  return new AlertDialog(
    titlePadding: EdgeInsets.all(0.0),
    title: new Stack(children: <Widget>[
      new Container(
        color: theme.BreezColors.blue[900],
        height: 70.0,
        width: 300.0,
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.only(bottom: 20.0, top: 26.0),
            child: new Text('RANDOM', style: theme.whiteButtonStyle),
            onPressed: () {
              userBloc.randomizeSink.add(null);
              FocusScope.of(context).requestFocus(new FocusNode());
            },
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
          FlatButton(
            padding: EdgeInsets.only(bottom: 20.0, top: 26.0),
            child: new Text('GALLERY', style: theme.whiteButtonStyle),
            onPressed: () {
              _pickImage(context);
            },
          ),
        ],
      ),
    ]),
    content: new SingleChildScrollView(
      child: new ListBody(
        children: <Widget>[
          new Theme(
            data: new ThemeData(
                primaryColor: theme.BreezColors.blue[900],
                hintColor: theme.BreezColors.blue[900]),
            child: new TextField(
                style: theme.avatarDialogStyle,
                controller: _nameInputController,
                decoration: InputDecoration(hintText: 'Enter your name'),
                onSubmitted: (text) {}),
          )
        ],
      ),
    ),
    actions: <Widget>[
      new FlatButton(
        child: new Text('CANCEL', style: theme.buttonStyle),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      new FlatButton(
        child: new Text('SAVE', style: theme.buttonStyle),
        onPressed: () {
          userBloc.userSink
              .add(_currentSettings.copyWith(name: _nameInputController.text));
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

List<int> scaleAndFormatPNG(List<int> imageBytes) {
  DartImage.Image image = DartImage.decodeImage(imageBytes);
  DartImage.Image resized = DartImage.copyResize(
      image,
      image.width < image.height ? -1 : scaledWidth,
      image.width < image.height ? scaledWidth : -1);
  DartImage.Image centered = DartImage.copyInto(_transparentImage, resized,
      dstX: ((scaledWidth - resized.width) / 2).round(),
      dstY: ((scaledWidth - resized.height) / 2).round());
  return DartImage.encodePng(centered);
}
