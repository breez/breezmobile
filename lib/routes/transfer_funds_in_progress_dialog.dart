import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/widgets/animated_loader_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

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
  ModalRoute _currentRoute;

  @override
  void initState() {
    super.initState();
    _stateSubscription = widget.accountStream.listen((state) {
      if (state.transferringOnChainDeposit != true && _currentRoute.isActive) {
        Navigator.of(context).removeRoute(_currentRoute);
      }
    }, onError: (err) {
      if (_currentRoute.isActive) {
        Navigator.of(context).removeRoute(_currentRoute);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return createAnimatedLoaderDialog(
      context,
      texts.transferring_funds_title,
    );
  }
}
