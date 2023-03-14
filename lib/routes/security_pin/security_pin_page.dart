import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/backup_in_progress_dialog.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/security_pin/backup_phrase/backup_phrase_confirmation_page.dart';
import 'package:breez/routes/security_pin/backup_phrase/backup_phrase_warning_dialog.dart';
import 'package:breez/routes/security_pin/change_pin_code.dart';
import 'package:breez/routes/security_pin/lock_screen.dart';
import 'package:breez/routes/security_pin/remote_server_auth.dart';
import 'package:breez/services/local_auth_service.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/designsystem/switch/simple_switch.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  final UserProfileBloc userProfileBloc;
  final BackupBloc backupBloc;

  const SecurityPage(
    this.userProfileBloc,
    this.backupBloc, {
    Key key,
  }) : super(key: key);

  @override
  SecurityPageState createState() {
    return SecurityPageState();
  }
}

class SecurityPageState extends State<SecurityPage>
    with WidgetsBindingObserver {
  final _autoSizeGroup = AutoSizeGroup();
  bool _screenLocked = true;
  int _renderIndex = 0;
  LocalAuthenticationOption _localAuthenticationOption;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localAuthenticationOption = LocalAuthenticationOption.NONE;
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
    final texts = context.texts();

    return StreamBuilder<BackupState>(
      stream: widget.backupBloc.backupStateStream,
      builder: (ctx, backupStateSnapshot) => StreamBuilder<BackupSettings>(
        stream: widget.backupBloc.backupSettingsStream,
        builder: (context, backupSnapshot) => StreamBuilder<BreezUserModel>(
          stream: widget.userProfileBloc.userStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            final backupState = backupStateSnapshot.data;
            final userModel = snapshot.data;

            if (userModel.securityModel.requiresPin && _screenLocked) {
              return AppLockScreen(
                (pinEntered) {
                  final validateAction = ValidatePinCode(pinEntered);
                  widget.userProfileBloc.userActionsSink.add(validateAction);
                  return validateAction.future.then((_) {
                    setState(() {
                      _screenLocked = false;
                    });
                  });
                },
                canCancel: true,
              );
            }

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: const backBtn.BackButton(),
                title: Text(texts.security_and_backup_title),
              ),
              body: ListView(
                children: _buildSecurityPINTiles(
                  context,
                  userModel.securityModel,
                  backupSnapshot.data,
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  left: 20.0,
                  top: 20.0,
                ),
                child: _lastBackup(context, backupState),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _lastBackup(BuildContext context, BackupState backupState) {
    if (backupState == null) return const SizedBox();
    final lastBackupTime = backupState.lastBackupTime;
    if (lastBackupTime == null) return const SizedBox();

    final texts = context.texts();
    final accountName = backupState.lastBackupAccountName;
    final lastBackup = BreezDateUtils.formatYearMonthDayHourMinute(
      lastBackupTime,
    );

    return Text(
      accountName == null || accountName.isEmpty
          ? texts.security_and_backup_last_backup_no_account(lastBackup)
          : texts.security_and_backup_last_backup_with_account(
              lastBackup,
              accountName,
            ),
      textAlign: TextAlign.left,
    );
  }

  List<Widget> _buildSecurityPINTiles(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    List<Widget> tiles = [
      _buildDisablePINTile(
        context,
        securityModel,
        backupSettings,
      ),
    ];
    if (securityModel.requiresPin) {
      tiles
        ..add(const Divider())
        ..add(_buildPINIntervalTile(
          context,
          securityModel,
          backupSettings,
        ))
        ..add(const Divider())
        ..add(_buildChangePINTile(
          context,
          securityModel,
          backupSettings,
        ));
      if (_localAuthenticationOption != LocalAuthenticationOption.NONE) {
        tiles
          ..add(const Divider())
          ..add(_buildEnableBiometricAuthTile(
            context,
            securityModel,
            backupSettings,
          ));
      }
    }
    tiles
      ..add(const Divider())
      ..add(_buildBackupProviderTitle(
        context,
        securityModel,
        backupSettings,
      ));
    if (backupSettings.backupProvider?.name ==
        BackupSettings.remoteServerBackupProvider().name) {
      tiles
        ..add(const Divider())
        ..add(_buildRemoteServerAuthDataTile(
          context,
          securityModel,
          backupSettings,
        ));
    }
    tiles
      ..add(const Divider())
      ..add(_buildGenerateBackupPhraseTile(
        context,
        securityModel,
        backupSettings,
      ));
    return tiles;
  }

  Widget _buildGenerateBackupPhraseTile(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    final texts = context.texts();

    return SimpleSwitch(
      text: texts.security_and_backup_encrypt,
      switchValue: backupSettings.backupKeyType == BackupKeyType.PHRASE,
      group: _autoSizeGroup,
      onChanged: (bool value) async {
        if (mounted) {
          if (value) {
            Navigator.push(
              context,
              FadeInRoute(
                builder: (BuildContext context) => withBreezTheme(
                  context,
                  BackupPhraseGeneratorConfirmationPage(),
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return BackupPhraseWarningDialog();
              },
            ).then(
              (approved) {
                if (approved) {
                  _updateBackupSettings(
                    context,
                    backupSettings,
                    backupSettings.copyWith(
                      keyType: BackupKeyType.NONE,
                    ),
                  ).then((value) => triggerBackup());
                }
              },
            );
          }
        }
      },
    );
  }

  ListTile _buildBackupProviderTitle(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    final texts = context.texts();

    return ListTile(
      title: AutoSizeText(
        texts.security_and_backup_store_location,
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: _autoSizeGroup,
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<BackupProvider>(
          iconEnabledColor: Colors.white,
          value: backupSettings.backupProvider,
          isDense: true,
          onChanged: (BackupProvider newValue) {
            if (newValue.name ==
                BackupSettings.remoteServerBackupProvider().name) {
              promptAuthData(context).then((auth) {
                if (auth == null) {
                  return;
                }
                _updateBackupSettings(
                  context,
                  backupSettings,
                  backupSettings.copyWith(
                    backupProvider: newValue,
                    remoteServerAuthData: auth,
                  ),
                ).then((value) => triggerBackup());
              });
              return;
            }
            _updateBackupSettings(
              context,
              backupSettings,
              backupSettings.copyWith(
                backupProvider: newValue,
              ),
            ).then((value) => triggerBackup());
          },
          items: BackupSettings.availableBackupProviders().map((provider) {
            return DropdownMenuItem(
              value: provider,
              child: AutoSizeText(
                provider.displayName,
                style: theme.FieldTextStyle.textStyle,
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  ListTile _buildPINIntervalTile(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    final texts = context.texts();

    return ListTile(
      title: AutoSizeText(
        texts.security_and_backup_lock_automatically,
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: _autoSizeGroup,
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          iconEnabledColor: Colors.white,
          value: securityModel.automaticallyLockInterval,
          isDense: true,
          onChanged: (int newValue) {
            _updateSecurityModel(
              context,
              securityModel,
              securityModel.copyWith(
                automaticallyLockInterval: newValue,
              ),
              backupSettings,
            );
          },
          items: SecurityModel.lockIntervals.map((int seconds) {
            return DropdownMenuItem(
              value: seconds,
              child: AutoSizeText(
                _formatSeconds(texts, seconds),
                style: theme.FieldTextStyle.textStyle,
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _formatSeconds(BreezTranslations texts, int seconds) {
    if (seconds == 0) {
      return texts.security_and_backup_lock_automatically_option_immediate;
    }
    const enLocale = EnglishDurationLocale();
    final locales = {
      "de": const GermanDurationLocale(),
      "en": enLocale,
      "es": const SpanishDurationLanguage(),
      "fi": const FinnishDurationLocale(),
      "fr": const FrenchDurationLocale(),
      "it": const ItalianDurationLocale(),
      "pt": const PortugueseBRDurationLanguage(),
      "sv": const SwedishDurationLanguage(),
    };
    return printDuration(
      Duration(seconds: seconds),
      locale: locales[texts.locale] ?? enLocale,
    );
  }

  ListTile _buildRemoteServerAuthDataTile(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    return ListTile(
      title: AutoSizeText(
        BackupSettings.remoteServerBackupProvider().displayName,
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: _autoSizeGroup,
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        color: Colors.white,
        size: 30.0,
      ),
      onTap: () {
        promptAuthData(context).then((auth) {
          if (auth != null) {
            _updateBackupSettings(
              context,
              backupSettings,
              backupSettings.copyWith(
                remoteServerAuthData: auth,
              ),
            ).then((value) => triggerBackup());
          }
        });
      },
    );
  }

  ListTile _buildChangePINTile(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    final texts = context.texts();

    return ListTile(
      title: AutoSizeText(
        texts.security_and_backup_change_pin,
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: _autoSizeGroup,
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        color: Colors.white,
        size: 30.0,
      ),
      onTap: () => _onChangePinSelected(
        context,
        securityModel,
        backupSettings,
      ),
    );
  }

  Widget _buildEnableBiometricAuthTile(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    final texts = context.texts();

    return SimpleSwitch(
      text: _localAuthenticationOptionLabel(texts),
      switchValue: securityModel.isFingerprintEnabled,
      group: securityModel.requiresPin ? _autoSizeGroup : null,
      onChanged: (value) {
        if (mounted) {
          if (value) {
            _validateBiometrics(
              context,
              securityModel,
              backupSettings,
            );
          } else {
            _updateSecurityModel(
              context,
              securityModel,
              securityModel.copyWith(isFingerprintEnabled: false),
              backupSettings,
            );
          }
        }
      },
    );
  }

  Future _validateBiometrics(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) async {
    final texts = context.texts();

    final validateBiometricsAction = ValidateBiometrics(
      localizedReason: texts.security_and_backup_validate_biometrics_reason,
    );
    widget.userProfileBloc.userActionsSink.add(validateBiometricsAction);
    validateBiometricsAction.future.then(
      (isValid) async {
        _updateSecurityModel(
          context,
          securityModel,
          securityModel.copyWith(isFingerprintEnabled: isValid),
          backupSettings,
        );
        setState(() => _renderIndex++);
      },
      onError: (error) => showFlushbar(context, message: error),
    );
  }

  Widget _buildDisablePINTile(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    final texts = context.texts();

    return SimpleSwitch(
      text: securityModel.requiresPin
          ? texts.security_and_backup_pin_option_deactivate
          : texts.security_and_backup_pin_option_create,
      trailing: securityModel.requiresPin
          ? null
          : const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 30.0,
            ),
      switchValue: securityModel.requiresPin,
      group: securityModel.requiresPin ? _autoSizeGroup : null,
      onTap: securityModel.requiresPin
          ? null
          : () => _onChangePinSelected(
                context,
                securityModel,
                backupSettings,
              ),
      onChanged: (bool value) {
        if (mounted) {
          _resetSecurityModel(context);
        }
      },
    );
  }

  void _onChangePinSelected(
    BuildContext context,
    SecurityModel securityModel,
    BackupSettings backupSettings,
  ) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    Navigator.of(context).push(
      FadeInRoute(
        builder: (BuildContext context) {
          return withBreezTheme(
            context,
            const ChangePinCode(),
          );
        },
      ),
    ).then((newPIN) async {
      if (newPIN != null) {
        var updatePinAction = UpdatePinCode(newPIN);
        widget.userProfileBloc.userActionsSink.add(updatePinAction);
        updatePinAction.future
            .then((_) => _updateSecurityModel(
                  context,
                  securityModel,
                  securityModel.copyWith(requiresPin: true),
                  backupSettings,
                  pinCodeChanged: true,
                ))
            .catchError(
              (err) => promptError(
                context,
                texts.security_and_backup_internal_error,
                Text(
                  err.toString(),
                  style: themeData.dialogTheme.contentTextStyle,
                ),
              ),
            );
      }
    });
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

  Future _resetSecurityModel(BuildContext context) async {
    final texts = context.texts();
    final themeData = Theme.of(context);

    var action = ResetSecurityModel();
    widget.userProfileBloc.userActionsSink.add(action);
    action.future.catchError((err) {
      promptError(
        context,
        texts.security_and_backup_internal_error,
        Text(
          err.toString(),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  Future _updateSecurityModel(
    BuildContext context,
    SecurityModel oldModel,
    SecurityModel newModel,
    BackupSettings backupSettings, {
    bool pinCodeChanged = false,
  }) async {
    final texts = context.texts();
    final themeData = Theme.of(context);

    _screenLocked = false;
    var action = UpdateSecurityModel(newModel);
    widget.userProfileBloc.userActionsSink.add(action);
    return action.future.catchError((err) {
      promptError(
        context,
        texts.security_and_backup_internal_error,
        Text(
          err.toString(),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  Future _updateBackupSettings(
    BuildContext context,
    BackupSettings oldBackupSettings,
    BackupSettings newBackupSettings,
  ) async {
    final texts = context.texts();
    final themeData = Theme.of(context);

    _screenLocked = false;
    var action = UpdateBackupSettings(newBackupSettings);
    widget.backupBloc.backupActionsSink.add(action);
    return action.future.catchError((err) {
      promptError(
        context,
        texts.security_and_backup_internal_error,
        Text(
          err.toString(),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
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
            ctx,
            widget.backupBloc.backupStateStream,
          ),
        );
      }
    });
  }

  String _localAuthenticationOptionLabel(BreezTranslations texts) {
    switch (_localAuthenticationOption) {
      case LocalAuthenticationOption.FACE:
        return texts.security_and_backup_enable_biometric_option_face;
      case LocalAuthenticationOption.FACE_ID:
        return texts.security_and_backup_enable_biometric_option_face_id;
      case LocalAuthenticationOption.FINGERPRINT:
        return texts.security_and_backup_enable_biometric_option_fingerprint;
      case LocalAuthenticationOption.TOUCH_ID:
        return texts.security_and_backup_enable_biometric_option_touch_id;
      case LocalAuthenticationOption.NONE:
      default:
        return texts.security_and_backup_enable_biometric_option_none;
    }
  }
}
