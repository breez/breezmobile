import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/bottom_actions_bar.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class AddFundsMessage extends StatelessWidget {
  final AccountModel accountModel;

  const AddFundsMessage({
    Key key,
    this.accountModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final minFontSize = MinFontSize(context).minFontSize;

    return Container(
      height: 64,
      color: themeData.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 12.0, 20.0, 12.0),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                texts.podcast_add_funds_title,
                style: themeData.textTheme.bodyMedium.copyWith(
                  letterSpacing: 0.25,
                  height: 1.24,
                ),
                textAlign: TextAlign.start,
                minFontSize: minFontSize,
                stepGranularity: 0.1,
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  backgroundColor: themeData.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                onPressed: () => showReceiveOptions(context, accountModel),
                child: AutoSizeText(
                  texts.podcast_add_funds_action_add,
                  minFontSize: minFontSize,
                  stepGranularity: 0.1,
                  maxLines: 1,
                  style: themeData.textTheme.bodyMedium.copyWith(
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
