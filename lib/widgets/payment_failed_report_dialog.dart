import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class PaymentFailedReportDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc _accountBloc;

  PaymentFailedReportDialog(this.context, this._accountBloc);

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
    return buildFailureDialog();
  }

  Widget buildFailureDialog() {
    return Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).canvasColor,
        ),
        child: new AlertDialog(
          title: new Text(
            "Failed Payment",
            style: theme.alertTitleStyle,
          ),
          titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
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
                                  _settings.failePaymentBehavior !=
                                      BugReportBehavior.PROMPT,
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
          contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
          actions: [
            new SimpleDialogOption(
              onPressed: () {
                onSubmit(false);
                Navigator.pop(widget.context, false);
              },
              child: new Text("NO", style: theme.buttonStyle),
            ),
            new SimpleDialogOption(
              onPressed: (() async {
                onSubmit(true);
                Navigator.pop(widget.context, true);
              }),
              child: new Text("YES", style: theme.buttonStyle),
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ));
  }

  void onSubmit(bool yesNo) {
    var dontAsk =
        _doneAsk ?? _settings.failePaymentBehavior != BugReportBehavior.PROMPT;
    if (dontAsk) {
      widget._accountBloc.accountSettingsSink.add(_settings.copyWith(
          failePaymentBehavior: yesNo
              ? BugReportBehavior.SEND_REPORT
              : BugReportBehavior.IGNORE));
    }
  }
}
