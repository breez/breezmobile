/* 
   FIXME 
   - tap 'Request invoice'
   - press 'back' on Android.
   - The loading animation is removed.
   - The LNURLFetchInvoicePage is visible.
   - tap 'Request invoice' and get the following error:

   Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5013 pos 12: '!_debugLocked': is not true.

   - It is then impossible to interact with the app. The UI is unresponsive and keeps throwing the above exception.

*/
import 'dart:async';
import 'dart:io';

import 'package:breez/services/breezlib/data/rpc.pb.dart';
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
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LNURLFetchInvoicePage extends StatefulWidget {
  final PayFetchResponse payFetchResponse;

  const LNURLFetchInvoicePage(this.payFetchResponse);

  @override
  LNURLFetchInvoicePageState createState() {
    return LNURLFetchInvoicePageState();
  }
}

class LNURLFetchInvoicePageState extends State<LNURLFetchInvoicePage> {
  PayFetchResponse _payFetchResponse;

  final _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _isInit = false;
  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;
  ModalRoute _loaderRoute;
  ModalRoute _currentRoute;

  @override
  void didChangeDependencies() {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    if (mounted) {
      if (!_isInit) {
        if (widget.payFetchResponse != null) {
          accountBloc.accountStream.first.then((account) {
            setState(() {
              applyPayFetchResponse(widget.payFetchResponse, account);
            });
          });
        }
      }

      _isInit = true;
      /*
   FIXME Do we need this? I think this condition is always false because payFetchResponse is requiered by the constructor.
   */
      if (widget.payFetchResponse == null) {
        log.info('didChangeDependencies: payFetchResponse == null.');
        Future.delayed(Duration(milliseconds: 200),
            () => FocusScope.of(context).requestFocus(_amountFocusNode));
      }
      super.didChangeDependencies();
    }
  }

  @override
  void initState() {
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
    super.initState();
  }

  @override
  void dispose() {
    log.info('LNURLFetchInvoicePage disposed.');
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showFetchInvoiceDialog();
  }

