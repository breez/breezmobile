import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/bottom_actions_bar.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class AddFundsMessage extends StatefulWidget {
  final AccountModel accountModel;

  const AddFundsMessage({Key key, this.accountModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddFundsMessageState();
  }
}

class AddFundsMessageState extends State<AddFundsMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 12.0, bottom: 12.0, left: 24.0, right: 20.0),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                "Add funds to your balance to send payments to this podcast.",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(letterSpacing: 0.25, height: 1.24),
                textAlign: TextAlign.start,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 100,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: () {
                  showReceiveOptions(context, widget.accountModel);
                },
                color: Theme.of(context).primaryColor,
                child: AutoSizeText(
                  "ADD FUNDS",
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                  maxLines: 1,
                  style: Theme.of(context).accentTextTheme.bodyText2.copyWith(
                      letterSpacing: 1,
                      height: 1.24,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
