import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/share.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/services.dart';

class WaitBroadcastDialog extends StatefulWidget {
  final AccountBloc _accountBloc;
  final String _fromAddress;
  final String _toAddress;

  WaitBroadcastDialog(this._accountBloc, this._fromAddress, this._toAddress);

  @override
  State<StatefulWidget> createState() {
    return _WaitBroadcastDialog();
  }
}

class _WaitBroadcastDialog extends State<WaitBroadcastDialog> {
  BroadcastRefundResponseModel _response;
  Object _error;
  StreamSubscription<BroadcastRefundResponseModel> _broadcastSubscription;

  @override
  void initState() {
    super.initState();
    _broadcastSubscription =
        widget._accountBloc.broadcastRefundResponseStream.listen((response) {
      setState(() {
        _response = response;
      });
    }, onError: (e) {
      setState(() {
        _error = e;
      });
    });

    var broadcastModel = new BroadcastRefundRequestModel(widget._fromAddress, widget._toAddress);                             
    widget._accountBloc.broadcastRefundRequestSink.add(broadcastModel);
  }

  @override
  void dispose() {
    _broadcastSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          unselectedWidgetColor: Theme.of(context).canvasColor,
          accentColor: Theme.of(context).canvasColor),
      child: new AlertDialog(
        title: Text(getTitleText(),
            style: theme.alertTitleStyle, textAlign: TextAlign.center),
        content: getContent(),
        actions: _response == null && _error == null
            ? []
            : <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("CLOSE", style: theme.buttonStyle)),
              ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
      ),
    );
  }

  String getTitleText() {
    if (_error != null) {
      return "Refund Error";
    }
    return "Refund Transaction";
  }

  getContent() {
    if (_error != null) {
      return Text("Error in broadcasting transaction: " + _error.toString(),
          style: theme.alertStyle, textAlign: TextAlign.center);
    }
    if (_response == null) {
      return getWaitingContent();
    }
    return getResultContent();
  }

  Widget getWaitingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          "Please wait while Breez is sending the funds to the specified address.",
          style: theme.alertStyle,
          textAlign: TextAlign.center,
        ),
        Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: new Image.asset(
              'src/images/breez_loader.gif',
              gaplessPlayback: true,
            ))
      ],
    );
  }

  Widget getResultContent() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(children: <Widget>[
              Expanded(
                child: Text(
                  "Funds were successfully sent to the specified address.",
                  style: theme.alertStyle,
                  textAlign: TextAlign.center,
                ),
              )
            ]),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text("Transaction ID:",
                    style: theme.paymentDetailsTitleStyle),
              ),
              Expanded(
                  child: Container(
                height: 36.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(top: 4.0, right: 0.0, left: 0.0),
                      tooltip: "Copy Transaction Hash",
                      iconSize: 16.0,
                      color: theme.BreezColors.blue[500],
                      icon: Icon(
                        IconData(0xe90b, fontFamily: 'icomoon'),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _response.txID));
                      },
                    ),
                    IconButton(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(top: 4.0, right: 0.0, left: 0.0),
                      tooltip: "Share Transaction Hash",
                      iconSize: 16.0,
                      color: theme.BreezColors.blue[500],
                      icon: Icon(Icons.share),
                      onPressed: () {
                        Share.share(_response.txID);
                      },
                    )
                  ],
                ),
              ))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Text('${_response.txID}',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      maxLines: 4,
                      style: theme.paymentDetailsNodeIdStyle),
                ),
              ),
            ],
          )
        ]);
  }
}
