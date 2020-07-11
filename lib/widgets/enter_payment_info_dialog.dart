import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/node_id.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'keyboard_done_action.dart';

class EnterPaymentInfoDialog extends StatefulWidget {
  final BuildContext context;
  final InvoiceBloc invoiceBloc;
  final GlobalKey firstPaymentItemKey;

  EnterPaymentInfoDialog(
      this.context, this.invoiceBloc, this.firstPaymentItemKey);

  @override
  State<StatefulWidget> createState() {
    return EnterPaymentInfoDialogState();
  }
}

class EnterPaymentInfoDialogState extends State<EnterPaymentInfoDialog> {
  TextEditingController _paymentInfoController = TextEditingController();
  final FocusNode _paymentInfoFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  @override
  void initState() {
    super.initState();
    _paymentInfoController.addListener(() {
      setState(() {});
    });
    _doneAction = KeyboardDoneAction(<FocusNode>[_paymentInfoFocusNode]);
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text(
        "Enter Invoice or Node ID",
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: _buildPaymentInfoForm(context),
      actions: _buildActions(),
    );
  }

  Theme _buildPaymentInfoForm(BuildContext context) {
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
      child: TextField(
        focusNode: _paymentInfoFocusNode,
        controller: _paymentInfoController,
        style: TextStyle(
            color: Theme.of(context).primaryTextTheme.headline4.color),
      ),
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
      )
    ];

    if (_paymentInfoController.text.isNotEmpty) {
      actions.add(SimpleDialogOption(
        onPressed: (() async {
          Navigator.of(context).pop();
          var nodeID = parseNodeId(_paymentInfoController.text);
          if (nodeID == null) {
            widget.invoiceBloc.decodeInvoiceSink
                .add(_paymentInfoController.text);
          } else {
            Navigator.of(context).push(FadeInRoute(
              builder: (_) =>
                  SpontaneousPaymentPage(nodeID, widget.firstPaymentItemKey),
            ));
          }
        }),
        child:
            Text("APPROVE", style: Theme.of(context).primaryTextTheme.button),
      ));
    }
    return actions;
  }
}
