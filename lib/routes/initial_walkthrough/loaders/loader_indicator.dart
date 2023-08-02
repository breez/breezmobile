import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';

class LoaderIndicator extends StatelessWidget {
  final String message;

  const LoaderIndicator({
    Key key,
    this.message = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message.isEmpty
        ? const Loader()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Loader(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: LoadingAnimatedText(message),
              )
            ],
          );
  }
}
