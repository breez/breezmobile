import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/user/create_invoice/qr_code_dialog.dart';
import 'package:breez/services/background_task.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'lnurl_withdraw_dialog.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage();

  @override
  State<StatefulWidget> createState() {
    return new CreateInvoicePageState();
  }
}

class CreateInvoicePageState extends State<CreateInvoicePage> {
  LNUrlBloc _lnurlBloc;
  String _withdrawUrl;

  final _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _descriptionController =
      new TextEditingController();
  final TextEditingController _amountController = new TextEditingController();

  StreamSubscription<bool> _paidInvoicesSubscription;
  bool _isInit = false;
  final FocusNode _amountFocusNode = FocusNode();
  final BackgroundTaskService _bgService = ServiceInjector().backgroundTaskService;
  KeyboardDoneAction _doneAction;

  @override void didChangeDependencies(){        
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    if (!_isInit) {      
      _paidInvoicesSubscription = invoiceBloc.paidInvoicesStream.listen((paid) {            
            Navigator.popUntil(context, ModalRoute.withName("/create_invoice"));  
            Navigator.pop(context, "Payment was successfuly received!");            
      });
      _isInit = true;
      Future.delayed(Duration(milliseconds: 200), () => FocusScope.of(context).requestFocus(_amountFocusNode));
    }
    super.didChangeDependencies();
  }

  @override 
  void initState() {
    _lnurlBloc = new LNUrlBloc();
    _doneAction = new KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
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
    final String _title = "Create an Invoice";
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);

    return new Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: new Padding(
          padding: new EdgeInsets.only(bottom: 40.0),
          child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new SizedBox(
              height: 48.0,
              width: 168.0,
              child: StreamBuilder<AccountModel>(
                  stream: accountBloc.accountStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return StaticLoader();
                    }
                    var account = snapshot.data;
                    return RaisedButton(
                      child: new Text(
                        _withdrawUrl == null ? "CREATE" : "WITHDRAW",
                        style: Theme.of(context).textTheme.button,
                      ),
                      color: Theme.of(context).buttonColor,
                      elevation: 0.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(42.0)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _createInvoice(invoiceBloc, account);
                        }
                      },
                    );
                  }),
            )
          ])),
      appBar: new AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        actions: <Widget>[
          StreamBuilder<Object>(
            stream: accountBloc.accountStream,
            builder: (context, snapshot) {
              var account = snapshot.data;
              return new IconButton(                
                alignment: Alignment.center,
                icon: new Image(
                  image: new AssetImage("src/icon/qr_scan.png"),
                  color: theme.BreezColors.white[500],
                  fit: BoxFit.contain,
                  width: 24.0,
                  height: 24.0,
                ),
                tooltip: 'Scan Barcode',
                onPressed: () => account != null ? _scanBarcode(account) : null,
              );
            }
          )
        ],
        title: new Text(_title, style: Theme.of(context).appBarTheme.textTheme.title),
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
              child: new Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    maxLength: 90,
                    maxLengthEnforced: true,
                    decoration: new InputDecoration(
                      labelText: "Description (optional)",
                    ),
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  new AmountFormField(
                      context: context,
                      accountModel: acc,
                      focusNode: _amountFocusNode,
                      controller: _amountController,
                      validatorFn: acc.validateIncomingPayment,
                      style: theme.FieldTextStyle.textStyle),
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    padding: new EdgeInsets.only(top: 16.0),
                    child: _buildReceivableBTC(acc),
                  ),
                  StreamBuilder(
                      stream: accountBloc.accountStream,
                      builder: (BuildContext context, AsyncSnapshot<AccountModel> accSnapshot) {
                        if (!accSnapshot.hasData) {
                          return Container();
                        }
                        AccountModel acc = accSnapshot.data;
                        
                        String message;
                        if (accSnapshot.hasError) {
                          message = accSnapshot.error.toString();
                        } else if (!accSnapshot.hasData) {
                          message = 'Receiving payments will be available as soon as Breez is synchronized.';
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
                              padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                              child: Column(children: <Widget>[
                                Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: theme.warningStyle.copyWith(color: Theme.of(context).errorColor),
                                ),
                              ]));
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: _buildReserveAmountWarning(accSnapshot.data),
                          );
                        }
                      })
                ],
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
        "Receive up to: ${acc.currency.format(acc.maxAllowedToReceive)}",
        style: theme.textStyle,
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
      ),
      onTap: () => _amountController.text = acc.currency.format(acc.maxAllowedToReceive, includeSymbol: false, userInput: true),
    );
  }

  Widget _buildReserveAmountWarning(AccountModel account) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), border: Border.all(color: Theme.of(context).errorColor)),
        padding: new EdgeInsets.all(16),
        child: Text(
          "Breez requires you to keep\n${account.currency.format(account.warningMaxChanReserveAmount, fixedDecimals: false)} in your balance.",
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future _scanBarcode(AccountModel account) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      String barcode = await BarcodeScanner.scan();
      await _handleLNUrlWithdraw(account, barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        promptError(context, "",
          Text(
            "Please grant Breez camera permission to scan QR codes.",
            style: Theme.of(context).dialogTheme.contentTextStyle,
          ));       
      }   
    } 
    catch (e) {
      promptError(context, "", Text(e.toString(), style: Theme.of(context).dialogTheme.contentTextStyle));  
    }
  }

  Future _handleLNUrlWithdraw(AccountModel account, String url) async{
    Fetch fetchAction = Fetch(url);
    _lnurlBloc.actionsSink.add(fetchAction);
    var response = await fetchAction.future;
    if (response.runtimeType != WithdrawFetchResponse) {
      throw "Invalid URL";
    }
    WithdrawFetchResponse withdrawResponse = response as WithdrawFetchResponse;
    setState(() {
      _withdrawUrl = url;
      _descriptionController.text = withdrawResponse.defaultDescription;
      _amountController.text = account.currency.format(withdrawResponse.maxAmount, includeSymbol: false);
    });
  }

  Future _createInvoice(InvoiceBloc invoiceBloc, AccountModel account){
    invoiceBloc.newInvoiceRequestSink.add(
      new InvoiceRequestModel(
          null,
          _descriptionController.text,
          null,
          account.currency.parse(_amountController.text)));

    Widget dialog = _withdrawUrl != null ? 
    LNURlWidthrawDialog(_withdrawUrl, invoiceBloc, _lnurlBloc) : 
    QrCodeDialog(context, invoiceBloc);

    return _bgService.runAsTask(
      showDialog(
        context: context, builder: (_) => dialog),
      (){
        log.info("waiting for payment background task finished");
      }
    );
  }  
}
