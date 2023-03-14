import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:share_plus/share_plus.dart';

class WaitBroadcastDialog extends StatefulWidget {
  final AccountBloc _accountBloc;
  final String _fromAddress;
  final String _toAddress;
  final Int64 _feeRate;

  const WaitBroadcastDialog(
    this._accountBloc,
    this._fromAddress,
    this._toAddress,
    this._feeRate,
  );

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
      widget._fromAddress,
      widget._toAddress,
      widget._feeRate,
    );
    widget._accountBloc.broadcastRefundRequestSink.add(broadcastModel);
  }

  @override
  void dispose() {
    _broadcastSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
        colorScheme: ColorScheme.dark(
          secondary: themeData.canvasColor,
        ),
      ),
      child: AlertDialog(
        title: Text(
          getTitleText(context),
          style: themeData.dialogTheme.titleTextStyle,
          textAlign: TextAlign.center,
        ),
        content: getContent(context),
        actions: _response == null && _error == null
            ? []
            : [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(
                    _error != null && _response?.txID?.isNotEmpty == true,
                  ),
                  child: Text(
                    texts.waiting_broadcast_dialog_action_close,
                    style: themeData.primaryTextTheme.labelLarge,
                  ),
                ),
              ],
      ),
    );
  }

  String getTitleText(BuildContext context) {
    final texts = context.texts();
    if (_error != null) {
      return texts.waiting_broadcast_dialog_dialog_title_error;
    }
    return texts.waiting_broadcast_dialog_dialog_title;
  }

  Widget getContent(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    if (_error != null) {
      return Text(
        texts.waiting_broadcast_dialog_content_error(_error.toString()),
        style: themeData.dialogTheme.contentTextStyle,
        textAlign: TextAlign.center,
      );
    }
    if (_response == null) {
      return getWaitingContent(context);
    }
    return getResultContent(context);
  }

  Widget getWaitingContent(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          texts.waiting_broadcast_dialog_content_warning,
          style: themeData.dialogTheme.contentTextStyle,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Image.asset(
            theme.customData[theme.themeId].loaderAssetPath,
            gaplessPlayback: true,
          ),
        ),
      ],
    );
  }

  Widget getResultContent(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  texts.waiting_broadcast_dialog_content_success,
                  style: themeData.dialogTheme.contentTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                texts.waiting_broadcast_dialog_transaction_id,
                style: themeData.primaryTextTheme.headlineMedium,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 36.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                      tooltip: texts.waiting_broadcast_dialog_action_copy,
                      iconSize: 16.0,
                      color: themeData.primaryTextTheme.labelLarge.color,
                      icon: const Icon(
                        IconData(
                          0xe90b,
                          fontFamily: "icomoon",
                        ),
                      ),
                      onPressed: () => ServiceInjector()
                          .device
                          .setClipboardText(_response.txID),
                    ),
                    IconButton(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                      tooltip: texts.waiting_broadcast_dialog_action_share,
                      iconSize: 16.0,
                      color: themeData.primaryTextTheme.labelLarge.color,
                      icon: const Icon(Icons.share),
                      onPressed: () => Share.share(_response.txID),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Text(
                  _response.txID,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  maxLines: 4,
                  style: themeData.primaryTextTheme.displaySmall.copyWith(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
