import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NostrGetDialogContent extends StatefulWidget {
  final String textContent;
  final String choiceType;

  const NostrGetDialogContent({Key key, this.textContent, this.choiceType})
      : super(key: key);

  @override
  State<NostrGetDialogContent> createState() => _NostrGetDialogContentState();
}

class _NostrGetDialogContentState extends State<NostrGetDialogContent> {
  bool _rememberChoice = false;

  void _handleRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember${widget.choiceType}Choice', value);
    setState(() {
      _rememberChoice = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 12.0),
          child: Text(
            widget.textContent,
            style: themeData.primaryTextTheme.displaySmall.copyWith(
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
          child: Row(
            children: [
              Theme(
                data: themeData.copyWith(
                  unselectedWidgetColor: themeData.textTheme.labelLarge.color,
                ),
                child: Checkbox(
                  activeColor: themeData.canvasColor,
                  value: _rememberChoice,
                  onChanged: _handleRememberMe,
                ),
              ),
              Text(
                'Don\'t prompt again',
                style: themeData.primaryTextTheme.displaySmall.copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
