import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ActivateCardPageState extends State<ActivateCardPage> with WidgetsBindingObserver {
  final String _title = "Activate Card";
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  
  static ServiceInjector injector = new ServiceInjector();
  NFCService nfc = injector.nfc;

  StreamSubscription _streamSubscription;
  bool _isInit = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      UserProfileBloc userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      userBloc.cardActivationInit();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    nfc.checkNFCSettings().then((isNfcEnabled) {
      if (!isNfcEnabled) {
        return new Timer(new Duration(milliseconds: 500), () {
          _showAlertDialog();
        });
      }
    });   
  }

  @override void didChangeDependencies() {            
      if (!_isInit) {
        UserProfileBloc userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
        userBloc.cardActivationInit();      
        _streamSubscription = userBloc.cardActivationStream.listen((bool success) {
          if (success) {
            Navigator.pop(context, "Your Breez card has been activated and is now ready for use!");
          } else {
            log.info("Card activation failed!");
          }
        });
        _isInit = true;
      }
      super.didChangeDependencies();
    }

  void _showAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      content: new Text("Breez requires NFC to be enabled in your device in order to activate a card.",
          style: Theme.of(context).dialogTheme.contentTextStyle),
      actions: <Widget>[
        new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("CANCEL", style: Theme.of(context).primaryTextTheme.button)),
        new FlatButton(
            onPressed: () {
              nfc.openSettings();
              Navigator.pop(context);
            },
            child: new Text("SETTINGS", style: Theme.of(context).primaryTextTheme.button))
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  void dispose() {    
    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardActivation(context);
  }

  Widget _buildCardActivation(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: new Text(
          _title,
          style: theme.appBarTextStyle,
        ),
        elevation: 0.0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0),
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  "To activate your Breez card,",
                  textAlign: TextAlign.center,
                  style: theme.textStyle,
                  maxLines: 1,
                  group: _autoSizeGroup,
                ),
                AutoSizeText(
                  "hold it close to your mobile device",
                  textAlign: TextAlign.center,
                  style: theme.textStyle,
                  maxLines: 1,
                  group: _autoSizeGroup,
                )
              ],
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              "src/images/waves-middle.png",
              fit: BoxFit.contain,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              "src/images/nfc-background.png",
              fit: BoxFit.contain,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivateCardPage extends StatefulWidget {  
  final platform = const MethodChannel('com.breez.client/nfc');

  ActivateCardPage();
  @override
  State<StatefulWidget> createState() {
    return new ActivateCardPageState();
  }
}
