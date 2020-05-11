import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/payment_request_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class ProcessingPaymentDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final GlobalKey firstPaymentItemKey;
  final Function(PaymentRequestState state) _onStateChange;
  final double _initialDialogSize;
  final bool popOnCompletion;
  final Future<String> paymentHashFuture;

  ProcessingPaymentDialog(
      this.context,
      this.paymentHashFuture,
      this.accountBloc,
      this.firstPaymentItemKey,
      this._initialDialogSize,
      this._onStateChange,
      {this.popOnCompletion = false});

  @override
  ProcessingPaymentDialogState createState() {
    return ProcessingPaymentDialogState();
  }
}

class ProcessingPaymentDialogState extends State<ProcessingPaymentDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Color> colorAnimation;
  Animation<double> borderAnimation;
  Animation<double> opacityAnimation;
  Animation<RelativeRect> transitionAnimation;

  StreamSubscription<CompletedPayment> _sentPaymentResultSubscription;
  StreamSubscription<PaymentInfo> _pendingPaymentSubscription;
  ModalRoute _currentRoute;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    if (!_isInit) {
      widget.paymentHashFuture.then((hash) {
        _listenPaymentsResults(hash);
      }).catchError((err) => Navigator.of(context).pop(err));

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
      _initializeTransitionAnimation();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  _listenPaymentsResults(String paymentHash) {
    _sentPaymentResultSubscription =
        widget.accountBloc.completedPaymentsStream.listen((fulfilledPayment) {
      if (fulfilledPayment.paymentHash == paymentHash) {
        _animateClose();
      }
    }, onError: (err) {
      var paymentError = err as PaymentError;
      if (paymentError.paymentHash == paymentHash) {
        if (widget.popOnCompletion) {
          Navigator.of(context).removeRoute(_currentRoute);
        }
        widget._onStateChange(PaymentRequestState.PAYMENT_COMPLETED);
      }
    });

    _pendingPaymentSubscription = widget.accountBloc.pendingPaymentStream
        .transform(DebounceStreamTransformer(Duration(seconds: 10)))
        .where((p) => p?.paymentHash == paymentHash)
        .listen((p) {
      _animateClose();
    });
  }

  void _animateClose() {
    Future.delayed(Duration(milliseconds: 50)).then((_) {
      _initializeTransitionAnimation();
      setState(() {
        controller.reverse();
      });
    });
  }

  void _initializeTransitionAnimation() {
    var kSystemStatusBarHeight = MediaQuery.of(context).padding.top;
    var kSafeArea = MediaQuery.of(context).size.height - kSystemStatusBarHeight;
    // We subtract dialog size from safe area and divide by half because the dialog is at the center of the screen(distances to top and bottom are equal).
    double _dialogYMargin = (kSafeArea - widget._initialDialogSize) / 2;

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
    _sentPaymentResultSubscription?.cancel();
    _pendingPaymentSubscription?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(children: <Widget>[
        PositionedTransition(
          rect: transitionAnimation,
          child: Container(
            height: widget._initialDialogSize,
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(minHeight: 220.0, maxHeight: 350.0),
            child: Opacity(
                opacity: opacityAnimation.value,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: _buildProcessingPaymentDialog())),
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
    );
  }

  List<Widget> _buildProcessingPaymentDialog() {
    List<Widget> _processingPaymentDialog = <Widget>[];
    _processingPaymentDialog.add(_buildTitle());
    _processingPaymentDialog.add(_buildContent());
    return _processingPaymentDialog;
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

  Expanded _buildContent() {
    return Expanded(
      flex: 1,
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
              Image.asset(
                theme.customData[theme.themeId].loaderAssetPath,
                height: 64.0,
                colorBlendMode:
                    theme.customData[theme.themeId].loaderColorBlendMode ??
                        BlendMode.srcIn,
                color: theme.themeId == "BLUE"
                    ? colorAnimation?.value ?? Colors.transparent
                    : null,
                gaplessPlayback: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
