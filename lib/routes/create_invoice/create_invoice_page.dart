import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/charge/succesful_payment.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/services/background_task.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/utils/i18n.dart';

import 'lnurl_withdraw_dialog.dart';
import 'qr_code_dialog.dart';

class CreateInvoicePage extends StatefulWidget {
  final WithdrawFetchResponse lnurlWithdraw;

  const CreateInvoicePage({this.lnurlWithdraw});

  @override
  State<StatefulWidget> createState() {
    return CreateInvoicePageState();
  }
}

class CreateInvoicePageState extends State<CreateInvoicePage> {
  WithdrawFetchResponse _withdrawFetchResponse;

  final _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  StreamSubscription<PaymentRequestModel> _paidInvoicesSubscription;
  bool _isInit = false;
  final FocusNode _amountFocusNode = FocusNode();
  final BackgroundTaskService _bgService =
      ServiceInjector().backgroundTaskService;
  KeyboardDoneAction _doneAction;

  @override
  void didChangeDependencies() {
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);
    if (!_isInit) {
      _paidInvoicesSubscription = invoiceBloc.paidInvoicesStream.listen((paid) {
        Navigator.pop(context, "Payment was successfully received!");
      });
      if (widget.lnurlWithdraw != null) {
        accBloc.accountStream.first.then((account) {
          setState(() {
            applyWithdrawFetchResponse(widget.lnurlWithdraw, account);
          });
        });
      }

      _isInit = true;
      if (widget.lnurlWithdraw == null) {
        Future.delayed(Duration(milliseconds: 200),
            () => FocusScope.of(context).requestFocus(_amountFocusNode));
      }
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
    super.initState();
  }

