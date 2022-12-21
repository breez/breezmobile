import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/currency.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/currency_converter_dialog.dart';
import 'package:clovrlabs_wallet/widgets/sat_amount_form_field_formatter.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AmountFormField extends TextFormField {
  final AccountModel accountModel;
  final String Function(Int64 amount) validatorFn;
  final AppLocalizations texts;

  AmountFormField({
    this.accountModel,
    this.validatorFn,
    this.texts,
    BuildContext context,
    Color iconColor,
    Function(String amount) returnFN,
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
    bool readOnly,
  }) : super(
          focusNode: focusNode,
          keyboardType: TextInputType.numberWithOptions(
            decimal: accountModel.currency != Currency.SAT,
          ),
          decoration: InputDecoration(
            labelText: texts.amount_form_denomination(
              accountModel.currency.displayName,
            ),
            suffixIcon: (readOnly ?? false)
                ? null
                : IconButton(
                    icon: Image.asset(
                      (accountModel.fiatCurrency != null)
                          ? accountModel.fiatCurrency.logoPath
                          : "src/icon/btc_convert.png",
                      color: iconColor != null
                          ? iconColor
                          : theme.ClovrLabsWalletColors.white[500],
                    ),
                    padding: EdgeInsets.only(top: 21.0),
                    alignment: Alignment.bottomRight,
                  ),
          ),
          style: style,
          enabled: enabled,
          controller: controller,
          inputFormatters: accountModel.currency != Currency.SAT
              ? [FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))]
              : [SatAmountFormFieldFormatter()],
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          onChanged: onChanged,
          readOnly: readOnly ?? false,
        );

  @override
  FormFieldValidator<String> get validator {
    return (value) {
      if (value.isEmpty) {
        return texts.amount_form_insert_hint(
          accountModel.currency.displayName,
        );
      }
      try {
        Int64 intAmount = accountModel.currency.parse(value);
        if (intAmount <= 0) {
          return texts.amount_form_error_invalid_amount;
        }
        String msg;
        if (validatorFn != null) {
          msg = validatorFn(intAmount);
        }
        return msg;
      } catch (err) {
        return texts.amount_form_error_invalid_amount;
      }
    };
  }
}
