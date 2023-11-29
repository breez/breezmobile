import 'dart:collection';
import 'dart:typed_data';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/bloc/satscard/satscard_op_status.dart';
import 'package:breez/routes/satscard_balance/satscard_balance_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/fee_chooser.dart';
import 'package:breez/widgets/satscard/satscard_operation_dialog.dart';
import 'package:breez/widgets/satscard/spend_code_field.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class SweepSlotPage extends StatefulWidget {
  final Satscard _card;
  final Slot _slot;
  final Function() onBack;
  final Function(RawSlotSweepTransaction, Uint8List) onUnsealed;
  final AddressInfo Function() getAddressInfo;
  final Uint8List Function() getCachedPrivateKey;

  const SweepSlotPage(this._card, this._slot,
      {this.onBack,
      this.onUnsealed,
      this.getAddressInfo,
      this.getCachedPrivateKey});

  @override
  State<StatefulWidget> createState() => SweepSlotPageState();
}

class SweepSlotPageState extends State<SweepSlotPage> {
  final _formKey = GlobalKey<FormState>();
  final _spendCodeController = TextEditingController();
  final _spendCodeFocusNode = FocusNode();
  final _incorrectCodes =
      HashSet<String>(equals: (a, b) => a == b, hashCode: (a) => a.hashCode);

  AddFundsBloc _addFundsBloc;
  SatscardBloc _satscardBloc;
  AddressInfo _addressInfo;
  AddFundResponse _fundResponse;
  CreateSlotSweepResponse _createResponse;
  List<FeeOption> _feeOptions;
  Int64 _lspFee;
  Int64 _receiveAmount;
  int _selectedFeeIndex = 1;
  String _recentError = "";

  RawSlotSweepTransaction get _transaction =>
      _createResponse != null ? _createResponse.txs[_selectedFeeIndex] : null;

