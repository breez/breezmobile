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
import 'package:breez/routes/add_funds/conditional_deposit.dart';
import 'package:breez/routes/satscard_balance/satscard_balance_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/utils/stream_builder_extensions.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/fee_chooser.dart';
import 'package:breez/widgets/satscard/satscard_operation_dialog.dart';
import 'package:breez/widgets/satscard/spend_code_field.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:collection/collection.dart';
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
      {@required this.onBack,
      @required this.onUnsealed,
      @required this.getAddressInfo,
      @required this.getCachedPrivateKey});

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
  Future _transactionFuture;
  Object _fundError;
  AddFundResponse _fundResponse;
  CreateSlotSweepResponse _createResponse;
  int _selectedFeeIndex = 1;

  RawSlotSweepTransaction get _transaction =>
      _createResponse != null ? _createResponse.txs[_selectedFeeIndex] : null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
    _satscardBloc = AppBlocsProvider.of<SatscardBloc>(context);
    _addressInfo = widget.getAddressInfo();
    _requestDepositAddress();
  }

  @override
  Widget build(BuildContext context) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    final texts = context.texts();
    final displayIndex = widget._card.activeSlotIndex + 1;
    return ConditionalDeposit(
      title: texts.satscard_sweep_title(displayIndex),
      enabledChild: FutureBuilder(
        future: _transactionFuture,
        builder: (context, futureSnapshot) => StreamBuilder2(
          streamA: accountBloc.accountStream,
          streamB: lspBloc.lspStatusStream,
          builder: (context, accSnapshot, lspSnapshot) {
            _createResponse = futureSnapshot.data;

            // Handle logic separately
            final texts = context.texts();
            final info = _BuildInfo.create(
              texts,
              accSnapshot.data,
              lspSnapshot.data,
              _fundResponse,
              _createResponse,
              _selectedFeeIndex,
              error: futureSnapshot.error ??
                  _fundError ??
                  lspSnapshot.error ??
                  accSnapshot.error,
            );

            return Scaffold(
              appBar: AppBar(
                leading: backBtn.BackButton(
                  onPressed: () {
                    if (_spendCodeFocusNode.hasFocus) {
                      _spendCodeFocusNode.unfocus();
                    }
                    widget.onBack();
                  },
                ),
                title: Text(texts.satscard_sweep_title(displayIndex)),
              ),
              bottomNavigationBar: _buildButton(context, texts, info),
              body: _buildBody(context, texts, accSnapshot.data, info),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BreezTranslations texts,
      AccountModel acc, _BuildInfo info) {
    final feeOptions = _getFeeOptions();
    final themeData = Theme.of(context);
    final minFont = MinFontSize(context);

    if (info.showError) {
      return buildErrorBody(themeData, info.outText);
    } else if (info.showLoader) {
      return buildLoaderBody(themeData, info.outText);
    }
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
                    economyFee: feeOptions[0],
                    regularFee: feeOptions[1],
                    priorityFee: feeOptions[2],
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
                      buildSlotPageTextTile(
                        context,
                        minFont,
                        titleText: texts.satscard_sweep_balance_label,
                        trailingText:
                            formatBalanceValue(texts, acc, _transaction.input),
                        trailingColor: themeData.colorScheme.error,
                      ),
                      buildSlotPageTextTile(
                        context,
                        minFont,
                        titleText: texts.satscard_sweep_chain_fee_label,
                        trailingText: texts.satscard_sweep_fee_value(
                          acc.currency.format(_transaction.fees),
                        ),
                        titleColor: Colors.white.withOpacity(0.4),
                        trailingColor: Colors.white.withOpacity(0.4),
                      ),
                      !info.willOpenChannel
                          ? null
                          : buildSlotPageTextTile(
                              context,
                              minFont,
                              titleText: texts.satscard_sweep_lsp_fee_label,
                              trailingText: texts.satscard_sweep_fee_value(
                                acc.currency.format(info.lspFee),
                              ),
                              titleColor: Colors.white.withOpacity(0.4),
                              trailingColor: Colors.white.withOpacity(0.4),
                            ),
                      buildSlotPageTextTile(
                        context,
                        minFont,
                        titleText: texts.satscard_sweep_receive_label,
                        trailingText:
                            formatBalanceValue(texts, acc, info.receiveAmount),
                        trailingColor: themeData.colorScheme.error,
                      ),
                      info.canSweep
                          ? null
                          : buildSlotPageTextTile(
                              context,
                              minFont,
                              titleText: info.failureLabel,
                              trailingText: formatBalanceValue(
                                  texts, acc, info.failureAmount),
                              trailingColor: themeData.colorScheme.error,
                            ),
                    ].whereNotNull().toList(),
                  ),
                ),
                info.outText.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: buildWarning(
                          themeData,
                          title: info.outText,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, BreezTranslations texts, _BuildInfo info) {
    String text = "";
    Function() onPressed;

    switch (info.buttonAction) {
      case _ButtonAction.None:
        return null;

      case _ButtonAction.Cancel:
        text = texts.satscard_sweep_button_cancel_label;
        onPressed = widget.onBack;
        break;

      case _ButtonAction.Retry:
        text = texts.satscard_balance_button_retry_label;
        onPressed = () {
          if (_fundResponse == null || _fundResponse.errorMessage.isNotEmpty) {
            _requestDepositAddress();
          } else {
            _updateFundResponse(_fundResponse);
          }
        };
        break;

      case _ButtonAction.Sweep:
        text = texts.satscard_sweep_button_confirm_label;
        onPressed = () {
          Uint8List cachedKey = widget.getCachedPrivateKey();
          if (cachedKey != null && cachedKey.isNotEmpty) {
            widget.onUnsealed(_transaction, cachedKey);
            return;
          }
          if (_formKey.currentState.validate()) {
            final spendCode = _spendCodeController.text;
            if (widget._slot.status == SlotStatus.sealed) {
              _satscardBloc.actionsSink
                  .add(UnsealSlot(widget._card, spendCode));
            } else {
              _satscardBloc.actionsSink
                  .add(GetSlot(widget._card, widget._slot.index, spendCode));
            }
            showSatscardOperationDialog(
              context,
              _satscardBloc,
              widget._card.ident,
            ).then((r) {
              if (r is SatscardOpStatusBadAuth) {
                _incorrectCodes.add(spendCode);
                _formKey.currentState.validate();
              }
              if (r is SatscardOpStatusSuccess) {
                if (_spendCodeFocusNode.hasFocus) {
                  _spendCodeFocusNode.unfocus();
                }
                widget.onUnsealed(_transaction, r.slot.privkey);
              }
            });
          }
        };
        break;
    }
    return SingleButtonBottomBar(
      stickToBottom: false,
      text: text,
      onPressed: onPressed,
    );
  }

  List<FeeOption> _getFeeOptions() {
    if (_createResponse == null) {
      return List<FeeOption>.empty();
    }
    return List<FeeOption>.generate(
      _createResponse.txs.length,
      (i) => FeeOption(
        _createResponse.txs[i].fees.toInt(),
        _createResponse.txs[i].targetConfirmations,
      ),
    );
  }

  void _requestDepositAddress() {
    setState(() => _fundError = null);

    final addFundsAction = AddFundsInfo(true, false);
    _addFundsBloc.addFundRequestSink.add(addFundsAction);
    _addFundsBloc.addFundResponseStream
        .listen((response) => _updateFundResponse(response));
    _addFundsBloc.addFundResponseStream
        .handleError((e) => setState(() => _fundError = e));
  }

  Future _requestSlotSweepTransactions(String depositAddress) {
    final action = CreateSlotSweepTransactions(_addressInfo, depositAddress);
    _satscardBloc.actionsSink.add(action);
    return action.future;
  }

  void _updateFundResponse(AddFundResponse response) {
    setState(() {
      _fundResponse = response;
      if (_fundResponse == null || _fundResponse.errorMessage.isNotEmpty) {
        _transactionFuture = null;
      } else {
        _transactionFuture = _requestSlotSweepTransactions(response.address);
      }
    });
  }
}

enum _ButtonAction {
  None,
  Cancel,
  Retry,
  Sweep,
}

class _BuildInfo {
  _ButtonAction buttonAction = _ButtonAction.None;
  bool showError = false;
  bool showLoader = false;
  String outText = "";
  Int64 receiveAmount = Int64.ZERO;
  Int64 lspFee = Int64.ZERO;
  String failureLabel = "";
  Int64 failureAmount = Int64.ZERO;

  bool get canSweep => failureLabel.isEmpty;
  bool get willOpenChannel => lspFee > 0;

  _BuildInfo.sweepable(this.outText, this.receiveAmount, this.lspFee)
      : buttonAction = _ButtonAction.Sweep;

  _BuildInfo.failure(this.outText, this.receiveAmount, this.lspFee,
      this.failureLabel, this.failureAmount)
      : buttonAction = _ButtonAction.Cancel;

  _BuildInfo.error(this.outText)
      : buttonAction = _ButtonAction.Retry,
        showError = true;

  _BuildInfo.loading(this.outText)
      : buttonAction = _ButtonAction.None,
        showLoader = true;

  factory _BuildInfo.create(
    BreezTranslations texts,
    AccountModel acc,
    LSPStatus lsp,
    AddFundResponse fund,
    CreateSlotSweepResponse sweep,
    int selectedTxIndex, {
    Object error,
  }) {
    // Handle errors
    if (error != null) {
      return _BuildInfo.error(sweep == null
          ? texts.satscard_sweep_error_create_transactions(error)
          : texts.satscard_sweep_error_deposit_address(error));
    } else if (fund != null && fund.errorMessage.isNotEmpty) {
      return _BuildInfo.error(
          texts.satscard_sweep_error_deposit_address(fund.errorMessage));
    }

    // Handle loading
    if (acc == null) {
      return _BuildInfo.loading(texts.satscard_balance_awaiting_account_label);
    } else if (lsp == null) {
      return _BuildInfo.loading(texts.satscard_sweep_awaiting_lsp_label);
    } else if (fund == null) {
      return _BuildInfo.loading(texts.satscard_sweep_awaiting_deposit_label);
    } else if (sweep == null) {
      return _BuildInfo.loading(texts.satscard_sweep_awaiting_fees_label);
    }

    // Figure out if we need a new channel
    final liquidity = acc.connected ? acc.maxInboundLiquidity : Int64.ZERO;
    final tx = sweep.txs[selectedTxIndex];
    var receive = tx.output;
    var lspFee = Int64.ZERO;
    var outText = "";
    if (liquidity < receive) {
      final minFee = lsp.currentLSP.cheapestOpeningFeeParams.minMsat ~/ 1000;
      final propFee = tx.output *
          lsp.currentLSP.cheapestOpeningFeeParams.proportional ~/
          1000000;
      lspFee = minFee > propFee ? minFee : propFee;
      receive -= lspFee;

      // Format our warning message
      final sats = acc.currency.format(liquidity);
      final fee = acc.currency.format(minFee);
      final percent =
          (lsp.currentLSP.cheapestOpeningFeeParams.proportional / 10000)
              .toString();
      outText = acc.maxInboundLiquidity == 0
          ? texts.satscard_sweep_warning_lsp_fee_no_liquidity_label(
              fee, percent)
          : texts.satscard_sweep_warning_lsp_fee_label(fee, percent, sats);
    }

    // Verify the sweep meets all the deposit conditions
    final minimum =
        fund.minAllowedDeposit > lspFee ? fund.minAllowedDeposit : lspFee;
    if (tx.output < minimum) {
      return _BuildInfo.failure(texts.satscard_sweep_warning_not_valid, receive,
          lspFee, texts.satscard_sweep_balance_too_low_label, minimum);
    } else if (tx.output > fund.maxAllowedDeposit) {
      return _BuildInfo.failure(
          texts.satscard_sweep_warning_not_valid,
          receive,
          lspFee,
          texts.satscard_sweep_balance_too_high_label,
          fund.maxAllowedDeposit);
    } else if (receive < fund.requiredReserve) {
      return _BuildInfo.failure(
          texts.satscard_sweep_warning_not_valid,
          receive,
          lspFee,
          texts.satscard_sweep_reserve_not_met_label,
          fund.requiredReserve);
    }
    return _BuildInfo.sweepable(outText, receive, lspFee);
  }
}
