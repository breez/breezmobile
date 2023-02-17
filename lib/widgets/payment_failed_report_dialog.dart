import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class PaymentFailedReportDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc _accountBloc;

  const PaymentFailedReportDialog(
    this.context,
    this._accountBloc,
  );

  @override
  PaymentFailedReportDialogState createState() {
    return PaymentFailedReportDialogState();
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
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          texts.payment_failed_report_dialog_title,
          style: themeData.dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: _settings == null
            ? Container()
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 12.0),
                    child: Text(
                      texts.payment_failed_report_dialog_message,
                      style: themeData.primaryTextTheme.displaySmall
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        Theme(
                          data: themeData.copyWith(
                            unselectedWidgetColor:
                                themeData.textTheme.labelLarge.color,
                          ),
                          child: Checkbox(
                            activeColor: themeData.canvasColor,
                            value: _doneAsk ??
                                _settings.failedPaymentBehavior !=
                                    BugReportBehavior.PROMPT,
                            onChanged: (v) {
                              setState(() {
                                _doneAsk = v;
                              });
                            },
                          ),
                        ),
                        Text(
                          texts.payment_failed_report_dialog_do_not_ask_again,
                          style: themeData.primaryTextTheme.displaySmall.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          SimpleDialogOption(
            onPressed: () {
              onSubmit(false);
              Navigator.pop(widget.context, false);
            },
            child: Text(
              texts.payment_failed_report_dialog_action_no,
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
          SimpleDialogOption(
            onPressed: (() async {
              onSubmit(true);
              Navigator.pop(widget.context, true);
            }),
            child: Text(
              texts.payment_failed_report_dialog_action_yes,
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  void onSubmit(bool yesNo) {
    var dontAsk =
        _doneAsk ?? _settings.failedPaymentBehavior != BugReportBehavior.PROMPT;
    if (dontAsk) {
      widget._accountBloc.accountSettingsSink.add(_settings.copyWith(
          failedPaymentBehavior: yesNo
              ? BugReportBehavior.SEND_REPORT
              : BugReportBehavior.IGNORE));
    }
  }
}
