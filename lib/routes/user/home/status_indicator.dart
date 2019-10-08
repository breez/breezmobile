import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final BuildContext context;
  final AccountModel _accountModel;

  StatusIndicator(this.context, this._accountModel);

  @override
  Widget build(BuildContext context) {
    if (_accountModel != null && _accountModel.connected && !_accountModel.isInitialBootstrap) {
      return Container();
    }

    return SizedBox(
      child: createStatusIndicator(),
      height: 2.0,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget createStatusIndicator() {
    double value;
    if (_accountModel.bootstraping && _accountModel.bootstrapProgress < 1) {
      return LinearProgressIndicator(
        backgroundColor: Theme.of(context).backgroundColor,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).highlightColor),
          value: _accountModel.bootstrapProgress);
    }

    return LinearProgressIndicator(
        valueColor:
        AlwaysStoppedAnimation<Color>(Theme.of(context).backgroundColor),
        backgroundColor: Theme.of(context).highlightColor, value: value);
  }
}
