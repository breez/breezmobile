import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/logger.dart';
import 'package:breez/utils/exceptions.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/fee_chooser.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger("SweepAllCoinsConfirmation");

class SweepAllCoinsConfirmation extends StatefulWidget {
  final AccountBloc accountBloc;
  final String address;
  final Function() onPrevious;
  final Future Function(TxDetail tx) onConfirm;

  const SweepAllCoinsConfirmation({
    Key key,
    this.onPrevious,
    this.onConfirm,
    this.accountBloc,
    this.address,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SweepAllCoinsConfirmationState();
  }
}

class SweepAllCoinsConfirmationState extends State<SweepAllCoinsConfirmation> {
  List<FeeOption> feeOptions;
  List<TxDetail> transactions;
  int selectedFeeIndex = 1;
  Future _txsDetailsFuture;
  Int64 _sweepAmount;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();

    var action = SweepAllCoinsTxsAction(widget.address);
    widget.accountBloc.userActionsSink.add(action);
    _txsDetailsFuture = action.future.then((r) {
      _log.info("Sweep all coins response: $r");
      SweepAllCoinsTxs response = r as SweepAllCoinsTxs;
      _sweepAmount = response.amount;
      List<int> targetConfirmations = response.transactions.keys.toList()
        ..sort();
      List<int> trimmedTargetConfirmations =
          targetConfirmations.reversed.toList();
      _log.info("Sweep all coins amount $_sweepAmount"
          "confirmations: ${trimmedTargetConfirmations.logDescription((e) => e.toString())}");
      if (trimmedTargetConfirmations.length > 3) {
        _log.info("Reducing confirmations to 3");
        var middle = (targetConfirmations.length / 2).floor();
        trimmedTargetConfirmations = [
          targetConfirmations.last,
          targetConfirmations[middle],
          targetConfirmations.first
        ];
      }

      transactions = trimmedTargetConfirmations
          .map((index) => response.transactions[index])
          .toList();
      _log.info("Sweep all coins transactions: "
          "${transactions.logDescription((e) => e.txHash)}");

      feeOptions =
          List.generate(trimmedTargetConfirmations.length, (index) => index)
              .map((index) => FeeOption(transactions[index].fees.toInt(),
                  trimmedTargetConfirmations[index]))
              .toList();
      if (feeOptions.isNotEmpty) {
        setState(() {
          _showConfirm = true;
        });
      }
      selectedFeeIndex = (feeOptions.length / 2).floor();
      while (feeOptions.length < 3) {
        feeOptions.add(null);
        transactions.add(null);
      }
    }, onError: (error) {
      _log.warning("Sweep all coins error", error);
      promptError(
        context,
        null,
        Text(
          extractExceptionMessage(error, texts: context.texts()),
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    return Scaffold(
      appBar: AppBar(
        leading: backBtn.BackButton(onPressed: () {
          _log.info("Back");
          widget.onPrevious();
        }),
        title: Text(texts.sweep_all_coins_speed),
      ),
      body: StreamBuilder<AccountModel>(
        stream: AppBlocsProvider.of<AccountBloc>(context).accountStream,
        builder: (context, snapshot) {
          AccountModel acc = snapshot.data;
          return FutureBuilder(
            future: _txsDetailsFuture,
            builder: (context, futureSnapshot) {
              if (futureSnapshot.error != null) {
                _log.warning("Sweep all coins error", futureSnapshot.error);
                return _ErrorMessage(
                  message: texts.sweep_all_coins_error_retrieve_fees,
                );
              }

              if (futureSnapshot.connectionState != ConnectionState.done ||
                  acc == null) {
                _log.info("Waiting ${futureSnapshot.connectionState} $acc");
                return const SizedBox();
              }

              if (feeOptions == null ||
                  feeOptions.where((f) => f != null).isEmpty) {
                _log.info("No fees");
                return _ErrorMessage(
                  message: texts.sweep_all_coins_error_amount_small,
                );
              }

              return Container(
                height: 500.0,
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FeeChooser(
                      economyFee: feeOptions[0],
                      regularFee: feeOptions[1],
                      priorityFee: feeOptions[2],
                      selectedIndex: selectedFeeIndex,
                      onSelect: (index) => setState(() {
                        _log.info("Selected fee $index");
                        selectedFeeIndex = index;
                      }),
                    ),
                    const SizedBox(height: 36.0),
                    buildSummary(acc),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: !_showConfirm
          ? null
          : SingleButtonBottomBar(
              text: texts.sweep_all_coins_action_confirm,
              onPressed: () {
                _log.info(
                    "Sweep all coins using $selectedFeeIndex of ${transactions.logDescription((e) => e.fees.toString())}");
                Navigator.of(context).push(createLoaderRoute(context));
                widget.onConfirm(transactions[selectedFeeIndex]).then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  _log.warning("Sweep all coins error", error);
                  Navigator.of(context).pop();
                  promptError(
                    context,
                    null,
                    Text(
                      extractExceptionMessage(error, texts: texts),
                      style: themeData.dialogTheme.contentTextStyle,
                    ),
                  );
                });
              },
            ),
    );
  }

  Widget buildSummary(AccountModel acc) {
    _log.info("buildSummary, $selectedFeeIndex "
        "${feeOptions != null ? feeOptions.logDescription((e) => e.confirmationTarget.toString()) : "null"}");
    final themeData = Theme.of(context);
    final texts = context.texts();
    final receive = _sweepAmount - feeOptions[selectedFeeIndex].sats;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
          color: themeData.colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_send,
              style: const TextStyle(
                color: Colors.white,
              ),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              acc.currency.format(_sweepAmount),
              style: TextStyle(
                color: themeData.colorScheme.error,
              ),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_transaction_fee,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              texts.sweep_all_coins_fee(
                acc.currency.format(
                  Int64(feeOptions[selectedFeeIndex].sats),
                ),
              ),
              style: TextStyle(
                color: themeData.colorScheme.error.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_receive,
              style: const TextStyle(
                color: Colors.white,
              ),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              acc.fiatCurrency == null
                  ? texts.sweep_all_coins_amount_no_fiat(
                      acc.currency.format(receive),
                    )
                  : texts.sweep_all_coins_amount_with_fiat(
                      acc.currency.format(receive),
                      acc.fiatCurrency.format(receive),
                    ),
              style: TextStyle(
                color: themeData.colorScheme.error,
              ),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
