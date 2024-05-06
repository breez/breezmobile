import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/marketplace/nostr_settings.dart';
import 'package:flutter/material.dart';

class NostrGetDialogContent extends StatefulWidget {
  final String textContent;
  final String choiceType;
  final AsyncSnapshot<NostrSettings> streamSnapshot;
  final MarketplaceBloc bloc;

  const NostrGetDialogContent({Key key, this.textContent, this.choiceType, this.streamSnapshot, this.bloc})
      : super(key: key);

  @override
  State<NostrGetDialogContent> createState() => _NostrGetDialogContentState();
}

class _NostrGetDialogContentState extends State<NostrGetDialogContent> {
  @override
  Widget build(BuildContext context) {
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
                  value: widget.choiceType == "GetPubKey"
                      ? widget.streamSnapshot.data.isRememberPubKey
                      : widget.streamSnapshot.data.isRememberSignEvent,
                  onChanged: (value) {
                    var currentSettings = widget.streamSnapshot.data;
                    if (widget.choiceType == "GetPubKey") {
                      widget.bloc.nostrSettingsSettingsSink.add(currentSettings.copyWith(
                        isRememberPubKey: value,
                      ));
                    } else if (widget.choiceType == "SignEvent") {
                      widget.bloc.nostrSettingsSettingsSink.add(currentSettings.copyWith(
                        isRememberSignEvent: value,
                      ));
                    }
                  },
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
