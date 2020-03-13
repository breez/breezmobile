import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/backup_in_progress_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';

import 'backup_phrase/backup_phrase_confirmation_page.dart';
import 'backup_phrase/backup_phrase_warning_dialog.dart';
import 'change_pin_code.dart';
import 'lock_screen.dart';

class SecurityPage extends StatefulWidget {
  final UserProfileBloc userProfileBloc;
  final BackupBloc backupBloc;

  SecurityPage(this.userProfileBloc, this.backupBloc, {Key key})
      : super(key: key);

  @override
  SecurityPageState createState() {
    return SecurityPageState();
  }
}

class SecurityPageState extends State<SecurityPage>
    with WidgetsBindingObserver {
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  bool _screenLocked = true;
  int _renderIndex = 0;
  String _enrolledBiometrics;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enrolledBiometrics = "";
    _getEnrolledBiometrics();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getEnrolledBiometrics();
    }
  }

  @override
  void dispose() {
    widget.userProfileBloc.userActionsSink.add(StopBiometrics());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _title = "Security & Backup";
    return StreamBuilder<BackupState>(
      stream: widget.backupBloc.backupStateStream,
      builder: (ctx, backupStateSnapshot) => StreamBuilder<BackupSettings>(
        stream: widget.backupBloc.backupSettingsStream,
        builder: (context, backupSnapshot) => StreamBuilder<BreezUserModel>(
            stream: widget.userProfileBloc.userStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                var backupState = backupStateSnapshot.data;
                if (snapshot.data.securityModel.requiresPin &&
                    this._screenLocked) {
                  return AppLockScreen(
                    (pinEntered) {
                      var validateAction = ValidatePinCode(pinEntered);
                      widget.userProfileBloc.userActionsSink
                          .add(validateAction);
                      return validateAction.future.then((_) {
                        setState(() {
                          this._screenLocked = false;
                        });
                      });
                    },
                    canCancel: true,
                  );
                }
                return Scaffold(
                  appBar: AppBar(
                      iconTheme: Theme.of(context).appBarTheme.iconTheme,
                      textTheme: Theme.of(context).appBarTheme.textTheme,
                      backgroundColor: Theme.of(context).canvasColor,
                      automaticallyImplyLeading: false,
                      leading: backBtn.BackButton(),
                      title: Text(
                        _title,
                        style: Theme.of(context).appBarTheme.textTheme.title,
                      ),
                      elevation: 0.0),
                  body: ListView(
                    children: _buildSecurityPINTiles(
                        snapshot.data.securityModel, backupSnapshot.data),
                  ),
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 20.0, top: 20.0),
                    child: backupStateSnapshot.data != null &&
                            backupStateSnapshot.data.lastBackupTime != null
                        ? Text(
                            "Last backup: ${DateUtils.formatYearMonthDayHourMinute(backupState.lastBackupTime)}" +
                                (backupState.lastBackupAccountName
                                            ?.isNotEmpty ==
                                        true
                                    ? "\nAccount: ${backupState.lastBackupAccountName}"
                                    : ""),
                            textAlign: TextAlign.left)
                        : SizedBox(),
                  ),
                );
              }
            }),
      ),
    );
  }

  List<Widget> _buildSecurityPINTiles(
      SecurityModel securityModel, BackupSettings backupSettings) {
    List<Widget> _tiles = <Widget>[
      _buildDisablePINTile(securityModel, backupSettings)
    ];
    if (securityModel.requiresPin) {
      _tiles
        ..add(Divider())
        ..add(_buildPINIntervalTile(securityModel, backupSettings))
        ..add(Divider())
        ..add(_buildChangePINTile(securityModel, backupSettings));
      if (_enrolledBiometrics.isNotEmpty) {
        _tiles
          ..add(Divider())
          ..add(_buildEnableBiometricAuthTile(securityModel, backupSettings));
      }
    }
    _tiles
      ..add(Divider())
      ..add(_buildBackupProviderTitle(securityModel, backupSettings))
      ..add(Divider())
      ..add(_buildGenerateBackupPhraseTile(securityModel, backupSettings));
    return _tiles;
  }

  ListTile _buildGenerateBackupPhraseTile(
      SecurityModel securityModel, BackupSettings backupSettings) {
    return ListTile(
      title: Container(
        child: AutoSizeText(
          "Encrypt Backup Data",
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing: Switch(
        value: backupSettings.backupKeyType == BackupKeyType.PHRASE,
        activeColor: Colors.white,
        onChanged: (bool value) async {
          if (this.mounted) {
            if (value) {
              Navigator.push(
                  context,
                  FadeInRoute(
                      builder: (BuildContext context) =>
                          BackupPhraseGeneratorConfirmationPage()));
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return BackupPhraseWarningDialog();
                  }).then(
                (approved) {
                  if (approved)
                    _updateBackupSettings(backupSettings,
                        backupSettings.copyWith(keyType: BackupKeyType.NONE));
                },
              );
            }
          }
        },
      ),
    );
  }

  ListTile _buildBackupProviderTitle(
      SecurityModel securityModel, BackupSettings backupSettings) {
    return ListTile(
      title: Container(
        child: AutoSizeText(
          "Store Backup Data in",
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<BackupProvider>(
          value: backupSettings.backupProvider,
          isDense: true,
          onChanged: (BackupProvider newValue) {
            _updateBackupSettings(backupSettings,
                backupSettings.copyWith(backupProvider: newValue));
          },
          items: BackupSettings.availableBackupProviders().map((provider) {
            return DropdownMenuItem(
              value: provider,
              child: Container(
                child: AutoSizeText(
                  provider.displayName,
                  style: theme.FieldTextStyle.textStyle,
                  maxLines: 1,
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  ListTile _buildPINIntervalTile(
      SecurityModel securityModel, BackupSettings backupSettings) {
    return ListTile(
      title: Container(
        child: AutoSizeText(
          "Lock Automatically",
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: securityModel.automaticallyLockInterval,
          isDense: true,
          onChanged: (int newValue) {
            _updateSecurityModel(
                securityModel,
                securityModel.copyWith(automaticallyLockInterval: newValue),
                backupSettings);
          },
          items: SecurityModel.lockIntervals.map((int seconds) {
            return DropdownMenuItem(
              value: seconds,
              child: Container(
                child: AutoSizeText(
                  _formatSeconds(seconds),
                  style: theme.FieldTextStyle.textStyle,
                  maxLines: 1,
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _formatSeconds(int seconds) {
    if (seconds == 0) {
      return "Immediate";
    }
    return printDuration(Duration(seconds: seconds));
  }

  ListTile _buildChangePINTile(
      SecurityModel securityModel, BackupSettings backupSettings) {
    return ListTile(
      title: Container(
        child: AutoSizeText(
          "Change PIN",
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () => _onChangePinSelected(securityModel, backupSettings),
    );
  }

  ListTile _buildEnableBiometricAuthTile(
      SecurityModel securityModel, BackupSettings backupSettings) {
    return ListTile(
      title: AutoSizeText(
        "Enable ${_enrolledBiometrics}",
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: securityModel.requiresPin ? _autoSizeGroup : null,
      ),
      trailing: Switch(
        key: Key(_renderIndex.toString()),
        activeColor: Colors.white,
        value: securityModel.isFingerprintEnabled,
        onChanged: (value) {
          if (this.mounted) {
            if (value) {
              _validateBiometrics(securityModel, backupSettings);
            } else {
              _updateSecurityModel(
                  securityModel,
                  securityModel.copyWith(isFingerprintEnabled: false),
                  backupSettings);
            }
          }
        },
      ),
    );
  }

  Future _validateBiometrics(
      SecurityModel securityModel, BackupSettings backupSettings) async {
    var validateBiometricsAction = ValidateBiometrics(
        localizedReason: "Authenticate to enable this setting");
    widget.userProfileBloc.userActionsSink.add(validateBiometricsAction);
    validateBiometricsAction.future.then((isValid) async {
      _updateSecurityModel(
          securityModel,
          securityModel.copyWith(isFingerprintEnabled: isValid),
          backupSettings);
      setState(() => _renderIndex++);
    }, onError: (error) => showFlushbar(context, message: error));
  }

  ListTile _buildDisablePINTile(
      SecurityModel securityModel, BackupSettings backupSettings) {
    return ListTile(
      title: AutoSizeText(
        securityModel.requiresPin ? "Activate PIN" : "Create PIN",
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: securityModel.requiresPin ? _autoSizeGroup : null,
      ),
      trailing: securityModel.requiresPin
          ? Switch(
              value: securityModel.requiresPin,
              activeColor: Colors.white,
              onChanged: (bool value) {
                if (this.mounted) {
                  _resetSecurityModel();
                }
              },
            )
          : Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: securityModel.requiresPin
          ? null
          : () => _onChangePinSelected(securityModel, backupSettings),
    );
  }

  void _onChangePinSelected(
      SecurityModel securityModel, BackupSettings backupSettings) {
    Navigator.of(context).push(
      FadeInRoute(
        builder: (BuildContext context) {
          return ChangePinCode();
        },
      ),
    ).then((newPIN) async {
      if (newPIN != null) {
        var updatePinAction = UpdatePinCode(newPIN);
        widget.userProfileBloc.userActionsSink.add(updatePinAction);
        updatePinAction.future
            .then((_) => _updateSecurityModel(securityModel,
                securityModel.copyWith(requiresPin: true), backupSettings,
                pinCodeChanged: true))
            .catchError((err) {
          promptError(
              context,
              "Internal Error",
              Text(
                err.toString(),
                style: Theme.of(context).dialogTheme.contentTextStyle,
              ));
        });
      }
    });
  }

  Future _getEnrolledBiometrics() async {
    var getEnrolledBiometricsAction = GetEnrolledBiometrics();
    widget.userProfileBloc.userActionsSink.add(getEnrolledBiometricsAction);
    return getEnrolledBiometricsAction.future.then((enrolledBiometrics) {
      setState(() {
        _enrolledBiometrics = enrolledBiometrics;
      });
    });
  }

  Future _resetSecurityModel() async {
    var action = ResetSecurityModel();
    widget.userProfileBloc.userActionsSink.add(action);
    action.future.catchError((err) {
      promptError(
          context,
          "Internal Error",
          Text(
            err.toString(),
            style: Theme.of(context).dialogTheme.contentTextStyle,
          ));
    });
  }

  Future _updateSecurityModel(SecurityModel oldModel, SecurityModel newModel,
      BackupSettings backupSettings,
      {bool pinCodeChanged = false}) async {
    _screenLocked = false;
    var action = UpdateSecurityModel(newModel);
    widget.userProfileBloc.userActionsSink.add(action);
    action.future.then((_) {
      //(newModel.backupKeyType != oldModel.backupKeyType) ||
      if ((backupSettings.backupKeyType == BackupKeyType.PIN &&
          pinCodeChanged)) {
        triggerBackup();
      }
    }).catchError((err) {
      promptError(
          context,
          "Internal Error",
          Text(
            err.toString(),
            style: Theme.of(context).dialogTheme.contentTextStyle,
          ));
    });
  }

  Future _updateBackupSettings(
      BackupSettings oldBackupSettings, BackupSettings newBackupSettings,
      {bool pinCodeChanged = false}) async {
    _screenLocked = false;
    var action = UpdateBackupSettings(newBackupSettings);
    widget.backupBloc.backupActionsSink.add(action);
    action.future.then((_) {
      //(newModel.backupKeyType != oldModel.backupKeyType) ||
      if ((oldBackupSettings.backupKeyType != newBackupSettings.backupKeyType ||
          oldBackupSettings.backupProvider !=
              newBackupSettings.backupProvider)) {
        triggerBackup();
      }
    }).catchError((err) {
      promptError(
          context,
          "Internal Error",
          Text(
            err.toString(),
            style: Theme.of(context).dialogTheme.contentTextStyle,
          ));
    });
  }

  void triggerBackup() {
    widget.backupBloc.backupNowSink.add(true);
    widget.backupBloc.backupStateStream
        .firstWhere((s) => s.inProgress)
        .then((s) {
      if (mounted) {
        showDialog(
            useRootNavigator: false,
            barrierDismissible: false,
            context: context,
            builder: (ctx) => buildBackupInProgressDialog(
                ctx, widget.backupBloc.backupStateStream));
      }
    });
  }
}
