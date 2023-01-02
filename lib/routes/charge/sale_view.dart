import 'dart:async';

import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/actions.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/bloc.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/currency.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/routes/charge/currency_wrapper.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/utils/date.dart';
import 'package:clovrlabs_wallet/utils/print_pdf.dart';
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:clovrlabs_wallet/widgets/payment_details_dialog.dart';
import 'package:clovrlabs_wallet/widgets/print_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import 'items/item_avatar.dart';

class SaleView extends StatefulWidget {
  final CurrencyWrapper saleCurrency;
  final Function() onDeleteSale;
  final VoidCallback onCharge;
  final PaymentInfo salePayment;
  final Sale readOnlySale;

  const SaleView({
    Key key,
    this.saleCurrency,
    this.onDeleteSale,
    this.onCharge,
    this.salePayment,
    this.readOnlySale,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SaleViewState();
  }

  bool get readOnly => readOnlySale != null;
}

class SaleViewState extends State<SaleView> {
  final _scrollController = ScrollController();
  final _noteController = TextEditingController();
  final _noteFocus = FocusNode();

  StreamSubscription<Sale> _currentSaleSubscription;
  Sale saleInProgress;

  Sale get currentSale => widget.readOnlySale ?? saleInProgress;

  @override
  void didChangeDependencies() {
    if (_currentSaleSubscription == null) {
      if (!widget.readOnly) {
        final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
        _currentSaleSubscription =
            posCatalogBloc.currentSaleStream.listen((sale) {
          setState(() {
            bool updateNote = saleInProgress == null;
            saleInProgress = sale;
            if (updateNote) {
              _noteController.text = sale.note;
            }
          });
        });

        _noteController.addListener(() {
          posCatalogBloc.actionsSink.add(SetCurrentSale(saleInProgress.copyWith(
            note: _noteController.text,
          )));
        });
      } else {
        _noteController.text = widget.readOnlySale.note;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _currentSaleSubscription?.cancel();
    super.dispose();
  }

  bool get showNote =>
      !widget.readOnly || widget.readOnlySale.note?.isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, accSnapshot) {
        var accModel = accSnapshot.data;
        if (accModel == null) {
          return Loader();
        }

        CurrencyWrapper saleCurrency =
            widget.saleCurrency ?? CurrencyWrapper.fromBTC(Currency.SAT);
        String title = texts.sale_view_title;
        if (widget.salePayment != null) {
          title = BreezDateUtils.formatYearMonthDayHourMinute(
            DateTime.fromMillisecondsSinceEpoch(
              widget.salePayment.creationTimestamp.toInt() * 1000,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            iconTheme: themeData.appBarTheme.iconTheme,
            textTheme: themeData.appBarTheme.textTheme,
            backgroundColor: themeData.canvasColor,
            leading: backBtn.BackButton(),
            title: Text(
              title,
              // style: themeData.appBarTheme.textTheme.headline6,
            ),
            actions: widget.readOnly
                ? _buildPrintIcon(context, accModel)
                : [
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: themeData.iconTheme.color,
                      ),
                      onPressed: () {
                        widget.onDeleteSale();
                      },
                    ),
                  ],
            elevation: 0.0,
          ),
          extendBody: false,
          backgroundColor: themeData.backgroundColor,
          body: GestureDetector(
            onTap: () {
              final currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _note(context),
                    Expanded(
                      child: SaleLinesList(
                        saleCurrency: saleCurrency,
                        readOnly: widget.readOnly,
                        scrollController: _scrollController,
                        accountModel: accModel,
                        currentSale: currentSale,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: theme.themeId == "WHITE"
                  ? themeData.backgroundColor
                  : themeData.canvasColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0.5, 0.5),
                  blurRadius: 5.0,
                ),
                BoxShadow(
                  color: themeData.backgroundColor,
                )
              ],
            ),
            //color: Theme.of(context).canvasColor,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Container(
                child: _TotalSaleCharge(
                  salePayment: widget.salePayment,
                  onCharge: widget.onCharge,
                  accountModel: accModel,
                  currentSale: currentSale,
                  saleCurrency: saleCurrency,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _note(BuildContext context) {
    if (!showNote) return SizedBox();

    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Container(
      color: themeData.canvasColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: TextField(
          enabled: !widget.readOnly,
          keyboardType: TextInputType.multiline,
          maxLength: 90,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            _noteFocus.requestFocus();
          },
          buildCounter: (
            BuildContext ctx, {
            int currentLength,
            bool isFocused,
            int maxLength,
          }) {
            return SizedBox();
          },
          controller: _noteController,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Color(0xFFc5cedd),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Color(0xFFc5cedd),
              ),
            ),
            hintText: texts.sale_view_note_hint,
            hintStyle: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPrintIcon(
    BuildContext context,
    AccountModel account,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return [
      StreamBuilder<ClovrUserModel>(
        stream: userBloc.userStream,
        builder: (context, snapshot) {
          var user = snapshot.data;
          if (user == null) {
            return Loader();
          }
          return Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              alignment: Alignment.center,
              tooltip: texts.sale_view_print,
              iconSize: 24.0,
              color: themeData.iconTheme.color,
              icon: SvgPicture.asset(
                "src/icon/printer.svg",
                color: Colors.white,
                fit: BoxFit.contain,
                width: 24.0,
                height: 24.0,
              ),
              onPressed: () => PrintService(
                PrintParameters(
                  currentUser: user,
                  account: account,
                  submittedSale: widget.readOnlySale,
                  paymentInfo: widget.salePayment,
                ),
              ).printAsPDF(context),
            ),
          );
        },
      )
    ];
  }
}

class _TotalSaleCharge extends StatelessWidget {
  final AccountModel accountModel;
  final Sale currentSale;
  final CurrencyWrapper saleCurrency;
  final VoidCallback onCharge;
  final PaymentInfo salePayment;

