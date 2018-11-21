import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:image/image.dart' as DartImage;
import 'package:breez/bloc/account/account_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PaymentRequestDialog extends StatelessWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final _transparentImage = DartImage.encodePng(DartImage.Image(300, 300));

  PaymentRequestDialog(this.context, this.accountBloc, this.invoice);

  @override
  Widget build(BuildContext context) {
    return showPaymentRequestDialog();
  }

  Widget showPaymentRequestDialog() {
    return new AlertDialog(
      titlePadding: EdgeInsets.only(top: 48.0),
      title: invoice.payeeImageURL.isEmpty
          ? null
          : Stack(alignment: Alignment(0.0, 0.0), children: <Widget>[
              CircularProgressIndicator(),
              ClipOval(
                child: FadeInImage(
                    width: 64.0,
                    height: 64.0,
                    placeholder: MemoryImage(_transparentImage),
                    image: AdvancedNetworkImage(invoice.payeeImageURL, useDiskCache: true),
                    fadeOutDuration: new Duration(milliseconds: 200),
                    fadeInDuration: new Duration(milliseconds: 200)),
              )
            ]),
      contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
        invoice.payeeName == null ? Container() : new Text(
          "${invoice.payeeName}",
          style: theme.paymentRequestTitleStyle,
          textAlign: TextAlign.center,
        ),
        invoice.payeeName == null || invoice.payeeName.isEmpty ? new Text(
          "You are requested to pay:",
          style: theme.paymentRequestSubtitleStyle,
          textAlign: TextAlign.center,
        ) : new Text(
          "is requesting you to pay:",
          style: theme.paymentRequestSubtitleStyle,
          textAlign: TextAlign.center,
        ),
        StreamBuilder<AccountModel>(
            stream: accountBloc.accountStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? new Text(
                      snapshot.data.currency.format(invoice.amount),
                      style: theme.paymentRequestAmountStyle,
                      textAlign: TextAlign.center,
                    )
                  : new Text(
                      invoice.amount.toRadixString(10) + " Sat",
                      style: theme.paymentRequestAmountStyle,
                      textAlign: TextAlign.center,
                    );
            }),
        invoice.description == null || invoice.description.isEmpty
            ? Container()
            : Padding(padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0), child: AutoSizeText(
          invoice.description,
          style: theme.paymentRequestSubtitleStyle,
          textAlign: invoice.description.length > 40 ? TextAlign.justify : TextAlign.center,
          maxLines: 3,
        ),),
        new Padding(padding: EdgeInsets.only(top: 24.0)),
        new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: new Text("CANCEL", style: theme.buttonStyle),
            ),
            new SimpleDialogOption(
              onPressed: (() {
                accountBloc.sentPaymentsSink.add(invoice.rawPayReq);
                Navigator.pop(context);
              }),
              child: new Text("APPROVE", style: theme.buttonStyle),
            ),
          ],
        ),
      ],),
    );
  }
}
