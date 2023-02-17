import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/backup_provider_selection_dialog.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/restore_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:rxdart/rxdart.dart';

import 'beta_warning_dialog.dart';
import 'security_pin/backup_phrase/enter_backup_phrase_page.dart';
import 'security_pin/restore_pin.dart';

class _BackupContext {
  final BackupSettings settings;
  final List<SnapshotInfo> snapshots;

  _BackupContext(
    this.snapshots,
    this.settings,
  );
}

class InitialWalkthroughPage extends StatefulWidget {
  final UserProfileBloc _registrationBloc;
  final BackupBloc _backupBloc;
  final PosCatalogBloc _posCatalogBloc;
  final Sink<bool> _reloadDatabaseSink;

  const InitialWalkthroughPage(
    this._registrationBloc,
    this._backupBloc,
    this._posCatalogBloc,
    this._reloadDatabaseSink,
  );

  @override
  State createState() => InitialWalkthroughPageState();
}

class InitialWalkthroughPageState extends State<InitialWalkthroughPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _animation;

  StreamSubscription<bool> _restoreFinishedSubscription;
  StreamSubscription<List<SnapshotInfo>> _multipleRestoreSubscription;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _registered = false;

  @override
  void initState() {
    super.initState();

    Rx.combineLatest2<List<SnapshotInfo>, BackupSettings, _BackupContext>(
      widget._backupBloc.multipleRestoreStream,
      widget._backupBloc.backupSettingsStream,
      (a, b) => _BackupContext(a, b),
    ).listen(_listenBackupContext, onError: (error) {
      popToWalkthrough(
        error: error.runtimeType != SignInFailedException
            ? error.toString()
            : null,
      );
      if (error.runtimeType == SignInFailedException) {
        _handleSignInException(error as SignInFailedException);
      }
    });

    _restoreFinishedSubscription =
        widget._backupBloc.restoreFinishedStream.listen((restored) {
      if (restored) {
        _reloadDatabases();
        popToWalkthrough();
        _proceedToRegister();
      }
    }, onError: (error) {
      Navigator.of(context).pop();
      if (error.runtimeType != SignInFailedException) {
        showFlushbar(
          context,
          duration: const Duration(seconds: 3),
          message: error.toString(),
        );
      } else {
        _handleSignInException(error as SignInFailedException);
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2720),
    )..forward(from: 0.0);
    _animation = IntTween(begin: 0, end: 67).animate(_controller);
    if (_controller.isCompleted) {
      _controller.stop();
      _controller.dispose();
    }
  }

  Future<void> _listenBackupContext(_BackupContext backupContext) async {
    final texts = context.texts();
    final options = backupContext.snapshots;
    if (options.isEmpty) {
      popToWalkthrough(
        error: texts.initial_walk_through_error_backup_location,
      );
      return;
    }

    SnapshotInfo toRestore;
    if (options.length == 1) {
      toRestore = options.first;
    } else {
      popToWalkthrough();
      toRestore = await showDialog<SnapshotInfo>(
        useRootNavigator: false,
        context: context,
        builder: (_) => RestoreDialog(context, widget._backupBloc, options),
      );
    }

    if (toRestore != null) {
      if (toRestore.encrypted) {
        if (toRestore.encryptionType.startsWith("Mnemonics")) {
          log.info(
              'initial_walkthrough.dart: restoring backup with mnemonic of type "${toRestore.encryptionType}"');

          restoreUsingPhrase(
            toRestore.encryptionType == "Mnemonics",
            (entropy) async {
              await _createBackupPhrase(entropy);
              final updateAction = UpdateBackupSettings(
                backupContext.settings.copyWith(
                  keyType: BackupKeyType.PHRASE,
                ),
              );
              widget._backupBloc.backupActionsSink.add(updateAction);
              updateAction.future.then((_) => _restore(
                    toRestore,
                    HEX.decode(entropy),
                  ));
            },
          );
          return;
        }

        restoreUsingPIN((pin) async {
          final updateAction = UpdateBackupSettings(
            backupContext.settings.copyWith(keyType: BackupKeyType.NONE),
          );
          final key = sha256.convert(utf8.encode(pin));
          widget._backupBloc.backupActionsSink.add(updateAction);
          updateAction.future.then((_) => _restore(toRestore, key.bytes));
        });
        return;
      }

      _restore(toRestore, null);
    }
  }

  void _restore(SnapshotInfo snapshot, List<int> key) {
    const logKey = "initial_walkthrough.dart.restore";
    log.info('$logKey: snapshotInfo with timestamp: ${snapshot?.modifiedTime}');
    log.info('$logKey: using key with length: ${key?.length}');

    final texts = context.texts();
    widget._backupBloc.restoreRequestSink.add(RestoreRequest(
      snapshot,
      BreezLibBackupKey(key: key),
    ));
    Navigator.push(
      context,
      createLoaderRoute(
        context,
        message: texts.initial_walk_through_restoring,
        opacity: 0.8,
      ),
    );
  }

  Future _handleSignInException(SignInFailedException e) async {
    final texts = context.texts();
    final themeData = Theme.of(context);
    if (e.provider == BackupSettings.icloudBackupProvider()) {
      await promptError(
        context,
        texts.initial_walk_through_sign_in_icloud_title,
        Text(
          texts.initial_walk_through_sign_in_icloud_message,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    }
  }

  Future<String> restoreUsingPhrase(
    bool is24Word,
    Function(String key) onKeySubmitted,
  ) {
    return Navigator.of(context).push(FadeInRoute(
      builder: (BuildContext context) {
        return EnterBackupPhrasePage(
          is24Word: is24Word,
          onPhraseSubmitted: onKeySubmitted,
        );
      },
    ));
  }

  Future _createBackupPhrase(String entropy) async {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final saveBackupKeyAction = SaveBackupKey(entropy);
    widget._backupBloc.backupActionsSink.add(saveBackupKeyAction);
    return saveBackupKeyAction.future.catchError((err) {
      promptError(
        context,
        texts.initial_walk_through_error_internal,
        Text(
          err.toString(),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  Future<String> restoreUsingPIN(Function(String key) onKeySubmitted) {
    return Navigator.of(context).push(FadeInRoute(
      builder: (BuildContext context) {
        return RestorePinCode(onPinCodeSubmitted: onKeySubmitted);
      },
    ));
  }

  void popToWalkthrough({String error}) {
    Navigator.popUntil(context, (route) {
      return route.settings.name == "/intro";
    });
    if (error != null) {
      SnackBar snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(error.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _reloadDatabases() {
    widget._posCatalogBloc.reloadPosItemsSink.add(true);
    widget._reloadDatabaseSink.add(true);
  }

  @override
  void dispose() {
    _multipleRestoreSubscription?.cancel();
    _restoreFinishedSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _proceedToRegister() {
    widget._registrationBloc.registerSink.add(null);
    _registered = true;
    Navigator.of(context).pop();
  }

  Future<bool> _onWillPop() async {
    if (!_registered) {
      exit(0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Theme(
      data: blueTheme,
      child: Scaffold(
        key: _scaffoldKey,
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 200,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 171,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (BuildContext context, Widget child) {
                          String frame =
                              _animation.value.toString().padLeft(2, '0');
                          return Image.asset(
                            'src/animations/welcome/frame_${frame}_delay-0.04s.png',
                            gaplessPlayback: true,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 200,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 48,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: AutoSizeText(
                          texts.initial_walk_through_welcome_message,
                          textAlign: TextAlign.center,
                          style: theme.welcomeTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 60,
                      child: Container(),
                    ),
                    SizedBox(
                      height: 48.0,
                      width: 168.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          backgroundColor: theme.buttonColor,
                          elevation: 0.0,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          texts.initial_walk_through_lets_breeze,
                          style: themeData.textTheme.labelLarge,
                        ),
                        onPressed: () => _letsBreez(context),
                      ),
                    ),
                    Expanded(
                      flex: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: GestureDetector(
                          onTap: () => _restoreFromBackup(context),
                          child: Text(
                            texts.initial_walk_through_restore_from_backup,
                            style: theme.restoreLinkStyle,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 120,
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _letsBreez(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BetaWarningDialog();
      },
    ).then((approved) {
      if (approved) {
        final resetSecurity = ResetSecurityModel();
        widget._registrationBloc.userActionsSink.add(resetSecurity);
        resetSecurity.future.then((_) {
          _proceedToRegister();
        }).catchError((err) {
          promptError(
            context,
            texts.initial_walk_through_error_internal,
            Text(
              err.toString(),
              style: themeData.dialogTheme.contentTextStyle,
            ),
          );
        });
      }
    });
  }

  void _restoreFromBackup(BuildContext context) {
    widget._backupBloc.backupSettingsStream.first.then((settings) async {
      final providers = BackupSettings.availableBackupProviders();
      var backupProvider = settings.backupProvider;
      if (backupProvider == null || providers.length > 1) {
        backupProvider = await showDialog(
          useRootNavigator: false,
          context: context,
          builder: (_) => BackupProviderSelectionDialog(
            backupBloc: widget._backupBloc,
            restore: true,
          ),
        );
      }
      if (backupProvider != null) {
        // Restore then start lightninglib
        Navigator.push(context, createLoaderRoute(context));
        widget._backupBloc.restoreRequestSink.add(null);
      }
    });
  }
}
