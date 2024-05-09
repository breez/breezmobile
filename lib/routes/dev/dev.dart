import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/marketplace/nostr_settings.dart';
import 'package:breez/bloc/podcast_history/sqflite/podcast_history_database.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/sqlite/db.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/dev/default_commands.dart';
import 'package:breez/routes/dev/set_height_hint.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/permissions.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final _log = Logger("DevView");

bool allowRebroadcastRefunds = false;
final _cliInputController = TextEditingController();
final FocusNode _cliEntryFocusNode = FocusNode();

class Choice {
  final String title;
  final IconData icon;
  final Function function;

  const Choice({
    this.title,
    this.icon,
    this.function,
  });
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// ignore: must_be_immutable
class DevView extends StatefulWidget {
  BreezBridge _breezBridge;
  Permissions _permissionsService;

  DevView() {
    ServiceInjector injector = ServiceInjector();
    _breezBridge = injector.breezBridge;
    _permissionsService = injector.permissions;
  }

  void _select(Choice choice) {
    choice.function();
  }

  @override
  DevViewState createState() {
    return DevViewState();
  }
}

class DevViewState extends State<DevView> {
  static const FORCE_RESCAN_FILE_NAME = "FORCE_RESCAN";
  String _cliText = '';
  String _lastCommand = '';
  TextStyle _cliTextStyle = theme.smallTextStyle;

  var _richCliText = <TextSpan>[];

  bool _showDefaultCommands = true;

  void _sendCommand(String command) {
    FocusScope.of(context).requestFocus(FocusNode());
    _lastCommand = command;
    widget._breezBridge.sendCommand(command).then(
      (reply) {
        setState(() {
          _showDefaultCommands = false;
          _cliTextStyle = theme.smallTextStyle;
          _cliText = reply;
          _richCliText = <TextSpan>[
            TextSpan(text: _cliText),
          ];
        });
      },
    ).catchError(
      (error) {
        setState(() {
          _showDefaultCommands = false;
          _cliText = error;
          _cliTextStyle = theme.warningStyle;
          _richCliText = <TextSpan>[
            TextSpan(text: _cliText),
          ];
        });
      },
    );
  }

