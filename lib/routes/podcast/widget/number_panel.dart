import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class NumberPanel extends StatelessWidget {
  final String topLabel;
  final String bottomLabel;
  final double width;
  final double innerWidth;
  final Function onTap;

  const NumberPanel({
    Key key,
    this.topLabel,
    this.bottomLabel,
    this.width,
    this.innerWidth,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const stepGranularity = 0.1;
    var minFontSize = 9.0 / MediaQuery.of(context).textScaleFactor;
    minFontSize = minFontSize - (minFontSize % stepGranularity);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: innerWidth,
              height: 20,
              child: AutoSizeText(
                topLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.3,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                minFontSize: minFontSize,
                stepGranularity: stepGranularity,
                maxLines: 1,
              ),
            ),
            AutoSizeText(
              bottomLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                letterSpacing: 1,
              ),
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: stepGranularity,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
