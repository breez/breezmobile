import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/backup_in_progress_dialog.dart';
import 'package:breez/routes/security_pin/lock_screen.dart';
import 'package:breez/routes/security_pin/remote_server_auth/remote_server_auth.dart';
import 'package:breez/routes/security_pin/security_and_backup/backup_tiles/backup_provider_tile.dart';
import 'package:breez/routes/security_pin/security_and_backup/backup_tiles/generate_backup_phrase_tile.dart';
import 'package:breez/routes/security_pin/security_and_backup/backup_tiles/remote_server_credentials_tile.dart';
import 'package:breez/routes/security_pin/security_and_backup/security_tiles/change_pin_tile.dart';
import 'package:breez/routes/security_pin/security_and_backup/security_tiles/enable_biometric_auth_tile.dart';
import 'package:breez/routes/security_pin/security_and_backup/security_tiles/enable_pin_tile.dart';
import 'package:breez/routes/security_pin/security_and_backup/security_tiles/pin_interval_tile.dart';
import 'package:breez/routes/security_pin/security_and_backup/widgets/last_backup_text.dart';
import 'package:breez/services/local_auth_service.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SecurityAndBackupPage extends StatefulWidget {
  final UserProfileBloc userProfileBloc;
  final BackupBloc backupBloc;

  const SecurityAndBackupPage(
    this.userProfileBloc,
    this.backupBloc, {
    Key key,
  }) : super(key: key);

  @override
  SecurityAndBackupPageState createState() {
    return SecurityAndBackupPageState();
  }
}