  Widget _renderBody() {
    if (_showDefaultCommands) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ListView(
          children: defaultCliCommandsText(
            (command) {
              _cliInputController.text = "$command ";
              FocusScope.of(_scaffoldKey.currentState.context)
                  .requestFocus(_cliEntryFocusNode);
            },
          ),
        ),
      );
    }
    return ListView(
      children: [
        RichText(
          text: TextSpan(
            style: _cliTextStyle,
            children: _richCliText,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);
    BackupBloc backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    AddFundsBloc addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
    UserProfileBloc userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    MarketplaceBloc marketplaceBloc =
        AppBlocsProvider.of<MarketplaceBloc>(context);
    return StreamBuilder<BackupState>(
      stream: backupBloc.backupStateStream,
      builder: (ctx, backupSnapshot) => StreamBuilder(
        stream: accBloc.accountStream,
        builder: (accCtx, accSnapshot) {
          AccountModel account = accSnapshot.data;
          return StreamBuilder(
            stream: accBloc.accountSettingsStream,
            builder: (context, settingsSnapshot) {
              return StreamBuilder(
                stream: addFundsBloc.addFundsSettingsStream,
                builder: (context, addFundsSettingsSnapshot) {
                  return StreamBuilder<BreezUserModel>(
                    stream: userBloc.userStream,
                    builder: (context, userSnapshot) {
                      return StreamBuilder(
                        stream: marketplaceBloc.nostrSettingsStream,
                        builder: (context, nostrSettingsSnapshot) {
                          final themeData = Theme.of(context);

                          return Scaffold(
                            key: _scaffoldKey,
                            appBar: AppBar(
                              leading: const backBtn.BackButton(),
                              title: const Text("Developers"),
                              actions: <Widget>[
                                PopupMenuButton<Choice>(
                                  onSelected: widget._select,
                                  color: themeData.colorScheme.background,
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: themeData.iconTheme.color,
                                  ),
                                  itemBuilder: (BuildContext context) {
                                    return getChoices(
                                      accBloc,
                                      settingsSnapshot.data,
                                      account,
                                      addFundsBloc,
                                      addFundsSettingsSnapshot.data,
                                      userBloc,
                                      userSnapshot.data,
                                      marketplaceBloc,
                                      nostrSettingsSnapshot.data,
                                    ).map((Choice choice) {
                                      return PopupMenuItem<Choice>(
                                        value: choice,
                                        child: Text(
                                          choice.title,
                                          style: themeData.textTheme.labelLarge,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ],
                            ),
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          focusNode: _cliEntryFocusNode,
                                          controller: _cliInputController,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'Enter a command or use the links below',
                                          ),
                                          onSubmitted: (command) {
                                            _sendCommand(command);
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.play_arrow,
                                        ),
                                        tooltip: 'Run',
                                        onPressed: () {
                                          _sendCommand(
                                            _cliInputController.text,
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.clear),
                                        tooltip: 'Clear',
                                        onPressed: () {
                                          setState(() {
                                            _cliInputController.clear();
                                            _showDefaultCommands = true;
                                            _lastCommand = '';
                                            _cliText = "";
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                    ),
                                    child: Container(
                                      padding: _showDefaultCommands
                                          ? const EdgeInsets.all(0.0)
                                          : const EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        border: _showDefaultCommands
                                            ? null
                                            : Border.all(
                                                width: 1.0,
                                                color: const Color(0x80FFFFFF),
                                              ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          _showDefaultCommands
                                              ? Container()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.content_copy,
                                                      ),
                                                      tooltip:
                                                          'Copy to Clipboard',
                                                      iconSize: 19.0,
                                                      onPressed: () {
                                                        ServiceInjector()
                                                            .device
                                                            .setClipboardText(
                                                                _cliText);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Copied to clipboard.',
                                                              style: theme
                                                                  .snackBarStyle,
                                                            ),
                                                            backgroundColor: theme
                                                                .snackBarBackgroundColor,
                                                            duration:
                                                                const Duration(
                                                              seconds: 2,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.share,
                                                      ),
                                                      iconSize: 19.0,
                                                      tooltip: 'Share',
                                                      onPressed: () {
                                                        _shareFile(
                                                          _lastCommand
                                                              .split(" ")[0],
                                                          _cliText,
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                          Expanded(child: _renderBody())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  List<Choice> getChoices(
    AccountBloc accBloc,
    AccountSettings settings,
    AccountModel account,
    AddFundsBloc addFundsBloc,
    AddFundsSettings addFundsSettings,
    UserProfileBloc userBloc,
    BreezUserModel userModel,
    MarketplaceBloc marketplaceBloc,
    NostrSettings nostrSettings,
  ) {
    List<Choice> choices = <Choice>[];
    choices.addAll(
      [
        const Choice(
          title: 'Share Logs',
          icon: Icons.share,
          function: shareLog,
        ),
        /*Choice(
          title: 'Show Initial Screen',
          icon: Icons.phone_android,
          function: _gotoInitialScreen,
        ),
        Choice(
          title:
              '${settings.showConnectProgress ? "Hide" : "Show"} Connect Progress',
          icon: Icons.phone_android,
          function: () {
            toggleConnectProgress(accBloc, settings);
          },
        ),*/
        Choice(
          title: 'Describe Graph',
          icon: Icons.phone_android,
          function: _describeGraph,
        ),
        Choice(
          title: 'Update Graph',
          icon: Icons.phone_android,
          function: _refreshGraph,
        ),
        Choice(
          title: 'Clear Downloads',
          icon: Icons.phone_android,
          function: _deleteInProgressDownloads,
        )
      ],
    );
    if (Platform.isAndroid) {
      choices.add(
        Choice(
          title: 'Battery Optimization',
          icon: Icons.phone_android,
          function: _showOptimizationsSettings,
        ),
      );
    }
    if (settings.ignoreWalletBalance) {
      choices.add(
        Choice(
          title: "Show Excess Funds",
          icon: Icons.phone_android,
          function: () => _setShowExcessFunds(accBloc, settings),
        ),
      );
    }
    if (settings.failedPaymentBehavior != BugReportBehavior.PROMPT) {
      choices.add(
        Choice(
          title: 'Reset Payment Report',
          icon: Icons.phone_android,
          function: () {
            _resetBugReportBehavior(accBloc, settings);
          },
        ),
      );
    }
    choices.add(
      Choice(
        title:
            "${addFundsSettings.moonpayIpCheck ? "Disable" : "Enable"} MoonPay IP Check",
        icon: Icons.network_check,
        function: () => _enableMoonpayIpCheck(addFundsBloc, addFundsSettings),
      ),
    );
    choices.add(
      Choice(
        title: 'Reset Refunds Status',
        icon: Icons.phone_android,
        function: () {
          allowRebroadcastRefunds = true;
        },
      ),
    );
    choices.add(
      Choice(
        title: "Recover Chain Information",
        icon: Icons.phone_android,
        function: () async {
          ResetChainService resetAction = ResetChainService();
          accBloc.userActionsSink.add(resetAction);
          await resetAction.future;
          _promptForRestart();
        },
      ),
    );
    choices.add(
      Choice(
        title: "Refresh Private Channels",
        icon: Icons.phone_android,
        function: () async {
          await widget._breezBridge.populateChannelPolicy();
        },
      ),
    );
    choices.add(
      Choice(
        title: "Reset Unconfirmed Swap",
        icon: Icons.phone_android,
        function: () async {
          await widget._breezBridge.setNonBlockingUnconfirmedSwaps();
          await widget._breezBridge
              .resetUnconfirmedReverseSwapClaimTransaction();
        },
      ),
    );
    choices.add(
      Choice(
        title: "Export DB Files",
        icon: Icons.phone_android,
        function: () async {
          Directory tempDir = await getTemporaryDirectory();
          tempDir = await tempDir.createTemp("graph");
          var walletFiles =
              await ServiceInjector().breezBridge.getWalletDBpFilePath();
          var encoder = ZipFileEncoder();
          var zipFilePath = '${tempDir.path}/wallet-files.zip';
          encoder.create(zipFilePath);
          var i = 1;
          for (var f in walletFiles) {
            var file = File(f);
            encoder.addFile(file,
                "${i.toString()}_${file.path.split(Platform.pathSeparator).last}");
            i += 1;
          }
          encoder.close();
          final zipFile = XFile(zipFilePath);
          Share.shareXFiles([zipFile]);
        },
      ),
    );
    choices.add(
      Choice(
        title: "Export Product Catalog DB",
        icon: Icons.file_upload,
        function: () async {
          final databasePath = await getDatabasePath();
          final databaseFile = XFile(databasePath);
          Share.shareXFiles([databaseFile]);
        },
      ),
    );
    choices.add(
      Choice(
        title: "Import Product Catalog DB",
        icon: Icons.file_download,
        function: () async {
          final fileResult = await FilePicker.platform.pickFiles(
            dialogTitle: "Select Product Catalog DB",
          );
          if (fileResult != null && fileResult.files.isNotEmpty) {
            final file = fileResult.files.first;
            if (file.path.endsWith(".db")) {
              final databasePath = await getDatabasePath();
              await File(file.path).copy(databasePath);
            } else {
              _log.warning("Invalid file type for product catalog DB");
            }
          } else {
            _log.info("No file selected for product catalog DB");
          }
        },
      ),
    );
    choices.add(
      Choice(
        title: 'Reset POS DB',
        icon: Icons.phone_android,
        function: () {
          PosCatalogBloc bloc = AppBlocsProvider.of<PosCatalogBloc>(context);
          bloc.resetDB();
        },
      ),
    );
    choices.add(
      Choice(
        title: "Set Height Hint",
        icon: Icons.phone_android,
        function: () async {
          final success = await Navigator.of(context).push(FadeInRoute(
            builder: (_) => SetHeightHintPage(),
          ));
          if (success == true) {
            _promptForRestart();
          }
        },
      ),
    );
    choices.add(
      Choice(
        title: "Restore Channels",
        icon: Icons.phone_android,
        function: () async {
          _restoreChannelsBackup();
        },
      ),
    );
    choices.add(
      Choice(
        title: 'Show Tutorials',
        icon: Icons.phone_android,
        function: () {
          UserProfileBloc bloc = AppBlocsProvider.of<UserProfileBloc>(context);
          bloc.userActionsSink.add(SetSeenPaymentStripTutorial(false));
        },
      ),
    );
    choices.add(
      Choice(
        title: 'Log Cache',
        icon: Icons.phone_android,
        function: _printCacheUsage,
      ),
    );
    choices.add(
      Choice(
        title: 'Download Backup',
        icon: Icons.phone_android,
        function: () {
          _downloadSnapshot(accBloc);
        },
      ),
    );
    choices.add(
      Choice(
        title: 'Reset Top Podcasts DB',
        icon: Icons.phone_android,
        function: () {
          PodcastHistoryDatabase.instance.resetDatabase();
        },
      ),
    );
    choices.add(Choice(
      title: "${nostrSettings.showSnort ? "Display" : "Hide"} Snort",
      icon: Icons.phone_android,
      function: () {
        _toggleSnort(marketplaceBloc, nostrSettings);
      },
    ));

    return choices;
  }

/*  void _gotoInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstRun', true);
    Navigator.of(_scaffoldKey.currentState.context)
        .pushReplacementNamed("/splash");
  }*/

  void _toggleSnort(
    MarketplaceBloc bloc,
    NostrSettings nostrSettings,
  ) {
    bloc.nostrSettingsSettingsSink.add(
      nostrSettings.copyWith(
        showSnort: !nostrSettings.showSnort,
      ),
    );
  }

  void _shareFile(String command, String text) async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("command");
    String filePath = '${tempDir.path}/$command.json';
    File file = File(filePath);
    await file.writeAsString(text, flush: true);
    final xFile = XFile(filePath);
    Share.shareXFiles([xFile]);
  }

  void _showOptimizationsSettings() async {
    widget._permissionsService.requestOptimizationSettings();
  }

  void toggleConnectProgress(
    AccountBloc bloc,
    AccountSettings settings,
  ) {
    bloc.accountSettingsSink.add(
      settings.copyWith(showConnectProgress: !settings.showConnectProgress),
    );
  }

  void _resetBugReportBehavior(
    AccountBloc bloc,
    AccountSettings settings,
  ) {
    bloc.accountSettingsSink.add(
      settings.copyWith(failedPaymentBehavior: BugReportBehavior.PROMPT),
    );
  }

  void _setShowExcessFunds(
    AccountBloc bloc,
    AccountSettings settings, {
    bool ignore = false,
  }) {
    bloc.accountSettingsSink.add(
      settings.copyWith(ignoreWalletBalance: ignore),
    );
  }

  void _enableMoonpayIpCheck(
    AddFundsBloc bloc,
    AddFundsSettings addFundsSettings,
  ) {
    bloc.addFundsSettingsSink.add(
      addFundsSettings.copyWith(
        moonpayIpCheck: !addFundsSettings.moonpayIpCheck,
      ),
    );
  }

  void _restoreChannelsBackup() async {
    var filePath = await widget._breezBridge.getChanBackupPath();
    _sendCommand("restorechanbackup --multi_file $filePath");
  }

  void _describeGraph() async {
    final navigator = Navigator.of(context);
    final loaderRoute = createLoaderRoute(
      context,
      message: "Generating graph data...",
      opacity: 0.8,
    );
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("graph");
    bool userCancelled = false;
    String filePath = '${tempDir.path}/graph.json';
    navigator.push(loaderRoute).whenComplete(() => userCancelled = true);

    widget._breezBridge
        .sendCommand("describegraph $filePath --include_unannounced")
        .then((_) {
      var encoder = ZipFileEncoder();
      encoder.create('${tempDir.path}/graph.zip');
      encoder.addFile(File(filePath));
      encoder.close();
      File("${tempDir.path}/graph.json").deleteSync();
      if (!userCancelled) {
        return shareFile("${tempDir.path}/graph.zip");
      }
    }).whenComplete(() {
      if (!userCancelled) {
        Navigator.pop(context);
      }
    });
  }

  void _downloadSnapshot(AccountBloc accBloc) async {
    final nodeID = await accBloc.getPersistentNodeID();
    final downloaded = await widget._breezBridge.downloadBackup(nodeID);
    _shareBackup(downloaded.files);
  }

  Future _shareBackup(List<String> files) async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("backup");
    var encoder = ZipFileEncoder();
    var zipFilePath = '${tempDir.path}/backup.zip';
    encoder.create(zipFilePath);
    for (var f in files) {
      var file = File(f);
      encoder.addFile(file, file.path.split(Platform.pathSeparator).last);
    }
    encoder.close();
    final zipFile = XFile(zipFilePath);
    Share.shareXFiles([zipFile]);
  }

  void _refreshGraph() async {
    final navigator = Navigator.of(context);
    final loaderRoute = createLoaderRoute(
      context,
      message: "Deleting graph...",
      opacity: 0.8,
    );
    await FlutterDownloader.cancelAll();
    await widget._breezBridge.deleteDownloads();
    navigator.push(loaderRoute);
    widget._breezBridge.deleteGraph().whenComplete(() {
      navigator.pop();
      _promptForRestart();
    });
  }

  void _deleteInProgressDownloads() async {
    await FlutterDownloader.cancelAll();
    await widget._breezBridge.deleteAllDownloads();
  }

  void _printCacheUsage() async {
    Directory tempDir = await getTemporaryDirectory();
    var stats = await tempDir.stat();
    _log.info("temp dir size = ${stats.size / 1024}kb");
    var children = tempDir.listSync();
    for (var child in children) {
      var childStats = await child.stat();
      var idDir = (child is Directory);
      _log.info(
        '${idDir ? "Directory - " : "File - "} path: ${child.path}: ${childStats.size / 1024}kb',
      );
      if (child is Directory) {
        var secondLevelChildren = child.listSync();
        for (var secondLevelChild in secondLevelChildren) {
          var idChildDir = (secondLevelChild is Directory);
          var secondLevelChildStats = await secondLevelChild.stat();
          _log.info(
            "\t${idChildDir ? "Directory - " : "File - "} path: ${secondLevelChild.path}: ${secondLevelChildStats.size / 1024}kb",
          );
        }
      }
    }
  }

  Future _promptForRestart() {
    return promptAreYouSure(
      context,
      null,
      Text(
        "Please restart to resynchronize Breez.",
        style: Theme.of(context).dialogTheme.contentTextStyle,
      ),
      cancelText: "CANCEL",
      okText: "EXIT BREEZ",
    ).then(
      (shouldExit) {
        if (shouldExit) {
          exit(0);
        }
        return;
      },
    );
  }
}