  const _TotalSaleCharge({
    Key key,
    this.accountModel,
    this.currentSale,
    this.onCharge,
    this.salePayment,
    this.saleCurrency,
  }) : super(key: key);

  bool get readOnly => salePayment != null;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: themeData.primaryColorLight,
        padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
      ),
      child: Text(
        _title(context),
        maxLines: 1,
        textAlign: TextAlign.center,
        style: theme.invoiceChargeAmountStyle,
      ),
      onPressed: () {
        if (readOnly) {
          showPaymentDetailsDialog(context, salePayment);
        } else {
          onCharge();
        }
      },
    );
  }

  String _title(BuildContext context) {
    final texts = AppLocalizations.of(context);

    final totalAmountInSats = currentSale.totalAmountInSats;
    final totalAmountInFiat = currentSale.totalAmountInFiat;

    final satCurrency = CurrencyWrapper.fromBTC(Currency.SAT);
    final satMessage = (satCurrency.format(
              totalAmountInSats,
              removeTrailingZeros: true,
            ) +
            " " +
            satCurrency.shortName)
        .toUpperCase();

    if (totalAmountInFiat.length == 1) {
      final currency = totalAmountInFiat.entries.first.key;
      final total = totalAmountInFiat.entries.first.value;
      if (currency != satCurrency.shortName) {
        CurrencyWrapper saleCurrency = CurrencyWrapper.fromShortName(
          currency,
          accountModel,
        );
        final fiatValue = saleCurrency
            .format(
              total,
              removeTrailingZeros: true,
              includeCurrencySymbol: true,
            )
            .toUpperCase();
        return readOnly
            ? texts.sale_view_total_title_read_only_fiat(satMessage, fiatValue)
            : texts.sale_view_total_title_charge_fiat(satMessage, fiatValue);
      }
    }
    return readOnly
        ? texts.sale_view_total_title_read_only_no_fiat(satMessage)
        : texts.sale_view_total_title_charge_no_fiat(satMessage);
  }
}

class SaleLinesList extends StatelessWidget {
  final Sale currentSale;
  final CurrencyWrapper saleCurrency;
  final AccountModel accountModel;
  final ScrollController scrollController;
  final bool readOnly;

