import 'package:flutter/widgets.dart';

mixin HandlerContextProvider<T extends StatefulWidget> on State<T> {
  BuildContext getBuildContext() {
    return context;
  }
}