  Widget showFetchInvoiceDialog() {
    final String _title = "Pay via Invoice";
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    LNUrlBloc lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

    /*
        4. `LN WALLET` displays a payment dialog where user can specify an exact sum to be sent which would be bounded by:

	```
	max can send = min(maxSendable, local estimation of how much can be sent from wallet)

	min can send = max(minSendable, local minimal value allowed by wallet)
	```
	Additionally, a payment dialog must include:
	- Domain name extracted from `LNURL` query string.
	- A way to view the metadata sent of `text/plain` format.
	- A text input where user can enter a `comment` string (max character count is equal or less than `commentAllowed` value)
    */

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
                text: "REQUEST INVOICE",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _getInvoice(invoiceBloc, accountBloc, lnurlBloc, account);
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
        actions: <Widget>[], // FIXME: Should we have anything here?
        title: Text(_title,
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
                        controller: _commentController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        maxLength: 90,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          labelText: "Comment (optional)",
                        ),
                        style: theme.FieldTextStyle.textStyle,
                      ),
                      AmountFormField(
                          context: context,
                          accountModel: acc,
                          focusNode: _amountFocusNode,
                          controller: _amountController,
                          validatorFn: (amt) {
                            final min = widget.payFetchResponse.minAmount;
                            final max = widget.payFetchResponse.maxAmount;

                            if (amt < min) {
                              return 'Payment required is at least ${acc.currency.format(min)}.';
                            }

                            if (amt > max) {
                              return 'Payment exceeds the limit (${acc.currency.format(max)}).';
                            }

                            return null;
                          },
                          style: theme.FieldTextStyle.textStyle),
                      Text('${_payFetchResponse.host}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: theme.FieldTextStyle.labelStyle),
                      Text('${_getMetadataText(_payFetchResponse.metadata)}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: theme.FieldTextStyle.labelStyle),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        padding: EdgeInsets.only(top: 16.0),
                        child: _buildPayableBTC(acc),
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

  Widget _buildPayableBTC(AccountModel acc) {
    return GestureDetector(
      child: AutoSizeText(
        "Pay between ${acc.currency.format(widget.payFetchResponse.minAmount)} and ${acc.currency.format(widget.payFetchResponse.maxAmount)}",
        style: theme.textStyle,
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
      ),
      onTap: () => _amountController.text = acc.currency.format(
          widget.payFetchResponse.minAmount,
          includeDisplayName: false,
          userInput: true),
    );
  }

  void applyPayFetchResponse(PayFetchResponse response, AccountModel account) {
    _payFetchResponse = response;
    _commentController.text = response.comment;
    _amountController.text = account.currency
        .format(response.minAmount, includeDisplayName: false, userInput: true);
  }

  String _getMetadataText(List<LNUrlPayMetadata> metadata) {
    /*

    `metadata` json array must contain one `text/plain` entry, all other types of entries are optional:

    ```
    [
        [
            "text/plain", // must always be present
            content // actual metadata content
        ],
        [
            "image/png;base64", // optional 512x512px PNG thumbnail which will represent this lnurl in a list or grid
            content // base64 string, up to 136536 characters (100Kb of image data in base-64 encoding)
        ],
        [
            "image/jpeg;base64", // optional 512x512px JPG thumbnail which will represent this lnurl in a list or grid
            content // base64 string, up to 136536 characters (100Kb of image data in base-64 encoding)
        ],
        ... // more objects for future types
    ]
    ```

    and be sent as a string:

    ```
    "[[\"text/plain\", \"lorem ipsum blah blah\"]]"
    ```
    */
    var result = '';
    log.info('_getMetadataText: metadata: $metadata');

    for (var datum in metadata) {
      if (datum.entry[0] == 'text/plain') {
        result = datum.entry[1];
        break;
      }
    }

    return result;
  }

  void _getInvoice(InvoiceBloc invoiceBloc, AccountBloc accountBloc,
      LNUrlBloc lnurlBloc, AccountModel account) async {
    log.info('_getInvoice.');
    /*
         5. LN WALLET makes a GET request using callback with the following query parameters:
         amount (input) - user specified sum in MilliSatoshi
         nonce - an optional parameter used to prevent server response caching
         fromnodes - an optional parameter with value set to comma separated nodeIds if payer wishes a service to provide payment routes starting from specified LN nodeIds
         comment (input) - an optional parameter to pass the LN WALLET user's comment to LN SERVICE

    */

    var navigator = Navigator.of(context);
    _currentRoute = ModalRoute.of(navigator.context);
    _loaderRoute = createLoaderRoute(context, onClose: _reset); // TODO TEST
    navigator.push(_loaderRoute);

    _payFetchResponse.amount =
        account.currency.parse(_amountController.text) * 1000;
    _payFetchResponse.comment = _commentController.text;

    LNUrlPayInfo payinfo;
    var action = FetchInvoice(_payFetchResponse);
    action.future.catchError((e) {
      promptError(
          context,
          "LNURL-Pay Error",
          Text(
              "An error occurred while attempting to retreive an invoice from ${_payFetchResponse.host}!\nReason: ${e.toString()}",
              style: Theme.of(context).dialogTheme.contentTextStyle),
          okFunc: _removeLoader);
    }).then((payinfo) {
      invoiceBloc.decodeInvoiceSink.add(payinfo.invoice);
      log.info(
          '_getInvoice: Found LNUrlPayInfo. Beginning payment request flow.');
      _removeLoader();

      /*
           FIXME Verify that this works when:
           "Before popping here, I suggest to check if the user cancelled by closing the dialog (back on android).  One way to do it is to check if the current widget is disposed and continue with the invoice only if it is not." (@roeierez) 
      */

      if (!_currentRoute.isCurrent) return;

      Navigator.of(context).pop();
    });

    lnurlBloc.actionsSink.add(action);
  }

  void _removeLoader() {
    if (_loaderRoute != null) {
      Navigator.of(context).removeRoute(
          _loaderRoute); // @nochiel: By the time we get here, _loaderRoute has been disposed/destroyed?
    }
  }

  void _reset() {
    _isInit = false;
  }
}
