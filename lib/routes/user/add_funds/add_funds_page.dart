import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class AddOrSendFundsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>(
        (context, blocs) => _AddOrSendFunds(blocs.accountBloc));
  }
}

class _AddOrSendFunds extends StatelessWidget {
  final AccountBloc _accountBloc;

  const _AddOrSendFunds(this._accountBloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountModel>(
        stream: _accountBloc.accountStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return Loader();
          }
          return _AddFundsPage(_accountBloc);
        });
  }
}

class _AddFundsPage extends StatefulWidget {
  final AccountBloc _accountBloc;

  _AddFundsPage(this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return new AddFundsState();
  }
}

class AddFundsState extends State<_AddFundsPage> {
  final String _title = "Add Funds";
  StreamSubscription<AccountModel> _accountSubscription;
  StreamSubscription<AddFundResponse> _addressSubscription;

  bool _connected = true;

  @override
  initState() {
    super.initState();

    _addressSubscription = widget._accountBloc.addFundStream.listen((data) {
      setState(() {
        _connected = true;
      });
    });
    _addressSubscription.onError((error) {
      setState(() {
        _connected = false;
      });
    });

    widget._accountBloc.requestAddressSink.add(null);
  }

  @override
  void dispose() {
    if (_accountSubscription != null) {
      _accountSubscription.cancel();
    }
    if (_addressSubscription != null) {
      _addressSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        bottomNavigationBar: !_connected
            ? new Padding(
                padding: new EdgeInsets.only(bottom: 40.0),
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new SizedBox(
                        height: 48.0,
                        width: 168.0,
                        child: RaisedButton(
                          padding: EdgeInsets.only(
                              top: 16.0, bottom: 16.0, right: 39.0, left: 39.0),
                          child: new Text(
                            "RETRY",
                            style: theme.buttonStyle,
                          ),
                          color: Colors.white,
                          elevation: 0.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(42.0)),
                          onPressed: () {
                            widget._accountBloc.requestAddressSink.add(null);
                          },
                        ),
                      ),
                    ]))
            : null,
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
            child: Column(
              children: <Widget>[
                StreamBuilder(
                    stream: widget._accountBloc.accountStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<AccountModel> accSnapshot) {
                      AccountModel acc = accSnapshot.data;
                      return StreamBuilder(
                          stream: widget._accountBloc.addFundStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<AddFundResponse> snapshot) {
                            AddFundResponse response = snapshot.data;
                            String message;
                            if (accSnapshot.hasError) {
                              message = accSnapshot.error.toString();
                            } else if (!accSnapshot.hasData) {
                              message =
                                  'Bitcoin address will be available as soon as Breez is synchronized.';
                            } else if (accSnapshot
                                    .data.waitingDepositConfirmation ||
                                accSnapshot.data.processingWithdrawal) {
                              message =
                                  'Breez is processing your previous ${acc.waitingDepositConfirmation || acc.processiongBreezConnection ? "deposit" : "withdrawal"}. You will be able to add more funds once this operation is completed.';
                            } else if (snapshot.hasData &&
                                response.errorMessage != null &&
                                response.errorMessage.isNotEmpty) {
                              message = response.errorMessage;
                            }

                            if (message != null) {
                              return Container(
                                color: theme.massageBackgroundColor,
                                padding: new EdgeInsets.only(
                                    left: 16.0,
                                    top: 9.0,
                                    right: 16.0,
                                    bottom: 9.0),
                                child: new Text(
                                  message,
                                  style: new TextStyle(
                                    color: theme.whiteColor,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Container(
                                  padding: EdgeInsets.only(
                                      top: 50.0, left: 30.0, right: 30.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      "Failed to retrieve an address from Breez server\nPlease check your internet connection.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ]));
                            }

                            return _buildBitcoinFundsSection(
                                context,
                                snapshot.data?.address,
                                snapshot.data?.backupJson);
                          });
                    }),
                new Container(
                  padding: new EdgeInsets.only(top: 36.0),
                  child: _connected
                      ? _buildAmountWarning(widget._accountBloc)
                      : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildAmountWarning(AccountBloc accountBloc) {
  return StreamBuilder(
      stream: accountBloc.accountStream,
      builder:
          (BuildContext context, AsyncSnapshot<AccountModel> accountSnapshot) {
        return StreamBuilder(
            stream: accountBloc.addFundStream,
            builder: (BuildContext context,
                AsyncSnapshot<AddFundResponse> addFundSnapshot) {
              if (addFundSnapshot.hasData &&
                  accountSnapshot.hasData &&
                  addFundSnapshot.data.errorMessage.isEmpty) {
                return new Column(children: <Widget>[
                  Text(
                      "Send up to " +
                          accountSnapshot.data.currency.format(
                              addFundSnapshot.data.maxAllowedDeposit,
                              includeSymbol: true) +
                          " to this address",
                      style: theme.warningStyle)
                ]);
              } else {
                return new Container();
              }
            });
      });
}

Widget _buildBitcoinFundsSection(
    BuildContext context, String address, String backupJson) {
  final snackBar = new SnackBar(
    content: new Text(
      'Deposit address was copied to your clipboard.',
      style: theme.snackBarStyle,
    ),
    backgroundColor: theme.snackBarBackgroundColor,
    duration: new Duration(seconds: 4),
  );

  return new Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      new Container(
        padding: new EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              "Deposit Address",
              style: theme.FieldTextStyle.labelStyle,
            ),
            new Container(
              child: Row(
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(IconData(0xe917, fontFamily: 'icomoon')),
                    color: theme.whiteColor,
                    onPressed: () {
                      final RenderBox box = context.findRenderObject();
                      Share.share(address,
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                  ),
                  new IconButton(
                    icon: new Icon(IconData(0xe90b, fontFamily: 'icomoon')),
                    color: theme.whiteColor,
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(text: address));
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      address == null
          ? _buildQRPlaceholder()
          : new Column(children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                padding: const EdgeInsets.all(8.6),
                decoration: theme.qrImageStyle,
                child: new Container(
                  color: theme.whiteColor,
                  child: new QrImage(
                    data: "bitcoin:" + address,
                    size: 180.0,
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: new Text(
                  address,
                  style: theme.smallTextStyle,
                ),
              ),
              new GestureDetector(
                  onTap: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(backupJson,
                        sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
                  },
                  child: new Text("Get refund transaction",
                      style: theme.linkStyle)),
            ])
    ],
  );
}

Widget _buildQRPlaceholder() {
  return Container(
    width: 188.6,
    height: 188.6,
    margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
    padding: const EdgeInsets.all(8.6),
    child: CircularProgressIndicator(),
  );
}
