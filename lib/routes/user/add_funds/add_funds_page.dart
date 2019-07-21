import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/routes/user/add_funds/address_widget.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
        builder:
            (BuildContext context, AsyncSnapshot<AccountModel> accSnapshot) {
          return StreamBuilder(
              stream: _addFundsBloc.addFundResponseStream,
              builder: (BuildContext context,
                  AsyncSnapshot<AddFundResponse> snapshot) {
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
                      body: new Container(
                        child: Material(
                            child: getBody(
                                context,
                                accSnapshot.data,
                                snapshot.data,
                                snapshot.hasError
                                    ? "Failed to retrieve an address from Breez server\nPlease check your internet connection."
                                    : null)),
                      )),
                );
              });
        });
  }

  Widget getBody(BuildContext context, AccountModel account,
      AddFundResponse response, String error) {
    var unconfirmedTxID = account?.swapFundsStatus?.unconfirmedTxID;
    bool waitingDepositConfirmation = unconfirmedTxID?.isNotEmpty == true;

    String errorMessage;
    if (error != null) {
      errorMessage = error;
    } else if (account == null || account.bootstraping) {
      errorMessage =
          'You\'d be able to add funds after Breez is finished bootstrapping.';
    } else if (unconfirmedTxID?.isNotEmpty == true ||
        account.processingWithdrawal) {
      errorMessage =
          'Breez is processing your previous ${waitingDepositConfirmation || account.processingBreezConnection ? "deposit" : "withdrawal"}. You will be able to add more funds once this operation is completed.';
    } else if (response != null && response.errorMessage.isNotEmpty) {
      errorMessage = response.errorMessage;
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
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [ 
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                      child: Text("Transaction ID:", textAlign: TextAlign.start),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 30.0, right: 22.0),
                          child: 
                          LinkLauncher(
                            linkName: unconfirmedTxID,
                            linkAddress: "https://blockstream.info/tx/$unconfirmedTxID",
                            onCopy: (){
                              Clipboard.setData(ClipboardData(text: unconfirmedTxID));
                              showFlushbar(context,
                                  message:
                                      "Transaction ID was copied to your clipboard.",
                                  duration: Duration(seconds: 3));
                            },
                          )
                  )
                  ])                      
              : SizedBox()
        ],
      );
    }
    return Column(children: <Widget>[
      AddressWidget(response?.address, response?.backupJson),
      response == null
          ? SizedBox()
          : Expanded(
              child: Container(
                padding:
                    new EdgeInsets.only(top: 36.0, left: 12.0, right: 12.0),
                child: Text(
                  "Send up to " +
                      account.currency.format(response.maxAllowedDeposit,
                          includeSymbol: true) +
                      " to this address." +
                      "\nBreez requires you to keep ${account.currency.format(account.warningMaxChanReserveAmount)} in your balance.",
                  style: theme.warningStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      _buildBottomBar(response, account,
          hasError: error != null ? true : false),
    ]);
  }

  Widget _buildRedeemVoucherButton() {
    return new GestureDetector(
        onTap: () => Navigator.of(context).pushNamed("/fastbitcoins"),
        child: Container(
          decoration: BoxDecoration(
              color: theme.fastbitcoins.iconBgColor,
              border: Border.all(
                  color: Colors.white, style: BorderStyle.solid, width: 1.0),
              borderRadius: BorderRadius.circular(14.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("src/icon/vendors/fastbitcoins_logo.png"),
                height: 24.0,
                fit: BoxFit.scaleDown,
                color: theme.fastbitcoins.iconFgColor,
              ),
              Padding(padding: EdgeInsets.only(right: 4.0)),
              Text(
                'REDEEM FASTBITCOINS VOUCHER',
                style: theme.fastbitcoinsTextStyle,
              )
            ],
          ),
        ));
  }

  Widget _buildBottomBar(AddFundResponse response, AccountModel account,
      {hasError = false}) {
    if (hasError || response?.errorMessage?.isNotEmpty == true) {
      return SingleButtonBottomBar(
          text: hasError ? "RETRY" : "CLOSE",
          onPressed: () {
            if (hasError) {
              _addFundsBloc.addFundRequestSink.add(null);
            } else {
              Navigator.of(context).pop();
            }
          });
    }

    return response == null || account?.active != true
        ? SizedBox()
        : new Padding(
            padding: new EdgeInsets.only(bottom: 40.0),
            child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new SizedBox(
                      height: 48.0,
                      width: 256.0,
                      child: _buildRedeemVoucherButton())
                ]));
  }
}
