import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/payment_options/payment_options_actions.dart';
import 'package:breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentOptionsPage extends StatelessWidget {
  final _baseFeeController = TextEditingController();
  final _proportionalFeeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final paymentOptions = AppBlocsProvider.of<PaymentOptionsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        automaticallyImplyLeading: false,
        leading: backBtn.BackButton(),
        title: Text(
          texts.payment_options_title,
          style: themeData.appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: StreamBuilder<bool>(
        stream: paymentOptions.paymentOptionsFeeEnabledStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final overrideFee = snapshot.data;

          return StreamBuilder<double>(
            stream: paymentOptions.paymentOptionsProportionalFeeStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              final proportionalFee = snapshot.data.toStringAsFixed(2);
              if (_proportionalFeeController.text.isEmpty) {
                _proportionalFeeController.text = proportionalFee;
              }

              return StreamBuilder<int>(
                stream: paymentOptions.paymentOptionsBaseFeeStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  final baseFee = snapshot.data.toString();
                  if (_baseFeeController.text.isEmpty) {
                    _baseFeeController.text = baseFee;
                  }

                  return _body(context, overrideFee);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _body(
    BuildContext context,
    bool overrideFee,
  ) {
    return Column(
      children: [
        _headerFee(context, overrideFee),
        _overrideFee(context, overrideFee),
        _baseFee(context, overrideFee),
        _proportionalFee(context, overrideFee),
        _actionsFee(context, overrideFee),
      ],
    );
  }

  Widget _headerFee(
    BuildContext context,
    bool overrideFee,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              texts.payment_options_fee_header,
              style: themeData.primaryTextTheme.headline3.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _overrideFee(
    BuildContext context,
    bool overrideFee,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final paymentOptions = AppBlocsProvider.of<PaymentOptionsBloc>(context);

    return CheckboxListTile(
      activeColor: Colors.white,
      checkColor: themeData.canvasColor,
      controlAffinity: ListTileControlAffinity.leading,
      value: overrideFee,
      onChanged: (value) {
        paymentOptions.actionsSink.add(OverridePaymentFee(value));
      },
      title: Text(
        texts.payment_options_fee_override_enable,
        style: themeData.primaryTextTheme.headline3.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _baseFee(
    BuildContext context,
    bool overrideFee,
  ) {
    final texts = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: Form(
              child: TextFormField(
                enabled: overrideFee,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _baseFeeController,
                decoration: InputDecoration(
                  labelText: texts.payment_options_base_fee_label,
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return texts.payment_options_base_fee_label;
                  }
                  try {
                    final newBaseFee = int.parse(value);
                    if (newBaseFee < 0) {
                      return texts.payment_options_base_fee_label;
                    }
                  } catch (e) {
                    return texts.payment_options_base_fee_label;
                  }
                  return null;
                },
                onChanged: (value) => _saveBase(context, value),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _proportionalFee(
    BuildContext context,
    bool overrideFee,
  ) {
    final texts = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Form(
              child: TextFormField(
                enabled: overrideFee,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                controller: _proportionalFeeController,
                decoration: InputDecoration(
                  labelText: texts.payment_options_proportional_fee_label,
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return texts.payment_options_proportional_fee_label;
                  }
                  try {
                    final newProportionalFee = double.parse(value);
                    if (newProportionalFee < 0.0) {
                      return texts.payment_options_proportional_fee_label;
                    }
                  } catch (e) {
                    return texts.payment_options_proportional_fee_label;
                  }
                  return null;
                },
                onChanged: (value) => _saveProportional(context, value),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionsFee(
    BuildContext context,
    bool overrideFee,
  ) {
    final texts = AppLocalizations.of(context);
    final paymentOptions = AppBlocsProvider.of<PaymentOptionsBloc>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              primary: Colors.white,
            ),
            child: Text(
              texts.network_restart_action_reset,
            ),
            onPressed: () {
              _proportionalFeeController.text = "";
              _baseFeeController.text = "";
              paymentOptions.actionsSink.add(ResetPaymentFee());
              _closeKeyboard();
            },
          ),
          SizedBox(width: 12.0),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              primary: Colors.white,
            ),
            child: Text(
              texts.network_restart_action_save,
            ),
            onPressed: () {
              _saveProportional(context, _proportionalFeeController.text);
              _saveBase(context, _baseFeeController.text);
              _closeKeyboard();
            },
          ),
        ],
      ),
    );
  }

  void _saveProportional(
    BuildContext context,
    String value,
  ) {
    double newProportionalFee = 0.0;
    try {
      newProportionalFee = double.parse(value);
    } catch (e) {
      return;
    }
    AppBlocsProvider.of<PaymentOptionsBloc>(context)
        .actionsSink
        .add(UpdatePaymentProportionalFee(newProportionalFee));
  }

  void _saveBase(
    BuildContext context,
    String value,
  ) {
    int newBaseFee = 0;
    try {
      newBaseFee = int.parse(value);
    } catch (e) {
      return;
    }
    AppBlocsProvider.of<PaymentOptionsBloc>(context)
        .actionsSink
        .add(UpdatePaymentBaseFee(newBaseFee));
  }

  void _closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
