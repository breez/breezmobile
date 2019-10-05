import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'loading_animated_text.dart';

AlertDialog createAnimatedLoaderDialog(BuildContext context, String text, {bool withOKButton = true}){
  return  AlertDialog(
      contentPadding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new LoadingAnimatedText(
            text,
            textStyle: Theme.of(context).dialogTheme.contentTextStyle,
            textAlign: TextAlign.center,
          ),
          new Image.asset(
            'src/images/breez_loader.gif',
            height: 64.0,
            colorBlendMode: BlendMode.multiply,
            gaplessPlayback: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: withOKButton ? <Widget>[
              FlatButton(
                child: Text('OK', style: Theme.of(context).primaryTextTheme.button),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              )
            ] : [],
          )
        ],
      ),
    );
}