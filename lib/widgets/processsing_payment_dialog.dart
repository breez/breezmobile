import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/channels_status_poller.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/payment_request_dialog.dart';
import 'package:breez/widgets/sync_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/utils/i18n.dart';
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

  ProcessingPaymentDialog(this.context, this.paymentFunc, this.accountBloc,
      this.firstPaymentItemKey, this._onStateChange, this.minHeight,
      {this.popOnCompletion = false});

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
              vsync: this, duration: Duration(milliseconds: 500));
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
        .listen((p) {
      _animateClose();
    });
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
    var kSystemStatusBarHeight = MediaQuery.of(context).padding.top;
    var kSafeArea = MediaQuery.of(context).size.height - kSystemStatusBarHeight;
    // We subtract dialog size from safe area and divide by half because the dialog is at the center of the screen(distances to top and bottom are equal).
    RenderBox box = _dialogKey.currentContext.findRenderObject();
    startHeight = box.size.height;
    double _dialogYMargin = (kSafeArea - box.size.height) / 2;

    RelativeRect endPosition =
        RelativeRect.fromLTRB(40.0, _dialogYMargin, 40.0, _dialogYMargin);
    RelativeRect startPosition = endPosition;
    if (widget.firstPaymentItemKey.currentContext != null) {
      RenderBox _paymentTableBox =
          widget.firstPaymentItemKey.currentContext.findRenderObject();
      var _paymentItemStartPosition =
          _paymentTableBox.localToGlobal(Offset.zero).dy -
              kSystemStatusBarHeight;
      var _paymentItemEndPosition =
          (kSafeArea - _paymentItemStartPosition) - PAYMENT_LIST_ITEM_HEIGHT;
      startPosition = RelativeRect.fromLTRB(
          0.0, _paymentItemStartPosition, 0.0, _paymentItemEndPosition);
    }
    var tween = RelativeRectTween(begin: startPosition, end: endPosition);
    transitionAnimation = tween.animate(controller);
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
      return _animating ? _createAnimatedContent() : _createContentDialog();
    }
    return AlertDialog(
      content: SyncProgressLoader(
          value: channelsSyncProgress ?? 0,
          title: t(context, "synchronizing_to_the_network")),
      actions: <Widget>[
        FlatButton(
          onPressed: (() {
            _closeDialog();
          }),
          child:
              Text("CLOSE", style: Theme.of(context).primaryTextTheme.button),
        )
      ],
    );
  }

  List<Widget> _buildProcessingPaymentDialog() {
    List<Widget> _processingPaymentDialog = <Widget>[];
    _processingPaymentDialog.add(_buildTitle());
    _processingPaymentDialog.add(_buildContent());
    _processingPaymentDialog.add(Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Image.asset(
        theme.customData[theme.themeId].loaderAssetPath,
        height: 64.0,
        colorBlendMode: theme.customData[theme.themeId].loaderColorBlendMode ??
            BlendMode.srcIn,
        color: theme.themeId == "BLUE"
            ? colorAnimation?.value ?? Colors.transparent
            : null,
        gaplessPlayback: true,
      ),
    ));
    return _processingPaymentDialog;
  }

  Widget _createContentDialog() {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(minHeight: widget.minHeight),
        child: Column(
            key: _dialogKey,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: _buildProcessingPaymentDialog()),
      ),
    );
  }

  Widget _createAnimatedContent() {
    return Opacity(
      opacity: opacityAnimation.value,
      child: Material(
        color: Colors.transparent,
        child: Stack(children: <Widget>[
          PositionedTransition(
            rect: transitionAnimation,
            child: Container(
              height: startHeight,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildProcessingPaymentDialog()),
              decoration: ShapeDecoration(
                color: theme.themeId == "BLUE"
                    ? colorAnimation.value
                    : (controller.value >= 0.25
                        ? Theme.of(context).backgroundColor
                        : colorAnimation.value),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderAnimation.value)),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Container _buildTitle() {
    return Container(
      height: 64.0,
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        "Processing Payment",
        style: Theme.of(context).dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoadingAnimatedText(
                'Please wait while your payment is being processed',
                textStyle: Theme.of(context).dialogTheme.contentTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChanelsSyncLoader extends StatelessWidget {
  final double progress;
  final Function onClose;

  const ChanelsSyncLoader({Key key, this.progress, this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TransparentRouteLoader(
      message: "Breez is synchronizing your channels",
      value: progress,
      opacity: 0.9,
      onClose: onClose,
    );
  }
}
