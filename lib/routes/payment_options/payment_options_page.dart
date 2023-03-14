import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/payment_options/payment_options_actions.dart';
import 'package:breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class PaymentOptionsPage extends StatefulWidget {
  const PaymentOptionsPage({
    Key key,
  }) : super(key: key);

  @override
  State<PaymentOptionsPage> createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  final _baseFeeController = TextEditingController();
  final _proportionalFeeController = TextEditingController();

  bool _loadingOverride = false;
  bool _overriding = false;
  bool _loadingBaseFee = false;
  int _baseFee = 0;
  bool _loadingProportionalFee = false;
  double _proportionalFee = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final options = AppBlocsProvider.of<PaymentOptionsBloc>(context);
    options.paymentOptionsFeeEnabledStream.listen((overriding) {
      setState(() {
        _loadingOverride = false;
        _overriding = overriding;
      });
    });

    options.paymentOptionsProportionalFeeStream.listen((proportionalFee) {
      final proportionalFeeText = proportionalFee.toStringAsFixed(2);
      _proportionalFeeController.text = proportionalFeeText;

      setState(() {
        _loadingProportionalFee = false;
        _proportionalFee = proportionalFee;
      });
    });

    options.paymentOptionsBaseFeeStream.listen((baseFee) {
      final baseFeeText = baseFee.toString();
      _baseFeeController.text = baseFeeText;

      setState(() {
        _loadingBaseFee = false;
        _baseFee = baseFee;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const backBtn.BackButton(),
        title: Text(texts.payment_options_title),
      ),
      body: (_loadingOverride || _loadingBaseFee || _loadingProportionalFee)
          ? Container()
          : _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerFee(context),
          _overrideFee(context),
          _baseFeeWidget(context),
          _proportionalFeeWidget(context),
          _actionsFee(context),
          _warningBox(context),
        ],
      ),
    );
  }

  Widget _headerFee(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              texts.payment_options_fee_header,
              style: themeData.primaryTextTheme.displaySmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _overrideFee(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return CheckboxListTile(
      activeColor: Colors.white,
      checkColor: themeData.canvasColor,
      controlAffinity: ListTileControlAffinity.leading,
      value: _overriding,
      onChanged: (value) => setState(() => _overriding = value),
      title: Text(
        texts.payment_options_fee_override_enable,
        style: themeData.primaryTextTheme.displaySmall.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _baseFeeWidget(BuildContext context) {
    final texts = context.texts();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: Form(
              child: TextFormField(
                enabled: _overriding,
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _baseFeeController,
                decoration: InputDecoration(
                  labelText: texts.payment_options_base_fee_label,
                  border: const UnderlineInputBorder(),
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

  Widget _proportionalFeeWidget(BuildContext context) {
    final texts = context.texts();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Form(
              child: TextFormField(
                enabled: _overriding,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                controller: _proportionalFeeController,
                decoration: InputDecoration(
                  labelText: texts.payment_options_proportional_fee_label,
                  border: const UnderlineInputBorder(),
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

  Widget _actionsFee(BuildContext context) {
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            child: Text(
              texts.payment_options_fee_action_reset,
            ),
            onPressed: () => _reset(context),
          ),
          const SizedBox(width: 12.0),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            child: Text(
              texts.payment_options_fee_action_save,
            ),
            onPressed: () {
              if (_overriding) {
                showDialog(
                  context: context,
                  builder: (context) => _saveDialog(context),
                );
              } else {
                _save(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _saveDialog(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return AlertDialog(
      title: Text(
        texts.payment_options_fee_warning_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      content: Text(
        texts.payment_options_fee_warning_dialog_message,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      actions: [
        TextButton(
          child: Text(
            texts.payment_options_fee_action_cancel,
            style: themeData.primaryTextTheme.labelLarge,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(
            texts.payment_options_fee_action_save,
            style: themeData.primaryTextTheme.labelLarge,
          ),
          onPressed: () {
            _save(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _warningBox(BuildContext context) {
    final texts = context.texts();
    return WarningBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texts.payment_options_fee_warning,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _saveProportional(BuildContext context,
      String value) {
    double newProportionalFee = 0.0;
    try {
      newProportionalFee = double.parse(value);
    } catch (e) {
      return;
    }
    setState(() {
      _proportionalFee = newProportionalFee;
    });
  }

  void _saveBase(BuildContext context,
      String value) {
    int newBaseFee = 0;
    try {
      newBaseFee = int.parse(value);
    } catch (e) {
      return;
    }
    setState(() {
      _baseFee = newBaseFee;
    });
  }

  void _closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _reset(BuildContext context) {
    final paymentOptions = AppBlocsProvider.of<PaymentOptionsBloc>(context);
    _proportionalFeeController.text = "";
    _baseFeeController.text = "";
    paymentOptions.actionsSink.add(ResetPaymentFee());
    _closeKeyboard();
  }

  void _save(BuildContext context) async {
    _saveProportional(context, _proportionalFeeController.text);
    _saveBase(context, _baseFeeController.text);
    _closeKeyboard();

    final options = AppBlocsProvider.of<PaymentOptionsBloc>(context);
    var updatePaymentProportionalFeeAction =
        UpdatePaymentProportionalFee(_proportionalFee);
    var updatePaymentBaseFeeAction = UpdatePaymentBaseFee(_baseFee);
    final overridePaymentFeeAction = OverridePaymentFee(_overriding);
    options.actionsSink.add(updatePaymentProportionalFeeAction);
    options.actionsSink.add(updatePaymentBaseFeeAction);
    options.actionsSink.add(overridePaymentFeeAction);
    Future.wait([
      updatePaymentProportionalFeeAction.future,
      updatePaymentBaseFeeAction.future,
      overridePaymentFeeAction.future
    ]).whenComplete(() {
      final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
      backupBloc.backupAppDataSink.add(true);
    });
  }
}
