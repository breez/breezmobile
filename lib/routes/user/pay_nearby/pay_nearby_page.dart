import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:fixnum/fixnum.dart';
import 'package:breez/widgets/amount_form_field.dart';

class PayNearbyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>((context, blocs) => _PayNearbyPage(blocs.accountBloc, blocs.invoicesBloc));
  }
}

class _PayNearbyPage extends StatefulWidget {
  final AccountBloc _accountBloc; // Might be useful to stop payment in case we are not in sync?
  final InvoiceBloc _invoiceBloc;

  _PayNearbyPage(this._accountBloc, this._invoiceBloc);

  @override
  State<StatefulWidget> createState() {
    return new PayNearbyState();
  }
}

class PayNearbyState extends State<_PayNearbyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final String _title = "Pay Someone Nearby";
  Int64 _amountToSendSatoshi;

  @override
  Widget build(BuildContext context) {
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
                      widget._invoiceBloc.payBlankAmount = _amountToSendSatoshi;
                      Navigator.of(context).pushNamed('/pay_nearby_complete');
                    }
                  },
                ),
              ),
            ])),
        appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
          leading: backBtn.BackButton(),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0,
        ),
        body: StreamBuilder<AccountModel>(
          stream: widget._accountBloc.accountStream,
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
                      maxPaymentAmount: account.maxPaymentAmount,
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.only(top: 21.0, bottom: 8.0), labelText: account.currency.displayName + " Amount"),
                      style: theme.FieldTextStyle.textStyle,
                      currency: account.currency,
                      maxAmount: account.balance,
                      onFieldSubmitted: (String value) {
                        _amountToSendSatoshi = account.currency.parse(value);
                      },
                    ),
                    new Container(
                      padding: new EdgeInsets.only(top: 16.0),
                      child: new Row(
                        children: <Widget>[
                          new Text("Available:", style: theme.textStyle),
                          new Padding(
                            padding: EdgeInsets.only(left: 3.0),
                            child: new Text(account.currency.format(account.balance), style: theme.textStyle),
                          )
                        ],
                      ),
                    ),
                    new TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      maxLength: 90,
                      maxLengthEnforced: true,
                      decoration: new InputDecoration(
                        labelText: "Description",
                      ),
                      style: theme.transactionTitleStyle,
                      validator: (text) {
                        if (text.length == 0) {
                          return "Please enter a description";
                        }
                      },
                    ),
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
