import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'deposit_to_btc_address_page.dart';
import 'moonpay_webview.dart';

class AddFundsPage extends StatefulWidget {
  final BreezUserModel _user;
  final AccountBloc _accountBloc;
  final BackupBloc _backupBloc;

  const AddFundsPage(this._user, this._accountBloc, this._backupBloc);

  @override
  State<StatefulWidget> createState() {
    return new AddFundsState();
  }
}

class AddFundsState extends State<AddFundsPage> {
  final String _title = "Add Funds";
  AddFundsBloc _addFundsBloc;

  @override
  initState() {
    super.initState();
    _addFundsBloc = new AddFundsBloc(widget._user.userID);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return Material(
      child: new Scaffold(
        appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          leading: backBtn.BackButton(),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: accountBloc.accountStream,
          builder: (BuildContext context, AsyncSnapshot<AccountModel> account) {
            if (!account.hasData) {
              return Center(child: Loader(color: theme.BreezColors.white[400]));
            }
            return StreamBuilder(
                stream: _addFundsBloc.moonPayOrderStream,
                builder: (BuildContext context, AsyncSnapshot<MoonpayOrder> moonpayOrder) {
                  if (!moonpayOrder.hasData) {
                    return Center(child: Loader(color: theme.BreezColors.white[400]));
                  }
                  if (_orderIsPending(moonpayOrder.data) && _orderExistsInUnconfirmedAddresses(account, moonpayOrder.data)) {
                    return Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                        child: LoadingAnimatedText(
                          'Your MoonPay order is being processed',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]);
                  }
                  return StreamBuilder(
                      stream: _addFundsBloc.moonPayUrlStream,
                      builder: (BuildContext context, AsyncSnapshot<String> moonpayUrl) {
                        return getBody(context, account.data, moonpayUrl.data);
                      });
                });
          },
        ),
      ),
    );
  }

  bool _orderIsPending(MoonpayOrder moonpayOrder) =>
      DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(moonpayOrder.timestamp ?? 0)).inHours <= 1;

  bool _orderExistsInUnconfirmedAddresses(AsyncSnapshot<AccountModel> account, MoonpayOrder moonpayOrder) {
    return account.data?.addedFundsReply?.unConfirmedAddresses
            ?.firstWhere((swapAddressInfo) => swapAddressInfo.address == moonpayOrder.address, orElse: () => null) !=
        null;
  }

  Widget getBody(BuildContext context, AccountModel account, String moonpayUrl) {
    var unconfirmedTxID = account?.swapFundsStatus?.unconfirmedTxID;
    bool waitingDepositConfirmation = unconfirmedTxID?.isNotEmpty == true;

    String errorMessage;
    if (account == null || account.bootstraping) {
      errorMessage = 'You\'d be able to add funds after Breez is finished bootstrapping.';
    } else if (unconfirmedTxID?.isNotEmpty == true || account.processingWithdrawal) {
      errorMessage =
          'Breez is processing your previous ${waitingDepositConfirmation || account.processingBreezConnection ? "deposit" : "withdrawal"}. You will be able to add more funds once this operation is completed.';
    }

    if (errorMessage != null) {
      if (!errorMessage.endsWith('.')) {
        errorMessage += '.';
      }
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
            child: Text(errorMessage, textAlign: TextAlign.center),
          ),
          waitingDepositConfirmation
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                    child: Text("Transaction ID:", textAlign: TextAlign.start),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 22.0),
                      child: LinkLauncher(
                        linkName: unconfirmedTxID,
                        linkAddress: "https://blockstream.info/tx/$unconfirmedTxID",
                        onCopy: () {
                          Clipboard.setData(ClipboardData(text: unconfirmedTxID));
                          showFlushbar(context, message: "Transaction ID was copied to your clipboard.", duration: Duration(seconds: 3));
                        },
                      ))
                ])
              : SizedBox()
        ],
      );
    }
    return Stack(
      children: <Widget>[
        ListView(
          children: _buildList(moonpayUrl),
        ),
        Positioned(
          child: _buildReserveAmountWarning(account),
          bottom: 72,
          right: 22,
          left: 22,
        )
      ],
    );
  }

  List<Widget> _buildList(String moonpayUrl) {
    List<Widget> list = List();
    list
      ..add(_buildDepositToBTCAddress())
      ..add(Divider(
        indent: 72,
      ));
    if (moonpayUrl != null) {
      list..add(_buildMoonpayButton())..add(Divider(indent: 72));
    }
    list..add(_buildRedeemVoucherButton())..add(Divider(indent: 72));
    return list;
  }

  Widget _buildReserveAmountWarning(AccountModel account) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), border: Border.all(color: theme.errorColor)),
      padding: new EdgeInsets.all(16),
      child: Text(
        "Breez requires you to keep\n${account.currency.format(account.warningMaxChanReserveAmount, fixedDecimals: false)} in your balance.",
        style: theme.reserveAmountWarningStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDepositToBTCAddress() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 72,
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Image(
              image: AssetImage("src/icon/bitcoin.png"),
              height: 24.0,
              width: 24.0,
              fit: BoxFit.scaleDown,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              'DEPOSIT TO BTC ADDRESS',
              style: theme.addFundsItemsStyle,
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 24.0)),
        ]),
      ),
      onTap: () => Navigator.push(
        context,
        FadeInRoute(
          builder: (_) => DepositToBTCAddressPage(widget._user, widget._accountBloc),
        ),
      ),
    );
  }

  Widget _buildMoonpayButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 72,
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Image(
              image: AssetImage("src/icon/credit_card.png"),
              height: 24.0,
              width: 24.0,
              fit: BoxFit.scaleDown,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              'BUY BITCOIN',
              style: theme.addFundsItemsStyle,
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 24.0)),
        ]),
      ),
      onTap: () => Navigator.push(
        context,
        FadeInRoute(builder: (_) => new MoonpayWebView(widget._user, widget._accountBloc, widget._backupBloc)),
      ),
    );
  }

  Widget _buildRedeemVoucherButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 72,
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Image(
              image: AssetImage("src/icon/vendors/fastbitcoins_logo.png"),
              height: 24.0,
              width: 24.0,
              fit: BoxFit.scaleDown,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              'REDEEM FASTBITCOINS VOUCHER',
              style: theme.addFundsItemsStyle,
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 24.0)),
        ]),
      ),
      onTap: () => Navigator.of(context).pushNamed("/fastbitcoins"),
    );
  }
}
