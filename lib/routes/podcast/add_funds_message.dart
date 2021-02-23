import 'package:flutter/material.dart';

class AddFundsMessage extends StatefulWidget {
  final int total;

  const AddFundsMessage({Key key, this.total}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddFundsMessageState();
  }
}

class AddFundsMessageState extends State<AddFundsMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Add funds to your balance to send payments to this podcast.",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
          ),
          RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/create_invoice");
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                "Add Funds",
                style: Theme.of(context).accentTextTheme.bodyText2,
              )),
        ],
      ),
    );
  }
}
