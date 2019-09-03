import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_fund_vendor_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/moonpay_order.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddFundsPage extends StatefulWidget {  

  const AddFundsPage();

  @override
  State<StatefulWidget> createState() {
    return new AddFundsState();
  }
}

class AddFundsState extends State<AddFundsPage> {
  final String _title = "Add Funds";  

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    AddFundsBloc addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
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
                stream: addFundsBloc.completedMoonpayOrderStream,
                builder: (BuildContext context, AsyncSnapshot<MoonpayOrder> moonpayOrder) {
                  if (moonpayOrder.hasData &&
                      _orderIsPending(account.data, moonpayOrder.data)) {
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
                      stream: addFundsBloc.availableVendorsStream,
                      builder: (BuildContext context, AsyncSnapshot<List<AddFundVendorModel>> vendorList) {
                        if (!vendorList.hasData) {
                          return Center(child: Loader(color: theme.BreezColors.white[400]));
                        }
                        return getBody(context, account.data, vendorList.data);
                      });
                });
          },
        ),
      ),
    );
  }

  bool _orderIsPending(AccountModel account, MoonpayOrder moonpayOrder) {
      List<String> allAddresses = account.swapFundsStatus.unConfirmedAddresses.toList()
                                    ..addAll(account.swapFundsStatus.confirmedAddresses);
      return DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(moonpayOrder.orderTimestamp ?? 0)).inHours <= 1 && 
        !allAddresses.contains(moonpayOrder.address);
  }

  Widget getBody(BuildContext context, AccountModel account, List<AddFundVendorModel> vendorList) {
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
          children: _buildList(vendorList),
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

  List<Widget> _buildList(List<AddFundVendorModel> vendorsList) {
    List<Widget> list = List();
    vendorsList.forEach((v){
      if (v.isAllowed) {
        list
        ..add(_buildAddFundsVendorItem(v))
        ..add(Divider(
          indent: 72,
        ));
      }
    });       
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

  Widget _buildAddFundsVendorItem(AddFundVendorModel vendor) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 72,
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Image(
              image: AssetImage(vendor.icon),
              height: 24.0,
              width: 24.0,
              fit: BoxFit.scaleDown,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              vendor.name,
              style: theme.addFundsItemsStyle,
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 24.0)),
        ]),
      ),
      onTap: () {        
        Navigator.pushNamed(
          context,
          vendor.route
        );
      },
    );
  }
}
