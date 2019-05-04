import 'package:breez/widgets/amount_form_field.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:image/image.dart' as DartImage;
import 'package:breez/bloc/account/account_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/widgets/loading_animated_text.dart';

enum PaymentRequestState { PAYMENT_REQUEST, WAITING_FOR_CONFIRMATION, PROCESSING_PAYMENT}
final key = new GlobalKey<PaymentRequestDialogState>();

class PaymentRequestDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final _transparentImage = DartImage.encodePng(DartImage.Image(300, 300));

  PaymentRequestDialog(this.context, this.accountBloc, this.invoice, Key key)
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestDialogState();
  }
}

class PaymentRequestDialogState extends State<PaymentRequestDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _invoiceAmountController = new TextEditingController();

  AnimationController controller;
  Animation<double> opacityAnimation;
  Animation<double> borderAnimation;
  Animation<RelativeRect> transitionAnimation;
  Animation<Color> colorAnimation;

  PaymentRequestState _state;

  Int64 _amountToPay;
  String _amountToPayStr;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _state = PaymentRequestState.PAYMENT_REQUEST;
    });
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));
    borderAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    colorAnimation = new ColorTween(
      begin: theme.BreezColors.blue[500],
      end: theme.BreezColors.white[500],
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    _invoiceAmountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      var xMargin = (MediaQuery.of(context).size.height - 300.0) / 2;
      if (widget.invoice.payeeImageURL.isNotEmpty){
        xMargin = xMargin - 10;
        if (widget.invoice.description.isNotEmpty){
          var lineCount = (widget.invoice.description.length / 30).ceil();
          xMargin = xMargin - (lineCount*24);
        }
      }
      var _paymentItemStartPosition = ((MediaQuery.of(context).size.height) * 37)/100;
      var _paymentItemEndPosition = ((MediaQuery.of(context).size.height) * 50)/100;
      transitionAnimation = new RelativeRectTween(
          begin: new RelativeRect.fromLTRB(0.0, _paymentItemStartPosition, 0.0, _paymentItemEndPosition),
          end: new RelativeRect.fromLTRB(32.0, xMargin, 32.0, xMargin))
          .animate(controller);
      controller.value = 1.0;
      controller.addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          Navigator.pop(context);
        }
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showPaymentRequestDialog();
  }

  Widget showPaymentRequestDialog() {
    var titlePadding = _state == PaymentRequestState.PAYMENT_REQUEST
        ? widget.invoice.payeeImageURL.isEmpty
        ? EdgeInsets.zero : EdgeInsets.only(top: 48.0)
        : EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0);
    var contentPadding = _state == PaymentRequestState.PAYMENT_REQUEST
    ? EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0)
        : EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0);
    return Material(
        color: Colors.transparent,
        child: Stack(children: <Widget>[
          PositionedTransition(
            rect: transitionAnimation,
            child: Container(
              decoration: ShapeDecoration(
                color: colorAnimation.value,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderAnimation.value)),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Opacity(
                        opacity: opacityAnimation.value,
                        child: Padding(
                            padding: titlePadding,
                            child: _buildPaymentRequestTitle())),
                    Opacity(
                        opacity: opacityAnimation.value,
                        child: Padding(
                            padding: contentPadding,
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
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      );
    } else {
      return Container();
    }
  }

  Widget _buildPaymentRequestContent() {
    if (_state == PaymentRequestState.PAYMENT_REQUEST) {
      return StreamBuilder<AccountModel>(
        stream: widget.accountBloc.accountStream,
        builder: (context, snapshot) {
          var account = snapshot.data;
          if (account == null) {
            return Container();
          }
          List<Widget> children = [];
          _addIfNotNull(children, _buildPayeeNameWidget());
          _addIfNotNull(children, _buildRequestPayTextWidget());
          _addIfNotNull(children, _buildAmountWidget(account));
          _addIfNotNull(children, _buildDescriptionWidget());
          _addIfNotNull(children, _buildErrorMessage(account));
          _addIfNotNull(children, _buildActions(account));

          return Container(
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
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AutoSizeText.rich(TextSpan(
                text: 'Are you sure you want to pay ', children: <TextSpan>[
              TextSpan(text: _amountToPayStr,
                  style: theme.alertStyle.copyWith(fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              TextSpan(text: "?")
            ]),
                maxLines: 2,
                minFontSize: 20.0,
                textAlign: TextAlign.center,
                style: theme.alertStyle
            )
          ]
      );
    } else if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          LoadingAnimatedText(
            'Please wait while your payment is being processed',
            textStyle: theme.alertStyle,
            textAlign: TextAlign.center,),
          Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: new Image.asset(
                'src/images/breez_loader.gif',
                gaplessPlayback: true,
              ))
        ],
      );
    }
    return Container();
  }

  Widget _buildPaymentRequestTitle() {
    if (_state == PaymentRequestState.PAYMENT_REQUEST) {
      return widget.invoice.payeeImageURL.isEmpty
          ? Container()
          : Stack(alignment: Alignment(0.0, 0.0), children: <Widget>[
        CircularProgressIndicator(),
        ClipOval(
          child: FadeInImage(
              width: 64.0,
              height: 64.0,
              placeholder: MemoryImage(widget._transparentImage),
              image: AdvancedNetworkImage(widget.invoice.payeeImageURL,
                  useDiskCache: true),
              fadeOutDuration: new Duration(milliseconds: 200),
              fadeInDuration: new Duration(milliseconds: 200)),
        )
      ]);
    } else if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      return Text(
        "Payment Confirmation",
        style: theme.alertTitleStyle,
          textAlign: TextAlign.center,
      );
    } else if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return Text(
        "Processing Payment",
        style: theme.alertTitleStyle,
        textAlign: TextAlign.center,
      );
    }
    return Container();
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
                      labelText: account.currency.displayName +
                          " Amount"),
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
