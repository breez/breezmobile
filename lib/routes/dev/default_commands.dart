import 'package:flutter/material.dart';

class Command extends StatelessWidget {
  final String command;
  final Function(String command) onTap;

  const Command(this.command, this.onTap, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          this.onTap(command);
        },
        child: Container(
          alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Text(
              command,
              textAlign: TextAlign.left,
            )));
  }
}

class Category extends StatelessWidget {
  final String name;

  const Category(this.name, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(name, style: Theme.of(context).textTheme.headline6);
  }
}

List<Widget> defaultCliCommandsText(Function(String command) onCommand) => [
      ExpansionTile(title: Text("General"), children: <Widget>[
        Command("getinfo", onCommand),
        Command("debuglevel", onCommand),
        Command("stop", onCommand),
      ]),
      ExpansionTile(title: Text("Channels"), children: <Widget>[
        Command("openchannel", onCommand),
        Command("closechannel", onCommand),
        Command("closeallchannels", onCommand),
        Command("abandonchannel", onCommand),
        Command("channelbalance", onCommand),
        Command("pendingchannels", onCommand),
        Command("listchannels", onCommand),
        Command("closedchannels", onCommand),
        Command("getchaninfo", onCommand),
        Command("getnetworkinfo", onCommand),
        Command("feereport", onCommand),
        Command("updatechanpolicy", onCommand),
      ]),
      ExpansionTile(title: Text("On-chain"), children: <Widget>[
        Command("estimatefee", onCommand),
        Command("sendmany", onCommand),
        Command("listunspent", onCommand),
      ]),
      ExpansionTile(title: Text("Payments"), children: <Widget>[
        Command("sendpayment", onCommand),
        Command("payinvoice", onCommand),
        Command("sendtoroute", onCommand),
        Command("addinvoice", onCommand),
        Command("lookupinvoice", onCommand),
        Command("listinvoices", onCommand),
        Command("queryroutes", onCommand),
        Command("decodepayreq", onCommand),
        Command("fwdinghistory", onCommand),
        Command("querymc", onCommand),
        Command("queryprob", onCommand),
        Command("resetmc", onCommand),
        Command("buildroute", onCommand),
        Command("cancelinvoice", onCommand),
        Command("addholdinvoice", onCommand),
        Command("settleinvoice", onCommand),
      ]),
      ExpansionTile(title: Text("Peers"), children: <Widget>[
        Command("connect", onCommand),
        Command("disconnect", onCommand),
        Command("listpeers", onCommand),
        Command("describegraph", onCommand),
        Command("getnodeinfo", onCommand),
      ]),
      ExpansionTile(title: Text("Wallet"), children: <Widget>[
        Command("newaddress", onCommand),
        Command("walletbalance", onCommand),
        Command("signmessage", onCommand),
        Command("verifymessage", onCommand),
        Command("wallet pendingsweeps", onCommand),
        Command("wallet bumpfee", onCommand)
      ]),
    ];
