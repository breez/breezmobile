import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:image/image.dart' as DartImage;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'flushbar.dart';

Widget breezAvatarDialog(BuildContext context, UserProfileBloc userBloc) {
  AutoSizeGroup autoSizeGroup = AutoSizeGroup();
  BreezUserModel currentSettings;
  File pickedImage;
  bool isUploading = false;

  final nameInputController = TextEditingController();
  userBloc.userPreviewStream.listen((user) {
    nameInputController.text = user.name;
    currentSettings = user;
  });

  Future<File> pickImage() async {
    final picker = ImagePicker();
    XFile pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    final CroppedFile croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );
    return File(croppedFile.path);
  }

  return WillPopScope(
    onWillPop: () {
      return Future.value(!isUploading);
    },
    child: StatefulBuilder(
      builder: (context, setState) {
        final themeData = Theme.of(context);
        final queryData = MediaQuery.of(context);
        final texts = context.texts();
        final navigator = Navigator.of(context);
        final minFontSize = MinFontSize(context);

        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          title: Stack(
            children: [
              Container(
                height: 70.0,
                decoration: ShapeDecoration(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.0),
                    ),
                  ),
                  color: theme.themeId == "BLUE"
                      ? themeData.primaryColorDark
                      : themeData.canvasColor,
                ),
              ),
              SizedBox(
                width: queryData.size.width,
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                            bottom: 20.0,
                            top: 26.0,
                          ),
                        ),
                        child: AutoSizeText(
                          texts.breez_avatar_dialog_random,
                          style: theme.whiteButtonStyle,
                          maxLines: 1,
                          minFontSize: minFontSize.minFontSize,
                          stepGranularity: 0.1,
                          group: autoSizeGroup,
                        ),
                        onPressed: () {
                          userBloc.randomizeSink.add(null);
                          pickedImage = null;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                    StreamBuilder<BreezUserModel>(
                      stream: userBloc.userPreviewStream,
                      builder: (context, snapshot) {
                        final userModel = snapshot.data;

                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          return Stack(
                            children: [
                              isUploading
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 26.0),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            themeData
                                                .primaryTextTheme.labelLarge.color,
                                          ),
                                          backgroundColor:
                                              themeData.colorScheme.background,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: BreezAvatar(
                                    pickedImage?.path ?? userModel.avatarURL,
                                    radius: 36.0,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                            bottom: 20.0,
                            top: 26.0,
                          ),
                        ),
                        child: AutoSizeText(
                          texts.breez_avatar_dialog_gallery,
                          style: theme.whiteButtonStyle,
                          maxLines: 1,
                          minFontSize: minFontSize.minFontSize,
                          stepGranularity: 0.1,
                          group: autoSizeGroup,
                        ),
                        onPressed: () async {
                          await pickImage().then((file) {
                            setState(() {
                              pickedImage = file;
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Theme(
                  data: ThemeData(
                    primaryColor: themeData.primaryTextTheme.bodyMedium.color,
                    hintColor: themeData.primaryTextTheme.bodyMedium.color,
                  ),
                  child: TextField(
                    enabled: !isUploading,
                    style: themeData.primaryTextTheme.bodyMedium,
                    controller: nameInputController,
                    decoration: InputDecoration(
                      hintText: texts.breez_avatar_dialog_your_name,
                    ),
                    onSubmitted: (text) {},
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isUploading ? null : () => navigator.pop(),
              child: Text(
                texts.breez_avatar_dialog_action_cancel,
                style: themeData.primaryTextTheme.labelLarge,
              ),
            ),
            TextButton(
              onPressed: isUploading
                  ? null
                  : () async {
                      try {
                        var userName = nameInputController.text;
                        if (pickedImage != null) {
                          setState(() {
                            isUploading = true;
                          });
                          await _uploadImage(pickedImage, userBloc).then((_) {
                            setState(() {
                              isUploading = false;
                            });
                          });
                        }
                        userBloc.userSink.add(currentSettings.copyWith(
                          name: userName,
                        ));
                        navigator.pop();
                      } catch (e) {
                        setState(() {
                          isUploading = false;
                          pickedImage = null;
                        });
                        showFlushbar(
                          context,
                          message: texts.breez_avatar_dialog_error_upload,
                        );
                      }
                    },
              child: Text(
                texts.breez_avatar_dialog_action_save,
                style: themeData.primaryTextTheme.labelLarge,
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12.0),
              top: Radius.circular(13.0),
            ),
          ),
        );
      },
    ),
  );
}

Future _uploadImage(File pickedImage, UserProfileBloc userBloc) async {
  return pickedImage
      .readAsBytes()
      .then(_scaleAndFormatPNG)
      .then((imageBytes) async {
    var action = UploadProfilePicture(imageBytes);
    userBloc.userActionsSink.add(action);
    return action.future;
  });
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
    return DartImage.encodePng(resized);
  } catch (e) {
    rethrow;
  }
}
