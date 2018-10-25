import 'dart:async';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateInvoicePage extends StatelessWidget {
  CreateInvoicePage();

  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>((context, blocs) => _CreateInvoicePage(
        blocs.accountBloc, blocs.userProfileBloc, blocs.invoicesBloc));
  }
}

class _CreateInvoicePage extends StatefulWidget {
  final AccountBloc _accountBloc;
  final UserProfileBloc _userProfileBloc;
  final InvoiceBloc _invoiceBloc;

  const _CreateInvoicePage(
      this._accountBloc, this._userProfileBloc, this._invoiceBloc);

  @override
  State<StatefulWidget> createState() {
    return new _CreateInvoiceState();
  }
}

class _CreateInvoiceState extends State<_CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = "";
  String _bolt11 = "";
  final TextEditingController _descriptionController =
      new TextEditingController();
  final TextEditingController _amountController = new TextEditingController();
  StreamSubscription<AccountModel> accountSubscription;
  StreamSubscription<String> _invoiceReadyNotificationsSubscription;

  Currency _currency = Currency.BTC;

  @override
  void initState() {
    super.initState();

    _invoiceReadyNotificationsSubscription =
        widget._invoiceBloc.readyInvoicesStream.listen((invoice) {
      setState(() {
        //_bolt11 = invoice;
      });
    });

    accountSubscription = widget._accountBloc.accountStream.listen((acc) {
      _currency = acc.currency;
    });
  }

  @override
  void dispose() {
    accountSubscription.cancel();
    _invoiceReadyNotificationsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = "Create an Invoice";
    return new Scaffold(
      bottomNavigationBar: new Padding(
          padding: new EdgeInsets.only(bottom: 40.0),
          child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new SizedBox(
              height: 48.0,
              width: 168.0,
              child: StreamBuilder<AccountModel>(
                  stream: widget._accountBloc.accountStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return StaticLoader();
                    }
                    var account = snapshot.data;
                    return RaisedButton(
                      padding: EdgeInsets.only(
                          top: 16.0, bottom: 16.0, right: 39.0, left: 39.0),
                      child: new Text(
                        "CREATE",
                        style: theme.buttonStyle,
                      ),
                      color: Colors.white,
                      elevation: 0.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(42.0)),
                      onPressed: () {
                        widget._invoiceBloc.newStandardInvoiceRequestSink.add(
                            new InvoiceRequestModel(
                                null,
                                _descriptionController.text,
                                null,
                                account.currency
                                    .parse(_amountController.text)));
                      },
                    );
                  }),
            )
          ])),
      appBar: new AppBar(
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
        leading: backBtn.BackButton(),
        title: new Text(_title, style: theme.appBarTextStyle),
        elevation: 0.0,
      ),
      body: StreamBuilder<AccountModel>(
        stream: widget._accountBloc.accountStream,
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
                    decoration: new InputDecoration(
                      labelText: "Description",
                    ),
                    style: theme.FieldTextStyle.textStyle,
                    validator: (text) {
                      if (text.length == 0) {
                        return "Please enter a description";
                      }
                    },
                  ),
                  new Text(
                    _errorMessage,
                    style: theme.validatorStyle,
                  ),
                  new AmountFormField(
                      controller: _amountController,
                      currency: _currency,
                      maxAmount: acc.maxAllowedToReceive,
                      decoration: new InputDecoration(
                          labelText: _currency.displayName + " Amount"),
                      style: theme.FieldTextStyle.textStyle),
                  new Container(
                    padding: new EdgeInsets.only(top: 36.0),
                    child: _buildReceivableBTC(acc),
                  ),
                  _bolt11.isEmpty
                      ? Container()
                      : new Column(children: <Widget>[
                          new Container(
                            margin:
                                const EdgeInsets.only(top: 32.0, bottom: 16.0),
                            padding: const EdgeInsets.all(8.6),
                            decoration: theme.qrImageStyle,
                            child: new Container(
                              color: theme.whiteColor,
                              child: new QrImage(
                                data: _bolt11,
                                size: 180.0,
                              ),
                            ),
                          ),
//                    new Container(
//                      padding: EdgeInsets.only(top: 16.0),
//                      child: new Text(
//                        address,
//                        style: theme.smallTextStyle,
//                      ),
//                    )
                        ])
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceivableBTC(AccountModel acc) {
    return new Row(
      children: <Widget>[
        new Text("Receive up to:", style: theme.textStyle),
        new Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: new Text(_currency.format(acc.maxAllowedToReceive),
              style: theme.textStyle),
        )
      ],
    );
  }

  Widget _buildExpiryMessage() {
    return new Column(children: <Widget>[
      Text("In order to receive payment Breez app needs to stay open.",
          style: theme.warningStyle)
    ]);
  }
}
