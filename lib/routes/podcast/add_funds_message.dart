import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/bottom_actions_bar.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFundsMessage extends StatelessWidget {
  final AccountModel accountModel;

  const AddFundsMessage({
    Key key,
    this.accountModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final minFontSize = MinFontSize(context).minFontSize;

    return Container(
      height: 64,
      color: themeData.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 12.0, 20.0, 12.0),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                texts.podcast_add_funds_title,
                style: themeData.textTheme.bodyText2.copyWith(
                  letterSpacing: 0.25,
                  height: 1.24,
                ),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  backgroundColor: themeData.primaryColor,
                ),
                onPressed: () => showReceiveOptions(context, accountModel),
                child: AutoSizeText(
                  texts.podcast_add_funds_action_add,
                  minFontSize: minFontSize,
                  stepGranularity: 0.1,
                  maxLines: 1,
                  style: themeData.textTheme.bodyText2.copyWith(
                    color: Colors.white,
                    letterSpacing: 1,
                    height: 1.24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