  void _setError(String errorMessage) {
    if (context.mounted) {
      setState(() => _recentError = errorMessage);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
    _satscardBloc = AppBlocsProvider.of<SatscardBloc>(context);
    _addressInfo = widget.getAddressInfo();
    _recentError = "";

    // We need a deposit address before we can do anything
    _requestDepositAddress();
  }

  @override
  Widget build(BuildContext context) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, accSnapshot) => StreamBuilder<LSPStatus>(
        stream: lspBloc.lspStatusStream,
        builder: (context, lspSnapshot) {
          final themeData = Theme.of(context);
          final texts = context.texts();
          final acc = accSnapshot.data;
          final lsp = lspSnapshot.data;
          final loaderText = _getLoaderText(texts, acc, lsp);
          final isLoading = loaderText != null;

          // Update fee/receive parameters so we can construct widgets correctly
          if (!isLoading && _recentError.isEmpty) {
            _receiveAmount = _transaction.output;
            if (_isSetupFeeRequired(acc)) {
              final lspMinFee =
                  lsp.currentLSP.cheapestOpeningFeeParams.minMsat ~/ 1000;
              final lspPropFee = _transaction.output *
                  lsp.currentLSP.cheapestOpeningFeeParams.proportional ~/
                  1000000;
              _lspFee = lspMinFee > lspPropFee ? lspMinFee : lspPropFee;
              _receiveAmount -= _lspFee;
            }
          }

          return Scaffold(
            bottomNavigationBar: isLoading
                ? null
                : Padding(
                    padding: const EdgeInsets.all(0),
                    child: SingleButtonBottomBar(
                      stickToBottom: false,
                      text: _getBottomButtonText(texts, acc),
                      onPressed:
                          isLoading ? null : () => _onBottomButtonPressed(acc),
                    ),
                  ),
            appBar: AppBar(
              leading: backBtn.BackButton(
                onPressed: () {
                  if (_spendCodeFocusNode.hasFocus) {
                    _spendCodeFocusNode.unfocus();
                  }
                  widget.onBack();
                },
              ),
              title: Text(texts.satscard_sweep_title(widget._slot.index + 1)),
            ),
            body: _recentError.isNotEmpty
                ? buildErrorBody(themeData, _recentError)
                : isLoading
                    ? buildLoaderBody(themeData, loaderText)
                    : _buildFormBody(themeData, texts, acc, lsp),
          );
        },
      ),
    );
  }

  String _getLoaderText(
    BreezTranslations texts,
    AccountModel acc,
    LSPStatus lsp,
  ) {
    if (acc == null) {
      return texts.satscard_balance_awaiting_account_label;
    } else if (lsp == null) {
      return texts.satscard_sweep_awaiting_lsp_label;
    } else if (_fundResponse == null) {
      return texts.satscard_sweep_awaiting_deposit_label;
    } else if (_feeOptions == null || _createResponse == null) {
      return texts.satscard_sweep_awaiting_fees_label;
    }

    return null;
  }

  String _getBottomButtonText(BreezTranslations texts, AccountModel acc) {
    if (_recentError.isNotEmpty) {
      return texts.satscard_balance_button_retry_label;
    }
    if (!_canFundChannel(acc)) {
      return texts.satscard_sweep_button_cancel_label;
    }
    return texts.satscard_sweep_button_confirm_label;
  }

  void _onBottomButtonPressed(AccountModel acc) {
    // Handle error retrying
    if (_recentError.isNotEmpty) {
      if (_fundResponse == null) {
        _requestDepositAddress();
      } else if (_createResponse == null) {
        _requestRawSlotSweepTransactions(_fundResponse.address);
      }
      return;
    }
    // Handle cancel
    if (!_canFundChannel(acc)) {
      widget.onBack();
      return;
    }
    // Handle re-confirmation
    Uint8List cachedKey = widget.getCachedPrivateKey();
    if (cachedKey != null && cachedKey.isNotEmpty) {
      widget.onUnsealed(_transaction, cachedKey);
      return;
    }
    // Handle unseal
    if (_formKey.currentState.validate()) {
      final action = UnsealSlot(widget._card, _spendCodeController.text);
      _satscardBloc.actionsSink.add(action);
      showSatscardOperationDialog(context, _satscardBloc, widget._card.ident)
          .then((result) {
        if (result is SatscardOpStatusBadAuth) {
          _incorrectCodes.add(action.spendCode);
          _formKey.currentState.validate();
        }
        if (result is SatscardOpStatusSuccess) {
          widget.onUnsealed(_transaction, result.slot.privkey);
        }
      });
      return;
    }
  }

  void _requestDepositAddress() {
    setState(() {
      _fundResponse = null;
      _recentError = "";
    });

    final addFundsAction = AddFundsInfo(true, false);
    _addFundsBloc.addFundRequestSink.add(addFundsAction);
    _addFundsBloc.addFundResponseStream
        .handleError((e) => _setError(
            context.texts().satscard_sweep_error_deposit_address(e.toString())))
        .listen((fundResponse) {
      if (mounted) {
        // Now we can construct our unsigned transactions
        _requestUnsignedTransactions(fundResponse.address);

        setState(() {
          _fundResponse = fundResponse;
        });
      }
    });
  }

  void _requestRawSlotSweepTransactions(String depositAddress) {
    setState(() {
      _createResponse = null;
      _recentError = "";
    });

    final action = CreateSlotSweepTransactions(_addressInfo, depositAddress);
    _satscardBloc.actionsSink.add(action);
    action.future.then((result) {
      if (mounted) {
        setState(() {
          _recentError = "";
          _createResponse = result;
          _feeOptions = List<FeeOption>.generate(
            _createResponse.txs.length,
            (i) => FeeOption(
              _createResponse.txs[i].fees.toInt(),
              _createResponse.txs[i].targetConfirmations,
            ),
          );
        });
      }
    }).catchError((e) => _setError(context
        .texts()
        .satscard_sweep_error_create_transactions(e.toString())));
  }

  bool _canFundChannel(AccountModel acc) {
    return acc != null &&
        !_isBalanceTooHigh(acc) &&
        !_isBalanceTooLow(acc) &&
        _isReserveMet(acc);
  }

  bool _isSetupFeeRequired(AccountModel acc) {
    return acc != null && _transaction.output > acc.maxInboundLiquidity;
  }

  bool _isBalanceTooHigh(AccountModel acc) {
    return _isSetupFeeRequired(acc) &&
        _transaction.output > _fundResponse.maxAllowedDeposit;
  }

  bool _isBalanceTooLow(AccountModel acc) {
    return _isSetupFeeRequired(acc) &&
        _transaction.output < _fundResponse.minAllowedDeposit;
  }

  bool _isReserveMet(acc) {
    return !_isSetupFeeRequired(acc) ||
        _receiveAmount >= _fundResponse.requiredReserve;
  }

  Widget _buildFormBody(
    ThemeData themeData,
    BreezTranslations texts,
    AccountModel acc,
    LSPStatus lsp,
  ) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpendCodeFormField(
                  context: context,
                  texts: texts,
                  focusNode: _spendCodeFocusNode,
                  controller: _spendCodeController,
                  style: theme.FieldTextStyle.textStyle,
                  validatorFn: (code) {
                    if (_incorrectCodes.contains(code)) {
                      return texts.satscard_spend_code_incorrect_code_hint;
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: FeeChooser(
                    economyFee: _feeOptions[0],
                    regularFee: _feeOptions[1],
                    priorityFee: _feeOptions[2],
                    selectedIndex: _selectedFeeIndex,
                    onSelect: (index) => setState(() {
                      _selectedFeeIndex = index;
                      if (_spendCodeFocusNode.hasFocus) {
                        _spendCodeFocusNode.unfocus();
                      }
                    }),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(
                      color: themeData.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ..._buildSweepSummary(
                        context,
                        themeData,
                        texts,
                        acc,
                        lsp,
                      ).where((w) => w != null).toList()
                    ],
                  ),
                ),
                _buildWarningBox(texts, acc, lsp)
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSweepSummary(
    BuildContext context,
    ThemeData themeData,
    BreezTranslations texts,
    AccountModel acc,
    LSPStatus lsp,
  ) {
    final formattedBalance = acc.currency.format(_transaction.input);
    final formattedReceive = acc.currency.format(_receiveAmount);
    final minFont = MinFontSize(context);
    return [
      buildSlotPageTextTile(
        context,
        minFont,
        titleText: texts.satscard_sweep_balance_label,
        trailingText: acc.fiatCurrency == null
            ? texts.satscard_balance_value_no_fiat(formattedBalance)
            : texts.satscard_balance_value_with_fiat(
                formattedBalance, acc.fiatCurrency.format(_transaction.input)),
        trailingColor: themeData.colorScheme.error,
      ),
      buildSlotPageTextTile(
        context,
        minFont,
        titleText: texts.satscard_sweep_chain_fee_label,
        trailingText: texts
            .satscard_sweep_fee_value(acc.currency.format(_transaction.fees)),
        titleColor: Colors.white.withOpacity(0.4),
        trailingColor: Colors.white.withOpacity(0.4),
      ),
      !_isSetupFeeRequired(acc)
          ? null
          : buildSlotPageTextTile(
              context,
              minFont,
              titleText: texts.satscard_sweep_lsp_fee_label,
              trailingText:
                  texts.satscard_sweep_fee_value(acc.currency.format(_lspFee)),
              titleColor: Colors.white.withOpacity(0.4),
              trailingColor: Colors.white.withOpacity(0.4),
            ),
      buildSlotPageTextTile(
        context,
        minFont,
        titleText: texts.satscard_sweep_receive_label,
        trailingText: acc.fiatCurrency == null
            ? texts.satscard_balance_value_no_fiat(formattedReceive)
            : texts.satscard_balance_value_with_fiat(
                formattedReceive, acc.fiatCurrency.format(_receiveAmount)),
        trailingColor: themeData.colorScheme.error,
      ),
      !_isBalanceTooHigh(acc)
          ? null
          : buildSlotPageTextTile(
              context,
              minFont,
              titleText: texts.satscard_sweep_balance_too_high_label,
              trailingText: texts.satscard_balance_value_no_fiat(
                  acc.currency.format(_fundResponse.maxAllowedDeposit)),
              trailingColor: themeData.colorScheme.error,
            ),
      !_isBalanceTooLow(acc)
          ? null
          : buildSlotPageTextTile(
              context,
              minFont,
              titleText: texts.satscard_sweep_balance_too_low_label,
              trailingText: texts.satscard_balance_value_no_fiat(
                  acc.currency.format(_fundResponse.minAllowedDeposit)),
              trailingColor: themeData.colorScheme.error,
            ),
      _isReserveMet(acc)
          ? null
          : buildSlotPageTextTile(
              context,
              minFont,
              titleText: texts.satscard_sweep_balance_reserve_not_met_label,
              trailingText: texts.satscard_balance_value_no_fiat(
                  acc.currency.format(_fundResponse.requiredReserve)),
              trailingColor: themeData.colorScheme.error,
            ),
    ];
  }

  Widget _buildWarningBox(
    BreezTranslations texts,
    AccountModel acc,
    LSPStatus lsp,
  ) {
    if (_isSetupFeeRequired(acc)) {
      final propFee =
          (lsp.currentLSP.cheapestOpeningFeeParams.proportional / 10000)
              .toString();
      final minFee = acc.currency
          .format(lsp.currentLSP.cheapestOpeningFeeParams.minMsat ~/ 1000);
      final liquidity = acc.currency
          .format(acc.connected ? acc.maxInboundLiquidity : Int64(0));

      String contentText;
      if (!_canFundChannel(acc)) {
        contentText = texts.satscard_sweep_warning_not_valid;
      } else if (!acc.connected || acc.maxInboundLiquidity == 0) {
        contentText = texts.satscard_sweep_warning_lsp_fee_no_liquidity_label(
            minFee, propFee);
      } else {
        contentText = texts.satscard_sweep_warning_lsp_fee_label(
            minFee, propFee, liquidity);
      }
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: WarningBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                contentText,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
