import 'package:flutter/material.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;

class InputDecorationWallet extends InputDecoration {
  InputDecorationWallet({
    Key key,
    String labelText,
    String hintText,
    UnderlineInputBorder enabledBorder,
    UnderlineInputBorder focusedBorder,
    TextStyle style,
  }) : super(
          labelText: labelText,
          hintText: hintText,
          enabledBorder: enabledBorder = UnderlineInputBorder(
            borderSide:
                BorderSide(color: theme.ClovrLabsWalletColors.white[200]),
          ),
          focusedBorder: focusedBorder = UnderlineInputBorder(
            borderSide:
                BorderSide(color: theme.ClovrLabsWalletColors.white[200]),
          ),
          labelStyle: style =
              TextStyle(color: theme.ClovrLabsWalletColors.white[200]),
        );
}
