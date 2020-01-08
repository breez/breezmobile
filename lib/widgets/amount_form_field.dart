import 'package:breez/bloc/user_profile/currency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:fixnum/fixnum.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/widgets/currency_converter_dialog.dart';
import 'package:breez/theme_data.dart' as theme;

class AmountFormField extends TextFormField {
  final BuildContext context;
  final AccountModel accountModel;
  final Color iconColor;
  final Function(String amount) returnFN;
  final String Function(Int64 amount) validatorFn;

  AmountFormField({
    this.context,
    this.accountModel,
    this.iconColor,
    this.returnFN,
    this.validatorFn,
    TextEditingController controller,
    Key key,
    String initialValue,
    FocusNode focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextStyle style,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    int maxLength,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    bool enabled,
    ValueChanged<String> onChanged,
    bool readOnly
  }) : super(
            focusNode: focusNode,
            keyboardType: TextInputType.numberWithOptions(
                decimal: accountModel.currency != Currency.SAT),
            decoration: InputDecoration(
              labelText: accountModel.currency.displayName + " Amount",
              suffixIcon: IconButton(
                icon: Image.asset(
                  (accountModel.fiatCurrency != null)
                      ? accountModel.fiatCurrency.logoPath
                      : "src/icon/btc_convert.png",
                  color: iconColor != null
                      ? iconColor
                      : theme.BreezColors.white[500],
                ),
                padding: EdgeInsets.only(top: 21.0),
                alignment: Alignment.bottomRight,
                onPressed: () => showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (_) => CurrencyConverterDialog(
                      returnFN != null
                          ? returnFN
                          : (value) => controller.text = value,
                      validatorFn),
                ),
              ),
            ),
            style: style,
            enabled: enabled,
            controller: controller,
            inputFormatters: accountModel.currency != Currency.SAT
                ? [WhitelistingTextInputFormatter(RegExp(r'\d+\.?\d*'))]
                : [WhitelistingTextInputFormatter.digitsOnly],
            onFieldSubmitted: onFieldSubmitted,
            onSaved: onSaved,
            onChanged: onChanged,
            readOnly: readOnly);

  @override
  FormFieldValidator<String> get validator {
    return (value) {
      if (value.isEmpty) {
        return "Please enter the amount in " +
            accountModel.currency.displayName;
      }
      Int64 intAmount = accountModel.currency.parse(value);
      if (intAmount <= 0) {
        return "Invalid amount";
      }
      String msg;
      if (validatorFn != null) {
        msg = validatorFn(intAmount);
      }
      return msg;
    };
  }
}
