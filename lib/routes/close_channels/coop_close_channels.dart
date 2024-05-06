import 'package:breez/routes/close_channels/coop_close_channels_dialog.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/btc_address.dart';
import 'package:breez/utils/exceptions.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger("CoopCloseChannelsPage");

class CoopCloseChannelsPage extends StatefulWidget {
  const CoopCloseChannelsPage({Key key}) : super(key: key);

  @override
  State<CoopCloseChannelsPage> createState() => _CoopCloseChannelsPageState();
}

class _CoopCloseChannelsPageState extends State<CoopCloseChannelsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final _addressFocusNode = FocusNode();

  String _scannerErrorMessage = "";
  String _addressValidated;
  KeyboardDoneAction _doneAction;

  BreezBridge _breezLib;

  @override
  void initState() {
    super.initState();
    _breezLib = ServiceInjector().breezBridge;
    _doneAction = KeyboardDoneAction([_addressFocusNode]);
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.close_channels_title),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    focusNode: _addressFocusNode,
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: texts.close_channels_btc_address,
                      suffixIcon: IconButton(
                        padding: const EdgeInsets.only(top: 21.0),
                        alignment: Alignment.bottomRight,
                        icon: Image(
                          image: const AssetImage("src/icon/qr_scan.png"),
                          color: theme.BreezColors.white[500],
                          fit: BoxFit.contain,
                          width: 24.0,
                          height: 24.0,
                        ),
                        tooltip: texts.close_channels_scan_barcode,
                        onPressed: () => _scanBarcode(),
                      ),
                    ),
                    style: theme.FieldTextStyle.textStyle,
                    validator: (value) {
                      if (_addressValidated == null) {
                        _log.info("Invalid address");
                        return texts.withdraw_funds_error_invalid_address;
                      }
                      return null;
                    },
                  ),
                  _scannerErrorMessage.isNotEmpty
                      ? Text(
                          _scannerErrorMessage,
                          style: theme.validatorStyle,
                        )
                      : const SizedBox(),
                  WarningBox(
                    boxPadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          texts.close_channels_warning_message,
                          style: themeData.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: SingleButtonBottomBar(
          stickToBottom: true,
          text: texts.close_channels_action_next,
          onPressed: () => _onNext(),
        ),
      ),
    );
  }

  Future _scanBarcode() async {
    _log.info("Scanning barcode");
    final texts = context.texts();
    FocusScope.of(context).requestFocus(FocusNode());
    await Navigator.pushNamed<String>(context, "/qr_scan").then((barcode) {
      if (barcode.isEmpty) {
        _log.info("Received an empty barcode");
        showFlushbar(
          context,
          message: texts.close_channels_qr_code_not_detected,
        );
        return;
      } else {
        _log.info("Barcode: $barcode");
      }

      BTCAddressInfo btcInvoice = parseBTCAddress(barcode);
      setState(() {
        _addressController.text = btcInvoice.address;
        _scannerErrorMessage = "";
      });
      _asyncValidate();
    }, onError: (error) {
      _log.warning("Scanning barcode error", error);
      setState(() {
        _scannerErrorMessage = error.toString();
      });
    });
  }

  Future<bool> _asyncValidate() {
    _log.info("Validating address: ${_addressController.text}");
    return _breezLib.validateAddress(_addressController.text).then((data) {
      _log.info("Address validated: $data");
      _addressValidated = data;
      return _formKey.currentState.validate();
    }).catchError((err) {
      _log.warning("Validating address error", err);
      _addressValidated = null;
      return _formKey.currentState.validate();
    });
  }

  void _onNext() {
    _asyncValidate().then((validated) async {
      if (validated) {
        final texts = context.texts();
        final themeData = Theme.of(context);

        _formKey.currentState.save();
        var validatedAddress = _addressController.text;
        FocusScope.of(context).requestFocus(FocusNode());
        promptAreYouSure(
          context,
          texts.close_channels_title,
          RichText(
            text: TextSpan(
              style: themeData.dialogTheme.contentTextStyle,
              text: "${texts.close_channels_confirmation_dialog_message}?\n\n",
              children: [
                TextSpan(
                  text: validatedAddress,
                  style: themeData.dialogTheme.contentTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          okText: texts.close_channels_confirmation_dialog_action_yes,
          cancelText: texts.close_channels_confirmation_dialog_action_no,
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        ).then((ok) async {
          if (ok) {
            await showDialog(
              useRootNavigator: false,
              context: context,
              barrierDismissible: false,
              builder: (_) => CoopCloseChannelsDialog(
                closingAddress: validatedAddress,
              ),
            );
          }
        });
      }
    }).catchError((error) {
      _log.warning("onNext error", error);
      promptError(
        context,
        null,
        Text(
          extractExceptionMessage(error),
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
      );
    }).whenComplete(() {
      _log.info("onNext done");
    });
  }
}
