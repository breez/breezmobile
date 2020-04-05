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
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
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
      Category("General"),
      Command("getinfo", onCommand),
      Command("debuglevel", onCommand),
      Command("stop", onCommand),
      
      Category("Channels"),
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
      
      Category("On-chain"),
      Command("estimatefee", onCommand),
      Command("sendmany", onCommand),
      Command("listunspent", onCommand),
      
      Category("Payments"),
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
      
      Category("Peers"),
      Command("connect", onCommand),
      Command("disconnect", onCommand),
      Command("listpeers", onCommand),
      Command("describegraph", onCommand),
      Command("getnodeinfo", onCommand),
      
      Category("Wallet"),
      Command("newaddress", onCommand),
      Command("walletbalance", onCommand),
      Command("signmessage", onCommand),
      Command("verifymessage", onCommand),
      Command("wallet pendingsweeps", onCommand),
      Command("wallet bumpfee", onCommand)
    ];
