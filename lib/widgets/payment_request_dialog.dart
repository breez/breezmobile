import 'package:breez/widgets/amount_form_field.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:image/image.dart' as DartImage;
import 'package:breez/bloc/account/account_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PaymentRequestDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final _transparentImage = DartImage.encodePng(DartImage.Image(300, 300));

  PaymentRequestDialog(this.context, this.accountBloc, this.invoice);

  @override
  State<StatefulWidget> createState() {    
    return PaymentRequestDialogState();
  }
}

class PaymentRequestDialogState extends State<PaymentRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _invoiceAmountController = new TextEditingController();

  @override
  void initState() {    
    super.initState();
    _invoiceAmountController.addListener((){
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return showPaymentRequestDialog();
  }

  Widget showPaymentRequestDialog() {
    return new AlertDialog(
      titlePadding: EdgeInsets.only(top: 48.0),
      title: widget.invoice.payeeImageURL.isEmpty
          ? null
          : Stack(alignment: Alignment(0.0, 0.0), children: <Widget>[
              CircularProgressIndicator(),
              ClipOval(
                child: FadeInImage(
                    width: 64.0,
                    height: 64.0,
                    placeholder: MemoryImage(widget._transparentImage),
                    image: AdvancedNetworkImage(widget.invoice.payeeImageURL,
                        useDiskCache: true),
                    fadeOutDuration: new Duration(milliseconds: 200),
                    fadeInDuration: new Duration(milliseconds: 200)),
              )
            ]),
      contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      content: StreamBuilder<AccountModel>(
        stream: widget.accountBloc.accountStream,
        builder: (context, snapshot) {
          var account = snapshot.data;
          if (account == null) {
            return Container();
          }
          List<Widget> children = [];
          _addIfNotNull(children, _buildPayeeNameWidget());
          _addIfNotNull(children, _buildRequestPayTextWidget());
          _addIfNotNull(children, _buildAmountWidget(account));
          _addIfNotNull(children, _buildDescriptionWidget());
          _addIfNotNull(children, _buildErrorMessage(account));
          _addIfNotNull(children, _buildActions(account));

          return Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          );
        },
      ),
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
            style: theme.paymentRequestTitleStyle,
            textAlign: TextAlign.center,
          );
  }

  Widget _buildErrorMessage(AccountModel account) {
    if (account.maxAllowedToPay >= amountToPay || widget.invoice.amount == 0) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: AutoSizeText("Not enough funds to complete this payment",
          maxLines: 3,
          textAlign: TextAlign.center,
          style: theme.paymentRequestSubtitleStyle.copyWith(color: Colors.red)),
    );
  }

  Widget _buildRequestPayTextWidget() {
    return widget.invoice.payeeName == null || widget.invoice.payeeName.isEmpty
        ? new Text(
            "You are requested to pay:",
            style: theme.paymentRequestSubtitleStyle,
            textAlign: TextAlign.center,
          )
        : new Text(
            "is requesting you to pay:",
            style: theme.paymentRequestSubtitleStyle,
            textAlign: TextAlign.center,
          );
  }

  Widget _buildAmountWidget(AccountModel account) {
    if (widget.invoice.amount == 0) {
      return Theme(
        data: Theme.of(context).copyWith(
          hintColor: theme.alertStyle.color,
          accentColor: theme.BreezColors.blue[500],
          primaryColor: theme.BreezColors.blue[500],
          errorColor: Colors.red),        
          child: Form(            
            autovalidate: true,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Container(
                height: 80.0,
                child: AmountFormField(                
                  style: theme.alertStyle.copyWith(height: 1.0),
                  maxPaymentAmount: account.maxPaymentAmount,
                  currency: account.currency,
                  controller: _invoiceAmountController,
                  maxAmount: account.maxAllowedToPay - account.routingNodeFee,
                  decoration: new InputDecoration(
                      labelText: account.currency.displayName +
                          " Amount"),
                ),
              ),
            ),          
        ),
      );
    }
    return Text(
      account.currency.format(widget.invoice.amount),
      style: theme.paymentRequestAmountStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescriptionWidget() {
    return widget.invoice.description == null || widget.invoice.description.isEmpty
        ? null
        : Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: AutoSizeText(
              widget.invoice.description,
              style: theme.paymentRequestSubtitleStyle,
              textAlign: widget.invoice.description.length > 40
                  ? TextAlign.justify
                  : TextAlign.center,
              maxLines: 3,
            ),
          );
  }

  Widget _buildActions(AccountModel account) {
    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: new Text("CANCEL", style: theme.buttonStyle),
      )
    ];
    
    if (account.maxAllowedToPay >= amountToPay) {
      actions.add(SimpleDialogOption(
        onPressed: (() {
          if (widget.invoice.amount > 0 || _formKey.currentState.validate()) {           
            widget.accountBloc.sentPaymentsSink.add(PayRequest(widget.invoice.rawPayReq, amountToPay));
            Navigator.pop(context);
          }
        }),
        child: new Text("APPROVE", style: theme.buttonStyle),
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions,
      ),
    );
  } 

  Int64 get amountToPay {
    Int64 amount = widget.invoice.amount;
    if (amount == 0) {
      try {
        amount = Int64.parseInt(_invoiceAmountController.text);
      } catch (e) {}
    }
    return amount;
  }
}
