import 'package:flutter/material.dart';
import 'package:breez/routes/shared/dev/dev.dart';
import 'package:breez/theme_data.dart' as theme;

var defaultCliCommandsText = <TextSpan>[
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'getinfo',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'getbackup',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'listpeers',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'newaddress',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'sendcoins',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'sendmany',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'connect',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'disconnect',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'openchannel',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'closechannel',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'closeallchannels',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'walletbalance',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'channelbalance',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'pendingchannels',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'listchannels',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'closedchannels',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'sendpayment',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'sendtoroute',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'addinvoice',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'lookupinvoice',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'listinvoices',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'describegraph',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'listpayments',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'getchaninfo',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'getnodeinfo',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'queryroutes',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'getnetworkinfo',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'debuglevel',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'decodepayreq',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'listchaintxns',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'stop',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'signmessage',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'verifymessage',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'feereport',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'updatechanpolicy',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'fwdinghistory',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'querymc',
  ),
  TextSpan(text: "\n"),
  LinkTextSpan(
    style: theme.linkStyle,
    command: 'resetmc',
  ),
  TextSpan(text: "\n"),
];
