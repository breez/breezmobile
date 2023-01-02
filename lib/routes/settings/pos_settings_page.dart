import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clovrlabs_wallet/bloc/backup/backup_bloc.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/actions.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/bloc.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_actions.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/routes/settings/set_admin_password.dart';
import 'package:clovrlabs_wallet/utils/min_font_size.dart';
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/error_dialog.dart';
import 'package:clovrlabs_wallet/widgets/flushbar.dart';
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:clovrlabs_wallet/widgets/route.dart';
import 'package:clovrlabs_wallet/widgets/static_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as path;
import 'package:share_extend/share_extend.dart';

class PosSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    return StreamBuilder<ClovrUserModel>(
      stream: _userProfileBloc.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _PosSettingsPage(_userProfileBloc, snapshot.data);
        }
        return StaticLoader();
      },
    );
  }
}

class _PosSettingsPage extends StatefulWidget {
  final UserProfileBloc _userProfileBloc;
  final ClovrUserModel currentProfile;

  const _PosSettingsPage(
    this._userProfileBloc,
    this.currentProfile,
  );

  @override
  State<StatefulWidget> createState() {
    return PosSettingsPageState();
  }
}

class PosSettingsPageState extends State<_PosSettingsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _cancellationTimeoutController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _defaultNoteController = TextEditingController();
  final _autoSizeGroup = AutoSizeGroup();
  double _timeoutValue;

  @override
  void initState() {
    super.initState();
    final user = widget.currentProfile;
    _timeoutValue = user.cancellationTimeoutValue;
    _cancellationTimeoutController.text = "${user.cancellationTimeoutValue.toStringAsFixed(0)}";
    _addressLine1Controller.text = user.businessAddress?.addressLine1 ?? "";
    _addressLine2Controller.text = user.businessAddress?.addressLine2 ?? "";
    _defaultNoteController.text = user.defaultPosNote;
  }

  @override
  Widget build(BuildContext context) {
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: backBtn.BackButton(),
        automaticallyImplyLeading: false,
        iconTheme: themeData.appBarTheme.iconTheme,
        backgroundColor: themeData.canvasColor,
        title: Text(
          texts.pos_settings_title,
          // style: themeData.appBarTheme.textTheme.headline6,
        ),
        // elevation: 0.0, toolbarTextStyle: themeData.appBarTheme.textTheme.bodyText2,
        // titleTextStyle: themeData.appBarTheme.textTheme.headline6,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: StreamBuilder<ClovrUserModel>(
          stream: userProfileBloc.userStream,
          builder: (context, snapshot) {
            var user = snapshot.data;
            if (user == null) {
              return Loader();
            }
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 32.0,
                      bottom: 19.0,
                      left: 16.0,
                    ),
                    child: Text(
                      texts.pos_settings_cancellation_timeout,
                      style: TextStyle(
                        fontSize: 12.4,
                        letterSpacing: 0.11,
                        height: 1.24,
                        color: Color.fromRGBO(255, 255, 255, 0.87),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 304.0,
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: _cancellationSlider(context),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 16.0),
                        child: Text(
                          num.parse(_cancellationTimeoutController.text)
                              .toStringAsFixed(0),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.4,
                            letterSpacing: 0.11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ..._buildAdminPasswordTiles(context, userProfileBloc, user),
                  Divider(),
                  _buildExportItemsTile(context, posCatalogBloc),
                  Divider(),
                  _buildAddressField(context, userProfileBloc, user),
                  Divider(),
                  _buildDefaultNote(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _cancellationSlider(BuildContext context) {
    return Slider(
      value: _timeoutValue,
      label: _timeoutValue.toStringAsFixed(0),
      min: 30.0,
      max: 180.0,
      divisions: 5,
      onChanged: (double value) {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _timeoutValue = value;
          _cancellationTimeoutController.text = value.toStringAsFixed(0);
        });
      },
      onChangeEnd: (double value) {
        widget._userProfileBloc.userSink.add(
          widget.currentProfile.copyWith(cancellationTimeoutValue: value),
        );
      },
    );
  }

  List<Widget> _buildAdminPasswordTiles(
    BuildContext context,
    UserProfileBloc userProfileBloc,
    ClovrUserModel user,
  ) {
    var widgets = [
      Divider(),
      _buildEnablePasswordTile(context, userProfileBloc, user),
    ];
    if (user.hasAdminPassword) {
      widgets
        ..add(Divider())
        ..add(_buildSetPasswordTile(context));
    }
    return widgets;
  }

  Widget _buildExportItemsTile(
    BuildContext context,
    PosCatalogBloc posCatalogBloc,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    return ListTile(
      title: Container(
        child: AutoSizeText(
          texts.pos_settings_items_list,
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: PopupMenuButton(
          color: themeData.backgroundColor,
          icon: Icon(
            Icons.more_horiz,
            color: themeData.iconTheme.color,
          ),
          padding: EdgeInsets.zero,
          offset: Offset(12, 36),
          onSelected: _select,
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 36,
              value: Choice(() => _importItems(context, posCatalogBloc)),
              child: Text(
                texts.pos_settings_import_csv,
                style: themeData.textTheme.button,
              ),
            ),
            PopupMenuItem(
              height: 36,
              value: Choice(() => _exportItems(context, posCatalogBloc)),
              child: Text(
                texts.pos_settings_export_csv,
                style: themeData.textTheme.button,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _select(Choice choice) {
    choice.function();
  }

  Future _importItems(
    BuildContext context,
    PosCatalogBloc posCatalogBloc,
  ) async {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final navigator = Navigator.of(context);

    return promptAreYouSure(
      context,
      texts.pos_settings_import_dialog_title,
      Text(
        texts.pos_settings_import_dialog_message,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
      cancelText: texts.pos_settings_import_action_no,
      okText: texts.pos_settings_import_action_yes,
    ).then((acknowledged) async {
      if (acknowledged) {
        await FilePicker.platform.clearTemporaryFiles();
        FilePickerResult result = await FilePicker.platform.pickFiles();
        if (result == null) {
          return;
        }
        File importFile = File(result.files.single.path);
        String fileExtension = path.extension(importFile.path);
        if (fileExtension == ".csv") {
          var action = ImportItems(importFile);
          posCatalogBloc.actionsSink.add(action);
          var loaderRoute = createLoaderRoute(context);
          navigator.push(loaderRoute);
          action.future.then((_) {
            navigator.removeRoute(loaderRoute);
            navigator.pop();
            showFlushbar(
              context,
              message: texts.pos_settings_import_success_message,
            );
          }).catchError((err) {
            navigator.removeRoute(loaderRoute);
            String errorMessage;
            if (err == PosCatalogBloc.InvalidFile) {
              errorMessage = texts.pos_settings_import_error_invalid_file;
            } else if (err == PosCatalogBloc.InvalidData) {
              errorMessage = texts.pos_settings_import_error_invalid_data;
            } else {
              errorMessage = texts.pos_settings_import_error_generic;
            }
            showFlushbar(context, message: errorMessage);
          });
        } else {
          showFlushbar(
            context,
            message: texts.pos_settings_import_select_message,
          );
        }
      }
    });
  }

  Future _exportItems(
    BuildContext context,
    PosCatalogBloc posCatalogBloc,
  ) async {
    final texts = AppLocalizations.of(context);
    final navigator = Navigator.of(context);

    var action = ExportItems();
    posCatalogBloc.actionsSink.add(action);
    navigator.push(createLoaderRoute(context));
    action.future.then((filePath) {
      navigator.pop();
      ShareExtend.share(filePath, "file");
    }).catchError((err) {
      navigator.pop();
      final errorMessage = err.toString() == "EMPTY_LIST"
          ? texts.pos_settings_export_error_no_items
          : texts.pos_settings_export_error_generic;
      showFlushbar(context, message: errorMessage);
    });
  }

  ListTile _buildSetPasswordTile(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return ListTile(
      title: Container(
        child: AutoSizeText(
          texts.pos_settings_change_manager_password,
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Colors.white,
        size: 30.0,
      ),
      onTap: () => _onChangeAdminPasswordSelected(context),
    );
  }

  ListTile _buildEnablePasswordTile(
    BuildContext context,
    UserProfileBloc userProfileBloc,
    ClovrUserModel user,
  ) {
    final texts = AppLocalizations.of(context);
    return ListTile(
      title: AutoSizeText(
        user.hasAdminPassword
            ? texts.pos_settings_activate_manager_password
            : texts.pos_settings_create_manager_password,
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: user.hasAdminPassword ? _autoSizeGroup : null,
      ),
      trailing: user.hasAdminPassword
          ? Switch(
              value: user.hasAdminPassword,
              activeColor: Colors.white,
              onChanged: (bool value) {
                if (this.mounted) {
                  _resetAdminPassword(userProfileBloc);
                }
              },
            )
          : Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 30.0,
              ),
            ),
      onTap: user.hasAdminPassword
          ? null
          : () => _onChangeAdminPasswordSelected(
                context,
                isNew: !user.hasAdminPassword,
              ),
    );
  }

  _onChangeAdminPasswordSelected(
    BuildContext context, {
    bool isNew = false,
  }) async {
    final texts = AppLocalizations.of(context);
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final backupState = await backupBloc.backupStateStream.first
        .onError((error, stackTrace) => null);

    if (backupState?.lastBackupTime == null) {
      await promptError(
        context,
        texts.pos_settings_manager_password_error_title,
        Text(
          texts.pos_settings_manager_password_error_message,
        ),
      );
      return;
    }

    bool confirmed = true;
    if (isNew) {
      confirmed = await promptAreYouSure(
        context,
        texts.pos_settings_manager_password_title,
        Text(
          texts.pos_settings_manager_password_message,
        ),
      );
    }
    if (confirmed) {
      Navigator.of(context).push(FadeInRoute(
        builder: (_) => SetAdminPasswordPage(
          submitAction: isNew
              ? texts.pos_settings_manager_password_action_create
              : texts.pos_settings_manager_password_action_change,
        ),
      ));
    }
  }

  _resetAdminPassword(UserProfileBloc userProfileBloc) {
    SetAdminPassword action = SetAdminPassword(null);
    userProfileBloc.userActionsSink.add(action);
  }

  Widget _buildAddressField(
    BuildContext context,
    UserProfileBloc userProfileBloc,
    ClovrUserModel user,
  ) {
    final texts = AppLocalizations.of(context);
    final currentProfile = widget.currentProfile;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts.pos_settings_business_address,
          ),
          TextField(
            controller: _addressLine1Controller,
            minLines: 1,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: texts.pos_settings_address_line_1,
            ),
            onEditingComplete: () {
              widget._userProfileBloc.userSink.add(
                currentProfile.copyWith(
                  businessAddress: currentProfile.businessAddress.copyWith(
                    addressLine1: _addressLine1Controller.text,
                  ),
                ),
              );
              FocusScope.of(context).nextFocus();
            },
          ),
          TextField(
            controller: _addressLine2Controller,
            minLines: 1,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: texts.pos_settings_address_line_2,
            ),
            onEditingComplete: () {
              widget._userProfileBloc.userSink.add(
                currentProfile.copyWith(
                  businessAddress: currentProfile.businessAddress.copyWith(
                    addressLine2: _addressLine2Controller.text,
                  ),
                ),
              );
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultNote(
    BuildContext context,
  ) {
    final texts = AppLocalizations.of(context);
    final currentProfile = widget.currentProfile;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts.pos_settings_default_note,
          ),
          TextField(
            controller: _defaultNoteController,
            minLines: 1,
            maxLines: 1,
            onChanged: (_) => widget._userProfileBloc.userSink.add(
              currentProfile.copyWith(
                defaultPosNote: _defaultNoteController.text,
              ),
            ),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
        ],
      ),
    );
  }
}

class Choice {
  final Function function;

  const Choice(
    this.function,
  );
}
