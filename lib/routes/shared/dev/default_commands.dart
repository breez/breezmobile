import 'package:flutter/material.dart';
import 'package:breez/routes/shared/dev/dev.dart';
import 'package:breez/theme_data.dart' as theme;

var defaultCliCommandsText = <TextSpan>[
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'getinfo',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'getbackup',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'listpeers',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'newaddress',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'sendcoins',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'sendmany',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'connect',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'disconnect',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'openchannel',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'closechannel',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'closeallchannels',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'walletbalance',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'channelbalance',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'pendingchannels',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'listchannels',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'closedchannels',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'sendpayment',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'sendtoroute',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'addinvoice',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'lookupinvoice',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'listinvoices',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'describegraph',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'listpayments',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'getchaninfo',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'getnodeinfo',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'queryroutes',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'getnetworkinfo',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'debuglevel',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'decodepayreq',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'listchaintxns',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'stop',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'signmessage',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'verifymessage',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'feereport',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'updatechanpolicy',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'fwdinghistory',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'querymc',
  ),
  new TextSpan(text: "\n"),
  new LinkTextSpan(
    style: theme.linkStyle,
    command: 'resetmc',
  ),
  new TextSpan(text: "\n"),
];