  const SaleLinesList({
    Key key,
    this.currentSale,
    this.accountModel,
    this.scrollController,
    this.readOnly,
    this.saleCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);

    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: currentSale.saleLines.length,
        shrinkWrap: true,
        controller: scrollController,
        //primary: false,
        itemBuilder: (context, index) {
          return ListTileTheme(
            textColor: theme.themeId == "WHITE"
                ? themeData.canvasColor
                : themeData.textTheme.subtitle1.color,
            iconColor: theme.themeId == "WHITE"
                ? themeData.canvasColor
                : themeData.textTheme.subtitle1.color,
            child: Column(
              children: [
                SaleLineWidget(
                  saleCurrency: saleCurrency,
                  onDelete: readOnly
                      ? null
                      : () => posCatalogBloc.actionsSink.add(
                            SetCurrentSale(
                              currentSale.copyWith(
                                saleLines: currentSale.saleLines
                                  ..removeAt(index),
                              ),
                            ),
                          ),
                  onChangeQuantity: readOnly
                      ? null
                      : (int delta) {
                          var saleLines = currentSale.saleLines.toList();
                          var saleLine = currentSale.saleLines[index];
                          var newQuantity = saleLine.quantity + delta;
                          if (saleLine.quantity == 0) {
                            saleLines.removeAt(index);
                          } else {
                            saleLines = saleLines.map((sl) {
                              if (sl != saleLine) {
                                return sl;
                              }
                              return sl.copyWith(quantity: newQuantity);
                            }).toList();
                          }
                          var newSale = currentSale.copyWith(
                            saleLines: saleLines,
                          );
                          posCatalogBloc.actionsSink.add(
                            SetCurrentSale(newSale),
                          );
                        },
                  accountModel: accountModel,
                  saleLine: currentSale.saleLines[index],
                ),
                Divider(
                  height: 0.0,
                  color: index == currentSale.saleLines.length - 1
                      ? Colors.white.withOpacity(0.0)
                      : (theme.themeId == "WHITE"
                              ? themeData.canvasColor
                              : themeData.textTheme.subtitle1.color)
                          .withOpacity(0.5),
                  indent: 72.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SaleLineWidget extends StatelessWidget {
  final CurrencyWrapper saleCurrency;
  final SaleLine saleLine;
  final AccountModel accountModel;
  final Function(int delta) onChangeQuantity;
  final Function() onDelete;

  const SaleLineWidget({
    Key key,
    this.saleLine,
    this.accountModel,
    this.onChangeQuantity,
    this.onDelete,
    this.saleCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listTileThemeData = ListTileTheme.of(context);
    final iconColor = theme.themeId == "WHITE"
        ? Colors.black.withOpacity(0.3)
        : listTileThemeData.iconColor.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: ListTile(
        leading: ItemAvatar(
          saleLine.itemImageURL,
          itemName: saleLine.itemName,
        ),
        title: Text(
          saleLine.itemName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: CurrencyDisplay(
          currency: CurrencyWrapper.fromShortName(
            saleLine.currency,
            accountModel,
          ),
          saleLine: saleLine,
          saleCurrency: saleCurrency,
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            onChangeQuantity == null
                ? SizedBox()
                : IconButton(
                    iconSize: 22.0,
                    color: iconColor,
                    icon: Icon(Icons.add, color: Colors.white,),
                    onPressed: () => onChangeQuantity(1),
                  ),
            Container(
              width: 40.0,
              child: Center(
                child: Text(
                  saleLine.quantity.toString(),
                  style: TextStyle(
                    color: theme.themeId == "WHITE"
                        ? Colors.black.withOpacity(0.7)
                        : listTileThemeData.textColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            onDelete == null
                ? SizedBox()
                : IconButton(
                    iconSize: 22.0,
                    color: iconColor,
                    icon: Icon(

                      saleLine.quantity == 1
                          ? Icons.delete_outline
                          : Icons.remove,
                      color: Colors.white,
                    ),
                    onPressed: () => saleLine.quantity == 1
                        ? onDelete()
                        : onChangeQuantity(-1),
                  ),
          ],
        ),
      ),
    );
  }
}

class CurrencyDisplay extends StatelessWidget {
  final CurrencyWrapper currency;
  final SaleLine saleLine;
  final CurrencyWrapper saleCurrency;

  const CurrencyDisplay({
    Key key,
    @required this.currency,
    @required this.saleLine,
    @required this.saleCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double priceInFiat = saleLine.totalFiat;
    double priceInSats = saleLine.totalSats;
    TextStyle textStyle = TextStyle(
      color: ListTileTheme.of(context)
          .textColor
          .withOpacity(theme.themeId == "WHITE" ? 0.75 : 0.5),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisSize: MainAxisSize.min,
        children: [
          CurrencyText(
            text: currency.format(
              priceInFiat,
              includeCurrencySymbol: true,
              removeTrailingZeros: true,
            ),
            currency: currency,
            style: textStyle,
          ),
          CurrencyText(
            text: _priceInSaleCurrency(priceInSats),
            currency: saleCurrency,
            style: textStyle,
          ),
        ],
      ),
    );
  }

  String _priceInSaleCurrency(double priceInSats) {
    if (saleCurrency.symbol != currency.symbol) {
      String salePrice = saleCurrency.format(
        priceInSats / saleCurrency.satConversionRate,
        includeCurrencySymbol: true,
        removeTrailingZeros: true,
      );
      return saleCurrency.rtl ? "($salePrice) " : " ($salePrice)";
    }
    return "";
  }
}

class CurrencyText extends StatelessWidget {
  const CurrencyText({
    Key key,
    @required this.text,
    @required this.currency,
    this.style,
  }) : super(key: key);

  final String text;
  final CurrencyWrapper currency;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      textDirection: currency.rtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: currency.rtl ? TextAlign.end : TextAlign.start,
      style: style ?? DefaultTextStyle.of(context).style,
    );
  }
}
