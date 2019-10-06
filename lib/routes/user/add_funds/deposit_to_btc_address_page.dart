import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/user/add_funds/address_widget.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class DepositToBTCAddressPage extends StatefulWidget {  
  final AccountBloc _accountBloc;

  const DepositToBTCAddressPage(this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return new DepositToBTCAddressPageState();
  }
}

class DepositToBTCAddressPageState extends State<DepositToBTCAddressPage> {
  final String _title = "Deposit To Bitcoin Address";  
  AddFundsBloc _addFundsBloc;
  Route _thisRoute;

  @override void didChangeDependencies() {    
    super.didChangeDependencies();
    if (_addFundsBloc == null) {
      _thisRoute = ModalRoute.of(context);
      _addFundsBloc = BlocProvider.of<AddFundsBloc>(context); 
      _addFundsBloc.addFundRequestSink.add(false);
      widget._accountBloc.accountStream.firstWhere((acc) => !acc.bootstraping).then((acc) {
        if (this.mounted) {
          _addFundsBloc.addFundRequestSink.add(true);
        }
      });
            
      widget._accountBloc.accountStream.firstWhere(
        (acc) => acc?.swapFundsStatus?.unconfirmedTxID?.isNotEmpty == true)
        .then((acc) {
          if (this.mounted) {            
            Navigator.of(context).removeRoute(_thisRoute);
          }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return new StreamBuilder(
        stream: accountBloc.accountStream,
        builder: (BuildContext context, AsyncSnapshot<AccountModel> accSnapshot) {
          return StreamBuilder(
              stream: _addFundsBloc.addFundResponseStream,
              builder: (BuildContext context, AsyncSnapshot<AddFundResponse> snapshot) {
                return Material(
                  child: new Scaffold(
                      appBar: new AppBar(
                        iconTheme: theme.appBarIconTheme,
                        textTheme: theme.appBarTextTheme,
                        backgroundColor: Theme.of(context).canvasColor,
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

  Widget getBody(BuildContext context, AccountModel account, AddFundResponse response, String error) {
    String errorMessage;
    if (error != null) {
      errorMessage = error;
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
        ],
      );
    }
    return Column(children: <Widget>[
      AddressWidget(response?.address, response?.backupJson),
      response == null
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), border: Border.all(color: Theme.of(context).errorColor)),
                padding: new EdgeInsets.all(16),
                child: Text(
                  "Send up to " + account.currency.format(response.maxAllowedDeposit, includeSymbol: true) + " to this address.",
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      Expanded(child: SizedBox()),
      _buildBottomBar(response, account, hasError: error != null ? true : false),
    ]);
  }

  Widget _buildBottomBar(AddFundResponse response, AccountModel account, {hasError = false}) {
    if (hasError || response?.errorMessage?.isNotEmpty == true) {
      return SingleButtonBottomBar(
          text: hasError ? "RETRY" : "CLOSE",
          onPressed: () {
            if (hasError) {
              _addFundsBloc.addFundRequestSink.add(true);
            } else {
              Navigator.of(context).pop();
            }
          });
    }

    return SizedBox();
  }
}
