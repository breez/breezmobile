import 'dart:math';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/services/currency_data.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double ITEM_HEIGHT = 72.0;

class FiatCurrencySettings extends StatefulWidget {
  final AccountBloc accountBloc;
  final UserProfileBloc userProfileBloc;

  const FiatCurrencySettings(
    this.accountBloc,
    this.userProfileBloc,
  );

  @override
  FiatCurrencySettingsState createState() {
    return FiatCurrencySettingsState();
  }
}

class FiatCurrencySettingsState extends State<FiatCurrencySettings> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.fiat_currencies_title),
      ),
      body: StreamBuilder<AccountModel>(
        stream: widget.accountBloc.accountStream.distinct((acc1, acc2) {
          return listEquals(acc1.preferredCurrencies, acc2.preferredCurrencies);
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final account = snapshot.data;

          if (account.fiatConversionList.isEmpty ||
              account.fiatCurrency == null) {
            return const Center(
              child: Loader(
                color: Colors.white,
              ),
            );
          } else {
            return FutureBuilder(
              future: artificialWait(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: Loader(
                      color: Colors.white,
                    ),
                  );
                }

                return DragAndDropLists(
                  listPadding: EdgeInsets.zero,
                  children: [
                    _buildList(context, account),
                  ],
                  lastListTargetSize: 0,
                  lastItemTargetHeight: 8,
                  scrollController: _scrollController,
                  onListReorder: (oldListIndex, newListIndex) => {},
                  onItemReorder: (from, oldListIndex, to, newListIndex) =>
                      _onReorder(
                    context,
                    account,
                    from,
                    to,
                  ),
                  itemDragHandle: DragHandle(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.drag_handle,
                        color: theme.BreezColors.white[200],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  DragAndDropList _buildList(
    BuildContext context,
    AccountModel account,
  ) {
    return DragAndDropList(
      header: const SizedBox(),
      canDrag: false,
      children: List.generate(account.fiatConversionList.length, (index) {
        return DragAndDropItem(
          child: _buildFiatCurrencyTile(context, account, index),
          canDrag: account.preferredCurrencies.contains(
            account.fiatConversionList[index].currencyData.shortName,
          ),
        );
      }),
    );
  }

  void _changeFiatCurrency(
    AccountModel account,
    List<String> preferredFiatCurrencies,
  ) {
    for (var i = 0; i < preferredFiatCurrencies.length; i++) {
      if (isAboveMinAmount(account, i)) {
        widget.userProfileBloc.fiatConversionSink
            .add(preferredFiatCurrencies[i]);
        break;
      }
    }
    // revert to first item on list if no fiat value is above minimum amount
    widget.userProfileBloc.fiatConversionSink.add(preferredFiatCurrencies[0]);
    // reset pos currency to BTC if it's no longer in preferredFiatCurrencies
    if (!preferredFiatCurrencies.contains(account.posCurrencyShortName)) {
      widget.userProfileBloc.userActionsSink.add(SetPOSCurrency("BTC"));
    }
  }

  bool isAboveMinAmount(AccountModel accountModel, int index) {
    final conversions = accountModel.preferredFiatConversionList[index];
    final fiatValue = conversions.satToFiat(accountModel.balance);
    final fractionSize = conversions.currencyData.fractionSize;
    final minimumAmount = 1 / (pow(10, fractionSize));
    return fiatValue > minimumAmount;
  }

  Widget _buildFiatCurrencyTile(
    BuildContext context,
    AccountModel account,
    int index,
  ) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final fiatConversion = account.fiatConversionList[index];
    final currencyData = fiatConversion.currencyData;
    final prefCurrencies = account.preferredCurrencies;

    return CheckboxListTile(
      key: Key("tile-index-$index"),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: themeData.canvasColor,
      value: prefCurrencies.contains(currencyData.shortName),
      onChanged: (bool checked) {
        setState(() {
          if (checked) {
            prefCurrencies.add(currencyData.shortName);
            // center item in viewport
            if (_scrollController.offset >=
                (ITEM_HEIGHT * (prefCurrencies.length - 1))) {
              _scrollController.animateTo(
                ((2 * prefCurrencies.length - 1) * ITEM_HEIGHT -
                        _scrollController.position.viewportDimension) /
                    2,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 400),
              );
            }
          } else if (account.preferredFiatConversionList.length != 1) {
            prefCurrencies.remove(
              currencyData.shortName,
            );
          }
          _updatePreferredCurrencies(context, account, prefCurrencies);
        });
      },
      subtitle: Text(
        _subtitle(texts, currencyData),
        style: theme.fiatConversionDescriptionStyle,
      ),
      title: RichText(
        text: TextSpan(
          text: currencyData.shortName,
          style: theme.fiatConversionTitleStyle,
          children: [
            TextSpan(
              text: " (${currencyData.symbol})",
              style: theme.fiatConversionDescriptionStyle,
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle(BreezTranslations texts, CurrencyData currencyData) {
    final localizedName = currencyData.localizedName[texts.locale];
    return localizedName ?? currencyData.name;
  }

  void _onReorder(
    BuildContext context,
    AccountModel account,
    int oldIndex,
    int newIndex,
  ) {
    final preferredFiatCurrencies = List<String>.from(
      account.preferredCurrencies,
    );
    if (newIndex >= preferredFiatCurrencies.length) {
      newIndex = preferredFiatCurrencies.length - 1;
    }
    String item = preferredFiatCurrencies.removeAt(oldIndex);
    preferredFiatCurrencies.insert(newIndex, item);
    _updatePreferredCurrencies(context, account, preferredFiatCurrencies);
  }

  void _updatePreferredCurrencies(
    BuildContext context,
    AccountModel account,
    List<String> preferredFiatCurrencies,
  ) {
    final texts = context.texts();
    var action = UpdatePreferredCurrencies(preferredFiatCurrencies);
    widget.userProfileBloc.userActionsSink.add(action);
    action.future.then((_) {
      _changeFiatCurrency(account, preferredFiatCurrencies);
    }).catchError((err) {
      showFlushbar(context, message: texts.fiat_currencies_save_fail);
    });
  }

  /// DragAndDropLists has a performance issue with displaying a big list
  /// and blocks the UI thread. Since data retrieval is not the bottleneck, it
  /// blocks the UI thread almost immediately on the screen navigating to this page.
  /// Before the underlying performance issues are fixed on the library.
  /// We've added an artificial wait to display the page route animation and spinnig
  /// loader before UI thread is blocked to convey a better UX as a workaround.
  Future artificialWait() async {
    return await Future.delayed(const Duration(milliseconds: 800));
  }
}
