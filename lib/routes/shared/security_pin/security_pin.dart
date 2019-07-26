import 'dart:async';

import 'package:breez/routes/shared/security_pin/prompt_pin_code.dart';
import 'package:breez/routes/shared/security_pin/security_pin_warning_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
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
  bool _enableBiometrics = false;
  int _securityPIN;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPreferences();
  }

  Future loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _hasSecurityPIN = (prefs.getBool('hasSecurityPIN') ?? false);
    _useInBackupRestore = (prefs.getBool('useInBackupRestore') ?? false);
    _enableBiometrics = (prefs.getBool('enableBiometrics') ?? false);
    if (_hasSecurityPIN) {
      _readSecurityPIN();
      _setHasSecurityPIN(true);
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
        return PassCodeScreen(_securityPIN, dismissible: true, onSuccess: (value) => Navigator.pop(context));
      }));
    } else {
      prefs.setBool('hasSecurityPIN', false);
    }
  }

  _setHasSecurityPIN(bool value) {
    prefs.setBool('hasSecurityPIN', value);
    setState(() {
      _hasSecurityPIN = value;
    });
  }

  _setSecurityPIN(int securityPIN) async {
    // Write value
    await storage.write(key: 'securityPIN', value: securityPIN.toString());
    _readSecurityPIN();
  }

  _readSecurityPIN() async {
    // Read value
    _securityPIN = int.parse(await storage.read(key: 'securityPIN'));
  }

  _deleteSecurityPIN() async {
    // Delete value
    await storage.delete(key: 'securityPIN');
    setState(() {
      _securityPIN = null;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
                    setState(() {
                      _hasSecurityPIN = value;
                      prefs.setBool('hasSecurityPIN', value);
                      prefs.setBool('useInBackupRestore', false);
                      _useInBackupRestore = false;
                      _deleteSecurityPIN();
                    });
                  }
                },
              )
            : Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: _hasSecurityPIN
            ? null
            : () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
                  return PassCodeScreen(
                    _securityPIN,
                    title: "Enter your new PIN",
                    dismissible: true,
                    setSecurityPIN: (password) => _setSecurityPIN(password),
                    onSuccess: (value) => _setHasSecurityPIN(value),
                  );
                })));

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
              setState(() {
                if (value) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SecurityPINWarningDialog();
                      }).then((approved) {
                    if (approved) {
                      setState(() {
                        _useInBackupRestore = approved;
                      });
                      prefs.setBool('useInBackupRestore', approved);
                    }
                  });
                } else {
                  setState(() {
                    _useInBackupRestore = value;
                  });
                  prefs.setBool('useInBackupRestore', value);
                }
              });
            }
          },
        ));
    final _enableBiometricsTile = ListTile(
        title: Text(
          "Enable Fingerprint/Face",
          style: TextStyle(color: Colors.white),
        ),
        trailing: Switch(
          value: _enableBiometrics,
          activeColor: Colors.white,
          onChanged: (bool value) {
            if (this.mounted) {
              setState(() {
                _enableBiometrics = value;
                prefs.setBool('enableBiometrics', value);
              });
            }
          },
        ));
    final _changeSecurityPIN = ListTile(
      title: Text(
        "Change PIN",
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () => Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) {
          return PassCodeScreen(_securityPIN, title: "Enter your current PIN", onSuccess: (value) {
            Navigator.pop(context);
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
              return PassCodeScreen(
                null,
                title: "Enter your new PIN",
                setSecurityPIN: (password) => _setSecurityPIN(password),
                onSuccess: (value) => _setHasSecurityPIN(value),
              );
            }));
          });
        }),
      ),
    );

    _tiles..add(_disableSecurityPIN);

    if (_hasSecurityPIN) {
      _tiles
        ..add(Divider())
        ..add(_useInBackupRestoreTile)
        //..add(Divider())
        //..add(_enableBiometricsTile)
        ..add(Divider())
        ..add(_changeSecurityPIN);
    }
    return _tiles;
  }
}
