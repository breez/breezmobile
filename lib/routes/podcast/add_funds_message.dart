import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/bottom_actions_bar.dart';
import 'package:breez/utils/build_context.dart';
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
    ThemeData themeData = context.theme;
    TextTheme textTheme = themeData.textTheme;
    double minFontSize = context.minFontSize;

    return Container(
      height: 64,
      color: themeData.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 12.0, bottom: 12.0, left: 24.0, right: 20.0),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                "Add funds to your balance to send payments to this podcast.",
                style: textTheme.bodyText2
                    .copyWith(letterSpacing: 0.25, height: 1.24),
                textAlign: TextAlign.start,
                minFontSize: minFontSize,
                stepGranularity: 0.1,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  primary: context.primaryColor,
                ),
                onPressed: () {
                  showReceiveOptions(
                      context, widget.accountModel, context.l10n);
                },
                child: AutoSizeText(
                  "ADD FUNDS",
                  minFontSize: minFontSize,
                  stepGranularity: 0.1,
                  maxLines: 1,
                  style: textTheme.bodyText2.copyWith(
                      color: Colors.white,
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
