import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/lnurl.dart';
import 'package:breez/utils/node_id.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';

import 'flushbar.dart';

class EnterPaymentInfoDialog extends StatefulWidget {
  final BuildContext context;
  final InvoiceBloc invoiceBloc;
  final LNUrlBloc lnurlBloc;
  final GlobalKey firstPaymentItemKey;

  EnterPaymentInfoDialog(
    this.context,
    this.invoiceBloc,
    this.lnurlBloc,
    this.firstPaymentItemKey,
  );

  @override
  State<StatefulWidget> createState() {
    return EnterPaymentInfoDialogState();
  }
}

class EnterPaymentInfoDialogState extends State<EnterPaymentInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _paymentInfoController = TextEditingController();
  final _paymentInfoFocusNode = FocusNode();

  String _scannerErrorMessage = "";

  @override
  void initState() {
    super.initState();
    _paymentInfoController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text(
        context.l10n.payment_info_dialog_title,
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: _buildPaymentInfoForm(context),
      actions: _buildActions(context),
    );
  }

  Theme _buildPaymentInfoForm(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: theme.greyBorderSide,
          ),
        ),
        hintColor: Theme.of(context).dialogTheme.contentTextStyle.color,
        colorScheme: ColorScheme.dark(
          primary: Theme.of(context).textTheme.button.color,
        ),
        primaryColor: Theme.of(context).textTheme.button.color,
        errorColor: theme.themeId == "BLUE" ? Colors.red : Theme.of(context).errorColor,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: context.l10n.payment_info_dialog_hint,
                  suffixIcon: IconButton(
                    padding: EdgeInsets.only(top: 21.0),
                    alignment: Alignment.bottomRight,
                    icon: Image(
                      image: AssetImage("src/icon/qr_scan.png"),
                      color: Theme.of(context).primaryIconTheme.color,
                      fit: BoxFit.contain,
                      width: 24.0,
                      height: 24.0,
                    ),
                    tooltip: context.l10n.payment_info_dialog_barcode,
                    onPressed: () => _scanBarcode(context),
                  ),
                ),
                focusNode: _paymentInfoFocusNode,
                controller: _paymentInfoController,
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline4.color,
                ),
                validator: (value) {
                  if (parseNodeId(value) == null &&
                      _decodeInvoice(value) == null &&
                      !isLightningAddress(value)) {
                    return context.l10n.payment_info_dialog_error;
                  }
                  return null;
                },
              ),
              _scannerErrorMessage.length > 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _scannerErrorMessage,
                        style: theme.validatorStyle,
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  context.l10n.payment_info_dialog_hint_expanded,
                  style: theme.FieldTextStyle.labelStyle.copyWith(
                    fontSize: 13.0,
                    color: theme.themeId == "BLUE"
                        ? theme.BreezColors.grey[500]
                        : theme.BreezColors.white[200],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: Text(
          context.l10n.payment_info_dialog_action_cancel,
          style: Theme.of(context).primaryTextTheme.button,
        ),
      )
    ];

    if (_paymentInfoController.text.isNotEmpty) {
      actions.add(SimpleDialogOption(
        onPressed: (() async {
          if (_formKey.currentState.validate()) {
            Navigator.of(context).pop();
            var nodeID = parseNodeId(_paymentInfoController.text);
            if (nodeID != null) {
              Navigator.of(context).push(FadeInRoute(
                builder: (_) => SpontaneousPaymentPage(
                  nodeID,
                  widget.firstPaymentItemKey,
                ),
              ));
              return;
            }

            final lightningAddress = parseLightningAddress(
              _paymentInfoController.text,
            );
            if (lightningAddress != null) {
              widget.lnurlBloc.lnurlInputSink.add(lightningAddress);
              return;
            }

            if (_decodeInvoice(_paymentInfoController.text) != null) {
              widget.invoiceBloc.decodeInvoiceSink
                  .add(_paymentInfoController.text);
            }
          }
        }),
        child: Text(
          context.l10n.payment_info_dialog_action_approve,
          style: Theme.of(context).primaryTextTheme.button,
        ),
      ));
    }
    return actions;
  }

  Future _scanBarcode(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String barcode = await Navigator.pushNamed<String>(context, "/qr_scan");
    if (barcode == null) {
      return;
    }
    if (barcode.isEmpty) {
      showFlushbar(
        context,
        message: context.l10n.payment_info_dialog_error_qrcode,
      );
      return;
    }
    setState(() {
      _paymentInfoController.text = barcode;
      _scannerErrorMessage = "";
    });
  }

  String _decodeInvoice(String invoiceString) {
    String normalized = invoiceString?.toLowerCase();
    if (normalized == null) {
      return null;
    }
    if (normalized.startsWith("lightning:")) {
      normalized = normalized.substring(10);
    }
    if (normalized.startsWith("ln") && !normalized.startsWith("lnurl")) {
      return invoiceString;
    }
    return null;
  }
}
