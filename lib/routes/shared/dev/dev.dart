import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/shared/dev/default_commands.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/permissions.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _cliInputController = TextEditingController();
final FocusNode _cliEntryFocusNode = FocusNode();

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String command, String text})
      : super(
            style: style,
            text: text ?? command,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                _cliInputController.text = command + " ";
                FocusScope.of(_scaffoldKey.currentState.context)
                    .requestFocus(_cliEntryFocusNode);
              });
}

class Choice {
  const Choice({this.title, this.icon, this.function});

  final String title;
  final IconData icon;
  final Function function;
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class DevView extends StatefulWidget {
  BreezBridge _breezBridge;
  Permissions _permissionsService;

  DevView() {
    ServiceInjector injector = new ServiceInjector();
    _breezBridge = injector.breezBridge;
    _permissionsService = injector.permissions;
  }

  void _select(Choice choice) {
    choice.function();
  }

  @override
  DevViewState createState() {
    return new DevViewState();
  }
}

class DevViewState extends State<DevView> {
  static const FORCE_RESCAN_FILE_NAME = "FORCE_RESCAN";
  String _cliText = '';
  TextStyle _cliTextStyle = theme.smallTextStyle;

  var _richCliText = <TextSpan>[];

  bool _showDefaultCommands = true;

  @override
  void initState() {
    _richCliText = defaultCliCommandsText;
    super.initState();
  }

  void _sendCommand(String command) {
    FocusScope.of(context).requestFocus(new FocusNode());
    widget._breezBridge.sendCommand(command).then((reply) {
      setState(() {
        _showDefaultCommands = false;
        _cliTextStyle = theme.smallTextStyle;
        _cliText = reply;
        _richCliText = <TextSpan>[
          new TextSpan(text: _cliText),
        ];
      });
    }).catchError((error) {
      setState(() {
        _showDefaultCommands = false;
        _cliText = error;
        _cliTextStyle = theme.warningStyle;
        _richCliText = <TextSpan>[
          new TextSpan(text: _cliText),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);
    BackupBloc backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    AddFundsBloc addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
    return StreamBuilder<BackupState>(
      stream: backupBloc.backupStateStream,
      builder: (ctx, backupSnapshot) =>  StreamBuilder(
          stream: accBloc.accountStream,
          builder: (accCtx, accSnapshot) {
            AccountModel account = accSnapshot.data;
            return StreamBuilder(
                stream: accBloc.accountSettingsStream,
                builder: (context, settingsSnapshot) {
                  return StreamBuilder(
                      stream: addFundsBloc.addFundsSettingsStream,
                      builder: (context, addFundsSettingsSnapshot) {
                        return new Scaffold(
                          key: _scaffoldKey,
                          appBar: new AppBar(
                            iconTheme: Theme.of(context).appBarTheme.iconTheme,
                            textTheme: Theme.of(context).appBarTheme.textTheme,
                            backgroundColor: Theme.of(context).canvasColor,
                            leading: backBtn.BackButton(),
                            elevation: 0.0,
                            actions: <Widget>[
                              PopupMenuButton<Choice>(
                                onSelected: widget._select,
                                color: Theme.of(context).backgroundColor,
                                icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color,),
                                itemBuilder: (BuildContext context) {
                                  return getChoices(accBloc, settingsSnapshot.data, account, addFundsBloc, addFundsSettingsSnapshot.data)
                                      .map((Choice choice) {
                                    return PopupMenuItem<Choice>(
                                      value: choice,
                                      child: Text(choice.title, style: Theme.of(context).textTheme.button),
                                    );
                                  }).toList();
                                },
                              ),
                            ],
                            title: new Text(
                              "Developers",
                              style: Theme.of(context).appBarTheme.textTheme.title,
                            ),
                          ),
                          body: new Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: new Row(
                                children: <Widget>[
                                  new Flexible(
                                      child: new TextField(
                                    focusNode: _cliEntryFocusNode,
                                    controller: _cliInputController,
                                    decoration: InputDecoration(hintText: 'Enter a command or use the links below'),
                                    onSubmitted: (command) {
                                      _sendCommand(command);
                                    },
                                  )),
                                  new IconButton(
                                    icon: new Icon(Icons.play_arrow),
                                    tooltip: 'Run',
                                    onPressed: () {
                                      _sendCommand(_cliInputController.text);
                                    },
                                  ),
                                  new IconButton(
                                    icon: new Icon(Icons.clear),
                                    tooltip: 'Clear',
                                    onPressed: () {
                                      setState(() {
                                        _cliInputController.clear();
                                        _showDefaultCommands = true;
                                        _cliText = "";
                                        _richCliText = defaultCliCommandsText;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            new Expanded(
                                flex: 1,
                                child: new Container(
                                  padding: new EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                  child: new Container(
                                    padding: _showDefaultCommands ? new EdgeInsets.all(0.0) : new EdgeInsets.all(2.0),
                                    decoration: new BoxDecoration(
                                        border: _showDefaultCommands ? null : new Border.all(width: 1.0, color: Color(0x80FFFFFF))),
                                    child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        _showDefaultCommands
                                            ? new Container()
                                            : new Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  new IconButton(
                                                    icon: new Icon(Icons.content_copy),
                                                    tooltip: 'Copy to Clipboard',
                                                    iconSize: 19.0,
                                                    onPressed: () {
                                                      Clipboard.setData(new ClipboardData(text: _cliText));
                                                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                                        content: new Text(
                                                          'Copied to clipboard.',
                                                          style: theme.snackBarStyle,
                                                        ),
                                                        backgroundColor: theme.snackBarBackgroundColor,
                                                        duration: new Duration(seconds: 2),
                                                      ));
                                                    },
                                                  ),
                                                  new IconButton(
                                                    icon: new Icon(Icons.share),
                                                    iconSize: 19.0,
                                                    tooltip: 'Share',
                                                    onPressed: () {
                                                      ShareExtend.share(_cliText, "text");
                                                    },
                                                  )
                                                ],
                                              ),
                                        new Expanded(
                                            child: new SingleChildScrollView(
                                                child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: new Row(
                                            children: <Widget>[
                                              new Expanded(
                                                  child: new RichText(text: new TextSpan(style: _cliTextStyle, children: _richCliText)))
                                            ],
                                          ),
                                        )))
                                      ],
                                    ),
                                  ),
                                )),                            
                          ]),
                        );
                      });
                });
          }),
    );
  }

