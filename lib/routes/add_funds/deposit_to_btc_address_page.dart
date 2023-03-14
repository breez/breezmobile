import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/routes/add_funds/address_widget.dart';
import 'package:breez/routes/add_funds/conditional_deposit.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class DepositToBTCAddressPage extends StatefulWidget {
  const DepositToBTCAddressPage();

  @override
  State<StatefulWidget> createState() {
    return DepositToBTCAddressPageState();
  }
}

class DepositToBTCAddressPageState extends State<DepositToBTCAddressPage> {
  AddFundsBloc _addFundsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_addFundsBloc == null) {
      _addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
      _addFundsBloc.addFundRequestSink.add(AddFundsInfo(false, false));
      _addFundsBloc.addFundRequestSink.add(AddFundsInfo(true, false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);

    return ConditionalDeposit(
      title: texts.invoice_btc_address_title,
      enabledChild: StreamBuilder<LSPStatus>(
        stream: lspBloc.lspStatusStream,
        builder: (context, lspSnapshot) {
          return StreamBuilder(
            stream: accountBloc.accountStream,
            builder: (context, accSnapshot) {
              return StreamBuilder(
                stream: _addFundsBloc.addFundResponseStream,
                builder: (context, snapshot) {
                  return Material(
                    child: Scaffold(
                      appBar: AppBar(
                        leading: const backBtn.BackButton(),
                        title: Text(texts.invoice_btc_address_title),
                      ),
                      body: getBody(
                        context,
                        accSnapshot.data,
                        snapshot.data,
                        lspSnapshot.data,
                        snapshot.hasError
                            ? texts.invoice_btc_address_network_error
                            : null,
                      ),
                      bottomNavigationBar: _buildBottomBar(
                        context,
                        snapshot.data,
                        accSnapshot.data,
                        hasError: snapshot.hasError,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget getBody(
    BuildContext context,
    AccountModel account,
    AddFundResponse response,
    LSPStatus lspStatus,
    String error,
  ) {
    final texts = context.texts();

    String errorMessage;
    if (error != null) {
      errorMessage = error;
    } else if (response != null && response.errorMessage.isNotEmpty) {
      errorMessage = response.errorMessage;
    }
    if (errorMessage != null) {
      if (!errorMessage.endsWith('.')) {
        errorMessage += '.';
      }
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
            child: Text(errorMessage, textAlign: TextAlign.center),
          ),
        ],
      );
    }

    final lspInfo = lspStatus?.currentLSP;
    final minAllowedDeposit = response?.minAllowedDeposit;
    final maxAllowedDeposit = response?.maxAllowedDeposit;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AddressWidget(response?.address, response?.backupJson),
          response == null || lspInfo == null
              ? const SizedBox()
              : WarningBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _sendMessage(
                          texts,
                          account,
                          lspInfo,
                          minAllowedDeposit,
                          maxAllowedDeposit,
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  String _sendMessage(
    BreezTranslations texts,
    AccountModel accountModel,
    LSPInfo lspInfo,
    Int64 minAllowedDeposit,
    Int64 maxAllowedDeposit,
  ) {
    final connected = accountModel.connected;
    final minFees = (lspInfo != null)
        ? Int64(lspInfo.channelMinimumFeeMsat) ~/ 1000
        : Int64(0);
    final showMinFeeMessage = minFees > 0;
    final minFeeFormatted = accountModel.currency.format(minFees);
    final minSats = accountModel.currency.format(
      _minAllowedDeposit(
        lspInfo,
        minAllowedDeposit,
      ),
      includeDisplayName: true,
    );
    final maxSats = accountModel.currency.format(
      maxAllowedDeposit,
      includeDisplayName: true,
    );
    final setUpFee = (lspInfo.channelFeePermyriad / 100).toString();
    final liquidity = accountModel.currency.format(
      connected ? accountModel.maxInboundLiquidity : Int64(0),
    );

    if (connected && showMinFeeMessage) {
      return texts.invoice_btc_address_warning_with_min_fee_account_connected(
        minSats,
        maxSats,
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (connected && !showMinFeeMessage) {
      return texts
          .invoice_btc_address_warning_without_min_fee_account_connected(
        minSats,
        maxSats,
        setUpFee,
        liquidity,
      );
    } else if (!connected && showMinFeeMessage) {
      return texts
          .invoice_btc_address_warning_with_min_fee_account_not_connected(
        minSats,
        maxSats,
        setUpFee,
        minFeeFormatted,
      );
    } else {
      return texts
          .invoice_btc_address_warning_without_min_fee_account_not_connected(
        minSats,
        maxSats,
        setUpFee,
      );
    }
  }

  Int64 _minAllowedDeposit(
    LSPInfo lspInfo,
    Int64 minAllowedDeposit,
  ) {
    final minFees = (lspInfo != null)
        ? Int64(lspInfo.channelMinimumFeeMsat) ~/ 1000
        : Int64(0);
    if (minAllowedDeposit == null) return minFees;
    if (minFees > minAllowedDeposit) return minFees;
    return minAllowedDeposit;
  }

  Widget _buildBottomBar(
    BuildContext context,
    AddFundResponse response,
    AccountModel account, {
    hasError = false,
  }) {
    final texts = context.texts();

    if (hasError || response?.errorMessage?.isNotEmpty == true) {
      return SingleButtonBottomBar(
        text: hasError
            ? texts.invoice_btc_address_action_retry
            : texts.invoice_btc_address_action_close,
        onPressed: () {
          if (hasError) {
            _addFundsBloc.addFundRequestSink.add(AddFundsInfo(true, false));
          } else {
            Navigator.of(context).pop();
          }
        },
      );
    }

    return const SizedBox();
  }
}
