import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class MarketplacePage extends StatefulWidget {
  final String _title = "Marketplace";

  @override
  State<StatefulWidget> createState() {
    return new MarketplacePageState();
  }
}

class MarketplacePageState extends State<MarketplacePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          leading: backBtn.BackButton(),
          automaticallyImplyLeading: false,
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
          title: new Text(
            widget._title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            new GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/bitrefill');
                },
                child: new Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                  child: new Container(
                    height: 160.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.blue),
                    child: new Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.bluetooth,
                          size: 36.0,
                        ),
                        Text(
                          "Bitrefill",
                          style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.1,
                              fontFamily: 'Roboto'),
                        )
                      ],
                    )),
                  ),
                ))
          ],
        ));
  }
}
