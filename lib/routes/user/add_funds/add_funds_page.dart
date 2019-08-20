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
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool _isIpAllowed = false;

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
  }

  isIpAllowed() async {
    var response = await http.get("https://api.moonpay.io/v2/ip_address");
    if (response.statusCode != 200) {
      log.severe('moonpay response error: ${response.body.substring(0, 100)}');
      throw "Service Unavailable. Please try again later.";
    }
    _isIpAllowed = jsonDecode(response.body)['isAllowed'];
  }

  @override
  void dispose() {
    _addFundsBloc.addFundRequestSink.close();
    _accountSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return new StreamBuilder(
        stream: accountBloc.accountStream,
        builder: (BuildContext context, AsyncSnapshot<AccountModel> account) {
          if (!account.hasData) {
            return StaticLoader();
          }
          return StreamBuilder(
              stream: _addFundsBloc.addFundResponseStream,
              builder: (BuildContext context, AsyncSnapshot<AddFundResponse> response) {
                if (!response.hasData) {
                  return StaticLoader();
                }
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
                      body: Stack(
                        children: <Widget>[
                          ListView(
                            children: _buildList(response.data),
                          ),
                          Positioned(
                            child: _buildReserveAmountWarning(account.data, response.data),
                            bottom: 72,
                            right: 22,
                            left: 22,
                          )
                        ],
                      )),
                );
              });
        });
  }

  List<Widget> _buildList(AddFundResponse response) {
    List<Widget> list = List();
    list
      ..add(_buildDepositToBTCAddress())
      ..add(Divider(
        indent: 72,
      ))
      ..add(_buildMoonPayButton(response))
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
              'DEPOSIT TO BITCOIN ADDRESS',
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

  Widget _buildMoonPayButton(AddFundResponse response) {
    String baseUrl = "https://buy-staging.moonpay.io";
    String apiKey = "pk_test_AZskxvTXb0rpsI7o2GCdmzs8jeST9d";
    String currencyCode = "btc";
    String walletAddress = "n4VQ5YdHf7hLQ2gWQYYrcxoE5B7nWuDFNF";
    String maxQuoteCurrencyAmount = Currency.BTC.format(response?.maxAllowedDeposit, includeSymbol: false, fixedDecimals: false);
    String colorCode = "%23055DEB";
    String redirectURL = "https%3A%2F%2Fbreez.technology";
    String moonPayURL =
        "$baseUrl?apiKey=$apiKey&currencyCode=$currencyCode&walletAddress=$walletAddress&colorCode=$colorCode&redirectURL=$redirectURL";
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
