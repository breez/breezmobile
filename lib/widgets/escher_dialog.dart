import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/amount_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'keyboard_done_action.dart';

class EscherDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;

  EscherDialog(this.context, this.accountBloc);

  @override
  State<StatefulWidget> createState() {
    return EscherDialogState();
  }
}

class EscherDialogState extends State<EscherDialog> {
  final _dialogKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _invoiceAmountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  @override
  void initState() {
    super.initState();
    _invoiceAmountController.addListener(() {
      setState(() {});
    });
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPaymentRequestDialog();
  }

  Widget _buildPaymentRequestDialog() {
    List<Widget> _paymentRequestDialog = <Widget>[];
    _addIfNotNull(_paymentRequestDialog, _buildPaymentRequestContent());
    return Dialog(
      child: Container(
          key: _dialogKey,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: _paymentRequestDialog)),
    );
  }

  Widget _buildPaymentRequestContent() {
    return StreamBuilder<AccountModel>(
      stream: widget.accountBloc.accountStream,
      builder: (context, snapshot) {
        var account = snapshot.data;
        if (account == null) {
          return Container(width: 0.0, height: 0.0);
        }
        List<Widget> children = [];
        _addIfNotNull(children, _buildRequestPayTextWidget());
        _addIfNotNull(children, _buildAmountWidget(account));
        _addIfNotNull(children, _buildActions(account));

        return Container(
          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        );
      },
    );
  }

  void _addIfNotNull(List<Widget> widgets, Widget w) {
    if (w != null) {
      widgets.add(w);
    }
  }

  Widget _buildRequestPayTextWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 36, bottom: 8),
      child: Text(
        "Enter cash-out amount:",
        style:
            Theme.of(context).primaryTextTheme.headline3.copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAmountWidget(AccountModel account) {
    return Theme(
      data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder:
                  UnderlineInputBorder(borderSide: theme.greyBorderSide)),
          hintColor: Theme.of(context).dialogTheme.contentTextStyle.color,
          accentColor: Theme.of(context).textTheme.button.color,
          primaryColor: Theme.of(context).textTheme.button.color,
          errorColor: theme.themeId == "BLUE"
              ? Colors.red
              : Theme.of(context).errorColor),
      child: Form(
        autovalidate: true,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Container(
            height: 80.0,
            child: AmountFormField(
              context: context,
              accountModel: account,
              iconColor: Theme.of(context).primaryIconTheme.color,
              focusNode: _amountFocusNode,
              controller: _invoiceAmountController,
              validatorFn: account.validateOutgoingPayment,
              style: Theme.of(context)
                  .dialogTheme
                  .contentTextStyle
                  .copyWith(height: 1.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(AccountModel account) {
    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
      ),
    ];
    if (_invoiceAmountController.text.isNotEmpty) {
      var parsedAmount = account.currency.parse(_invoiceAmountController.text);
      if (account.validateOutgoingPayment(parsedAmount) == null) {
        actions.add(SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            var satValue = Currency.SAT.format(parsedAmount,
                includeDisplayName: false, userInput: true);
            launch("https://hub.escher.app/cashout/breez?amount=$satValue", forceSafariVC: false, enableJavaScript: true);
          },
          child:
              Text("APPROVE", style: Theme.of(context).primaryTextTheme.button),
        ));
      }
    }
    return Theme(
      data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ),
    );
  }
}
