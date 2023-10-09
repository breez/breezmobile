import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/breez_avatar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'keyboard_done_action.dart';

class PaymentRequestInfoDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final Function() _onCancel;
  final Function() _onWaitingConfirmation;
  final Function(SendPayment) _onPaymentApproved;
  final Function(Map map) _setAmountToPay;
  final double minHeight;

  const PaymentRequestInfoDialog(
    this.context,
    this.accountBloc,
    this.invoice,
    this._onCancel,
    this._onWaitingConfirmation,
    this._onPaymentApproved,
    this._setAmountToPay,
    this.minHeight,
  );

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestInfoDialogState();
  }
}

class PaymentRequestInfoDialogState extends State<PaymentRequestInfoDialog> {
  final _dialogKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _invoiceAmountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _amountToPayMap = <String, dynamic>{};

  KeyboardDoneAction _doneAction;
  bool _showFiatCurrency = false;

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
    _addIfNotNull(paymentRequestDialog, _buildPaymentRequestTitle());
    _addIfNotNull(paymentRequestDialog, _buildPaymentRequestContent());
    return Dialog(
      child: Container(
        constraints: BoxConstraints(minHeight: widget.minHeight),
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

  Widget _buildPaymentRequestTitle() {
    return widget.invoice.payeeImageURL.isEmpty
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 48, bottom: 8),
            child: BreezAvatar(
              widget.invoice.payeeImageURL,
              radius: 32.0,
            ),
          );
  }

  Widget _buildPaymentRequestContent() {
    return StreamBuilder<AccountModel>(
      stream: widget.accountBloc.accountStream,
      builder: (context, snapshot) {
        final account = snapshot.data;
        if (account == null) {
          return const SizedBox(width: 0.0, height: 0.0);
        }

        List<Widget> children = [];
        _addIfNotNull(children, _buildPayeeNameWidget());
        _addIfNotNull(children, _buildRequestPayTextWidget());
        _addIfNotNull(children, _buildAmountWidget(account));
        _addIfNotNull(children, _buildDescriptionWidget());
        _addIfNotNull(children, _buildErrorMessage(account));
        _addIfNotNull(children, _buildActions(account));

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

  Widget _buildPayeeNameWidget() {
    return widget.invoice.payeeName == null
        ? null
        : Text(
            widget.invoice.payeeName,
            style: Theme.of(context)
                .primaryTextTheme
                .headlineMedium
                .copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          );
  }

  Widget _buildRequestPayTextWidget() {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final payeeName = widget.invoice.payeeName;

    return Text(
      payeeName == null || payeeName.isEmpty
          ? texts.payment_request_dialog_requested
          : texts.payment_request_dialog_requesting,
      style: themeData.primaryTextTheme.displaySmall.copyWith(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAmountWidget(AccountModel account) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    if (widget.invoice.amount == 0) {
      return Theme(
        data: themeData.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: theme.greyBorderSide,
            ),
          ),
          hintColor: themeData.dialogTheme.contentTextStyle.color,
          colorScheme: ColorScheme.dark(
            primary: themeData.textTheme.labelLarge.color,
            error: theme.themeId == "BLUE"
                ? Colors.red
                : themeData.colorScheme.error,
          ),
          primaryColor: themeData.textTheme.labelLarge.color,
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
                style: themeData.dialogTheme.contentTextStyle
                    .copyWith(height: 1.0),
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (_) {
        setState(() {
          _showFiatCurrency = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _showFiatCurrency = false;
        });
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: Text(
          _showFiatCurrency && account.fiatCurrency != null
              ? account.fiatCurrency.format(widget.invoice.amount)
              : account.currency.format(widget.invoice.amount),
          style: themeData.primaryTextTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDescriptionWidget() {
    final themeData = Theme.of(context);
    final description = widget.invoice.description;

    return description == null || description.isEmpty
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
                minWidth: double.infinity,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: AutoSizeText(
                    description,
                    style: themeData.primaryTextTheme.displaySmall
                        .copyWith(fontSize: 16),
                    textAlign:
                        description.length > 40 && !description.contains("\n")
                            ? TextAlign.start
                            : TextAlign.center,
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildErrorMessage(AccountModel account) {
    final validationError = account.validateOutgoingPayment(
      amountToPay(account),
    );
    if (validationError == null || widget.invoice.amount == 0) {
      return null;
    }

    final themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: AutoSizeText(
        validationError,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: themeData.primaryTextTheme.displaySmall.copyWith(
          fontSize: 16,
          color: theme.themeId == "BLUE"
              ? Colors.red
              : themeData.colorScheme.error,
        ),
      ),
    );
  }

  Widget _buildActions(AccountModel account) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => widget._onCancel(),
        child: Text(
          texts.payment_request_dialog_action_cancel,
          style: themeData.primaryTextTheme.labelLarge,
        ),
      )
    ];

    Int64 toPay = amountToPay(account);
    if (toPay > 0 && account.maxAllowedToPay >= toPay) {
      actions.add(SimpleDialogOption(
        onPressed: (() async {
          if (widget.invoice.amount > 0 || _formKey.currentState.validate()) {
            if (widget.invoice.amount == 0) {
              _amountToPayMap["_amountToPay"] = toPay;
              _amountToPayMap["_amountToPayStr"] =
                  account.currency.format(amountToPay(account));
              widget._setAmountToPay(_amountToPayMap);
              widget._onWaitingConfirmation();
            } else {
              widget._onPaymentApproved(SendPayment(
                PayRequest(
                  widget.invoice.rawPayReq,
                  amountToPay(account),
                ),
              ));
            }
          }
        }),
        child: Text(
          texts.payment_request_dialog_action_approve,
          style: themeData.primaryTextTheme.labelLarge,
        ),
      ));
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

  Int64 amountToPay(AccountModel acc) {
    Int64 amount = widget.invoice.amount;
    if (amount == 0) {
      try {
        amount = acc.currency.parse(_invoiceAmountController.text);
      } catch (e) {
        // do nothing.
      }
    }
    return amount;
  }
}
