import 'package:clovrlabs_wallet/bloc/invoice/invoice_bloc.dart';
import 'package:clovrlabs_wallet/bloc/lnurl/lnurl_bloc.dart';
import 'package:clovrlabs_wallet/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/utils/lnurl.dart';
import 'package:clovrlabs_wallet/utils/node_id.dart';
import 'package:clovrlabs_wallet/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text(
        texts.payment_info_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: _buildPaymentInfoForm(context),
      actions: _buildActions(context),
    );
  }

  Theme _buildPaymentInfoForm(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return Theme(
      data: themeData.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: theme.greyBorderSide,
          ),
        ),
        hintColor: themeData.dialogTheme.contentTextStyle.color,
        colorScheme: ColorScheme.dark(
          primary: themeData.textTheme.button.color,
        ),
        primaryColor: themeData.textTheme.button.color,
        errorColor: theme.themeId == "WHITE" ? Colors.red : themeData.errorColor,
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
                  labelText: texts.payment_info_dialog_hint,
                  suffixIcon: IconButton(
                    padding: EdgeInsets.only(top: 21.0),
                    alignment: Alignment.bottomRight,
                    icon: Image(
                      image: AssetImage("src/icon/qr_scan.png"),
                      color: themeData.primaryIconTheme.color,
                      fit: BoxFit.contain,
                      width: 24.0,
                      height: 24.0,
                    ),
                    tooltip: texts.payment_info_dialog_barcode,
                    onPressed: () => _scanBarcode(context),
                  ),
                ),
                focusNode: _paymentInfoFocusNode,
                controller: _paymentInfoController,
                style: TextStyle(
                  color: themeData.primaryTextTheme.headline4.color,
                ),
                validator: (value) {
                  if (parseNodeId(value) == null &&
                      _decodeInvoice(value) == null &&
                      !isLightningAddress(value)) {
                    return texts.payment_info_dialog_error;
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
                  texts.payment_info_dialog_hint_expanded,
                  style: theme.FieldTextStyle.labelStyle.copyWith(
                    fontSize: 13.0,
                    color: theme.themeId == "WHITE"
                        ? theme.ClovrLabsWalletColors.grey[500]
                        : theme.ClovrLabsWalletColors.white[200],
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
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.payment_info_dialog_action_cancel,
          style: themeData.primaryTextTheme.button,
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
                  .add('LNBCRT1P34TNQ3PP5P3V6QM2QPNM466429H7Q4CRUZHWGH8H9PLQXVCH96W4Q07DU9KSSDQQCQZPGXQRRSSSP5PFMZJZRDDTJ9ULCTF76RRDNPFUX8R90JGMJX09VXU56EK4UGZ0US9QYYSSQ3QKCWJW6WQUJ2AGHLYSMLLRWEMQZMX8ZNLCNQ7LG9ASC0DRQFNYS9RZH62ZV2TXVZKMF7K65Z28SCN50KV4AJNVXRUX8E5V30TFE8GCPDMUPKP');
            }
          }
        }),
        child: Text(
          texts.payment_info_dialog_action_approve,
          style: themeData.primaryTextTheme.button,
        ),
      ));
    }
    return actions;
  }

  Future _scanBarcode(BuildContext context) async {
    final texts = AppLocalizations.of(context);

    FocusScope.of(context).requestFocus(FocusNode());
    String barcode = await Navigator.pushNamed<String>(context, "/qr_scan");
    if (barcode == null) {
      return;
    }
    if (barcode.isEmpty) {
      showFlushbar(
        context,
        message: texts.payment_info_dialog_error_qrcode,
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
