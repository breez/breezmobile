import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/lnurl_metadata_extension.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LNURLFetchInvoicePage extends StatefulWidget {
  final PayFetchResponse payFetchResponse;

  const LNURLFetchInvoicePage(
    this.payFetchResponse,
  );

  @override
  LNURLFetchInvoicePageState createState() {
    return LNURLFetchInvoicePageState();
  }
}

class LNURLFetchInvoicePageState extends State<LNURLFetchInvoicePage> {
  PayFetchResponse _payFetchResponse;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _commentController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();

  bool _isInit = false;
  KeyboardDoneAction _doneAction;
  ModalRoute _loaderRoute;
  ModalRoute _currentRoute;

  @override
  void didChangeDependencies() {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    if (mounted) {
      if (!_isInit) {
        if (widget.payFetchResponse != null) {
          accountBloc.accountStream.first.then((account) {
            setState(() {
              applyPayFetchResponse(widget.payFetchResponse, account);
            });
          });
        }

        Future.delayed(
          Duration(milliseconds: 200),
          () => FocusScope.of(context).requestFocus(_amountFocusNode),
        );
      }

      _isInit = true;
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
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

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

    var payee = "";
    if (_payFetchResponse != null) {
      payee = _payFetchResponse.lightningAddress;
      if (payee.isEmpty) {
        payee = _payFetchResponse.host;
      }
    }

    final response = widget.payFetchResponse;

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
                text: texts.lnurl_fetch_invoice_action_continue,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _getInvoice(
                      context,
                      invoiceBloc,
                      accountBloc,
                      lnurlBloc,
                      account,
                    );
                  }
                },
              ),
            );
          }),
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          texts.lnurl_fetch_invoice_pay_to_payee(payee),
          style: themeData.appBarTheme.textTheme.headline6,
        ),
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
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  response.commentAllowed > 0
                      ? TextFormField(
                          controller: _commentController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          maxLength: response.commentAllowed.toInt(),
                          maxLengthEnforced: true,
                          decoration: InputDecoration(
                            labelText: texts.lnurl_fetch_invoice_comment,
                          ),
                          style: theme.FieldTextStyle.textStyle,
                        )
                      : Container(),
                  AmountFormField(
                    context: context,
                    accountModel: acc,
                    texts: texts,
                    focusNode: _amountFocusNode,
                    controller: _amountController,
                    validatorFn: (amt) {
                      final min = response.minAmount;
                      final max = response.maxAmount;

                      if (amt < min) {
                        return texts.lnurl_fetch_invoice_error_min(
                          acc.currency.format(min),
                        );
                      }

                      if (amt > max) {
                        return texts.lnurl_fetch_invoice_error_max(
                          acc.currency.format(max),
                        );
                      }

                      return null;
                    },
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      texts.lnurl_fetch_invoice_limit(
                        acc.currency.format(response.minAmount),
                        acc.currency.format(response.maxAmount),
                      ),
                      textAlign: TextAlign.left,
                      style: theme.FieldTextStyle.labelStyle,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildDescription(context, acc),
                  ),
                  StreamBuilder(
                    stream: accountBloc.accountStream,
                    builder: (context, accSnapshot) {
                      if (!accSnapshot.hasData) {
                        return Container();
                      }

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
                          padding: const EdgeInsets.only(
                            top: 50.0,
                            left: 30.0,
                            right: 30.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: theme.warningStyle.copyWith(
                                  color: themeData.errorColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 22),
                      child: _buildImage(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescription(
    BuildContext context,
    AccountModel acc,
  ) {
    return GestureDetector(
      child: AutoSizeText(
        _payFetchResponse.metadata.metadataText(),
        style: theme.textStyle,
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final image = _payFetchResponse.metadata.metadataImage();
    if (image == null) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 125,
            maxHeight: 125,
          ),
          child: image,
        ),
      ],
    );
  }

  void applyPayFetchResponse(
    PayFetchResponse response,
    AccountModel account,
  ) {
    _payFetchResponse = response;
    _commentController.text = response.comment;
    if (response.minAmount == response.maxAmount) {
      _amountController.text = "${response.minAmount}";
    }
  }

  void _getInvoice(
    BuildContext context,
    InvoiceBloc invoiceBloc,
    AccountBloc accountBloc,
    LNUrlBloc lnurlBloc,
    AccountModel account,
  ) async {
    log.info('_getInvoice.');
    /*
         5. LN WALLET makes a GET request using callback with the following query parameters:
         amount (input) - user specified sum in MilliSatoshi
         nonce - an optional parameter used to prevent server response caching
         fromnodes - an optional parameter with value set to comma separated nodeIds if payer wishes a service to provide payment routes starting from specified LN nodeIds
         comment (input) - an optional parameter to pass the LN WALLET user's comment to LN SERVICE

    */

    final texts = AppLocalizations.of(context);
    var navigator = Navigator.of(context);
    _currentRoute = ModalRoute.of(navigator.context);
    _loaderRoute = createLoaderRoute(context);
    navigator.push(_loaderRoute);

    _payFetchResponse.amount =
        account.currency.parse(_amountController.text) * 1000;
    _payFetchResponse.comment = _commentController.text;

    var action = FetchInvoice(_payFetchResponse);
    action.future.catchError((e) {
      promptError(
        context,
        texts.lnurl_fetch_invoice_error_title,
        Text(
          texts.lnurl_fetch_invoice_error_message(
            _payFetchResponse.host,
            e.toString(),
          ),
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
        okFunc: _removeLoader,
      );
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
    if (mounted) {
      if (_loaderRoute != null && _loaderRoute.isCurrent) {
        Navigator.of(context).removeRoute(_loaderRoute);
      }
    }
  }
}
