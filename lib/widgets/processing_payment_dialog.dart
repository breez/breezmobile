import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/payment_request_dialog.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
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

  bool _isInit = false;

  @override
  void initState() {
    super.initState();    
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Future.value(true).then((_) {        
          _payAncClose();
          _currentRoute = ModalRoute.of(context);
          controller = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          );
          colorAnimation = ColorTween(
            begin: Theme.of(context).canvasColor,
            end: Theme.of(context).colorScheme.background,
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
        .debounceTime(const Duration(seconds: 10))
        .listen((p) => _animateClose());
  }

  void _animateClose() {
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
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
      RenderBox paymentTableBox = paymentCtx.findRenderObject();
      final dy = paymentTableBox.localToGlobal(Offset.zero).dy;
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
    _pendingPaymentSubscription?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animating
          ? _createAnimatedContent(context)
          : _createContentDialog(context);
  }

  List<Widget> _buildProcessingPaymentDialog(BuildContext context) {
    final themeData = theme.customData[theme.themeId];
    return [
      _buildTitle(context),
      _buildContent(context),
      Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Image.asset(
          themeData.loaderAssetPath,
          height: 64.0,
          colorBlendMode: themeData.loaderColorBlendMode ?? BlendMode.srcIn,
          color: theme.themeId == "BLUE"
              ? colorAnimation?.value ?? Colors.transparent
              : null,
          gaplessPlayback: true,
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
                decoration: ShapeDecoration(
                  color: theme.themeId == "BLUE"
                      ? colorAnimation.value
                      : controller.value >= 0.25
                          ? themeData.colorScheme.background
                          : colorAnimation.value,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      borderAnimation.value,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildProcessingPaymentDialog(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTitle(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Container(
      height: 64.0,
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        texts.processing_payment_dialog_processing_payment,
        style: themeData.dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: SizedBox(
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
    );
  }
}
