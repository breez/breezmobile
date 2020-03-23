import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

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
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
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

    return Material(
      child: Scaffold(
        bottomNavigationBar: SingleButtonBottomBar(
          text: "PAY",
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              invoiceBloc.payBlankAmount = _amountToSendSatoshi;
              Navigator.of(context).pushNamed('/pay_nearby_complete');
            }
          },
        ),
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(),
          title: Text(
            _title,
            style: Theme.of(context).appBarTheme.textTheme.headline6,
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
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AmountFormField(
                      focusNode: _amountFocusNode,
                      returnFN: (value) =>
                          _amountToSendSatoshi = account.currency.parse(value),
                      validatorFn: account.validateOutgoingPayment,
                      style: theme.FieldTextStyle.textStyle,
                      onFieldSubmitted: (String value) {
                        _amountToSendSatoshi = account.currency.parse(value);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Row(
                        children: <Widget>[
                          Text("Available:", style: theme.textStyle),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0),
                            child: Text(
                                account.currency.format(account.balance),
                                style: theme.textStyle),
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
