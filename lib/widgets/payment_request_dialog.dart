import 'package:breez/widgets/amount_form_field.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:image/image.dart' as DartImage;
import 'package:breez/bloc/account/account_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/payment_failed_report_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'dart:async';

const PAYMENT_LIST_ITEM_HEIGHT = 72.0;
enum PaymentRequestState { PAYMENT_REQUEST, WAITING_FOR_CONFIRMATION, PROCESSING_PAYMENT}

class PaymentRequestDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final _transparentImage = DartImage.encodePng(DartImage.Image(300, 300));

  PaymentRequestDialog(this.context, this.accountBloc, this.invoice, this.firstPaymentItemKey, this.scrollController);

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestDialogState();
  }
}

class PaymentRequestDialogState extends State<PaymentRequestDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  GlobalKey _titleKey = GlobalKey();
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _actionsKey = GlobalKey();
  TextEditingController _invoiceAmountController = new TextEditingController();

  AnimationController controller;
  Animation<double> opacityAnimation;
  Animation<double> borderAnimation;
  Animation<RelativeRect> transitionAnimation;
  Animation<Color> colorAnimation;

  PaymentRequestState _state;

  AccountSettings _accountSettings;
  StreamSubscription<AccountModel> _paymentInProgressSubscription;
  StreamSubscription<AccountSettings> _accountSettingsSubscription;
  StreamSubscription<String> _sentPaymentResultSubscription;

  Int64 _amountToPay;
  String _amountToPayStr;

  bool _inProgress = false;

  double _dialogContentHeight;
  double _dialogTitleHeight;
  double _dialogActionsHeight;

  @override
  void initState() {
    super.initState();
    _state = PaymentRequestState.PAYMENT_REQUEST;
    _paymentInProgressSubscription = widget.accountBloc.accountStream.listen((acc) {
      _inProgress = acc.paymentRequestInProgress != null && acc.paymentRequestInProgress.isNotEmpty;
    });
    _listenPaymentsResults();
    _invoiceAmountController.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    _paymentInProgressSubscription?.cancel();
    _accountSettingsSubscription?.cancel();
    _sentPaymentResultSubscription?.cancel();
    controller?.dispose();
    super.dispose();
  }

  _listenPaymentsResults() {
    _accountSettingsSubscription = widget.accountBloc.accountSettingsStream
        .listen((settings) => _accountSettings = settings);

    _sentPaymentResultSubscription = widget.accountBloc.fulfilledPayments.listen((fulfilledPayment) {
      controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 500));
      borderAnimation = Tween<double>(begin: 0.0, end: 8.0)
          .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
      opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
      colorAnimation = new ColorTween(
        begin: theme.BreezColors.blue[500],
        end: theme.BreezColors.white[500],
      ).animate(controller)
        ..addListener(() {
          setState(() {});
        });
      controller.addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          Navigator.pop(context);
        }
      });

      Future scrollAnimationFuture = Future.value(null);
      if (widget.scrollController.hasClients) {
        scrollAnimationFuture = widget.scrollController
            .animateTo(widget.scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 200), curve: Curves.ease)
            .whenComplete(() => Future.delayed(Duration(milliseconds: 50)));
      }

      scrollAnimationFuture.whenComplete(() {
        _initializeTransitionAnimation();
        controller.value = 1.0;
        // Trigger the collapse animation and show flushbar after the animation is completed
        controller.reverse().whenComplete(() =>
            showFlushbar(context, message: "Payment was successfuly sent!"));
      });
    }, onError: (err) => _onPaymentError(_accountSettings, err as PaymentError));
  }

  void _initializeTransitionAnimation() {
    double _dialogYMargin = _getDialogPosition();
    RenderBox _paymentTableBox = widget.firstPaymentItemKey.currentContext.findRenderObject();
    var _paymentItemStartPosition = _paymentTableBox.localToGlobal(Offset.zero).dy - MediaQuery.of(widget.context).padding.top;
    var _paymentItemEndPosition = (MediaQuery.of(context).size.height - MediaQuery.of(widget.context).padding.top - _paymentItemStartPosition) - PAYMENT_LIST_ITEM_HEIGHT;
    var tween = new RelativeRectTween(
        begin: new RelativeRect.fromLTRB(0.0, _paymentItemStartPosition, 0.0, _paymentItemEndPosition),
        end: new RelativeRect.fromLTRB(32.0, _dialogYMargin - _dialogTitleHeight, 32.0, _dialogYMargin - _dialogTitleHeight));
    transitionAnimation = tween.animate(controller);
  }

  double _getDialogPosition() {
    final RenderBox _dialogTitleBox = _titleKey.currentContext?.findRenderObject();
    final _dialogTitlePosition = _dialogTitleBox?.localToGlobal(Offset.zero);
    final RenderBox _dialogContentBox = _contentKey.currentContext?.findRenderObject();
    final _dialogContentPosition = _dialogContentBox?.localToGlobal(Offset.zero);
    var _dialogYMargin =  _dialogTitlePosition?.dy ?? _dialogContentPosition?.dy;
    return _dialogYMargin;
  }

  _onPaymentError(AccountSettings accountSettings, PaymentError error) async {
    bool prompt =
        accountSettings.failePaymentBehavior == BugReportBehavior.PROMPT;
    bool send =
        accountSettings.failePaymentBehavior == BugReportBehavior.SEND_REPORT;

    // Close Payment Request Dialog
    Navigator.pop(context);
    showFlushbar(context,
        message:
            "Failed to send payment: ${error.toString().split("\n").first}");

    if (!error.validationError) {
      if (prompt) {
        send = await showDialog(
            context: widget.context,
            barrierDismissible: false,
            builder: (_) => new PaymentFailedReportDialog(
                widget.context, widget.accountBloc));
      }

      if (send) {
        var sendAction = SendPaymentFailureReport(error.traceReport);
        widget.accountBloc.userActionsSink.add(sendAction);
        await Navigator.push(
            widget.context,
            createLoaderRoute(widget.context,
                message: "Sending Report...",
                opacity: 0.8,
                action: sendAction.future));
      }
    }
  }

  // Do not pop dialog if there's a payment being processed
  Future<bool> _onWillPop() async {
    if (_inProgress) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop, child: showPaymentRequestDialog());
  }

  Widget showPaymentRequestDialog() {
    var _titlePadding = _state == PaymentRequestState.PAYMENT_REQUEST
        ? widget.invoice.payeeImageURL.isEmpty
        ? EdgeInsets.zero : EdgeInsets.only(top: 48.0)
        : EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0);
    var _contentPadding = _state == PaymentRequestState.PAYMENT_REQUEST
        ? EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0)
        : EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0);
    return controller == null
        ? new AlertDialog(
            title: _buildPaymentRequestTitle(),
            titlePadding: _titlePadding,
            content: _buildPaymentRequestContent(),
            contentPadding: _contentPadding,
            actions: [_buildPaymentRequestActions()],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
          )
        : Material(
            color: Colors.transparent,
            child: Stack(children: <Widget>[
              PositionedTransition(
                rect: transitionAnimation,
                child: Container(
                  height: widget.invoice.payeeImageURL.isEmpty
                      ? _dialogContentHeight - _dialogTitleHeight
                      : _dialogContentHeight + _dialogTitleHeight,
                  width: MediaQuery.of(context).size.width,
                  decoration: ShapeDecoration(
                    color: colorAnimation.value,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(borderAnimation.value)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Opacity(
                            opacity: opacityAnimation.value,
                            child: Padding(
                                padding: _titlePadding,
                                child: _buildPaymentRequestTitle())),
                        Opacity(
                            opacity: opacityAnimation.value,
                            child: Padding(
                                padding: _contentPadding,
                                child: _buildPaymentRequestContent())),
                        Opacity(
                            opacity: opacityAnimation.value,
                            child: _buildPaymentRequestActions())
                      ]),
                ),
              ),
            ]));
  }

  Widget _buildPaymentRequestActions() {
    if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      List<Widget> children = <Widget>[
        new FlatButton(
          child: new Text("NO", style: theme.buttonStyle),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text("YES", style: theme.buttonStyle),
          onPressed: () {
            widget.accountBloc.sentPaymentsSink
                .add(PayRequest(widget.invoice.rawPayReq, _amountToPay));
            setState(() {
              _state = PaymentRequestState.PROCESSING_PAYMENT;
            });
          },
        ),
      ];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: Row(
          key: _actionsKey,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: children,
        ),
      );
    } else {
      return null;
    }
  }

  _getDialogSize(){
    final RenderBox _dialogTitleBox = _titleKey.currentContext?.findRenderObject();
    final _dialogTitleSize = _dialogTitleBox?.size;

    final RenderBox _dialogContentBox = _contentKey.currentContext?.findRenderObject();
    final _dialogContentSize = _dialogContentBox?.size;

    final RenderBox _dialogActionsBox = _actionsKey.currentContext?.findRenderObject();
    final _dialogActionsSize = _dialogActionsBox?.size;

    setState(() {
      _dialogTitleHeight = _dialogTitleSize?.height ?? (widget.invoice.payeeImageURL.isEmpty ? 43.0 : 48.0); // 27 + 16.0
      _dialogContentHeight = _dialogContentSize?.height ?? _dialogContentHeight;
      _dialogActionsHeight = _dialogActionsSize?.height ?? 64.0; // Actions Height = 48.0 + 16.0 Bottom Padding
    });
  }

  Widget _buildPaymentRequestContent() {
    if (_state == PaymentRequestState.PAYMENT_REQUEST) {
      return StreamBuilder<AccountModel>(
        stream: widget.accountBloc.accountStream,
        builder: (context, snapshot) {
          var account = snapshot.data;
          if (account == null) {
            return new Container(width: 0.0, height: 0.0);
          }
          List<Widget> children = [];
          _addIfNotNull(children, _buildPayeeNameWidget());
          _addIfNotNull(children, _buildRequestPayTextWidget());
          _addIfNotNull(children, _buildAmountWidget(account));
          _addIfNotNull(children, _buildDescriptionWidget());
          _addIfNotNull(children, _buildErrorMessage(account));
          _addIfNotNull(children, _buildActions(account));

          return Container(
            key: _contentKey,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          );
        },
      );
    } else if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      return Container(
          key: _contentKey,
          height: widget.invoice.payeeImageURL.isEmpty
              ? _dialogContentHeight - _dialogActionsHeight - _dialogTitleHeight : _dialogContentHeight + _dialogTitleHeight - _dialogActionsHeight, // In reference to first dialog, this dialog had both title and actions field so we subtract those values
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Are you sure you want to pay',
                  style: theme.alertStyle,
                  textAlign: TextAlign.center,
                ),
                AutoSizeText.rich(
                    TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: _amountToPayStr,
                          style: theme.alertStyle.copyWith(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      TextSpan(text: " ?")
                    ]),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: theme.alertStyle),
              ]));
    } else if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return Container(
          key: _contentKey,
          height: widget.invoice.payeeImageURL.isEmpty
              ? _dialogContentHeight - _dialogTitleHeight : _dialogContentHeight + _dialogTitleHeight, // In reference to first dialog, this dialog had title field so we subtract that value
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoadingAnimatedText(
                'Please wait while your payment is being processed',
                textStyle: theme.alertStyle,
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'src/images/breez_loader.gif',
                height: 64.0,
                colorBlendMode: BlendMode.multiply,
                color: colorAnimation != null ? colorAnimation.value : Colors.transparent,
                gaplessPlayback: true,
              )
            ],
          ));
    }
    return null;
  }

  Widget _buildPaymentRequestTitle() {
    if (_state == PaymentRequestState.PAYMENT_REQUEST) {
      return widget.invoice.payeeImageURL.isEmpty
          ? null
          : Stack(
              key: _titleKey,
              alignment: Alignment(0.0, 0.0),
              children: <Widget>[
                  CircularProgressIndicator(),
                  ClipOval(
                    child: FadeInImage(
                        width: 64.0,
                        height: 64.0,
                        placeholder: MemoryImage(widget._transparentImage),
                        image: AdvancedNetworkImage(
                            widget.invoice.payeeImageURL,
                            useDiskCache: true),
                        fadeOutDuration: new Duration(milliseconds: 200),
                        fadeInDuration: new Duration(milliseconds: 200)),
                  )
                ]);
    } else if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      return Text(
        "Payment Confirmation",
        key: _titleKey,
        style: theme.alertTitleStyle,
        textAlign: TextAlign.center,
      );
    } else if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return Text(
        "Processing Payment",
        key: _titleKey,
        style: theme.alertTitleStyle,
        textAlign: TextAlign.center,
      );
    }
    return null;
  }

  void _addIfNotNull(List<Widget> widgets, Widget w) {
    if (w != null) {
      widgets.add(w);
    }
  }

  Widget _buildPayeeNameWidget() {
    return widget.invoice.payeeName == null
        ? null
        : Text(
            "${widget.invoice.payeeName}",
            style: theme.paymentRequestTitleStyle,
            textAlign: TextAlign.center,
          );
  }

  Widget _buildErrorMessage(AccountModel account) {
    String validationError = account.validateOutgoingPayment(amountToPay(account));
    if (validationError == null || widget.invoice.amount == 0) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: AutoSizeText(validationError,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: theme.paymentRequestSubtitleStyle.copyWith(color: Colors.red)),
    );
  }

  Widget _buildRequestPayTextWidget() {
    return widget.invoice.payeeName == null || widget.invoice.payeeName.isEmpty
        ? new Text(
            "You are requested to pay:",
            style: theme.paymentRequestSubtitleStyle,
            textAlign: TextAlign.center,
          )
        : new Text(
            "is requesting you to pay:",
            style: theme.paymentRequestSubtitleStyle,
            textAlign: TextAlign.center,
          );
  }

  Widget _buildAmountWidget(AccountModel account) {
    if (widget.invoice.amount == 0) {
      return Theme(
        data: Theme.of(context).copyWith(
            hintColor: theme.alertStyle.color,
            accentColor: theme.BreezColors.blue[500],
            primaryColor: theme.BreezColors.blue[500],
            errorColor: Colors.red),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              height: 80.0,
              child: AmountFormField(
                style: theme.alertStyle.copyWith(height: 1.0),
                validatorFn: account.validateOutgoingPayment,
                currency: account.currency,
                controller: _invoiceAmountController,
                decoration: new InputDecoration(
                    labelText: account.currency.displayName + " Amount"),
              ),
            ),
          ),
        ),
      );
    }
    return Text(
      account.currency.format(widget.invoice.amount),
      style: theme.paymentRequestAmountStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescriptionWidget() {
    return widget.invoice.description == null || widget.invoice.description.isEmpty
        ? null
        : Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: AutoSizeText(
              widget.invoice.description,
              style: theme.paymentRequestSubtitleStyle,
              textAlign: widget.invoice.description.length > 40
                  ? TextAlign.justify
                  : TextAlign.center,
              maxLines: 3,
            ),
          );
  }

  Widget _buildActions(AccountModel account) {
    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: new Text("CANCEL", style: theme.buttonStyle),
      )
    ];

    Int64 toPay = amountToPay(account);
    if (toPay > 0 && account.maxAllowedToPay >= toPay) {
      actions.add(SimpleDialogOption(
        onPressed: (() async {
          _getDialogSize();
          if (widget.invoice.amount > 0 || _formKey.currentState.validate()) {
            if (widget.invoice.amount == 0) {
              setState(() {
                _state = PaymentRequestState.WAITING_FOR_CONFIRMATION;
                _amountToPay = toPay;
                _amountToPayStr = account.currency.format(amountToPay(account));
              });
            } else {
              widget.accountBloc.sentPaymentsSink.add(
                  PayRequest(widget.invoice.rawPayReq, amountToPay(account)));
              setState(() {
                _state = PaymentRequestState.PROCESSING_PAYMENT;
              });
            }
          }
        }),
        child: new Text("APPROVE", style: theme.buttonStyle),
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions,
      ),
    );
  }

  Int64 amountToPay(AccountModel acc) {
    Int64 amount = widget.invoice.amount;
    if (amount == 0) {
      try {
        amount = acc.currency.parse(_invoiceAmountController.text);
      } catch (e) {}
    }
    return amount;
  }
}
