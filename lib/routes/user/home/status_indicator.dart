import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class StatusIndicator extends StatelessWidget {
  final AccountModel _accountModel;

  StatusIndicator(this._accountModel);

  @override
  Widget build(BuildContext context) {
    if (_accountModel != null && _accountModel.connected) {
      return Container();
    }

    return SizedBox(
      child: LinearProgressIndicator(backgroundColor: theme.BreezColors.blue[200]),
      height: 2.0,
      width: MediaQuery.of(context).size.width,
    );
  }
}
