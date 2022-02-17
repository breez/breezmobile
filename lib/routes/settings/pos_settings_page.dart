import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/settings/set_admin_password.dart';
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:share_extend/share_extend.dart';

class PosSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    return StreamBuilder<BreezUserModel>(
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
  final BreezUserModel currentProfile;

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
  final _cancellationTimeoutValueController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _autoSizeGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    _cancellationTimeoutValueController.text =
        widget.currentProfile.cancellationTimeoutValue.toString();
    _addressLine1Controller.text =
        widget.currentProfile.businessAddress?.addressLine1;
    _addressLine2Controller.text =
        widget.currentProfile.businessAddress?.addressLine2;
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    ThemeData theme = context.theme;
    AppBarTheme appBarTheme = theme.appBarTheme;
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: backBtn.BackButton(),
        automaticallyImplyLeading: false,
        iconTheme: appBarTheme.iconTheme,
        toolbarTextStyle: appBarTheme.toolbarTextStyle,
        titleTextStyle: appBarTheme.titleTextStyle,
        backgroundColor: theme.canvasColor,
        title: Text(l10n.pos_settings_title),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: StreamBuilder<BreezUserModel>(
            stream: userProfileBloc.userStream,
            builder: (context, snapshot) {
              var user = snapshot.data;
              if (user == null) {
                return Loader();
              }
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.focusScope.requestFocus(FocusNode());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                      EdgeInsets.only(top: 32.0, bottom: 19.0, left: 16.0),
                      child: Text(
                        l10n.pos_settings_cancellation_timeout,
                        style: TextStyle(
                            fontSize: 12.4,
                            letterSpacing: 0.11,
                            height: 1.24,
                            color: Color.fromRGBO(255, 255, 255, 0.87)),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 304.0,
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: _cancellationSlider(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 16.0),
                            child: Text(
                              num.parse(
                                      _cancellationTimeoutValueController.text)
                                  .toStringAsFixed(0),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.4,
                                  letterSpacing: 0.11),
                            ),
                          )
                        ]),
                    ..._buildAdminPasswordTiles(userProfileBloc, user),
                    Divider(),
                    _buildExportItemsTile(posCatalogBloc),
                    Divider(),
                    _buildAddressField(userProfileBloc, user)
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _cancellationSlider() {
    final timeoutValue = widget.currentProfile.cancellationTimeoutValue;
    return Slider(
      value: timeoutValue,
      label: timeoutValue.toStringAsFixed(0),
      min: 30.0,
      max: 180.0,
      divisions: 5,
      onChanged: (double value) {
        context.focusScope.requestFocus(FocusNode());
        _cancellationTimeoutValueController.text = value.toString();
        widget._userProfileBloc.userSink.add(
          widget.currentProfile.copyWith(cancellationTimeoutValue: value),
        );
      },
    );
  }

  List<Widget> _buildAdminPasswordTiles(
    UserProfileBloc userProfileBloc,
    BreezUserModel user,
  ) {
    var widgets = [
      Divider(),
      _buildEnablePasswordTile(userProfileBloc, user),
    ];
    if (user.hasAdminPassword) {
      widgets
        ..add(Divider())
        ..add(_buildSetPasswordTile());
    }
    return widgets;
  }

  Widget _buildExportItemsTile(PosCatalogBloc posCatalogBloc) {
    var l10n = context.l10n;
    TextTheme textTheme = context.textTheme;

    return ListTile(
      title: Container(
        child: AutoSizeText(
          l10n.pos_settings_items_list,
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: context.minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: PopupMenuButton(
          color: context.backgroundColor,
          icon: Icon(
            Icons.more_horiz,
            color: context.theme.iconTheme.color,
          ),
          padding: EdgeInsets.zero,
          offset: Offset(12, 36),
          onSelected: _select,
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 36,
              value: Choice(() => _importItems(context, posCatalogBloc)),
              child:
                  Text(l10n.pos_settings_import_csv, style: textTheme.button),
            ),
            PopupMenuItem(
              height: 36,
              value: Choice(() => _exportItems(context, posCatalogBloc)),
              child:
                  Text(l10n.pos_settings_export_csv, style: textTheme.button),
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
    var l10n = context.l10n;

    return promptAreYouSure(
            context,
            l10n.pos_settings_import_dialog_title,
            Text(l10n.pos_settings_import_dialog_message,
                style: context.dialogTheme.contentTextStyle),
            contentPadding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
            cancelText: l10n.pos_settings_import_action_no,
            okText: l10n.pos_settings_import_action_yes)
        .then((acknowledged) async {
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
          context.push(loaderRoute);
          action.future.then((_) {
            context.navigator.removeRoute(loaderRoute);
            context.pop();
            showFlushbar(context,
                message: l10n.pos_settings_import_success_message);
          }).catchError((err) {
            context.navigator.removeRoute(loaderRoute);
            String errorMessage;
            if (err == PosCatalogBloc.InvalidFile) {
              errorMessage = l10n.pos_settings_import_error_invalid_file;
            } else if (err == PosCatalogBloc.InvalidData) {
              errorMessage = l10n.pos_settings_import_error_invalid_data;
            } else {
              errorMessage = l10n.pos_settings_import_error_generic;
            }
            showFlushbar(context, message: errorMessage);
          });
        } else {
          showFlushbar(
            context,
            message: l10n.pos_settings_import_select_message,
          );
        }
      }
    });
  }

  Future _exportItems(
    BuildContext context,
    PosCatalogBloc posCatalogBloc,
  ) async {
    var l10n = context.l10n;

    var action = ExportItems();
    posCatalogBloc.actionsSink.add(action);
    context.push(createLoaderRoute(context));
    action.future.then((filePath) {
      context.pop();
      ShareExtend.share(filePath, "file");
    }).catchError((err) {
      context.pop();
      final errorMessage = err.toString() == "EMPTY_LIST"
          ? l10n.pos_settings_export_error_no_items
          : l10n.pos_settings_export_error_generic;
      showFlushbar(context, message: errorMessage);
    });
  }

  ListTile _buildSetPasswordTile() {
    var l10n = context.l10n;

    return ListTile(
      title: Container(
        child: AutoSizeText(
          l10n.pos_settings_change_manager_password,
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: context.minFontSize,
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
    UserProfileBloc userProfileBloc,
    BreezUserModel user,
  ) {
    var l10n = context.l10n;

    return ListTile(
      title: AutoSizeText(
        user.hasAdminPassword
            ? l10n.pos_settings_activate_manager_password
            : l10n.pos_settings_create_manager_password,
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: context.minFontSize,
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
    var l10n = context.l10n;
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final backupState = await backupBloc.backupStateStream.first;

    if (backupState.lastBackupTime == null) {
      await promptError(
        context,
        l10n.pos_settings_manager_password_error_title,
        Text(
          l10n.pos_settings_manager_password_error_message,
        ),
      );
      return;
    }

    bool confirmed = true;
    if (isNew) {
      confirmed = await promptAreYouSure(
        context,
        l10n.pos_settings_manager_password_title,
        Text(
          l10n.pos_settings_manager_password_message,
        ),
      );
    }
    if (confirmed) {
      context.push(FadeInRoute(
        builder: (_) => SetAdminPasswordPage(
          submitAction: isNew
              ? l10n.pos_settings_manager_password_action_create
              : l10n.pos_settings_manager_password_action_change,
        ),
      ));
    }
  }

  _resetAdminPassword(UserProfileBloc userProfileBloc) {
    SetAdminPassword action = SetAdminPassword(null);
    userProfileBloc.userActionsSink.add(action);
  }

  _buildAddressField(
    UserProfileBloc userProfileBloc,
    BreezUserModel user,
  ) {
    var l10n = context.l10n;
    final currentProfile = widget.currentProfile;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pos_settings_business_address,
          ),
          TextField(
            controller: _addressLine1Controller,
            minLines: 1,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: l10n.pos_settings_address_line_1,
            ),
            onChanged: (_) => widget._userProfileBloc.userSink.add(
              currentProfile.copyWith(
                businessAddress: currentProfile.businessAddress.copyWith(
                  addressLine1: _addressLine1Controller.text,
                ),
              ),
            ),
            onEditingComplete: () => context.focusScope.nextFocus(),
          ),
          TextField(
            controller: _addressLine2Controller,
            minLines: 1,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: l10n.pos_settings_address_line_2,
            ),
            onChanged: (_) => widget._userProfileBloc.userSink.add(
              currentProfile.copyWith(
                businessAddress: currentProfile.businessAddress.copyWith(
                  addressLine2: _addressLine2Controller.text,
                ),
              ),
            ),
            onEditingComplete: () => context.focusScope.unfocus(),
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
