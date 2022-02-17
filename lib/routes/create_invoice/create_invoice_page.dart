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
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/charge/succesful_payment.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
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
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'lnurl_withdraw_dialog.dart';
import 'qr_code_dialog.dart';

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
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final accBloc = AppBlocsProvider.of<AccountBloc>(context);

    if (!_isInit) {
      _paidInvoicesSubscription = invoiceBloc.paidInvoicesStream.listen((paid) {
        context.pop(context.l10n.invoice_payment_success);
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
          Duration(milliseconds: 200),
          () => context.focusScope.requestFocus(_amountFocusNode),
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
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    AppBarTheme appBarTheme = themeData.appBarTheme;

    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
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
          return Padding(
            padding: EdgeInsets.only(
              bottom: Platform.isIOS && _amountFocusNode.hasFocus ? 40.0 : 0.0,
            ),
            child: SingleButtonBottomBar(
              stickToBottom: true,
              text: _withdrawFetchResponse == null
                  ? l10n.invoice_action_create
                  : l10n.invoice_action_redeem,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _createInvoice(
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
        },
      ),
      appBar: AppBar(
        iconTheme: appBarTheme.iconTheme,
        toolbarTextStyle: appBarTheme.toolbarTextStyle,
        titleTextStyle: appBarTheme.titleTextStyle,
        backgroundColor: themeData.canvasColor,
        leading: backBtn.BackButton(),
        actions: [
          StreamBuilder<Object>(
            stream: accountBloc.accountStream,
            builder: (context, snapshot) {
              final account = snapshot.data;
              return IconButton(
                alignment: Alignment.center,
                icon: Image(
                  image: AssetImage("src/icon/qr_scan.png"),
                  color: theme.BreezColors.white[500],
                  fit: BoxFit.contain,
                  width: 24.0,
                  height: 24.0,
                ),
                tooltip: l10n.invoice_action_scan_barcode,
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
        title: Text(
          l10n.invoice_title,
        ),
        elevation: 0.0,
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
                  final channelMinimumFee = Int64(
                    lspStatus.currentLSP.channelMinimumFeeMsat ~/ 1000,
                  );
                  if (amount > acc.maxInboundLiquidity &&
                      amount <= channelMinimumFee) {
                    return l10n.invoice_insufficient_amount_fee(
                      acc.currency.format(channelMinimumFee),
                    );
                  }
                }
                return acc.validateIncomingPayment(amount);
              }

              return Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
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
                              labelText: l10n.invoice_description_label,
                            ),
                            style: theme.FieldTextStyle.textStyle,
                          ),
                          AmountFormField(
                            context: context,
                            accountModel: acc,
                            focusNode: _amountFocusNode,
                            controller: _amountController,
                            validatorFn: validatePayment,
                            style: theme.FieldTextStyle.textStyle,
                          ),
                          _buildReceivableBTC(context, acc, lspStatus),
                          StreamBuilder<AccountModel>(
                            stream: accountBloc.accountStream,
                            builder: (context, accSnapshot) {
                              if (!accSnapshot.hasData) {
                                return Container();
                              }
                              String message =
                              _availabilityMessage(accSnapshot);
                              if (message != null) {
                                // In case error doesn't have a trailing full stop
                                if (!message.endsWith('.')) {
                                  message += '.';
                                }
                                return Container(
                                  padding: EdgeInsets.only(
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
                                          color: context.errorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox();
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
    AsyncSnapshot<AccountModel> accSnapshot,
  ) {
    var l10n = context.l10n;

    if (accSnapshot.hasError) {
      return accSnapshot.error.toString();
    }
    if (!accSnapshot.hasData) {
      return l10n.invoice_availability_message_synchronizing;
    }
    final acc = accSnapshot.data;
    if (acc.processingConnection) {
      return l10n.invoice_availability_message_opening_channel;
    }
    return null;
  }

  Widget _buildReceivableBTC(
    BuildContext context,
    AccountModel acc,
    LSPStatus lspStatus,
  ) {
    TextTheme textTheme = context.textTheme;

    LSPInfo lsp = lspStatus?.currentLSP;
    Widget warning = lsp == null
        ? SizedBox()
        : WarningBox(
            boxPadding: EdgeInsets.fromLTRB(16, 30, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatFeeMessage(acc, lsp),
                  style: textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
        ],
      ),
    );
    if (_withdrawFetchResponse == null) {
      return Container(
        width: context.mediaQuerySize.width,
        height: 164,
        padding: EdgeInsets.only(top: 16.0),
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                context.l10n.invoice_receive_label(
                  acc.currency.format(acc.maxAllowedToReceive),
                ),
                style: theme.textStyle,
                maxLines: 1,
                minFontSize: context.minFontSize,
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
    AccountModel accountModel,
    LSPInfo lspInfo,
  ) {
    var l10n = context.l10n;

    final connected = accountModel.connected;
    final minFee = (lspInfo != null)
        ? Int64(lspInfo.channelMinimumFeeMsat) ~/ 1000
        : Int64(0);
    final minFeeFormatted = accountModel.currency.format(minFee);
    final showMinFeeMessage = minFee > 0;
    final setUpFee = (lspInfo.channelFeePermyriad / 100).toString();
    final liquidity = accountModel.currency.format(
      connected ? accountModel.maxInboundLiquidity : Int64(0),
    );

    if (connected && showMinFeeMessage) {
      return l10n.invoice_ln_address_warning_with_min_fee_account_connected(
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (connected && !showMinFeeMessage) {
      return l10n.invoice_ln_address_warning_without_min_fee_account_connected(
        setUpFee,
        liquidity,
      );
    } else if (!connected && showMinFeeMessage) {
      return l10n.invoice_ln_address_warning_with_min_fee_account_not_connected(
        setUpFee,
        minFeeFormatted,
      );
    } else {
      return l10n
          .invoice_ln_address_warning_without_min_fee_account_not_connected(
        setUpFee,
      );
    }
  }

  Future _scanBarcode(BuildContext context, AccountModel account) async {
    var l10n = context.l10n;
    DialogTheme dialogTheme = context.dialogTheme;

    TransparentPageRoute loaderRoute;
    try {
      context.focusScope.requestFocus(FocusNode());
      String barcode = await context.pushNamed("/qr_scan");
      if (barcode == null) {
        return;
      }
      if (barcode.isEmpty) {
        showFlushbar(context, message: l10n.invoice_qr_code_not_detected);
        return;
      }
      loaderRoute = createLoaderRoute(context);
      context.push(loaderRoute);
      await _handleLNUrlWithdraw(context, account, barcode);
      context.navigator.removeRoute(loaderRoute);
    } catch (e) {
      if (loaderRoute != null) {
        context.navigator.removeRoute(loaderRoute);
      }
      promptError(
        context,
        l10n.invoice_receive_fail,
        Text(
          l10n.invoice_receive_fail_message(e.toString()),
          style: dialogTheme.contentTextStyle,
        ),
      );
    }
  }

  Future _handleLNUrlWithdraw(
    BuildContext context,
    AccountModel account,
    String lnurl,
  ) async {
    final lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
    Fetch fetchAction = Fetch(lnurl);
    lnurlBloc.actionsSink.add(fetchAction);
    var response = await fetchAction.future;
    if (response.runtimeType != WithdrawFetchResponse) {
      throw context.l10n.invoice_error_url;
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
    _amountController.text = account.currency.format(
      response.maxAmount,
      includeDisplayName: false,
      userInput: true,
    );
  }

  Future _createInvoice(
    BuildContext context,
    InvoiceBloc invoiceBloc,
    AccountBloc accountBloc,
    LNUrlBloc lnurlBloc,
    AccountModel account,
  ) {
    invoiceBloc.newInvoiceRequestSink.add(
      InvoiceRequestModel(
        null,
        _descriptionController.text,
        null,
        account.currency.parse(_amountController.text),
      ),
    );
    context.pop();
    var currentRoute = ModalRoute.of(context.navigator.context);
    Widget dialog = _withdrawFetchResponse != null
        ? LNURlWithdrawDialog(invoiceBloc, accountBloc, lnurlBloc, (result) {
            onPaymentFinished(result, currentRoute, context.navigator);
          })
        : QrCodeDialog(context, invoiceBloc, accountBloc, (result) {
            onPaymentFinished(result, currentRoute, context.navigator);
          });
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
