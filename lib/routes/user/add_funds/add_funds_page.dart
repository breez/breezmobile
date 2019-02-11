import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/routes/user/add_funds/address_widget.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class AddFundsPage extends StatefulWidget {  
  final BreezUserModel _user;  

  const AddFundsPage(this._user);

  @override
  State<StatefulWidget> createState() {
    return new AddFundsState();
  }
}

class AddFundsState extends State<AddFundsPage> {
  static const int CHANNEL_RESERVE_SAT = 10000;
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
                      bottomNavigationBar: _buildBottomBar(snapshot.data,
                          hasError: snapshot.hasError),
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
    String errorMessage;
    if (error != null) {
      errorMessage = error;
    } else if (account == null) {
      errorMessage =
          'Bitcoin address will be available as soon as Breez is synchronized.';
    } else if (account.waitingDepositConfirmation ||
        account.processingWithdrawal) {
      errorMessage =
          'Breez is processing your previous ${account.waitingDepositConfirmation || account.processingBreezConnection ? "deposit" : "withdrawal"}. You will be able to add more funds once this operation is completed.';
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
          padding: new EdgeInsets.only(top: 36.0, left: 12.0, right: 12.0),
          child: Text(
              "Send up to " +
                  account.currency
                      .format(response.maxAllowedDeposit, includeSymbol: true) +
                  " to this address." + "\nBreez requires you to keep ${account.currency.format(Int64(CHANNEL_RESERVE_SAT))} in your balance.",
              style: theme.warningStyle, textAlign: TextAlign.center,)),
      response == null ? SizedBox() : Padding(
          padding: EdgeInsets.only(top: 32.0), child:
      Container(child: IconButton(icon: ImageIcon(
          AssetImage("src/icon/vendors/fastbitcoins_logo.png"),
          color: Color(0xFFff7c10)),
          iconSize: 36.0,
          onPressed: () => Navigator.of(context).pushNamed("/fastbitcoins")),
          padding: EdgeInsets.all(4.0),
          decoration: ShapeDecoration(
              color: Color(0xFF1f2a44), shape: CircleBorder()))),
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
