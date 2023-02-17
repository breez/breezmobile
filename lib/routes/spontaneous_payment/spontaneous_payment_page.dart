import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/collapsible_list_item.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/processing_payment_dialog.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class SpontaneousPaymentPage extends StatefulWidget {
  final String nodeID;
  final GlobalKey firstPaymentItemKey;

  const SpontaneousPaymentPage(
    this.nodeID,
    this.firstPaymentItemKey,
  );

  @override
  State<StatefulWidget> createState() {
    return SpontaneousPaymentPageState();
  }
}

class SpontaneousPaymentPageState extends State<SpontaneousPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;
  ModalRoute _currentRoute;

  @override
  void initState() {
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
    Future.delayed(
      const Duration(milliseconds: 200),
      () => FocusScope.of(context).requestFocus(_amountFocusNode),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return Scaffold(
      bottomNavigationBar: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          var account = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: SingleButtonBottomBar(
              stickToBottom: true,
              text: texts.spontaneous_payment_action_pay,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _sendPayment(context, accountBloc, account);
                }
              },
            ),
          );
        },
      ),
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.spontaneous_payment_title),
      ),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          AccountModel acc = snapshot.data;
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
              child: ListView(
                children: [
                  _buildNodeIdDescription(context),
                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    maxLength: 90,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      labelText: texts.spontaneous_payment_tip_message,
                    ),
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  AmountFormField(
                    context: context,
                    texts: texts,
                    accountModel: acc,
                    focusNode: _amountFocusNode,
                    controller: _amountController,
                    validatorFn: acc.validateOutgoingPayment,
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildPayableBTC(context, acc),
                  ),
                  StreamBuilder(
                    stream: accountBloc.accountStream,
                    builder: (context, accSnapshot) {
                      if (!accSnapshot.hasData) {
                        return Container();
                      }
                      AccountModel acc = accSnapshot.data;

                      String message;
                      if (accSnapshot.hasError) {
                        message = accSnapshot.error.toString();
                      } else if (acc.processingConnection) {
                        message = texts.spontaneous_payment_generic_message;
                      }

                      if (message != null) {
                        return Container(
                          padding: const EdgeInsets.only(
                            top: 50.0,
                            left: 30.0,
                            right: 30.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: theme.warningStyle.copyWith(
                                  color: themeData.colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPayableBTC(BuildContext context, AccountModel acc) {
    final texts = context.texts();
    return GestureDetector(
      child: AutoSizeText(
        texts.spontaneous_payment_max_amount(
          acc.currency.format(acc.maxAllowedToPay),
        ),
        style: theme.textStyle,
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
      ),
      onTap: () => _amountController.text = acc.currency.format(
        acc.maxAllowedToPay,
        includeDisplayName: false,
        userInput: true,
      ),
    );
  }

  Widget _buildNodeIdDescription(BuildContext context) {
    final texts = context.texts();
    return CollapsibleListItem(
      title: texts.spontaneous_payment_node_id,
      sharedValue: widget.nodeID,
      userStyle: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  Future _sendPayment(
    BuildContext context,
    AccountBloc accBloc,
    AccountModel account,
  ) async {
    final texts = context.texts();
    final themeData = Theme.of(context);

    String tipMessage = _descriptionController.text;
    var amount = account.currency.parse(_amountController.text);
    _amountFocusNode.unfocus();
    var ok = await promptAreYouSure(
      context,
      texts.spontaneous_payment_send_payment_title,
      Text(
        texts.spontaneous_payment_send_payment_message(
          account.currency.format(amount),
          widget.nodeID,
        ),
      ),
      okText: texts.spontaneous_payment_action_pay,
      cancelText: texts.spontaneous_payment_action_cancel,
    );
    if (ok) {
      var sendAction = SendSpontaneousPayment(
        widget.nodeID,
        amount,
        tipMessage,
      );
      try {
        showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: false,
          builder: (_) => ProcessingPaymentDialog(
            context,
            () {
              var sendPayment = Future.delayed(
                const Duration(seconds: 1),
                () {
                  accBloc.userActionsSink.add(sendAction);
                  return sendAction.future;
                },
              );

              return sendPayment;
            },
            accBloc,
            widget.firstPaymentItemKey,
            (_) {},
            220,
            popOnCompletion: true,
          ),
        );
        Navigator.of(context).removeRoute(_currentRoute);
        await sendAction.future;
      } catch (err) {
        if (err.runtimeType != PaymentError) {
          promptError(
            context,
            texts.spontaneous_payment_error_title,
            Text(
              err.toString(),
              style: themeData.dialogTheme.contentTextStyle,
            ),
          );
        }
      }
    }
  }
}
