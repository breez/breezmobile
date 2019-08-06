import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/shared/backup_in_progress_dialog.dart';
import 'package:breez/routes/shared/security_pin/security_pin_warning_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'change_pin_code.dart';
import 'lock_screen.dart';

class SecurityPage extends StatefulWidget {
  final UserProfileBloc userProfileBloc;
  final BackupBloc backupBloc;

  SecurityPage(this.userProfileBloc, this.backupBloc, {Key key}) : super(key: key);

  @override
  SecurityPageState createState() {
    return SecurityPageState();
  }
}

class SecurityPageState extends State<SecurityPage> {  
  bool _screenLocked = true;
  bool _verifyPin = false;

  @override
  Widget build(BuildContext context) {
    String _title = "Security PIN";
    return StreamBuilder<BreezUserModel>(
        stream: widget.userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            if (snapshot.data.securityModel.pinCode != null && this._screenLocked) {
              return AppLockScreen(
                snapshot.data.securityModel, 
                canCancel: true,
                onUnlock: () => setState(() {
                  if (_verifyPin) {
                    Navigator.of(context).push(
                      new FadeInRoute(
                        builder: (BuildContext context) {
                          return ChangePinCode();
                        },
                      ),
                    ).then((newPIN) {
                      if (newPIN != null) {
                        _updateSecurityModel(snapshot.data.securityModel.copyWith(pinCode: newPIN, requiresPin: true));
                      }
                      _verifyPin = false;
                      this._screenLocked = false;
                    });
                  } else {
                    this._screenLocked = false;
                  }
                }),
              );
            }
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
    List<Widget> _tiles = <Widget>[_buildDisablePINTile(securityModel)];
    if (securityModel.pinCode != null)
      _tiles..add(Divider())..add(_buildSecureBackupWithPinTile(securityModel))..add(Divider())..add(_buildChangePINTile(securityModel));
    return _tiles;
  }

  ListTile _buildSecureBackupWithPinTile(SecurityModel securityModel) {
    return ListTile(
      title: Text(
        "Use in Backup/Restore",
        style: TextStyle(color: Colors.white),
      ),
      trailing: Switch(
        value: securityModel.secureBackupWithPin,
        activeColor: Colors.white,
        onChanged: (bool value) async {
          if (this.mounted) {
            if (value) {
              bool approved = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SecurityPINWarningDialog();
                }
              );
              if (!approved) {
                return;
              }                                                
            }
            _updateSecurityModel(securityModel.copyWith(secureBackupWithPin: value));                        
          }
        },
      ),
    );
  }

  ListTile _buildChangePINTile(SecurityModel securityModel) {
    return ListTile(
      title: Text(
        "Change PIN",
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () => _onChangePinSelected(securityModel, true),
    );
  }

  ListTile _buildDisablePINTile(SecurityModel securityModel) {
    return ListTile(
      title: Text(
        securityModel.pinCode != null ? "Activate PIN" : "Create PIN",
        style: TextStyle(color: Colors.white),
      ),
      trailing: securityModel.pinCode != null
          ? Switch(
              value: securityModel.pinCode != null,
              activeColor: Colors.white,
              onChanged: (bool value) {
                if (this.mounted) {
                  _updateSecurityModel(SecurityModel(requiresPin: false, pinCode: null, secureBackupWithPin: false));                  
                }
              },
            )
          : Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: securityModel.pinCode != null ? null : () => _onChangePinSelected(securityModel, false),
    );
  }

  void _onChangePinSelected(SecurityModel securityModel, bool lockScreen) {
    if (lockScreen) {
      setState(() {
        _screenLocked = true;
        _verifyPin = true;
      });
    } else {
      Navigator.of(context).push(
        new FadeInRoute(
          builder: (BuildContext context) {
            return ChangePinCode();
          },
        ),
      ).then((newPIN) {
        if (newPIN != null) {
          _updateSecurityModel(securityModel.copyWith(pinCode: newPIN, requiresPin: true));
        }
      });
    }
  }

  Future _updateSecurityModel(SecurityModel newModel) async {
    _screenLocked = false;
    var action = UpdateSecurityModel(newModel);
    widget.userProfileBloc.userActionsSink.add(action);
    action.future
    .then((_){
      if (newModel.secureBackupWithPin) {
        widget.backupBloc.backupNowSink.add(true);                        
        widget.backupBloc.backupStateStream.firstWhere((s) => s.inProgress).then((s){
          if (mounted) {
            showDialog(
            context: context,
            builder: (ctx) => buildBackupInProgressDialog(ctx, widget.backupBloc.backupStateStream));
          }
        });
      }
    })
    .catchError((err){
      promptError(context, "Internal Error", Text(err.toString(), style: theme.alertStyle,));
    });    
  }
}
