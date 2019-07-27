import 'dart:async';

import 'package:breez/routes/shared/security_pin/prompt_pin_code.dart';
import 'package:breez/routes/shared/security_pin/security_pin_warning_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityPage extends StatefulWidget {
  SecurityPage({Key key}) : super(key: key);

  @override
  SecurityPageState createState() {
    return SecurityPageState();
  }
}

class SecurityPageState extends State<SecurityPage> {
  final storage = new FlutterSecureStorage();
  SharedPreferences prefs;

  bool _hasSecurityPIN = false;
  bool _useInBackupRestore = false;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (_hasSecurityPIN) _showLockScreen();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Future loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _setHasSecurityPIN(prefs.getBool('hasSecurityPIN') ?? false);
    _setUseInBackupRestore(prefs.getBool('useInBackupRestore') ?? false);
  }

  Future _showLockScreen() async {
    bool _isValid = await Navigator.of(context).push(new FadeInRoute(builder: (BuildContext context) {
      return LockScreen(dismissible: true);
    }));
    if (!_isValid) Navigator.pop(context);
  }

  void _setHasSecurityPIN(bool value) {
    prefs.setBool('hasSecurityPIN', value);
    setState(() {
      _hasSecurityPIN = value;
    });
  }

  void _setUseInBackupRestore(bool value) {
    prefs.setBool('useInBackupRestore', value);
    setState(() {
      _useInBackupRestore = value;
    });
  }

  _deleteSecurityPIN() async {
    await storage.delete(key: 'securityPIN');
  }

  @override
  Widget build(BuildContext context) {
    String _title = "Security PIN";
    return Scaffold(
      appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
      body: ListView(
        children: _buildSecurityPINTiles(),
      ),
    );
  }

  List<Widget> _buildSecurityPINTiles() {
    List<Widget> _tiles = List();
    final _disableSecurityPIN = ListTile(
        title: Text(
          _hasSecurityPIN ? "Activate PIN" : "Create PIN",
          style: TextStyle(color: Colors.white),
        ),
        trailing: _hasSecurityPIN
            ? Switch(
                value: _hasSecurityPIN,
                activeColor: Colors.white,
                onChanged: (bool value) {
                  if (this.mounted) {
                    _setHasSecurityPIN(value);
                    if (!value) {
                      _setUseInBackupRestore(value);
                      _deleteSecurityPIN();
                    }
                  }
                },
              )
            : Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: _hasSecurityPIN
            ? null
            : () async {
                bool _isValid = await Navigator.of(context).push(new FadeInRoute(builder: (BuildContext context) {
                  return LockScreen(
                    title: "Enter your new PIN",
                    dismissible: true,
                    setPassword: true,
                  );
                }));
                if (_isValid) _setHasSecurityPIN(true);
              });

    final _useInBackupRestoreTile = ListTile(
        title: Text(
          "Use in Backup/Restore",
          style: TextStyle(color: Colors.white),
        ),
        trailing: Switch(
          value: _useInBackupRestore,
          activeColor: Colors.white,
          onChanged: (bool value) {
            if (this.mounted) {
              if (value) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return SecurityPINWarningDialog();
                    }).then((approved) {
                  _setUseInBackupRestore(approved);
                });
              } else {
                _setUseInBackupRestore(value);
              }
            }
          },
        ));
    final _changeSecurityPIN = ListTile(
        title: Text(
          "Change PIN",
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () async {
          bool _isValid = await Navigator.of(context).push(new FadeInRoute(builder: (BuildContext context) {
            return LockScreen(
              title: "Enter your current PIN",
              dismissible: true,
            );
          }));
          if (_isValid) {
            bool isValid = await Navigator.of(context).push(new FadeInRoute(builder: (BuildContext context) {
              return LockScreen(
                title: "Enter your new PIN",
                dismissible: true,
                changePassword: true,
              );
            }));
            if (isValid) _setHasSecurityPIN(true);
          }
        });
    _tiles..add(_disableSecurityPIN);
    if (_hasSecurityPIN) {
      _tiles..add(Divider())..add(_useInBackupRestoreTile)..add(Divider())..add(_changeSecurityPIN);
    }
    return _tiles;
  }
}
