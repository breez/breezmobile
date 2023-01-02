import 'dart:async';

import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/channels_status_poller.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/circular_progress.dart';
import 'package:clovrlabs_wallet/widgets/loading_animated_text.dart';
import 'package:clovrlabs_wallet/widgets/payment_request_dialog.dart';
import 'package:clovrlabs_wallet/widgets/sync_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class ProcessingPaymentDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final GlobalKey firstPaymentItemKey;
  final Function(PaymentRequestState state) _onStateChange;
  final bool popOnCompletion;
  final Future Function() paymentFunc;
  final double minHeight;

  const ProcessingPaymentDialog(
    this.context,
    this.paymentFunc,
    this.accountBloc,
    this.firstPaymentItemKey,
    this._onStateChange,
    this.minHeight, {
    this.popOnCompletion = false,
  });

  @override
  ProcessingPaymentDialogState createState() {
    return ProcessingPaymentDialogState();
  }
}

class ProcessingPaymentDialogState extends State<ProcessingPaymentDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool _animating = false;
  double startHeight;
  Animation<Color> colorAnimation;
  Animation<double> borderAnimation;
  Animation<double> opacityAnimation;
  Animation<RelativeRect> transitionAnimation;
  final GlobalKey _dialogKey = GlobalKey();
  StreamSubscription<PaymentInfo> _pendingPaymentSubscription;
  ModalRoute _currentRoute;
  double channelsSyncProgress;
  final Completer synchronizedCompleter = Completer<bool>();
  UnconfirmedChannelsStatusPoller _channelsStatusPoller;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _channelsStatusPoller = UnconfirmedChannelsStatusPoller(
        widget.accountBloc.userActionsSink, (progress) {
      setState(() {
        channelsSyncProgress = progress;
      });
      if (progress == 1.0) {
        _channelsStatusPoller?.dispose();
        synchronizedCompleter.complete(true);
      }
    });
    _channelsStatusPoller.start();
  }

  void didChangeDependencies() {
    if (!_isInit) {
      synchronizedCompleter.future.then((value) {
        if (value == true) {
          _payAncClose();
          _currentRoute = ModalRoute.of(context);
          controller = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 500),
          );
          colorAnimation = ColorTween(
            begin: Theme.of(context).canvasColor,
            end: Theme.of(context).backgroundColor,
          ).animate(controller)
            ..addListener(() {
              setState(() {});
            });
          borderAnimation = Tween<double>(begin: 0.0, end: 12.0)
              .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
          opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
          controller.value = 1.0;
          controller.addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              if (widget.popOnCompletion) {
                Navigator.of(context).removeRoute(_currentRoute);
              }
              widget._onStateChange(PaymentRequestState.PAYMENT_COMPLETED);
            }
          });
        }
      }).catchError((err) {
        _closeDialog();
        return;
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  _closeDialog() {
    if (widget.popOnCompletion) {
      Navigator.of(context).removeRoute(_currentRoute);
    }
    widget._onStateChange(PaymentRequestState.USER_CANCELLED);
  }

  _payAncClose() {
    widget.paymentFunc().then((value) => _animateClose()).catchError((err) {
      if (widget.popOnCompletion) {
        Navigator.of(context).removeRoute(_currentRoute);
      }
      widget._onStateChange(PaymentRequestState.PAYMENT_COMPLETED);
    });

    _pendingPaymentSubscription = widget.accountBloc.pendingPaymentStream
        .where((p) => p.fullPending)
        .debounceTime(Duration(seconds: 10))
        .listen((p) => _animateClose());
  }

  void _animateClose() {
    Future.delayed(Duration(milliseconds: 50)).then((_) {
      _initializeTransitionAnimation();
      setState(() {
        _animating = true;
        controller.reverse();
      });
    });
  }

  void _initializeTransitionAnimation() {
    final queryData = MediaQuery.of(context);
    final statusBarHeight = queryData.padding.top;
    final safeArea = queryData.size.height - statusBarHeight;
    // We subtract dialog size from safe area and divide by half because the dialog
    // is at the center of the screen (distances to top and bottom are equal).
    RenderBox box = _dialogKey.currentContext.findRenderObject();
    startHeight = box.size.height;
    double yMargin = (safeArea - box.size.height) / 2;

    final endPosition = RelativeRect.fromLTRB(40.0, yMargin, 40.0, yMargin);
    RelativeRect startPosition = endPosition;
    final paymentCtx = widget.firstPaymentItemKey.currentContext;
    if (paymentCtx != null) {
      RenderBox _paymentTableBox = paymentCtx.findRenderObject();
      final dy = _paymentTableBox.localToGlobal(Offset.zero).dy;
      final start = dy - statusBarHeight;
      final end = safeArea - start - PAYMENT_LIST_ITEM_HEIGHT;
      startPosition = RelativeRect.fromLTRB(0.0, start, 0.0, end);
    }
    transitionAnimation = RelativeRectTween(
      begin: startPosition,
      end: endPosition,
    ).animate(controller);
  }

  @override
  void dispose() {
    _channelsStatusPoller?.dispose();
    _pendingPaymentSubscription?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (channelsSyncProgress == null || synchronizedCompleter.isCompleted) {
      return _animating
          ? _createAnimatedContent(context)
          : _createContentDialog(context);
    }

    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return AlertDialog(
      content: SyncProgressLoader(
        value: channelsSyncProgress ?? 0,
        title: texts.processing_payment_dialog_synchronizing,
      ),
      actions: [
        TextButton(
          onPressed: _closeDialog,
          child: Text(
            texts.processing_payment_dialog_action_close,
            style: themeData.primaryTextTheme.button,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildProcessingPaymentDialog(BuildContext context) {
    final themeData = theme.customData[theme.themeId];
    return [
      _buildTitle(context),
      _buildContent(context),
      Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: CircularProgress(
          size: 64.0,
        ),
      )
    ];
  }

  Widget _createContentDialog(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          minHeight: widget.minHeight,
        ),
        child: Column(
          key: _dialogKey,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: _buildProcessingPaymentDialog(context),
        ),
      ),
    );
  }

  Widget _createAnimatedContent(BuildContext context) {
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(context);

    return Opacity(
      opacity: opacityAnimation.value,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            PositionedTransition(
              rect: transitionAnimation,
              child: Container(
                height: startHeight,
                width: queryData.size.width,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: _buildProcessingPaymentDialog(context),
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: ShapeDecoration(
                  color: theme.themeId == "WHITE"
                      ? colorAnimation.value
                      : controller.value >= 0.25
                          ? themeData.backgroundColor
                          : colorAnimation.value,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      borderAnimation.value,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTitle(BuildContext context) {
    final texts = AppLocalizations.of(context);

    return Container(
      height: 64.0,
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        texts.processing_payment_dialog_processing_payment,
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(context);

    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          width: queryData.size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimatedText(
                texts.processing_payment_dialog_wait,
                textStyle: themeData.dialogTheme.contentTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChannelsSyncLoader extends StatelessWidget {
  final double progress;
  final Function onClose;

  const ChannelsSyncLoader({
    Key key,
    this.progress,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);

    return TransparentRouteLoader(
      message: texts.processing_payment_dialog_synchronizing_channels,
      value: progress,
      opacity: 0.9,
      onClose: onClose,
    );
  }
}
