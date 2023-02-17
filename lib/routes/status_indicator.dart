import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final BuildContext context;
  final AccountModel _accountModel;

  const StatusIndicator(this.context, this._accountModel);

  @override
  Widget build(BuildContext context) {
    if (_accountModel?.readyForPayments == true ||
        _accountModel?.processingConnection == true) {
      return Container();
    }

    return SizedBox(
      height: 2.0,
      width: MediaQuery.of(context).size.width,
      child: createStatusIndicator(),
    );
  }

  Widget createStatusIndicator() {
    return LinearProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.background),
        backgroundColor: Theme.of(context).highlightColor);
  }
}
