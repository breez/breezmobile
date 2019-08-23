import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

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
    bool hasBalance = (account?.balance ?? Int64(0)) > 0;

    var scaleFactor = MediaQuery.of(context).textScaleFactor;    
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
              Navigator.of(context).pushNamed('/add_funds');
            },
            shape: isSmallView
                ? new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(56.0))
                : new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(42.0)),
            color: Color.fromRGBO(0, 133, 251, 1.0),
            padding: isSmallView ? EdgeInsets.all(16.0) : EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
                      Container(                        
                        width: (hasBalance ? CTP_MAX_WIDTH - 64 / min(scaleFactor, 1.0) : ADD_FUNDS_MAX_WIDTH - 64 / min(scaleFactor, 1.0)),                        
                        child: AutoSizeText(
                          hasBalance ? "CONNECT TO PAY" : "ADD FUNDS",
                          style: theme.addFundsBtnStyle,
                          maxLines: 1,
                          minFontSize: MinFontSize(context).minFontSize,
                          stepGranularity: 0.1,
                        ),                        
                      )
                    ],
            ),
          )),
    );
  }
}
