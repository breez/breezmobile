import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/utils/i18n.dart';
import 'package:share_extend/share_extend.dart';

class WaitBroadcastDialog extends StatefulWidget {
  final AccountBloc _accountBloc;
  final String _fromAddress;
  final String _toAddress;
  final Int64 _feeRate;

  WaitBroadcastDialog(
      this._accountBloc, this._fromAddress, this._toAddress, this._feeRate);

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
        _error = null;
        _response = response;
      });
    }, onError: (e) {
      setState(() {
        _error = e;
      });
    });

    var broadcastModel = BroadcastRefundRequestModel(
        widget._fromAddress, widget._toAddress, widget._feeRate);
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
        colorScheme: ColorScheme.dark(secondary: Theme.of(context).canvasColor),
      ),
      child: AlertDialog(
        title: Text(getTitleText(),
            style: Theme.of(context).dialogTheme.titleTextStyle,
            textAlign: TextAlign.center),
        content: getContent(),
        actions: _response == null && _error == null
            ? []
            : <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(_error != null &&
                          _response?.txID?.isNotEmpty == true);
                    },
                    child: Text(t(context, "CLOSE"),
                        style: Theme.of(context).primaryTextTheme.button)),
              ],
      ),
    );
  }

  String getTitleText() {
    if (_error != null) {
      return t(context, "refund_error");
    }
    return t(context, "refund_transaction");
  }

  getContent() {
    if (_error != null) {
      return Text(
          t(context, "error_in_broadcasting_transaction") +
              ": " +
              _error.toString(),
          style: Theme.of(context).dialogTheme.contentTextStyle,
          textAlign: TextAlign.center);
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
        Text(
          t(context,
              "please_wait_while_breez_is_sending_the_funds_to_the_specified_address"),
          style: Theme.of(context).dialogTheme.contentTextStyle,
          textAlign: TextAlign.center,
        ),
        Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Image.asset(
              theme.customData[theme.themeId].loaderAssetPath,
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
                  t(context,
                      "funds_were_successfully_sent_to_the_specified_address"),
                  style: Theme.of(context).dialogTheme.contentTextStyle,
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
                child: Text(t(context, "transaction_id") + ":",
                    style: Theme.of(context).primaryTextTheme.headline4),
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
                      tooltip: t(context, "copy_text",
                          params: {"text": t(context, "transaction_hash")}),
                      iconSize: 16.0,
                      color: Theme.of(context).primaryTextTheme.button.color,
                      icon: Icon(
                        IconData(0xe90b, fontFamily: 'icomoon'),
                      ),
                      onPressed: () {
                        ServiceInjector()
                            .device
                            .setClipboardText(_response.txID);
                      },
                    ),
                    IconButton(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(top: 4.0, right: 0.0, left: 0.0),
                      tooltip: "Share Transaction Hash",
                      iconSize: 16.0,
                      color: Theme.of(context).primaryTextTheme.button.color,
                      icon: Icon(Icons.share),
                      onPressed: () {
                        ShareExtend.share(_response.txID, "text");
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
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline3
                          .copyWith(fontSize: 10)),
                ),
              ),
            ],
          )
        ]);
  }
}
