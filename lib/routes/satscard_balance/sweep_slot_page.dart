import 'dart:collection';
import 'dart:io';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/routes/satscard_balance/satscard_balance_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez/widgets/fee_chooser.dart';
import 'package:breez/widgets/satscard/spend_code_field.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SweepSlotPage extends StatefulWidget {
  final Satscard _card;
  final Slot _slot;
  final Function() onBack;
  final AddressInfo Function() getAddressInfo;

  const SweepSlotPage(this._card, this._slot,
      {this.onBack, this.getAddressInfo});

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
  int _selectedFeeIndex = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
    _satscardBloc = AppBlocsProvider.of<SatscardBloc>(context);
    _addressInfo = widget.getAddressInfo();

    // We need a deposit address before we can do anything
    _addFundsBloc.addFundRequestSink.add(AddFundsInfo(true, false));
    _addFundsBloc.addFundResponseStream.listen((fundResponse) {
      if (mounted) {
        // Now we can get the unsigned transactions we need
        final action =
            CreateSlotSweepTransactions(_addressInfo, fundResponse.address);
        _satscardBloc.actionsSink.add(action);
        action.future.then((result) {
          if (mounted) {
            setState(() {
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
        });
        setState(() {
          _fundResponse = fundResponse;
        });
      }
    });
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
          final loaderText = _getLoaderText(
            texts,
            acc,
            lsp,
          );
          final isLoading = loaderText != null;

          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                bottom:
                    Platform.isIOS && _spendCodeFocusNode.hasFocus ? 40.0 : 0.0,
              ),
              child: SingleButtonBottomBar(
                stickToBottom: true,
                text: texts.satscard_sweep_button_label,
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          // TODO: Add SweepSatscard action and open the NFC dialog
                        }
                      },
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
            body: isLoading
                ? _buildLoader(themeData, loaderText)
                : Form(
                    key: _formKey,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 10.0),
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
                                    return texts
                                        .satscard_spend_code_incorrect_code_hint;
                                  }
                                  return null;
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 24, bottom: 24),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  border: Border.all(
                                    color: themeData.colorScheme.onSurface
                                        .withOpacity(0.4),
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
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildLoader(ThemeData themeData, String title) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: CircularProgress(
            size: 64,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            color: themeData.progressIndicatorTheme.color,
            title: title,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSweepSummary(
    BuildContext context,
    ThemeData themeData,
    BreezTranslations texts,
    AccountModel acc,
    LSPStatus lsp,
  ) {
    final transaction = _createResponse.txs[_selectedFeeIndex];
    final lspMinFee = lsp.currentLSP.cheapestOpeningFeeParams.minMsat ~/ 1000;
    final lspPropFee = transaction.output *
        lsp.currentLSP.cheapestOpeningFeeParams.proportional ~/
        1000000;
    final lspFee = lspMinFee > lspPropFee ? lspMinFee : lspPropFee;
    final receive = transaction.output - lspFee;

    final formattedBalance = acc.currency.format(transaction.input);
    final formattedChainFee = acc.currency.format(transaction.fees);
    final formattedLspFee = acc.currency.format(lspFee);
    final formattedReceive = acc.currency.format(receive);
    final minFont = MinFontSize(context);
    return [
      buildSlotPageTextTile(
        context,
        minFont,
        titleText: texts.satscard_sweep_balance_label,
        trailingText: acc.fiatCurrency == null
            ? texts.satscard_balance_value_no_fiat(formattedBalance)
            : texts.satscard_balance_value_with_fiat(
                formattedBalance, acc.fiatCurrency.format(transaction.input)),
        trailingColor: themeData.colorScheme.error,
      ),
      buildSlotPageTextTile(
        context,
        minFont,
        titleText: texts.satscard_sweep_chain_fee_label,
        trailingText: texts.satscard_sweep_fee_value(formattedChainFee),
        titleColor: Colors.white.withOpacity(0.4),
        trailingColor: Colors.white.withOpacity(0.4),
      ),
      buildSlotPageTextTile(
        context,
        minFont,
        titleText: texts.satscard_sweep_lsp_fee_label,
        trailingText: texts.satscard_sweep_fee_value(formattedLspFee),
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
                formattedReceive, acc.fiatCurrency.format(receive)),
        trailingColor: themeData.colorScheme.error,
      ),
    ];
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
}