  List<Choice> getChoices(
      AccountBloc accBloc, AccountSettings settings, AccountModel account, AddFundsBloc addFundsBloc, AddFundsSettings addFundsSettings) {
    List<Choice> choices = new List<Choice>();
    choices.addAll([
      Choice(title: 'Share Logs', icon: Icons.share, function: shareLog),
      Choice(
          title: 'Show Initial Screen',
          icon: Icons.phone_android,
          function: _gotoInitialScreen),      
      Choice(
          title:
              '${settings.showConnectProgress ? "Hide" : "Show"} Connect Progress',
          icon: Icons.phone_android,
          function: () {
            toggleConnectProgress(accBloc, settings);
          }),
      Choice(
          title: 'Describe Graph',
          icon: Icons.phone_android,
          function: _describeGraph),      
    ]);

    if (Platform.isAndroid) {
      choices.add(Choice(
          title: 'Battery Optimization',
          icon: Icons.phone_android,
          function: _showOptimizationsSettings));
    }
    if (settings.ignoreWalletBalance) {
      choices.add(Choice(
          title: "Show Excess Funds",
          icon: Icons.phone_android,
          function: () => _setShowExcessFunds(accBloc, settings)));
    }
    if (settings.failePaymentBehavior != BugReportBehavior.PROMPT) {
      choices.add(Choice(
          title:
              'Reset Payment Report',
          icon: Icons.phone_android,
          function: () {
            _resetBugReportBehavior(accBloc, settings);
          }));
    }
    choices.add(Choice(
        title: "${addFundsSettings.moonpayIpCheck ? "Disable" : "Enable"} MoonPay IP Check",
        icon: Icons.network_check,
        function: () => _enableMoonpayIpCheck(addFundsBloc, addFundsSettings)));
    choices.add(Choice(
      title: "Force Rescan",
      icon: Icons.phone_android,
      function: () async {
        var workingDir = await widget._breezBridge.getWorkingDir();
        var rescanFile = File(workingDir.path + "/$FORCE_RESCAN_FILE_NAME");
        await rescanFile.create(recursive: true);
        _promptForRestart();

      }
    ));

    if (!account.enableInProgress && account.id.isNotEmpty) {
      choices.add(Choice(
        title: account.enabled
            ? "Disable Automatic Channel"
            : "Enable Automatic Channel",
        icon: Icons.phone_android,
        function: () {
          accBloc.accountEnableSink.add(!account.enabled);
      }));
    }   

    
    return choices;
  }

  void _gotoInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstRun', true);
    Navigator.of(_scaffoldKey.currentState.context)
        .pushReplacementNamed("/splash");
  }

  void _showOptimizationsSettings() async {
    widget._permissionsService.requestOptimizationSettings();
  }

  void toggleConnectProgress(AccountBloc bloc, AccountSettings settings) {
    bloc.accountSettingsSink.add(
        settings.copyWith(showConnectProgress: !settings.showConnectProgress));
  }

  void _resetBugReportBehavior(AccountBloc bloc, AccountSettings settings) {
    bloc.accountSettingsSink
        .add(settings.copyWith(failePaymentBehavior: BugReportBehavior.PROMPT));
  }

  void _setShowExcessFunds(AccountBloc bloc, AccountSettings settings, {bool ignore = false}) {
    bloc.accountSettingsSink
        .add(settings.copyWith(ignoreWalletBalance: ignore));
  }

  void _enableMoonpayIpCheck(AddFundsBloc bloc, AddFundsSettings addFundsSettings) {
    bloc.addFundsSettingsSink.add(addFundsSettings.copyWith(moonpayIpCheck: !addFundsSettings.moonpayIpCheck));
  }

  void _describeGraph() async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("graph");
    bool userCancelled = false;
    String filePath = '${tempDir.path}/graph.json';
    Navigator.push(
            context,
            createLoaderRoute(context,
                message: "Generating graph data...", opacity: 0.8))
        .whenComplete(() => userCancelled = true);

    widget._breezBridge.sendCommand("describegraph $filePath").then((_) {
      var encoder = new ZipFileEncoder();
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


  Future _promptForRestart() {
    return promptAreYouSure(context, null,
            Text("Please restart to resynchronize Breez.", style: Theme.of(context).dialogTheme.contentTextStyle),
            cancelText: "Cancel", okText: "Exit Breez")
        .then((shouldExit) {
      if (shouldExit) {
        exit(0);
      }
      return;
    });
  }
}
