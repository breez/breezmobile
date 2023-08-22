import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/security_pin/change_pin_code.dart';
import 'package:breez/widgets/designsystem/switch/simple_switch.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class DisablePinTile extends StatefulWidget {
  final UserProfileBloc userProfileBloc;
  final AutoSizeGroup autoSizeGroup;
  final Function(bool) unlockScreen;

  const DisablePinTile({
    @required this.userProfileBloc,
    @required this.unlockScreen,
    @required this.autoSizeGroup,
  });

  @override
  State<DisablePinTile> createState() => _DisablePinTileState();
}

class _DisablePinTileState extends State<DisablePinTile> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return StreamBuilder<BreezUserModel>(
        stream: widget.userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final securityModel = snapshot.data.securityModel;

          return SimpleSwitch(
            text: securityModel.requiresPin
                ? texts.security_and_backup_pin_option_deactivate
                : texts.security_and_backup_pin_option_create,
            trailing: securityModel.requiresPin
                ? null
                : const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 30.0,
                  ),
            switchValue: securityModel.requiresPin,
            group: securityModel.requiresPin ? widget.autoSizeGroup : null,
            onTap: securityModel.requiresPin
                ? null
                : () => _onChangePinSelected(securityModel),
            onChanged: (bool value) async {
              if (mounted) {
                await _resetSecurityModel();
              }
            },
          );
        });
  }

  void _onChangePinSelected(SecurityModel securityModel) {
    _openChangePinCodePage().then((newPIN) async {
      if (newPIN != null) {
        await _updatePinCode(newPIN, securityModel);
      }
    });
  }

  Future<dynamic> _openChangePinCodePage() {
    return Navigator.of(context).push(
      FadeInRoute(
        builder: (BuildContext context) {
          return withBreezTheme(
            context,
            const ChangePinCode(),
          );
        },
      ),
    );
  }

  Future _updatePinCode(newPIN, SecurityModel securityModel) {
    var updatePinAction = UpdatePinCode(newPIN);
    widget.userProfileBloc.userActionsSink.add(updatePinAction);
    return updatePinAction.future.then((_) async {
      await _updateSecurityModel(
        securityModel.copyWith(requiresPin: true),
      );
    }).catchError((err) => _handleError(err.toString()));
  }

  Future _updateSecurityModel(SecurityModel newModel) async {
    widget.unlockScreen(false);
    var action = UpdateSecurityModel(newModel);
    widget.userProfileBloc.userActionsSink.add(action);
    return action.future;
  }

  Future _resetSecurityModel() async {
    var action = ResetSecurityModel();
    widget.userProfileBloc.userActionsSink.add(action);
    return action.future.catchError((err) => _handleError(err.toString()));
  }

  Future<void> _handleError(String error) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return promptError(
      context,
      texts.security_and_backup_internal_error,
      Text(
        error,
        style: themeData.dialogTheme.contentTextStyle,
      ),
    );
  }
}
