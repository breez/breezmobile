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
import 'package:breez/bloc/lsp/lsp_actions.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/charge/successful_payment.dart';
import 'package:breez/routes/create_invoice/lnurl_withdraw_dialog.dart';
import 'package:breez/routes/create_invoice/qr_code_dialog.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/exceptions.dart';
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
import 'package:breez/widgets/warning_box.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateInvoicePage extends StatefulWidget {
  final WithdrawFetchResponse lnurlWithdraw;

  const CreateInvoicePage({
    this.lnurlWithdraw,
  });

  @override
  State<StatefulWidget> createState() {
    return CreateInvoicePageState();
  }
}

class CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _bgService = ServiceInjector().backgroundTaskService;

  bool _isInit = false;
  KeyboardDoneAction _doneAction;
  WithdrawFetchResponse _withdrawFetchResponse;
  StreamSubscription<PaymentRequestModel> _paidInvoicesSubscription;

  @override
  void didChangeDependencies() {
    final texts = context.texts();
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final accBloc = AppBlocsProvider.of<AccountBloc>(context);

    if (!_isInit) {
      _paidInvoicesSubscription = invoiceBloc.paidInvoicesStream.listen((paid) {
        Navigator.pop(context, texts.invoice_payment_success);
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
        Future.delayed(
          const Duration(milliseconds: 200),
          () => FocusScope.of(context).requestFocus(_amountFocusNode),
        );
      }
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _doneAction = KeyboardDoneAction([_amountFocusNode]);
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
    final texts = context.texts();
    final themeData = Theme.of(context);

    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          final account = snapshot.data;
          return StreamBuilder<LSPStatus>(
            stream: lspBloc.lspStatusStream,
            builder: (context, snapshot) {
              LSPStatus lspStatus = snapshot.data;

              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                      Platform.isIOS && _amountFocusNode.hasFocus ? 40.0 : 0.0,
                ),
                child: SingleButtonBottomBar(
                  stickToBottom: true,
                  text: _withdrawFetchResponse == null
                      ? texts.invoice_action_create
                      : texts.invoice_action_redeem,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      final tempFees =
                          lspStatus.currentLSP.cheapestOpeningFeeParams;
                      _fetchLSPList().then(
                        (_) {
                          // Show fee dialog if necessary and create invoice dialog
                          _showFeeDialog(
                            context,
                            hasFeesChanged(
                              tempFees,
                              lspStatus.currentLSP.cheapestOpeningFeeParams,
                            ),
                            () => _createInvoice(
                              context,
                              accountBloc,
                              account,
                              lspStatus.currentLSP.raw,
                            ),
                          );
                        },
                        onError: (e) {
                          showFlushbar(
                            context,
                            message: texts.qr_code_dialog_error(e.toString()),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.invoice_title),
        actions: [
          StreamBuilder<Object>(
            stream: accountBloc.accountStream,
            builder: (context, snapshot) {
              final account = snapshot.data;
              return IconButton(
                alignment: Alignment.center,
                icon: Image(
                  image: const AssetImage("src/icon/qr_scan.png"),
                  color: theme.BreezColors.white[500],
                  fit: BoxFit.contain,
                  width: 24.0,
                  height: 24.0,
                ),
                tooltip: texts.invoice_action_scan_barcode,
                onPressed: () => account != null
                    ? _scanBarcode(
                        context,
                        account,
                      )
                    : null,
              );
            },
          )
        ],
      ),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          final acc = snapshot.data;
          return StreamBuilder<LSPStatus>(
            stream: lspBloc.lspStatusStream,
            builder: (context, snapshot) {
              LSPStatus lspStatus = snapshot.data;
              String validatePayment(Int64 amount) {
                if (lspStatus?.currentLSP != null) {
                  final channelMinimumFee =
                      lspStatus.currentLSP.cheapestOpeningFeeParams.minMsat ~/
                          1000;
                  if (amount > acc.maxInboundLiquidity &&
                      amount <= channelMinimumFee) {
                    return texts.invoice_insufficient_amount_fee(
                      acc.currency.format(channelMinimumFee),
                    );
                  }
                }
                return acc.validateIncomingPayment(amount);
              }

              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            maxLines: null,
                            maxLength: 90,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            decoration: InputDecoration(
                              labelText: texts.invoice_description_label,
                            ),
                            style: theme.FieldTextStyle.textStyle,
                          ),
                          AmountFormField(
                            context: context,
                            texts: texts,
                            accountModel: acc,
                            focusNode: _amountFocusNode,
                            controller: _amountController,
                            validatorFn: validatePayment,
                            style: theme.FieldTextStyle.textStyle,
                          ),
                          if (_withdrawFetchResponse != null &&
                              !_withdrawFetchResponse.isFixedAmount) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                texts.lnurl_fetch_invoice_limit(
                                  acc.currency
                                      .format(_withdrawFetchResponse.minAmount),
                                  acc.currency
                                      .format(_withdrawFetchResponse.maxAmount),
                                ),
                                textAlign: TextAlign.left,
                                style: theme.FieldTextStyle.labelStyle,
                              ),
                            )
                          ],
                          _buildReceivableBTC(context, acc, lspStatus),
                          StreamBuilder<AccountModel>(
                            stream: accountBloc.accountStream,
                            builder: (context, accSnapshot) {
                              if (!accSnapshot.hasData) {
                                return Container();
                              }
                              String message = _availabilityMessage(
                                texts,
                                accSnapshot,
                              );
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
                                          color: themeData.colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _availabilityMessage(
    BreezTranslations texts,
    AsyncSnapshot<AccountModel> accSnapshot,
  ) {
    if (accSnapshot.hasError) {
      return accSnapshot.error.toString();
    }
    if (!accSnapshot.hasData) {
      return texts.invoice_availability_message_synchronizing;
    }
    final acc = accSnapshot.data;
    if (acc.processingConnection) {
      return texts.invoice_availability_message_opening_channel;
    }
    return null;
  }

  Widget _buildReceivableBTC(
    BuildContext context,
    AccountModel acc,
    LSPStatus lspStatus,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    LSPInfo lsp = lspStatus?.currentLSP;
    Widget warning = lsp == null
        ? const SizedBox()
        : WarningBox(
            boxPadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatFeeMessage(texts, acc, lsp),
                  style: themeData.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
    if (_withdrawFetchResponse == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 164,
        padding: const EdgeInsets.only(top: 16.0),
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                texts.invoice_receive_label(
                  acc.currency.format(acc.maxAllowedToReceive),
                ),
                style: theme.textStyle,
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
              ),
              warning,
            ],
          ),
          onTap: () => _amountController.text = acc.currency.format(
            acc.maxAllowedToReceive,
            includeDisplayName: false,
            userInput: true,
          ),
        ),
      );
    } else {
      return warning;
    }
  }

  String formatFeeMessage(
    BreezTranslations texts,
    AccountModel accountModel,
    LSPInfo lspInfo,
  ) {
    final connected = accountModel.connected;
    final minFee = (lspInfo != null)
        ? lspInfo.cheapestOpeningFeeParams.minMsat ~/ 1000
        : Int64(0);
    final minFeeFormatted = accountModel.currency.format(minFee);
    final showMinFeeMessage = minFee > 0;
    final setUpFee =
        (lspInfo.cheapestOpeningFeeParams.proportional / 10000).toString();
    final liquidity = accountModel.currency.format(
      connected ? accountModel.maxInboundLiquidity : Int64(0),
    );

    if (connected && showMinFeeMessage) {
      return texts.invoice_ln_address_warning_with_min_fee_account_connected(
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (connected && !showMinFeeMessage) {
      return texts.invoice_ln_address_warning_without_min_fee_account_connected(
        setUpFee,
        liquidity,
      );
    } else if (!connected && showMinFeeMessage) {
      return texts
          .invoice_ln_address_warning_with_min_fee_account_not_connected(
        setUpFee,
        minFeeFormatted,
      );
    } else {
      return texts
          .invoice_ln_address_warning_without_min_fee_account_not_connected(
        setUpFee,
      );
    }
  }

  Future _scanBarcode(BuildContext context, AccountModel account) async {
    final texts = context.texts();
    final navigator = Navigator.of(context);
    final themeData = Theme.of(context);

    TransparentPageRoute loaderRoute = createLoaderRoute(context);
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      navigator.pushNamed<String>("/qr_scan").then(
        (barcode) async {
          if (barcode == null) return;
          if (barcode.isEmpty) {
            showFlushbar(context, message: texts.invoice_qr_code_not_detected);
            return;
          }
          navigator.push(loaderRoute);
          await _handleLNUrlWithdraw(context, account, barcode).onError(
            (error, stackTrace) {
              if (loaderRoute.isActive) {
                navigator.removeRoute(loaderRoute);
              }
              promptError(
                context,
                texts.qr_action_button_error_code_not_processed,
                Text(
                  texts.invoice_receive_fail_message(
                      extractExceptionMessage(error)),
                  style: themeData.dialogTheme.contentTextStyle,
                ),
              );
            },
          ).whenComplete(
            () {
              if (loaderRoute.isActive) {
                navigator.removeRoute(loaderRoute);
              }
            },
          );
        },
      );
    } catch (e) {
      if (loaderRoute.isActive) {
        navigator.removeRoute(loaderRoute);
      }
      promptError(
        context,
        texts.invoice_receive_fail,
        Text(
          texts.invoice_receive_fail_message(e.toString()),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    } finally {
      if (loaderRoute.isActive) {
        Navigator.of(context).removeRoute(loaderRoute);
      }
    }
  }

  Future _handleLNUrlWithdraw(
    BuildContext context,
    AccountModel account,
    String lnurl,
  ) async {
    final texts = context.texts();
    final lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
    Fetch fetchAction = Fetch(lnurl);
    lnurlBloc.actionsSink.add(fetchAction);
    var response = await fetchAction.future;
    if (response.runtimeType != WithdrawFetchResponse) {
      throw texts.invoice_error_url;
    }
    final withdrawResponse = response as WithdrawFetchResponse;
    setState(() {
      applyWithdrawFetchResponse(withdrawResponse, account);
    });
  }

  void applyWithdrawFetchResponse(
    WithdrawFetchResponse response,
    AccountModel account,
  ) {
    _withdrawFetchResponse = response;
    _descriptionController.text = response.defaultDescription;
    if (response.isFixedAmount) {
      _amountController.text = "${response.minAmount}";
    }
  }

  Future _createInvoice(
    BuildContext context,
    AccountBloc accountBloc,
    AccountModel account,
    LSPInformation lspInformation,
  ) {
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

    invoiceBloc.newInvoiceRequestSink.add(
      InvoiceRequestModel(
        null,
        _descriptionController.text,
        null,
        account.currency.parse(_amountController.text),
        lspInformation: lspInformation,
      ),
    );
    final navigator = Navigator.of(context);
    navigator.pop();
    var currentRoute = ModalRoute.of(navigator.context);
    Widget dialog = _withdrawFetchResponse != null
        ? LNURlWithdrawDialog(invoiceBloc, accountBloc, lnurlBloc, (result) {
            onPaymentFinished(result, currentRoute, navigator);
          })
        : QrCodeDialog(
            context,
            invoiceBloc,
            accountBloc,
            (result) {
              onPaymentFinished(result, currentRoute, navigator);
            },
          );
    return _bgService.runAsTask(
        showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: false,
          builder: (_) => dialog,
        ), () {
      log.info("waiting for payment background task finished");
    });
  }

  onPaymentFinished(
    dynamic result,
    ModalRoute currentRoute,
    NavigatorState navigator,
  ) {
    if (result == true) {
      if (currentRoute.isCurrent) {
        navigator.push(TransparentPageRoute((ctx) {
          return withBreezTheme(ctx, const SuccessfulPaymentRoute());
        }));
      }
    } else {
      if (result is String) {
        showFlushbar(context, title: "", message: result);
      }
    }
  }

  Future _fetchLSPList() async {
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    var fetchAction = FetchLSPList();
    lspBloc.actionsSink.add(fetchAction);
    return await fetchAction.future;
  }
}

bool hasFeesChanged(OpeningFeeParams oldFees, OpeningFeeParams newFees) {
  // Mark fee as changed only if new fees are higher
  return (newFees.minMsat > oldFees.minMsat) ||
      (newFees.proportional > oldFees.proportional);
}

Future _showFeeDialog(
  BuildContext context,
  bool hasFeesChanged,
  Future Function() onNext,
) async {
  if (hasFeesChanged) {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Setup Fees'),
          content: const Text(
              'Please notice the updated setup fees under the QR code before receiving a payment.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
  return onNext();
}
