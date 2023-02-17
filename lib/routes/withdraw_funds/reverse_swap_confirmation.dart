import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/utils/exceptions.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/fee_chooser.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class ReverseSwapConfirmation extends StatefulWidget {
  final ReverseSwapRequest swap;
  final ReverseSwapBloc bloc;
  final Function() onPrevious;
  final Future Function(String address, Int64 toSend, Int64 boltzFees,
      Int64 claimFees, Int64 received, String feesHash) onFeeConfirmed;

  const ReverseSwapConfirmation({
    Key key,
    this.swap,
    this.onPrevious,
    this.onFeeConfirmed,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReverseSwapConfirmationState();
  }
}

class ReverseSwapConfirmationState extends State<ReverseSwapConfirmation> {
  List<FeeOption> feeOptions;
  Map<int, ReverseSwapAmounts> amounts;
  int selectedFeeIndex = 1;
  Future _claimFeeFuture;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    var action = GetClaimFeeEstimates(widget.swap.claimAddress);
    widget.bloc.actionsSink.add(action);
    _claimFeeFuture = action.future.then((r) {
      final feeEstimates = r as ReverseSwapClaimFeeEstimates;
      final targetConfirmations = feeEstimates.fees.keys.toList()..sort();
      var trimmedTargetConfirmations = targetConfirmations.reversed.toList();
      if (trimmedTargetConfirmations.length > 3) {
        var middle = (targetConfirmations.length / 2).floor();
        trimmedTargetConfirmations = [
          targetConfirmations.last,
          targetConfirmations[middle],
          targetConfirmations.first
        ];
      }

      if (widget.swap.isMax) {
        amounts = Map.fromIterable(
          trimmedTargetConfirmations,
          key: (e) => e,
          value: (e) {
            final toSend = widget.swap.amount;
            final boltzFees = Int64(
                    (toSend.toDouble() * widget.swap.policy.percentage / 100)
                        .ceil()) +
                widget.swap.policy.lockup;
            final received = toSend - boltzFees - feeEstimates.fees[e];
            return ReverseSwapAmounts(
              toSend,
              boltzFees,
              feeEstimates.fees[e],
              received,
            );
          },
        );
      } else {
        amounts = Map.fromIterable(
          trimmedTargetConfirmations,
          key: (e) => e,
          value: (e) {
            final received = widget.swap.amount;
            final p = widget.swap.policy.percentage / 100;
            final boltzFees = Int64(
                ((received + feeEstimates.fees[e]).toDouble() * p / (1 - p) +
                        widget.swap.policy.lockup.toDouble() / (1 - p))
                    .ceil());
            final toSend = received + boltzFees + feeEstimates.fees[e];

            return ReverseSwapAmounts(
              toSend,
              boltzFees,
              feeEstimates.fees[e],
              received,
            );
          },
        );
      }
      feeOptions = trimmedTargetConfirmations
          .map((e) => FeeOption(feeEstimates.fees[e].toInt(), e))
          .where((e) =>
              amounts[e.confirmationTarget].received > 0 &&
              amounts[e.confirmationTarget].toSend <= widget.swap.available)
          .toList();

      if (feeOptions.isNotEmpty) {
        setState(() {
          _showConfirm = true;
        });
      }
      selectedFeeIndex = (feeOptions.length / 2).floor();
      while (feeOptions.length < 3) {
        feeOptions.add(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    final rsAmounts =
        (feeOptions != null && feeOptions[selectedFeeIndex] != null)
            ? amounts[feeOptions[selectedFeeIndex].confirmationTarget]
            : null;

    return Scaffold(
      appBar: AppBar(
        leading: backBtn.BackButton(onPressed: () {
          widget.onPrevious();
        }),
        title: Text(texts.reverse_swap_confirmation_speed),
      ),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          AccountModel acc = snapshot.data;
          return FutureBuilder(
            future: _claimFeeFuture,
            builder: (context, snap) {
              if (snap.error != null) {
                //render error
                return _ErrorMessage(
                  message: texts.reverse_swap_confirmation_error_fetch_fee,
                );
              }
              if (snap.connectionState != ConnectionState.done || acc == null) {
                return const SizedBox();
              }

              if (feeOptions.where((f) => f != null).isEmpty) {
                return _ErrorMessage(
                  message: texts.reverse_swap_confirmation_error_funds_fee,
                );
              }

              return Container(
                height: 500.0,
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FeeChooser(
                      economyFee: feeOptions[0],
                      regularFee: feeOptions[1],
                      priorityFee: feeOptions[2],
                      selectedIndex: selectedFeeIndex,
                      onSelect: (index) {
                        setState(() {
                          selectedFeeIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 36.0),
                    buildSummary(
                      context,
                      acc,
                      rsAmounts.toSend,
                      rsAmounts.boltzFees,
                      rsAmounts.received,
                    ),
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
              text: texts.reverse_swap_confirmation_action_confirm,
              onPressed: () {
                log.info("Reverse swap confirmed");
                Navigator.of(context).push(createLoaderRoute(context));
                widget
                    .onFeeConfirmed(
                      widget.swap.claimAddress,
                      rsAmounts.toSend,
                      rsAmounts.boltzFees,
                      rsAmounts.claimFees,
                      rsAmounts.received,
                      widget.swap.policy.feesHash,
                    )
                    .then((_) => Navigator.of(context).pop())
                    .catchError(
                  (error) {
                    log.warning("Reverse swap error", error);
                    Navigator.of(context).pop();
                    promptError(
                      context,
                      null,
                      Text(
                        extractExceptionMessage(error, texts: texts),
                        style: themeData.dialogTheme.contentTextStyle,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget buildSummary(
    BuildContext context,
    AccountModel acc,
    Int64 toSend,
    boltzFees,
    received,
  ) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final minFont = MinFontSize(context);

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
              texts.reverse_swap_confirmation_you_send,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              acc.currency.format(toSend),
              style: TextStyle(color: themeData.colorScheme.error,),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.reverse_swap_confirmation_boltz_fee,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              texts.reverse_swap_confirmation_boltz_fee_value(
                acc.currency.format(boltzFees),
              ),
              style: TextStyle(
                color: themeData.colorScheme.error.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.reverse_swap_confirmation_transaction_fee,
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              texts.reverse_swap_confirmation_transaction_fee_value(
                acc.currency.format(Int64(feeOptions[selectedFeeIndex].sats)),
              ),
              style: TextStyle(
                color: themeData.colorScheme.error.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.reverse_swap_confirmation_you_receive,
              style: const TextStyle(
                color: Colors.white,
              ),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              acc.fiatCurrency == null
                  ? texts.reverse_swap_confirmation_received_no_fiat(
                      acc.currency.format(received),
                    )
                  : texts.reverse_swap_confirmation_received_with_fiat(
                      acc.currency.format(received),
                      acc.fiatCurrency.format(received),
                    ),
              style: TextStyle(
                color: themeData.colorScheme.error,
              ),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
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

class ReverseSwapAmounts {
  final Int64 toSend;
  final Int64 boltzFees;
  final Int64 claimFees;
  final Int64 received;

  const ReverseSwapAmounts(
    this.toSend,
    this.boltzFees,
    this.claimFees,
    this.received,
  );
}
