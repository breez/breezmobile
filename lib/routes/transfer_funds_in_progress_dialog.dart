import 'dart:async';

import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/widgets/animated_loader_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildTransferFundsInProgressDialog(
  BuildContext context,
  Stream<AccountModel> accountStream,
) {
  return _TransferFundsInProgressDialog(accountStream: accountStream);
}

class _TransferFundsInProgressDialog extends StatefulWidget {
  final Stream<AccountModel> accountStream;

  const _TransferFundsInProgressDialog({
    Key key,
    this.accountStream,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransferFundsInProgressDialogState();
  }
}

class _TransferFundsInProgressDialogState
    extends State<_TransferFundsInProgressDialog> {
  StreamSubscription<AccountModel> _stateSubscription;

  @override
  void initState() {
    super.initState();
    _stateSubscription = widget.accountStream.listen((state) {
      if (state.transferringOnChainDeposit != true) {
        _pop();
      }
    }, onError: (err) => _pop());
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  _pop() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return createAnimatedLoaderDialog(
      context,
      texts.transferring_funds_title,
    );
  }
}
