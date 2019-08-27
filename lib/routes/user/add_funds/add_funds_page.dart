import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/user/marketplace/vendor_webview.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:breez/bloc/account/moonpay_order.dart';
import 'deposit_to_btc_address_page.dart';

class AddFundsPage extends StatefulWidget {
  final BreezUserModel _user;
  final AccountBloc _accountBloc;

  const AddFundsPage(this._user, this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return new AddFundsState();
  }
}

class AddFundsState extends State<AddFundsPage> {
  final String _title = "Add Funds";
  AddFundsBloc _addFundsBloc;
  StreamSubscription<AccountModel> _accountSubscription;
  StreamSubscription<MoonpayOrder> _moonPaySubscription;
  bool _isIpAllowed = false;

  MoonpayOrder _moonPayOrder;
  Timer moonPayTimer;

  @override
  initState() {
    super.initState();
    _addFundsBloc = new AddFundsBloc(widget._user.userID);
    _accountSubscription = widget._accountBloc.accountStream.listen((acc) {
      if (!acc.bootstraping) {
        _addFundsBloc.addFundRequestSink.add(null);
        _accountSubscription.cancel();
      }
    });
    isIpAllowed();
    _moonPaySubscription = _addFundsBloc.moonPayOrderStream.listen((order) {
      setState(() {
        _moonPayOrder = order;
      });
    });
    _checkMoonpayOrderExpiration();
  }

  isIpAllowed() async {
    var response = await http.get("https://api.moonpay.io/v2/ip_address");
    if (response.statusCode != 200) {
      log.severe('moonpay response error: ${response.body.substring(0, 100)}');
      throw "Service Unavailable. Please try again later.";
    }
    _isIpAllowed = jsonDecode(response.body)['isAllowed'];
  }

  void _checkMoonpayOrderExpiration() {
    moonPayTimer = Timer.periodic(new Duration(seconds: 15), (_) async {
      if (_moonPayOrder?.timestamp != null &&
          DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(_moonPayOrder.timestamp)).inMinutes >= 15) {
        _addFundsBloc.moonPayOrderSink.add(MoonpayOrder(null, null));
      }
    });
  }

  @override
  void dispose() {
    _addFundsBloc.addFundRequestSink.close();
    _accountSubscription.cancel();
    _moonPaySubscription?.cancel();
    moonPayTimer?.cancel();
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
              stream: _addFundsBloc.addFundResponseStream,
              builder: (BuildContext context, AsyncSnapshot<AddFundResponse> response) {
                if (!response.hasData && !response.hasError) {
                  return Center(child: Loader(color: theme.BreezColors.white[400]));
                }
                return getBody(context, account.data, response.data,
                    response.hasError ? "Failed to retrieve an address from Breez server\nPlease check your internet connection." : null);
              },
            );
          },
        ),
      ),
    );
  }

  Widget getBody(BuildContext context, AccountModel account, AddFundResponse response, String error) {
    var unconfirmedTxID = account?.swapFundsStatus?.unconfirmedTxID;
    bool waitingDepositConfirmation = unconfirmedTxID?.isNotEmpty == true;

    String errorMessage;
    if (error != null) {
      errorMessage = error;
    } else if (account == null || account.bootstraping) {
      errorMessage = 'You\'d be able to add funds after Breez is finished bootstrapping.';
    } else if (unconfirmedTxID?.isNotEmpty == true || account.processingWithdrawal) {
      errorMessage =
          'Breez is processing your previous ${waitingDepositConfirmation || account.processingBreezConnection ? "deposit" : "withdrawal"}. You will be able to add more funds once this operation is completed.';
    } else if (response != null && response.errorMessage.isNotEmpty) {
      errorMessage = response.errorMessage;
    } else if (_moonPayOrder?.address != null &&
        account?.addedFundsReply?.unConfirmedAddresses
                ?.firstWhere((swapAddressInfo) => swapAddressInfo.address == _moonPayOrder.address, orElse: () => null) !=
            null) {
      errorMessage = 'Your MoonPay order is being processed';
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
            child: _moonPayOrder?.address != null
                ? LoadingAnimatedText(
                    errorMessage.substring(0, errorMessage.length - 1),
                    textAlign: TextAlign.center,
                  )
                : Text(errorMessage, textAlign: TextAlign.center),
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
          children: _buildList(response),
        ),
        Positioned(
          child: _buildReserveAmountWarning(account, response),
          bottom: 72,
          right: 22,
          left: 22,
        )
      ],
    );
  }

  List<Widget> _buildList(AddFundResponse response) {
    List<Widget> list = List();
    list
      ..add(_buildDepositToBTCAddress())
      ..add(Divider(
        indent: 72,
      ))
      ..add(_buildMoonpayButton(response))
      ..add(Divider(indent: 72))
      ..add(_buildRedeemVoucherButton())
      ..add(Divider(indent: 72));
    return list;
  }

  Widget _buildReserveAmountWarning(AccountModel account, AddFundResponse response) {
    return response == null
        ? SizedBox()
        : Container(
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

  Widget _buildMoonpayButton(AddFundResponse response) {
    String baseUrl = "https://buy-staging.moonpay.io";
    String apiKey = "pk_test_AZskxvTXb0rpsI7o2GCdmzs8jeST9d";
    String currencyCode = "btc";
    String walletAddress = "n4VQ5YdHf7hLQ2gWQYYrcxoE5B7nWuDFNF";
    String maxQuoteCurrencyAmount = Currency.BTC.format(response?.maxAllowedDeposit, includeSymbol: false, fixedDecimals: false);
    String colorCode = "%23055DEB";
    String redirectURL = "https://buy-staging.moonpay.io/transaction_receipt?addFunds=true";
    String moonPayURL =
        "$baseUrl?apiKey=$apiKey&currencyCode=$currencyCode&walletAddress=$walletAddress&colorCode=$colorCode&redirectURL=${Uri.encodeFull(redirectURL)}";
    if (response != null) {
      moonPayURL += "&maxQuoteCurrencyAmount=$maxQuoteCurrencyAmount";
    }

    return !_isIpAllowed
        ? GestureDetector(
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
              FadeInRoute(
                builder: (_) => new VendorWebViewPage(
                  null,
                  moonPayURL,
                  "MoonPay",
                  redirectURL: redirectURL,
                  walletAddress: walletAddress,
                  addFundsBloc: _addFundsBloc,
                  listenInvoices: false,
                ),
              ),
            ),
          )
        : null;
  }

  Widget _buildRedeemVoucherButton() {
    return GestureDetector(
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
