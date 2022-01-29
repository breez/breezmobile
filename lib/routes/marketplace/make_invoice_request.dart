import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/utils/build_context.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class MakeInvoiceRequest extends StatelessWidget {
  final AccountModel account;
  final int amount;
  final String description;

  const MakeInvoiceRequest(
      {Key key, this.amount, this.description, this.account})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme primaryTextTheme = context.primaryTextTheme;
    List<Widget> children = [
      Text("This site wants to pay you:",
          style: primaryTextTheme.headline3.copyWith(fontSize: 16),
          textAlign: TextAlign.center),
      Text(account.currency.format(Int64(amount)),
          style: primaryTextTheme.headline5, textAlign: TextAlign.center)
    ];

    if (description != null && description.isEmpty) {
      children.add(Padding(
        padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        child: AutoSizeText(
          description,
          style: primaryTextTheme.headline3.copyWith(fontSize: 16),
          textAlign:
              description.length > 40 ? TextAlign.justify : TextAlign.center,
          maxLines: 3,
        ),
      ));
    }

    children.add(Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => context.pop(false),
            child: Text("CANCEL", style: primaryTextTheme.button),
          ),
          SimpleDialogOption(
            onPressed: () => context.pop(true),
            child: Text("APPROVE", style: primaryTextTheme.button),
          )
        ],
      ),
    ));

    return Dialog(
      child: Container(
          width: context.mediaQuerySize.width,
          constraints: BoxConstraints(minHeight: 220.0, maxHeight: 350.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: children)),
    );
  }
}
