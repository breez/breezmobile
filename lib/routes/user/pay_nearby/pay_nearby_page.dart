import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/widgets/form_keyboard_actions.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:fixnum/fixnum.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/currency_converter_dialog.dart';

class PayNearbyPage extends StatefulWidget {  
  PayNearbyPage();

  @override
  State<StatefulWidget> createState() {
    return PayNearbyPageState();
  }
}

class PayNearbyPageState extends State<PayNearbyPage> {
  final _formKey = GlobalKey<FormState>();
  final String _title = "Pay Someone Nearby";
  Int64 _amountToSendSatoshi;
  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  @override 
  void initState() {
    _doneAction = new KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
    super.initState();
  }

  @override 
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return new Material(
      child: new Scaffold(
        bottomNavigationBar: new Padding(
            padding: new EdgeInsets.only(bottom: 40.0),
            child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              new SizedBox(
                height: 48.0,
                width: 168.0,
                child: new RaisedButton(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 39.0, left: 39.0),
                  child: new Text(
                    "PAY",
                    style: theme.buttonStyle,
                  ),
                  color: Colors.white,
                  elevation: 0.0,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(42.0)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      invoiceBloc.payBlankAmount = _amountToSendSatoshi;
                      Navigator.of(context).pushNamed('/pay_nearby_complete');
                    }
                  },
                ),
              ),
            ])),
        appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          leading: backBtn.BackButton(),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0,
        ),
        body: StreamBuilder<AccountModel>(
          stream: accountBloc.accountStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return StaticLoader();
            }
            var account = snapshot.data;
            return Form(
              key: _formKey,
              child: new Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new AmountFormField(
                      focusNode: _amountFocusNode,
                      validatorFn: account.validateOutgoingPayment,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(top: 21.0, bottom: 8.0),
                        labelText: account.currency.displayName + " Amount",
                        suffixIcon: IconButton(icon: Icon(Icons.loop, color: theme.BreezColors.white[500],),
                          padding: EdgeInsets.only(top: 21.0),
                          alignment: Alignment.bottomRight,
                          onPressed: () =>
                              showDialog(context: context,
                                  builder: (_) =>
                                      CurrencyConverterDialog((value) => _amountToSendSatoshi = account.currency.parse(value))),),),
                      style: theme.FieldTextStyle.textStyle,
                      currency: account.currency,                      
                      onFieldSubmitted: (String value) {
                        _amountToSendSatoshi = account.currency.parse(value);
                      },
                    ),
                    new Container(
                      padding: new EdgeInsets.only(top: 32.0),
                      child: new Row(
                        children: <Widget>[
                          new Text("Available:", style: theme.textStyle),
                          new Padding(
                            padding: EdgeInsets.only(left: 3.0),
                            child: new Text(account.currency.format(account.balance), style: theme.textStyle),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),            
            );
          },
        ),
      ),
    );
  }
}
