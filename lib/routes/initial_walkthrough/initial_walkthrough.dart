import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/beta_warning_dialog.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/select_backup_provider_dialog.dart';
import 'package:breez/routes/initial_walkthrough/handlers/backup_restore_handler.dart';
import 'package:breez/routes/initial_walkthrough/handlers/models/handler.dart';
import 'package:breez/routes/initial_walkthrough/handlers/models/handler_context_provider.dart';
import 'package:breez/routes/initial_walkthrough/handlers/restore_request_handler.dart';
import 'package:breez/routes/initial_walkthrough/loaders/loader_indicator.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class InitialWalkthroughPage extends StatefulWidget {
  final Sink<bool> reloadDatabaseSink;

  const InitialWalkthroughPage({this.reloadDatabaseSink});

  @override
  State<InitialWalkthroughPage> createState() => _InitialWalkthroughPageState();
}

class _InitialWalkthroughPageState extends State<InitialWalkthroughPage>
    with HandlerContextProvider, SingleTickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController controller;
  Animation<int> animation;

  final handlers = <Handler>[];

  bool _registered = false;

  @override
  void initState() {
    super.initState();

    /// Breez Logo Animation
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2720),
    )..forward(from: 0.0);
    animation = IntTween(begin: 0, end: 67).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value
        });
      });
    controller.forward();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      /// Backup Request & Restore Handlers
      handlers.addAll([
        RestoreRequestHandler(),
        BackupRestoreHandler(
          widget.reloadDatabaseSink,
        ),
      ]);
      for (var handler in handlers) {
        handler.init(this);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          key: scaffoldKey,
          body: Padding(
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
                        animation: animation,
                        builder: (BuildContext context, Widget child) {
                          String frame =
                              animation.value.toString().padLeft(2, '0');
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
                          backgroundColor: themeData.primaryColor,
                          elevation: 0.0,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          texts.initial_walk_through_lets_breeze,
                          style: themeData.textTheme.labelLarge,
                        ),
                        onPressed: () => _letsBreez(),
                      ),
                    ),
                    Expanded(
                      flex: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: GestureDetector(
                          onTap: () => _restoreFromBackup(),
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

  void _letsBreez() async {
    log.info("Registering new node");
    await showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => BetaWarningDialog(),
    ).then((approved) async {
      if (approved) {
        final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
        await _resetSecurityModel().then((_) {
          _registered = true;
          userProfileBloc.registerSink.add(null);
          Navigator.of(context).pop();
        });
      }
    });
  }

  Future _resetSecurityModel() async {
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    final texts = context.texts();
    final themeData = Theme.of(context);

    var action = ResetSecurityModel();
    userProfileBloc.userActionsSink.add(action);
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

  void _restoreFromBackup() {
    log.info("Restore from Backup");
    _getAvailableBackupProviders();
  }

  void _getAvailableBackupProviders() {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    backupBloc.backupSettingsStream.first.then((backupSettings) async {
      final backupProviders = BackupSettings.availableBackupProviders();

      if (backupProviders.length > 1) {
        await showDialog(
          useRootNavigator: false,
          context: context,
          builder: (_) => SelectBackupProviderDialog(
            backupSettings: backupSettings,
            backupProviders: backupProviders,
            onProviderSelected: (_) {
              EasyLoading.show(
                indicator: const LoaderIndicator(
                  message: 'Loading Backups',
                ),
              );
              backupBloc.restoreRequestSink.add(null);
            },
          ),
        );
      }
    });
  }
}
