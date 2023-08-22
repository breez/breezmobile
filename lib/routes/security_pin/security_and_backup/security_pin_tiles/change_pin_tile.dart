import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/security_pin/change_pin_code.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class ChangePinTile extends StatefulWidget {
  final UserProfileBloc userProfileBloc;
  final AutoSizeGroup autoSizeGroup;
  final Function(bool) unlockScreen;

  const ChangePinTile({
    @required this.userProfileBloc,
    @required this.autoSizeGroup,
    @required this.unlockScreen,
  });

  @override
  State<ChangePinTile> createState() => _ChangePinTileState();
}

class _ChangePinTileState extends State<ChangePinTile> {
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

          return ListTile(
            title: AutoSizeText(
              texts.security_and_backup_change_pin,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: widget.autoSizeGroup,
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 30.0,
            ),
            onTap: () => _onChangePinSelected(securityModel),
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
