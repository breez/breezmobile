import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final BuildContext context;
  final AccountModel _accountModel;

  StatusIndicator(this.context, this._accountModel);

  @override
  Widget build(BuildContext context) {
    if (_accountModel?.readyForPayments == true ||
        _accountModel?.processingConnection == true) {
      return Container();
    }

    return SizedBox(
      child: createStatusIndicator(),
      height: 2.0,
      width: context.mediaQuerySize.width,
    );
  }

  Widget createStatusIndicator() {
    return LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(context.backgroundColor),
        backgroundColor: context.highlightColor);
  }
}
