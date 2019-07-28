import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/shared/security_pin/prompt_pin_code.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityPage extends StatefulWidget {
  SecurityPage({Key key}) : super(key: key);

  @override
  SecurityPageState createState() {
    return SecurityPageState();
  }
}

class SecurityPageState extends State<SecurityPage> {
  final storage = new FlutterSecureStorage();
  UserProfileBloc _userProfileBloc;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      _isInit = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setHasSecurityPIN(SecurityModel _securityModel, bool value) {
    _userProfileBloc.securitySink.add(_securityModel.copyWith(hasSecurityPIN: value));
  }

  _deleteSecurityPIN() async {
    await storage.delete(key: 'securityPIN');
  }

  @override
  Widget build(BuildContext context) {
    String _title = "Security PIN";
    return StreamBuilder<BreezUserModel>(
        stream: _userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
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
                children: _buildSecurityPINTiles(snapshot.data.securityModel),
              ),
            );
          }
        });
  }

  List<Widget> _buildSecurityPINTiles(SecurityModel securityModel) {
    List<Widget> _tiles = List();
    final _disableSecurityPIN = ListTile(
        title: Text(
          securityModel.hasSecurityPIN ? "Activate PIN" : "Create PIN",
          style: TextStyle(color: Colors.white),
        ),
        trailing: securityModel.hasSecurityPIN
            ? Switch(
                value: securityModel.hasSecurityPIN,
                activeColor: Colors.white,
                onChanged: (bool value) {
                  if (this.mounted) {
                    _setHasSecurityPIN(securityModel, value);
                    if (!value) {
                      _deleteSecurityPIN();
                    }
                  }
                },
              )
            : Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: securityModel.hasSecurityPIN
            ? null
            : () async {
                bool _isValid = await Navigator.of(context).push(new FadeInRoute(builder: (BuildContext context) {
                  return LockScreen(
                    title: "Enter your new PIN",
                    dismissible: true,
                    setPassword: true,
                  );
                }));
                if (_isValid) _setHasSecurityPIN(securityModel, true);
              });

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
              changePassword: true,
            );
          }));
          if (_isValid) _setHasSecurityPIN(securityModel, true);
        });
    _tiles..add(_disableSecurityPIN);
    if (securityModel.hasSecurityPIN) {
      _tiles..add(Divider())..add(_changeSecurityPIN);
    }
    return _tiles;
  }
}
