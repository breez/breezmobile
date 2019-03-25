import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class PaymentFailedReportDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc _accountBloc;
  final PayRequest _failedPayment;

  PaymentFailedReportDialog(
      this.context, this._accountBloc, this._failedPayment);

  @override
  PaymentFailedReportDialogState createState() {
    return new PaymentFailedReportDialogState();
  }
}

class PaymentFailedReportDialogState extends State<PaymentFailedReportDialog> {
  bool _doneAsk;
  AccountSettings _settings;
  StreamSubscription<AccountSettings> _settingsSubscription;

  @override
  void initState() {
    super.initState();
    _settingsSubscription = widget._accountBloc.accountSettingsStream
        .listen((settings) => setState(() {
              _settings = settings;
            }));
  }

  @override
  void dispose() {
    _settingsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return createEnableBackupDialog();
  }

  Widget createEnableBackupDialog() {
    return Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).canvasColor,
        ),
        child: new AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
          title: new Text(
            "Failed Payment",
            style: theme.alertTitleStyle,
          ),
          contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
          content: _settings == null
              ? Container()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 12.0),
                      child: new Text(
                        "Sending failed payment details to Breez could help increase successful transactions rate.\nDo you want to send this failed payment details to Breez?",
                        style: theme.paymentRequestSubtitleStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              activeColor: theme.BreezColors.blue[500],
                              value: _doneAsk ??
                                  _settings.dontPromptOnPaymentFailure,
                              onChanged: (v) {
                                setState(() {
                                  _doneAsk = v;
                                });
                              }),
                          Text(
                            "Don't ask me again",
                            style: theme.paymentRequestSubtitleStyle,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
          actions: [
            new SimpleDialogOption(
              onPressed: () {
                var dontAsk = _doneAsk ?? _settings.dontPromptOnPaymentFailure;
                if (dontAsk) {
                  widget._accountBloc.accountSettingsSink.add(
                      _settings.copyWith(
                          sendReportOnPaymentFailure: false,
                          dontPromptOnPaymentFailure: dontAsk));
                }
                Navigator.pop(widget.context);
              },
              child: new Text("No", style: theme.buttonStyle),
            ),
            new SimpleDialogOption(
              onPressed: (() {
                var dontAsk = _doneAsk ?? _settings.dontPromptOnPaymentFailure;
                if (dontAsk) {
                  widget._accountBloc.accountSettingsSink.add(
                      _settings.copyWith(
                          sendReportOnPaymentFailure: true,
                          dontPromptOnPaymentFailure: dontAsk));
                }

                widget._accountBloc.actionsSink.add(SendPaymentFailureReport(
                    widget._failedPayment.paymentRequest,
                    amount: widget._failedPayment.amount));
                Navigator.pop(widget.context);
              }),
              child: new Text("YES", style: theme.buttonStyle),
            ),
          ],
        ));
  }
}
