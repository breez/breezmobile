import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/payment_request_dialog.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:image/image.dart' as DartImage;

import 'keyboard_done_action.dart';

class PaymentRequestInfoDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final Function(PaymentRequestState state) _onStateChange;
  final Function(double height) _setDialogHeight;
  final Function(Map map) _setAmountToPay;
  final _transparentImage = DartImage.encodePng(DartImage.Image(300, 300));

  PaymentRequestInfoDialog(this.context, this.accountBloc, this.invoice, this._onStateChange, this._setDialogHeight, this._setAmountToPay);

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestInfoDialogState();
  }
}

class PaymentRequestInfoDialogState extends State<PaymentRequestInfoDialog> {
  final _dialogKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _invoiceAmountController = new TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  Map<String, dynamic> _amountToPayMap = new Map<String, dynamic>();

  bool _showFiatCurrency = false;

  @override
  void initState() {
    super.initState();
    _invoiceAmountController.addListener(() {
      setState(() {});
    });
    _doneAction = new KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
  }

  @override void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPaymentRequestDialog();
  }

  Widget _buildPaymentRequestDialog() {
    List<Widget> _paymentRequestDialog = <Widget>[];
    _addIfNotNull(_paymentRequestDialog, _buildPaymentRequestTitle());
    _addIfNotNull(_paymentRequestDialog, _buildPaymentRequestContent());
    return Dialog(
        child: Container(
            key: _dialogKey,
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(minHeight: 220.0, maxHeight: 320.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: _paymentRequestDialog)),
        );
  }

  Widget _buildPaymentRequestTitle() {
    return widget.invoice.payeeImageURL.isEmpty
        ? null
        : Container(
            height: widget.invoice.payeeImageURL.isEmpty ? 64.0 : 128.0,
            padding: widget.invoice.payeeImageURL.isEmpty ? EdgeInsets.zero : EdgeInsets.only(top: 48.0),
            child: Stack(
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryTextTheme.button.color,
                    ),
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                ),
                Center(
                    child: ClipOval(
                  child: FadeInImage(
                      width: 64.0,
                      height: 64.0,
                      placeholder: MemoryImage(widget._transparentImage),
                      image: AdvancedNetworkImage(widget.invoice.payeeImageURL, useDiskCache: true),
                      fadeOutDuration: new Duration(milliseconds: 200),
                      fadeInDuration: new Duration(milliseconds: 200)),
                )),
              ],
            ));
  }

  Widget _buildPaymentRequestContent() {
    return StreamBuilder<AccountModel>(
      stream: widget.accountBloc.accountStream,
      builder: (context, snapshot) {
        var account = snapshot.data;
        if (account == null) {
          return new Container(width: 0.0, height: 0.0);
        }
        List<Widget> children = [];
        _addIfNotNull(children, _buildPayeeNameWidget());
        _addIfNotNull(children, _buildRequestPayTextWidget());
        _addIfNotNull(children, _buildAmountWidget(account));
        _addIfNotNull(children, _buildDescriptionWidget());
        _addIfNotNull(children, _buildErrorMessage(account));
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

  Widget _buildPayeeNameWidget() {
    return widget.invoice.payeeName == null
        ? null
        : Text(
            "${widget.invoice.payeeName}",
            style: Theme.of(context).primaryTextTheme.display1.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          );
  }

  Widget _buildRequestPayTextWidget() {
    return widget.invoice.payeeName == null || widget.invoice.payeeName.isEmpty
        ? new Text(
            "You are requested to pay:",
            style: Theme.of(context).primaryTextTheme.display2.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          )
        : new Text(
            "is requesting you to pay:",
            style: Theme.of(context).primaryTextTheme.display2.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          );
  }

  Widget _buildAmountWidget(AccountModel account) {
    if (widget.invoice.amount == 0) {
      return Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(enabledBorder: UnderlineInputBorder(borderSide: theme.greyBorderSide)),
          hintColor: Theme.of(context).dialogTheme.contentTextStyle.color,
          accentColor: Theme.of(context).textTheme.button.color,
          primaryColor: Theme.of(context).textTheme.button.color,
          errorColor: theme.themeId == "BLUE" ? Colors.red : Theme.of(context).errorColor),
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
                  style: Theme.of(context).dialogTheme.contentTextStyle.copyWith(height: 1.0),
                ),
              ),
            ),
          ),
      );
    }
    return GestureDetector(
      child: new ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Text(
          _showFiatCurrency && account.fiatCurrency != null
              ? "${account.fiatCurrency.format(widget.invoice.amount)}"
              : account.currency.format(widget.invoice.amount),
          style: Theme.of(context).primaryTextTheme.headline,
          textAlign: TextAlign.center,
        ),
      ),
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
    );
  }

  Widget _buildDescriptionWidget() {
    return widget.invoice.description == null || widget.invoice.description.isEmpty
        ? null
        : Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: AutoSizeText(
              widget.invoice.description,
              style: Theme.of(context).primaryTextTheme.display2.copyWith(fontSize: 16),
              textAlign: widget.invoice.description.length > 40 ? TextAlign.justify : TextAlign.center,
              maxLines: 3,
            ),
          );
  }

  Widget _buildErrorMessage(AccountModel account) {
    String validationError = account.validateOutgoingPayment(amountToPay(account));
    if (validationError == null || widget.invoice.amount == 0) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: AutoSizeText(validationError,
          maxLines: 3, textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.display2.copyWith(fontSize: 16, color: theme.themeId == "BLUE" ? Colors.red : Theme.of(context).errorColor)),
    );
  }

  Widget _buildActions(AccountModel account) {
    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => widget._onStateChange(PaymentRequestState.USER_CANCELLED),
        child: new Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
      )
    ];

    Int64 toPay = amountToPay(account);
    if (toPay > 0 && account.maxAllowedToPay >= toPay) {
      actions.add(SimpleDialogOption(
        onPressed: (() async {
          if (widget.invoice.amount > 0 || _formKey.currentState.validate()) {
            widget._setDialogHeight(_getDialogSize());
            if (widget.invoice.amount == 0) {
              _amountToPayMap["_amountToPay"] = toPay;
              _amountToPayMap["_amountToPayStr"] = account.currency.format(amountToPay(account));
              widget._setAmountToPay(_amountToPayMap);
              widget._onStateChange(PaymentRequestState.WAITING_FOR_CONFIRMATION);
            } else {
              widget.accountBloc.userActionsSink.add(SendPayment(PayRequest(widget.invoice.rawPayReq, amountToPay(account))));
              widget._onStateChange(PaymentRequestState.PROCESSING_PAYMENT);
            }
          }
        }),
        child: new Text("APPROVE", style: Theme.of(context).primaryTextTheme.button),
      ));
    }
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
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

  double _getDialogSize() {
    RenderBox _dialogBox = _dialogKey.currentContext.findRenderObject();
    return _dialogBox.size.height;
  }

  Int64 amountToPay(AccountModel acc) {
    Int64 amount = widget.invoice.amount;
    if (amount == 0) {
      try {
        amount = acc.currency.parse(_invoiceAmountController.text);
      } catch (e) {}
    }
    return amount;
  }
}
