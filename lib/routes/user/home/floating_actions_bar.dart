import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/withdraw_funds/withdraw_funds_page.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'dart:math';

class FloatingActionsBar extends StatelessWidget {
  static const double SHIRINKED_BUTTON_SIZE = 56.0;
  static const double CTP_MAX_WIDTH = 210.0;
  static const double ADD_FUNDS_MAX_WIDTH = 162.0;
  final AccountModel account;
  final double height;
  final double offsetFactor;

  FloatingActionsBar(this.account, this.height, this.offsetFactor);

  @override
  Widget build(BuildContext context) {
    bool isSmallView = height < 160;
    bool hasBalance = account.balance > 0;

    return new Positioned(
      top: (height - 25.0),
      right: 16.0,
      child: AnimatedContainer(
          width: isSmallView ? 56.0 : (hasBalance ? CTP_MAX_WIDTH : ADD_FUNDS_MAX_WIDTH),
          duration: Duration(milliseconds: 150),
          child: RaisedButton(
            onPressed: () {
              if (hasBalance) {
                Navigator.of(context).pushNamed('/connect_to_pay');
                return;
              }
              if (account.nonDepositableBalance > 0) {
                Navigator.of(context).push<String>(new MaterialPageRoute(builder: (ctx) => new WithdrawFundsPage(true))).then((message) {
                  if (message != null) {
                    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(message)));
                  }
                });
              } else {
                Navigator.of(context).pushNamed('/add_funds');
              }
            },
            shape: isSmallView
                ? new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(56.0))
                : new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(42.0)),
            color: Color.fromRGBO(0, 133, 251, 1.0),
            padding: isSmallView ? EdgeInsets.all(16.0) : EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: isSmallView
                  ? <Widget>[
                      hasBalance
                          ? ImageIcon(
                              AssetImage("src/icon/connect_to_pay.png"),
                              color: Colors.white,
                              size: 24.0,
                            )
                          : Icon(Icons.add),
                    ]
                  : <Widget>[
                      hasBalance
                          ? ImageIcon(
                              AssetImage("src/icon/connect_to_pay.png"),
                              color: Colors.white,
                              size: 24.0,
                            )
                          : Icon(Icons.add),
                      Padding(padding: EdgeInsets.only(left: 8.0)),
                      Text(hasBalance ? "CONNECT TO PAY" : "ADD FUNDS", style: theme.addFundsBtnStyle)
                    ],
            ),
          )),
    );
  }
}