  @override
  void dispose() {
    _paidInvoicesSubscription?.cancel();
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = "receive_via_invoice";
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    LNUrlBloc lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: StreamBuilder<AccountModel>(
          stream: accountBloc.accountStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return StaticLoader();
            }
            var account = snapshot.data;
            return Padding(
              padding: EdgeInsets.only(
                  bottom: (Platform.isIOS && _amountFocusNode.hasFocus)
                      ? 40.0
                      : 0.0),
              child: SingleButtonBottomBar(
                stickToBottom: true,
                text: I18N.t(context,
                    _withdrawFetchResponse == null ? "CREATE" : "REDEEM"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _createInvoice(
                        invoiceBloc, accountBloc, lnurlBloc, account);
                  }
                },
              ),
            );
          }),
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        actions: <Widget>[
          StreamBuilder<Object>(
              stream: accountBloc.accountStream,
              builder: (context, snapshot) {
                var account = snapshot.data;
                return IconButton(
                  alignment: Alignment.center,
                  icon: Image(
                    image: AssetImage("src/icon/qr_scan.png"),
                    color: theme.BreezColors.white[500],
                    fit: BoxFit.contain,
                    width: 24.0,
                    height: 24.0,
                  ),
                  tooltip: 'Scan Barcode',
                  onPressed: () =>
                      account != null ? _scanBarcode(account) : null,
                );
              })
        ],
        title: Text(I18N.t(context, _title),
            style: Theme.of(context).appBarTheme.textTheme.headline6),
        elevation: 0.0,
      ),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          AccountModel acc = snapshot.data;
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        maxLength: 90,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                          labelText: I18N.t(context, "description_optional"),
                        ),
                        style: theme.FieldTextStyle.textStyle,
                      ),
                      AmountFormField(
                          context: context,
                          accountModel: acc,
                          focusNode: _amountFocusNode,
                          controller: _amountController,
                          validatorFn: acc.validateIncomingPayment,
                          style: theme.FieldTextStyle.textStyle),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        padding: EdgeInsets.only(top: 16.0),
                        child: _buildReceivableBTC(acc),
                      ),
                      StreamBuilder(
                          stream: accountBloc.accountStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<AccountModel> accSnapshot) {
                            if (!accSnapshot.hasData) {
                              return Container();
                            }
                            AccountModel acc = accSnapshot.data;

                            String message;
                            if (accSnapshot.hasError) {
                              message = accSnapshot.error.toString();
                            } else if (!accSnapshot.hasData) {
                              message =
                                  'Receiving payments will be available as soon as Breez is synchronized.';
                            } else if (acc.processingConnection) {
                              message =
                                  'You will be able to receive payments after Breez is finished opening a secure channel with our server. This usually takes ~10 minutes to be completed. Please try again in a couple of minutes.';
                            }

                            if (message != null) {
                              // In case error doesn't have a trailing full stop
                              if (!message.endsWith('.')) {
                                message += '.';
                              }
                              return Container(
                                  padding: EdgeInsets.only(
                                      top: 50.0, left: 30.0, right: 30.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      message,
                                      textAlign: TextAlign.center,
                                      style: theme.warningStyle.copyWith(
                                          color: Theme.of(context).errorColor),
                                    ),
                                  ]));
                            } else {
                              return SizedBox();
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceivableBTC(AccountModel acc) {
    return GestureDetector(
      child: AutoSizeText(
        I18N.t(context, "receive_up_to", translationParams: {
          "max": acc.currency.format(acc.maxAllowedToReceive)
        }),
        style: theme.textStyle,
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
      ),
      onTap: () => _amountController.text = acc.currency.format(
          acc.maxAllowedToReceive,
          includeDisplayName: false,
          userInput: true),
    );
  }

  Future _scanBarcode(AccountModel account) async {
    TransparentPageRoute loaderRoute;
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      String barcode = await Navigator.pushNamed<String>(context, "/qr_scan");
      if (barcode == null) {
        return;
      }
      if (barcode.isEmpty) {
        showFlushbar(context, message: "QR code wasn't detected.");
        return;
      }
      loaderRoute = createLoaderRoute(context);
      Navigator.of(context).push(loaderRoute);
      await _handleLNUrlWithdraw(account, barcode);
      Navigator.of(context).removeRoute(loaderRoute);
    } catch (e) {
      if (loaderRoute != null) {
        Navigator.of(context).removeRoute(loaderRoute);
      }
      promptError(
          context,
          "Receive Failed",
          Text("Reason: ${e.toString()}",
              style: Theme.of(context).dialogTheme.contentTextStyle));
    }
  }

  Future _handleLNUrlWithdraw(AccountModel account, String lnurl) async {
    LNUrlBloc lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
    Fetch fetchAction = Fetch(lnurl);
    lnurlBloc.actionsSink.add(fetchAction);
    var response = await fetchAction.future;
    if (response.runtimeType != WithdrawFetchResponse) {
      throw "Invalid URL";
    }
    WithdrawFetchResponse withdrawResponse = response as WithdrawFetchResponse;
    setState(() {
      applyWithdrawFetchResponse(withdrawResponse, account);
    });
  }

  void applyWithdrawFetchResponse(
      WithdrawFetchResponse response, AccountModel account) {
    _withdrawFetchResponse = response;
    _descriptionController.text = response.defaultDescription;
    _amountController.text = account.currency
        .format(response.maxAmount, includeDisplayName: false, userInput: true);
  }

  Future _createInvoice(InvoiceBloc invoiceBloc, AccountBloc accountBloc,
      LNUrlBloc lnurlBloc, AccountModel account) {
    invoiceBloc.newInvoiceRequestSink.add(InvoiceRequestModel(
        null,
        _descriptionController.text,
        null,
        account.currency.parse(_amountController.text)));
    var navigator = Navigator.of(context);
    navigator.pop();
    var currentRoute = ModalRoute.of(navigator.context);
    Widget dialog = _withdrawFetchResponse != null
        ? LNURlWithdrawDialog(invoiceBloc, accountBloc, lnurlBloc, (result) {
            onPaymentFinished(result, currentRoute, navigator);
          })
        : QrCodeDialog(context, invoiceBloc, accountBloc, (result) {
            onPaymentFinished(result, currentRoute, navigator);
          });
    return _bgService.runAsTask(
        showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (_) => dialog), () {
      log.info("waiting for payment background task finished");
    });
  }

  onPaymentFinished(
      dynamic result, ModalRoute currentRoute, NavigatorState navigator) {
    {
      if (result == true) {
        if (currentRoute.isCurrent) {
          navigator.push(TransparentPageRoute((ctx) {
            return withBreezTheme(ctx, SuccessfulPaymentRoute());
          }));
        }
      } else {
        if (result is String) {
          showFlushbar(context, title: "", message: result);
        }
      }
    }
  }
}
