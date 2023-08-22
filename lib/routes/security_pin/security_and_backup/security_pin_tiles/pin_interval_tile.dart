import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';

class PinIntervalTile extends StatefulWidget {
  final UserProfileBloc userProfileBloc;
  final AutoSizeGroup autoSizeGroup;
  final Function(bool) unlockScreen;

  const PinIntervalTile({
    @required this.userProfileBloc,
    @required this.autoSizeGroup,
    @required this.unlockScreen,
  });

  @override
  State<PinIntervalTile> createState() => _PinIntervalTileState();
}

class _PinIntervalTileState extends State<PinIntervalTile> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return StreamBuilder<BreezUserModel>(
        stream: widget.userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final securityModel = snapshot.data.securityModel;

          return ListTile(
            title: AutoSizeText(
              texts.security_and_backup_lock_automatically,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: widget.autoSizeGroup,
            ),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton(
                iconEnabledColor: Colors.white,
                value: securityModel.automaticallyLockInterval,
                isDense: true,
                onChanged: (int newValue) async {
                  await _updateSecurityModel(
                    securityModel.copyWith(automaticallyLockInterval: newValue),
                  );
                },
                items: SecurityModel.lockIntervals.map((int seconds) {
                  return DropdownMenuItem(
                    value: seconds,
                    child: AutoSizeText(
                      _formatSeconds(seconds),
                      style: theme.FieldTextStyle.textStyle,
                      maxLines: 1,
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }

  String _formatSeconds(int seconds) {
    final texts = context.texts();

    if (seconds == 0) {
      return texts.security_and_backup_lock_automatically_option_immediate;
    }
    const enLocale = EnglishDurationLocale();
    final locales = {
      "cs": const CzechDurationLocale(),
      "de": const GermanDurationLocale(),
      "el": enLocale, // TODO add GreekDurationLocale
      "en": enLocale,
      "es": const SpanishDurationLanguage(),
      "fi": const FinnishDurationLocale(),
      "fr": const FrenchDurationLocale(),
      "it": const ItalianDurationLocale(),
      "pt": const PortugueseBRDurationLanguage(),
      "sk": enLocale, // TODO add SlovakDurationLocale
      "sv": const SwedishDurationLanguage(),
    };
    return printDuration(
      Duration(seconds: seconds),
      locale: locales[texts.locale] ?? enLocale,
    );
  }

  Future _updateSecurityModel(SecurityModel newModel) async {
    widget.unlockScreen(false);
    var action = UpdateSecurityModel(newModel);
    widget.userProfileBloc.userActionsSink.add(action);
    return action.future;
  }
}
