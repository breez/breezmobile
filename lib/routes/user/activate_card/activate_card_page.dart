import 'package:flutter/material.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'dart:async';
import 'package:breez/logger.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/services.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/widgets.dart';

class _ActivatePageState extends State<_ActivateCardPage> with WidgetsBindingObserver {
  final String _title = "Activate Card";
  final String _instructions = "To activate your Breez card,\nhold it close to your mobile device";

  static ServiceInjector injector = new ServiceInjector();
  NFCService nfc = injector.nfc;

  StreamSubscription _streamSubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget._userBloc.cardActivationInit();
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
    widget._userBloc.cardActivationInit();
    _streamSubscription = widget._userBloc.cardActivationStream.listen((bool success) {
      if (success) {
        Navigator.pop(context, "Your Breez card has been activated and is now ready for use!");
      } else {
        log.info("Card activation failed!");
      }
    });
  }

  void _showAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      content: new Text("Breez requires NFC to be enabled in your device in order to activate a card.",
          style: theme.alertStyle),
      actions: <Widget>[
        new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("CANCEL", style: theme.buttonStyle)),
        new FlatButton(
            onPressed: () {
              nfc.openSettings();
              Navigator.pop(context);
            },
            child: new Text("SETTINGS", style: theme.buttonStyle))
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  void dispose() {
    new BlocConnector<AppBlocs>((context, blocs) {});
    _streamSubscription.cancel();
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
        backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
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
            padding: EdgeInsets.only(top: 48.0),
            child: new Text(
              _instructions,
              textAlign: TextAlign.center,
              style: theme.textStyle,
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

class ActivateCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>((context, blocs) => new _ActivateCardPage(blocs.userProfileBloc));
  }
}

class _ActivateCardPage extends StatefulWidget {
  final UserProfileBloc _userBloc;
  final platform = const MethodChannel('com.breez.client/nfc');

  _ActivateCardPage(this._userBloc);
  @override
  State<StatefulWidget> createState() {
    return new _ActivatePageState();
  }
}
