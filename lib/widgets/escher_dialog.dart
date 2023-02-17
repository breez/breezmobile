import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/amount_form_field.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    List<Widget> paymentRequestDialog = [];

    _addIfNotNull(paymentRequestDialog, _buildPaymentRequestContent());
    return Dialog(
      child: SizedBox(
        key: _dialogKey,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: paymentRequestDialog,
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
          return const SizedBox(width: 0.0, height: 0.0);
        }

        List<Widget> children = [];
        _addIfNotNull(children, _buildRequestPayTextWidget(context));
        _addIfNotNull(children, _buildAmountWidget(context, account));
        _addIfNotNull(children, _buildActions(context, account));

        return Container(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
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

  Widget _buildRequestPayTextWidget(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 8),
      child: Text(
        texts.escher_cash_out_amount,
        style: themeData.primaryTextTheme.displaySmall.copyWith(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAmountWidget(BuildContext context, AccountModel account) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: theme.greyBorderSide,
          ),
        ),
        hintColor: themeData.dialogTheme.contentTextStyle.color,
        primaryColor: themeData.textTheme.labelLarge.color,
        colorScheme: ColorScheme.dark(
          primary: themeData.textTheme.labelLarge.color,
          error: theme.themeId == "BLUE"
              ? Colors.red
              : themeData.colorScheme.error,
        ),
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: SizedBox(
            height: 80.0,
            child: AmountFormField(
              context: context,
              texts: texts,
              accountModel: account,
              iconColor: themeData.primaryIconTheme.color,
              focusNode: _amountFocusNode,
              controller: _invoiceAmountController,
              validatorFn: account.validateOutgoingPayment,
              style: themeData.dialogTheme.contentTextStyle.copyWith(
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, AccountModel account) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.escher_action_cancel,
          style: themeData.primaryTextTheme.labelLarge,
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
              Navigator.pop(context);
              final satValue = Currency.SAT.format(
                parsedAmount,
                includeDisplayName: false,
                userInput: true,
              );
              launchUrlString(
                'https://hub.escher.app/cashout/breez?amount=$satValue',
              );
            },
            child: Text(
              texts.escher_action_approve,
              style: themeData.primaryTextTheme.labelLarge,
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
