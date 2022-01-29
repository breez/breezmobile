import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'keyboard_done_action.dart';

class EscherDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;

  const EscherDialog(
    this.context,
    this.accountBloc,
  );

  @override
  State<StatefulWidget> createState() {
    return EscherDialogState();
  }
}

class EscherDialogState extends State<EscherDialog> {
  final _dialogKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _invoiceAmountController = TextEditingController();
  final _amountFocusNode = FocusNode();

  KeyboardDoneAction _doneAction;

  @override
  void initState() {
    super.initState();
    _invoiceAmountController.addListener(() {
      setState(() {});
    });
    _doneAction = KeyboardDoneAction([_amountFocusNode]);
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _paymentRequestDialog = [];

    _addIfNotNull(_paymentRequestDialog, _buildPaymentRequestContent());
    return Dialog(
      child: Container(
        key: _dialogKey,
        width: context.mediaQuerySize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: _paymentRequestDialog,
        ),
      ),
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
        _addIfNotNull(children, _buildRequestPayTextWidget(context));
        _addIfNotNull(children, _buildAmountWidget(context, account));
        _addIfNotNull(children, _buildActions(context, account));

        return Container(
          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
          width: context.mediaQuerySize.width,
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

  Widget _buildRequestPayTextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 36, bottom: 8),
      child: Text(
        context.l10n.escher_cash_out_amount,
        style: context.primaryTextTheme.headline3.copyWith(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAmountWidget(BuildContext context, AccountModel account) {
    ThemeData themeData = context.theme;
    TextStyle dialogContentTextStyle = themeData.dialogTheme.contentTextStyle;
    Color hintColor = dialogContentTextStyle.color;
    Color primaryColor = themeData.textTheme.button.color;
    Color iconColor = themeData.primaryIconTheme.color;

    return Theme(
      data: themeData.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(borderSide: theme.greyBorderSide),
        ),
        hintColor: hintColor,
        colorScheme: ColorScheme.dark(primary: primaryColor),
        primaryColor: primaryColor,
        errorColor: theme.themeId == "BLUE" ? Colors.red : themeData.errorColor,
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Container(
            height: 80.0,
            child: AmountFormField(
              context: context,
              accountModel: account,
              iconColor: iconColor,
              focusNode: _amountFocusNode,
              controller: _invoiceAmountController,
              validatorFn: account.validateOutgoingPayment,
              style: dialogContentTextStyle.copyWith(height: 1.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, AccountModel account) {
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    TextStyle btnTextStyle = themeData.primaryTextTheme.button;

    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => context.pop(),
        child: Text(
          l10n.escher_action_cancel,
          style: btnTextStyle,
        ),
      ),
    ];

    final invoice = _invoiceAmountController.text ?? "";
    if (invoice.isNotEmpty) {
      var parsedAmount = account.currency.parse(invoice);
      if (account.validateOutgoingPayment(parsedAmount) == null) {
        actions.add(
          SimpleDialogOption(
            onPressed: () {
              context.pop();
              final satValue = Currency.SAT.format(
                parsedAmount,
                includeDisplayName: false,
                userInput: true,
              );
              launch(
                "https://hub.escher.app/cashout/breez?amount=$satValue",
                forceSafariVC: false,
                enableJavaScript: true,
              );
            },
            child: Text(
              l10n.escher_action_approve,
              style: btnTextStyle,
            ),
          ),
        );
      }
    }

    return Theme(
      data: themeData.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
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
