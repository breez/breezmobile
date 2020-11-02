import 'dart:math';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double ITEM_HEIGHT = 72.0;

class FiatCurrencySettings extends StatefulWidget {
  final AccountBloc accountBloc;
  final UserProfileBloc userProfileBloc;

  FiatCurrencySettings(this.accountBloc, this.userProfileBloc);

  @override
  FiatCurrencySettingsState createState() {
    return FiatCurrencySettingsState();
  }
}

class FiatCurrencySettingsState extends State<FiatCurrencySettings> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountModel>(
        stream: widget.accountBloc.accountStream.distinct((acc1, acc2) {
      return listEquals(acc1.preferredCurrencies, acc2.preferredCurrencies);
    }), builder: (context, snapshot) {
      AccountModel account = snapshot.data;
      if (!snapshot.hasData) {
        return Container();
      }

      if (account.fiatConversionList.isEmpty || account.fiatCurrency == null) {
        return Loader();
      }
      return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(),
          title: Text(
            "Fiat Currencies",
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0,
        ),
        body: DragAndDropLists(
          listPadding: EdgeInsets.zero,
          children: [
            _buildList(account),
          ],
          scrollController: _scrollController,
          onItemReorder: (from, oldListIndex, to, newListIndex) =>
              _onReorder(account, from, to),
          dragHandle: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.drag_handle, color: theme.BreezColors.white[200]),
          ),
        ),
      );
    });
  }

  DragAndDropList _buildList(AccountModel account) {
    return DragAndDropList(
      header: SizedBox(),
      canDrag: false,
      children: List.generate(
        account.fiatConversionList.length,
        (index) {
          return DragAndDropItem(
              child: _buildFiatCurrencyTile(account, index),
              canDrag: account.preferredCurrencies.contains(
                  account.fiatConversionList[index].currencyData.shortName));
        },
      ),
    );
  }

  _changeFiatCurrency(
      AccountModel account, List<String> preferredFiatCurrencies) {
    for (var i = 0; i < preferredFiatCurrencies.length; i++) {
      if (isAboveMinAmount(account, i)) {
        widget.userProfileBloc.fiatConversionSink
            .add(preferredFiatCurrencies[i]);
        break;
      }
    }
    // revert to first item on list if no fiat value is above minimum amount
    widget.userProfileBloc.fiatConversionSink.add(preferredFiatCurrencies[0]);
  }

  bool isAboveMinAmount(AccountModel accountModel, int index) {
    double fiatValue = accountModel.preferredFiatConversionList[index]
        .satToFiat(accountModel.balance);
    int fractionSize = accountModel
        .preferredFiatConversionList[index].currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    return fiatValue > minimumAmount;
  }

  Widget _buildFiatCurrencyTile(AccountModel account, int index) {
    return CheckboxListTile(
      key: Key("tile-index-$index"),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: Theme.of(context).canvasColor,
      value: account.preferredCurrencies
          .contains(account.fiatConversionList[index].currencyData.shortName),
      onChanged: (bool checked) {
        setState(() {
          if (checked) {
            account.preferredCurrencies
                .add(account.fiatConversionList[index].currencyData.shortName);
            // center item in viewport
            if (_scrollController.offset >=
                (ITEM_HEIGHT * (account.preferredCurrencies.length - 1))) {
              _scrollController.animateTo(
                ((2 * account.preferredCurrencies.length - 1) * ITEM_HEIGHT -
                        _scrollController.position.viewportDimension) /
                    2,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 400),
              );
            }
          } else if (account.preferredFiatConversionList.length != 1) {
            account.preferredCurrencies.remove(
                account.fiatConversionList[index].currencyData.shortName);
          }
          _updatePreferredCurrencies(account, account.preferredCurrencies);
        });
      },
      subtitle: Text(account.fiatConversionList[index].currencyData.name,
          style: theme.fiatConversionDescriptionStyle),
      title: RichText(
        text: TextSpan(
            text: account.fiatConversionList[index].currencyData.shortName,
            style: theme.fiatConversionTitleStyle,
            children: <TextSpan>[
              TextSpan(
                  text:
                      " (${account.fiatConversionList[index].currencyData.symbol})",
                  style: theme.fiatConversionDescriptionStyle),
            ]),
      ),
    );
  }

  void _onReorder(AccountModel account, int oldIndex, int newIndex) {
    List<String> preferredFiatCurrencies =
        List.from(account.preferredCurrencies);
    if (newIndex >= preferredFiatCurrencies.length) {
      newIndex = preferredFiatCurrencies.length - 1;
    }
    String item = preferredFiatCurrencies.removeAt(oldIndex);
    preferredFiatCurrencies.insert(newIndex, item);
    _updatePreferredCurrencies(account, preferredFiatCurrencies);
  }

  void _updatePreferredCurrencies(
      AccountModel account, List<String> preferredFiatCurrencies) {
    var action = UpdatePreferredCurrencies(preferredFiatCurrencies);
    widget.userProfileBloc.userActionsSink.add(action);
    action.future.then((_) {
      _changeFiatCurrency(account, preferredFiatCurrencies);
    }).catchError((err) {
      showFlushbar(context, message: "Failed to save changes.");
    });
  }
}
