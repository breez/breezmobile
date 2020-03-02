import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/breez_dropdown.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class CreateItemPage extends StatefulWidget {
  CreateItemPage();

  @override
  State<StatefulWidget> createState() {
    return CreateItemPageState();
  }
}

class CreateItemPageState extends State<CreateItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  // TODO: Add text field controllers
  AccountBloc _accountBloc;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      FetchRates fetchRatesAction = FetchRates();
      _accountBloc.userActionsSink.add(fetchRatesAction);

      fetchRatesAction.future.catchError((err) {
        if (this.mounted) {
          setState(() {
//            showFlushbar(context,
//                message: "Failed to retrieve BTC exchange rate.");
          });
        }
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<AccountModel>(
      stream: _accountBloc.accountStream,
      builder: (context, snapshot) {
        AccountModel account = snapshot.data;
        if (!snapshot.hasData) {
          return Container();
        }

        return _buildScaffold(
          ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /* TODO: Create AvatarPicker for Item
                            It should be a random color by default
                            Users can pick from a range of colors, icons or upload their own image
                        */
                      CircleAvatar(
                        radius: 48,
                      ),
                      TextFormField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            hintText: "Name", border: UnderlineInputBorder()),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                  hintText: "Price",
                                  border: UnderlineInputBorder()),
                            ),
                          ),
                          // TODO: This should has it's own widget
                          Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Theme.of(context).backgroundColor,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: BreezDropdownButton(
                                      onChanged: (value) => _selectCurrency,
                                      iconEnabledColor: Theme.of(context)
                                          .dialogTheme
                                          .titleTextStyle
                                          .color,
                                      style: Theme.of(context)
                                          .dialogTheme
                                          .titleTextStyle,
                                      items: Currency.currencies.map(
                                          (Currency value) {
                                        return DropdownMenuItem<String>(
                                          value: value.symbol,
                                          child: Text(
                                            value.displayName,
                                            style: Theme.of(context)
                                                .dialogTheme
                                                .titleTextStyle,
                                          ),
                                        );
                                      }).toList()
                                        ..addAll(
                                          account.fiatConversionList
                                              .map((FiatConversion fiat) {
                                            return new DropdownMenuItem<String>(
                                              value:
                                                  fiat.currencyData.shortName,
                                              child: new Text(
                                                fiat.currencyData.shortName,
                                                style: Theme.of(context)
                                                    .dialogTheme
                                                    .titleTextStyle,
                                              ),
                                            );
                                          }).toList(),
                                        )),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _selectCurrency() {
    // TODO: Select currency
  }

  Widget _buildScaffold(Widget body, [List<Widget> actions]) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          "Create Item",
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
      bottomNavigationBar: SingleButtonBottomBar(
        text: "Add Item",
        onPressed: () => {
          if (_formKey.currentState.validate())
            {
              // TODO: Add Item(.,.,.,) to DB and return to items view
            }
        },
      ),
    );
  }
}