class SecurityAndBackupPageState extends State<SecurityAndBackupPage>
    with WidgetsBindingObserver {
  StreamSubscription<BackupState> _backupInProgressSubscription;
  bool showingBackupDialog = false;
  final _autoSizeGroup = AutoSizeGroup();
  bool _screenLocked = true;
  LocalAuthenticationOption _localAuthenticationOption;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localAuthenticationOption = LocalAuthenticationOption.NONE;
    _getEnrolledBiometrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initListeners();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getEnrolledBiometrics();
    }
  }

  Future _getEnrolledBiometrics() async {
    var getEnrolledBiometricsAction = GetEnrolledBiometrics();
    widget.userProfileBloc.userActionsSink.add(getEnrolledBiometricsAction);
    return getEnrolledBiometricsAction.future.then((enrolledBiometrics) {
      setState(() {
        _localAuthenticationOption = enrolledBiometrics;
      });
    });
  }

  @override
  void dispose() {
    widget.userProfileBloc.userActionsSink.add(StopBiometrics());
    WidgetsBinding.instance.removeObserver(this);
    _backupInProgressSubscription?.cancel();
    super.dispose();
  }

  void _initListeners() {
    /// Subscribing to backups in progress such as here will also block the UI
    /// for other sources of backups outside this page such as
    /// receiving an onchain payment.
    _backupInProgressSubscription = widget.backupBloc.backupStateStream
        .where((s) => s.inProgress)
        .listen((s) async {
      if (mounted) {
        EasyLoading.dismiss();

        if (!showingBackupDialog) {
          setState(() {
            showingBackupDialog = true;
          });
          await showDialog(
            useRootNavigator: false,
            barrierDismissible: false,
            context: context,
            builder: (context) => buildBackupInProgressDialog(
              context,
              widget.backupBloc.backupStateStream,
              barrierDismissible: false,
            ),
          ).then((_) {
            setState(() {
              showingBackupDialog = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return StreamBuilder<BreezUserModel>(
        stream: widget.userProfileBloc.userStream,
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const SizedBox();
          }

          final requiresPin = userSnapshot.data.securityModel.requiresPin;
          if (requiresPin && _screenLocked) {
            return AppLockScreen(_validatePinCode, canCancel: true);
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: const backBtn.BackButton(),
              title: Text(texts.security_and_backup_title),
            ),
            body: StreamBuilder<BackupSettings>(
                stream: widget.backupBloc.backupSettingsStream,
                builder: (context, backupSnapshot) {
                  if (!backupSnapshot.hasData) {
                    return const Center(child: Loader());
                  }

                  final backupSettings = backupSnapshot.data;
                  final isRemoteServer =
                      backupSettings.backupProvider?.isRemoteServer;

                  return ListView(
                    children: [
                      EnablePinTile(
                        userProfileBloc: widget.userProfileBloc,
                        autoSizeGroup: _autoSizeGroup,
                        enablePin: _updateSecurityModel,
                      ),
                      if (requiresPin) ...[
                        const Divider(),
                        PinIntervalTile(
                          userProfileBloc: widget.userProfileBloc,
                          autoSizeGroup: _autoSizeGroup,
                          changePinInterval: _updateSecurityModel,
                        ),
                        const Divider(),
                        ChangePinTile(
                          userProfileBloc: widget.userProfileBloc,
                          autoSizeGroup: _autoSizeGroup,
                          changePin: _updateSecurityModel,
                        ),
                        if (_localAuthenticationOption !=
                            LocalAuthenticationOption.NONE) ...[
                          const Divider(),
                          EnableBiometricAuthTile(
                            userProfileBloc: widget.userProfileBloc,
                            autoSizeGroup: _autoSizeGroup,
                            localAuthenticationOption:
                                _localAuthenticationOption,
                            changeBiometricAuth: _updateSecurityModel,
                          ),
                        ]
                      ],
                      const Divider(),
                      BackupProviderTile(
                        backupSettings: backupSettings,
                        autoSizeGroup: _autoSizeGroup,
                        enterRemoteServerCredentials: () async {
                          await _enterRemoteServerCredentials(backupSettings);
                        },
                        backupNow: _backupNow,
                      ),
                      if (isRemoteServer) ...[
                        const Divider(),
                        RemoteServerCredentialsTile(
                          autoSizeGroup: _autoSizeGroup,
                          enterRemoteServerCredentials: () async {
                            await _enterRemoteServerCredentials(backupSettings);
                          },
                        ),
                      ],
                      const Divider(),
                      GenerateBackupPhraseTile(
                        backupSettings: backupSettings,
                        autoSizeGroup: _autoSizeGroup,
                        backupNow: _backupNow,
                      ),
                    ],
                  );
                }),
            bottomNavigationBar: const Padding(
              padding: EdgeInsets.only(
                bottom: 20.0,
                left: 20.0,
                top: 20.0,
              ),
              child: LastBackupText(),
            ),
          );
        });
  }

  Future _updateSecurityModel(SecurityModel newModel) async {
    _setScreenLocked(false);
    var action = UpdateSecurityModel(newModel);
    widget.userProfileBloc.userActionsSink.add(action);
    return action.future;
  }

  Future<dynamic> _validatePinCode(pinEntered) {
    final validateAction = ValidatePinCode(pinEntered);
    widget.userProfileBloc.userActionsSink.add(validateAction);
    return validateAction.future.then((_) => _setScreenLocked(false));
  }

  void _setScreenLocked(bool value) {
    setState(() {
      _screenLocked = value;
    });
  }

  Future<void> _enterRemoteServerCredentials(
    BackupSettings backupSettings,
  ) async {
    await promptAuthData(
      context,
      backupSettings,
    ).then(
      (auth) async {
        if (auth != null) {
          try {
            EasyLoading.show();

            await _backupNow(
              backupSettings.copyWith(
                backupProvider: BackupSettings.remoteServerBackupProvider(),
                remoteServerAuthData: auth,
              ),
            );
          } catch (e) {
            EasyLoading.dismiss();
          }
        }
      },
    );
  }

  Future _backupNow(BackupSettings backupSettings) async {
    final updateBackupSettings = UpdateBackupSettings(backupSettings);
    final backupAction = BackupNow(updateBackupSettings, recoverEnabled: true);
    widget.backupBloc.backupActionsSink.add(backupAction);
    return backupAction.future;
  }
}
