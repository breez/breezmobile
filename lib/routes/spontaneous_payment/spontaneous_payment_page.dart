import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/collapsible_list_item.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/processsing_payment_dialog.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpontaneousPaymentPage extends StatefulWidget {
  final String nodeID;
  final GlobalKey firstPaymentItemKey;

  const SpontaneousPaymentPage(this.nodeID, this.firstPaymentItemKey);

  @override
  State<StatefulWidget> createState() {
    return SpontaneousPaymentPageState();
  }
}

class SpontaneousPaymentPageState extends State<SpontaneousPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;
  ModalRoute _currentRoute;

  @override
  void initState() {
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentRoute == null) {
      _currentRoute = ModalRoute.of(context);
    }
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = "Send Payment";
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return Scaffold(
      bottomNavigationBar: StreamBuilder<AccountModel>(
          stream: accountBloc.accountStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return StaticLoader();
            }
            var account = snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SingleButtonBottomBar(
                stickToBottom: true,
                text: "PAY",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _sendPayment(accountBloc, account);
                  }
                },
              ),
            );
          }),
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: Text(_title,
            style: Theme.of(context).appBarTheme.textTheme.headline6),
        elevation: 0.0,
      ),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          AccountModel acc = snapshot.data;
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildNodeIdDescription(),
                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    maxLength: 90,
                    maxLengthEnforced: true,
                    decoration: InputDecoration(
                      labelText: "Tip Message (optional)",
                    ),
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  AmountFormField(
                      context: context,
                      accountModel: acc,
                      focusNode: _amountFocusNode,
                      controller: _amountController,
                      validatorFn: acc.validateOutgoingPayment,
                      style: theme.FieldTextStyle.textStyle),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    padding: EdgeInsets.only(top: 16.0),
                    child: _buildPayableBTC(acc),
                  ),
                  StreamBuilder(
                      stream: accountBloc.accountStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<AccountModel> accSnapshot) {
                        if (!accSnapshot.hasData) {
                          return Container();
                        }
                        AccountModel acc = accSnapshot.data;

                        String message;
                        if (accSnapshot.hasError) {
                          message = accSnapshot.error.toString();
                        } else if (acc.processingConnection) {
                          message =
                              'You will be able to receive payments after Breez is finished opening a secure channel with our server. This usually takes ~10 minutes to be completed. Please try again in a couple of minutes.';
                        }

                        if (message != null) {
                          return Container(
                              padding: EdgeInsets.only(
                                  top: 50.0, left: 30.0, right: 30.0),
                              child: Column(children: <Widget>[
                                Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: theme.warningStyle.copyWith(
                                      color: Theme.of(context).errorColor),
                                ),
                              ]));
                        } else {
                          return SizedBox();
                        }
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPayableBTC(AccountModel acc) {
    return GestureDetector(
      child: AutoSizeText(
        "Pay up to: ${acc.currency.format(acc.maxAllowedToPay)}",
        style: theme.textStyle,
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
      ),
      onTap: () => _amountController.text = acc.currency.format(
          acc.maxAllowedToPay,
          includeDisplayName: false,
          userInput: true),
    );
  }

  Widget _buildNodeIdDescription() {
    return CollapsibleListItem(
        title: "Node ID", sharedValue: widget.nodeID, color: Colors.white);
  }

  Future _sendPayment(AccountBloc accBloc, AccountModel account) async {
    String tipMessage = _descriptionController.text;
    var amount = account.currency.parse(_amountController.text);
    var ok = await promptAreYouSure(context, "Send Payment",
        Text("Are you sure you want to ${account.currency.format(amount)} to this node?\n\n${this.widget.nodeID}"),
        okText: "Pay", cancelText: "Cancel");
    if (ok) {
      var sendAction =
          SendSpontaneousPayment(widget.nodeID, amount, tipMessage);
      accBloc.userActionsSink.add(sendAction);
      try {
        String paymentHash = await sendAction.future;
        showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (_) => ProcessingPaymentDialog(
                  context,
                  paymentHash,
                  accBloc,
                  widget.firstPaymentItemKey,
                  300,
                  (_) {},
                  popOnCompletion: true,
                ));
        Navigator.of(context).removeRoute(_currentRoute);
      } catch (err) {
        promptError(
            context,
            "Payment Error",
            Text(
              err.toString(),
              style: Theme.of(context).dialogTheme.contentTextStyle,
            ));
      }
    }
  }
}
