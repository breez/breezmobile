import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class BitrefillPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new BitrefillPageState();
  }
}

class BitrefillPageState extends State<BitrefillPage> {
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
          title: new Text(
            "Hey",
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0,
        ),
        body: Stack(children: <Widget>[Center(child: Container(child: Text("Hello"),),)],));
  }
}

class SessionErrorWidget extends StatelessWidget {
  final Object _error;

  const SessionErrorWidget(this._error);

  @override
  Widget build(BuildContext context) {
    return Text("Failed connecting to session: ${_error.toString()}");
  }
}
