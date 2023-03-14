import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class SimpleSwitch extends StatelessWidget {
  final String text;
  final Widget trailing;
  final bool switchValue;
  final AutoSizeGroup group;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onChanged;

  const SimpleSwitch({
    Key key,
    this.text,
    this.trailing,
    this.switchValue,
    this.group,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AutoSizeText(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: group,
      ),
      trailing: trailing ??
          Switch(
            value: switchValue,
            activeColor: Colors.white,
            onChanged: onChanged,
          ),
      onTap: onTap,
    );
  }
}
