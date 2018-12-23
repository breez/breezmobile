import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/routes/user/add_funds/address_widget.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class AddFundsPage extends StatelessWidget {
  final BreezUserModel _user;

  AddFundsPage(this._user);

  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>(
        (context, blocs) => _AddFundsPage(this._user, blocs.accountBloc));
  }
}

class _AddFundsPage extends StatefulWidget {
  final BreezUserModel _user;
  final AccountBloc _accountBloc;

  const _AddFundsPage(this._user, this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return new AddFundsState();
  }
}

class AddFundsState extends State<_AddFundsPage> {
  final String _title = "Add Funds";
  AddFundsBloc _addFundsBloc;

  @override
  initState() {
    super.initState();
    _addFundsBloc = new AddFundsBloc(widget._user.userID);
    _addFundsBloc.addFundRequestSink.add(null);
  }

  @override
  void dispose() {
    _addFundsBloc.addFundRequestSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: widget._accountBloc.accountStream,
        builder:
            (BuildContext context, AsyncSnapshot<AccountModel> accSnapshot) {
          return StreamBuilder(
              stream: _addFundsBloc.addFundResponseStream,
              builder: (BuildContext context,
                  AsyncSnapshot<AddFundResponse> snapshot) {
                return Material(
                  child: new Scaffold(
                      bottomNavigationBar: _buildBottomBar(snapshot.data,
                          hasError: snapshot.hasError),
                      appBar: new AppBar(
                        iconTheme: theme.appBarIconTheme,
                        textTheme: theme.appBarTextTheme,
                        backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
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
    String errorMessage;
    if (error != null) {
      errorMessage = error;
    } else if (account == null) {
      errorMessage =
          'Bitcoin address will be available as soon as Breez is synchronized.';
    } else if (account.waitingDepositConfirmation ||
        account.processingWithdrawal) {
      errorMessage =
          'Breez is processing your previous ${account.waitingDepositConfirmation || account.processiongBreezConnection ? "deposit" : "withdrawal"}. You will be able to add more funds once this operation is completed.';
    } else if (response != null && response.errorMessage.isNotEmpty) {
      errorMessage = response.errorMessage;
    }    

    if (errorMessage != null) {
      if (!errorMessage.endsWith('.')) {
        errorMessage += '.';
      }
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Expanded(                
                 child: Padding(
                   padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                   child: Text(errorMessage, textAlign: TextAlign.center),
                 )
              )
            ],            
      );
    }
    return Column(children: <Widget>[
      AddressWidget(response?.address, response?.backupJson),
      response == null ? SizedBox() : Container(
          padding: new EdgeInsets.only(top: 36.0),
          child: Text(
              "Send up to " +
                  account.currency
                      .format(response.maxAllowedDeposit, includeSymbol: true) +
                  " to this address",
              style: theme.warningStyle))
    ]);   
  }

  Widget _buildBottomBar(AddFundResponse response, {hasError = false}) {
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

    return SizedBox(width: 0.0, height: 0.0);
  }
}
