import 'dart:async';

import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/bloc/satscard/satscard_op_status.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';

class SatscardOperationDialog extends StatefulWidget {
  final BuildContext _context;
  final SatscardBloc _bloc;
  final String _cardId;

  const SatscardOperationDialog(
    this._context,
    this._bloc,
    this._cardId,
  );

  @override
  State<StatefulWidget> createState() {
    return SatscardOperationDialogState();
  }
}

class SatscardOperationDialogState extends State<SatscardOperationDialog>
    with SingleTickerProviderStateMixin {
  Animation<double> _opacityAnimation;
  StreamSubscription<SatscardOpStatus> _operationSubscription;
  ModalRoute _currentRoute;
  bool _isClosing;

  @override
  void initState() {
    super.initState();
    _isClosing = false;
    var controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ));
    controller.value = 1.0;
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.dismissed && mounted) {
        _onFinish(delay: false);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  void dispose() {
    _operationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return StreamBuilder<SatscardOpStatus>(
        stream: widget._bloc.operationStream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          _handleExitConditions(data);
          return FadeTransition(
            opacity: _opacityAnimation,
            child: SimpleDialog(
              title: Text(texts.satscard_operation_dialog_title,
                  style: themeData.dialogTheme.titleTextStyle),
              titlePadding: const EdgeInsets.fromLTRB(20.0, 22.0, 0.0, 8.0),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              children: [
                StreamBuilder<SatscardOpStatus>(
                  stream: widget._bloc.operationStream,
                  builder: (context, _) {
                    return SizedBox(
                      width: 310,
                      height: 250,
                      child: _buildContentForState(context, data),
                    );
                  },
                ),
                _buildCancelButton(texts, themeData),
              ],
            ),
          );
        });
  }

  Widget _buildContentForState(BuildContext context, SatscardOpStatus status) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    if (status == null) {
      return _buildTextPrompt(
          themeData,
          texts.satscard_operation_dialog_present_satscards_label(
              widget._cardId));
    }
    if (status is SatscardOpStatusInProgress) {
      return _buildProgressIndicator(
          themeData, texts.satscard_operation_dialog_in_progress_label);
    }
    if (status is SatscardOpStatusWaiting) {
      final nominator = status.initialAuthDelay - status.currentAuthDelay;
      final percentage = nominator / status.initialAuthDelay;
      return _buildProgressIndicator(
          themeData, texts.satscard_operation_dialog_waiting_label,
          value: percentage);
    }
    if (status is SatscardOpStatusSlotInitialized) {
      return _buildOperationSuccessIndicator(context, status, texts, themeData);
    }
    if (status is SatscardOpStatusIncorrectCard) {
      return _buildTextPrompt(themeData,
          texts.satscard_operation_dialog_incorrect_card_label(widget._cardId));
    }
    if (status is SatscardOpStatusStaleCard) {
      return _buildTextPrompt(
          themeData, texts.satscard_operation_dialog_stale_card_label);
    }
    if (status is SatscardOpStatusNfcError) {
      return _buildTextPrompt(
          themeData, texts.satscard_operation_dialog_nfc_error_label);
    }
    if (status is SatscardOpStatusProtocolError) {
      return _buildTextPrompt(
          themeData,
          texts.satscard_operation_dialog_protocol_error_label(
              status.e.code, status.e.literal, status.e.message));
    }
    if (status is SatscardOpStatusUnexpectedError) {
      return _buildTextPrompt(themeData,
          texts.satscard_operation_dialog_unknown_error_label(status.message));
    }
    return Container();
  }

  Widget _buildProgressIndicator(ThemeData themeData, String title,
      {double value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: CircularProgress(
        color: themeData.dialogTheme.contentTextStyle.color,
        mainAxisAlignment: MainAxisAlignment.start,
        size: 100,
        title: title,
        value: value,
      ),
    );
  }

  Widget _buildTextPrompt(ThemeData themeData, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: themeData.dialogTheme.contentTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOperationSuccessIndicator(
      BuildContext context,
      SatscardOpStatusSlotInitialized status,
      BreezTranslations texts,
      ThemeData themeData) {
    return const Text("Success!");
  }

  Widget _buildCancelButton(BreezTranslations texts, ThemeData themeData) {
    return TextButton(
      onPressed: _isClosing ? null : () => _onFinish(delay: false),
      child: Text(
        texts.satscard_operation_dialog_cancel_label,
        style: themeData.primaryTextTheme.labelLarge.copyWith(
          color: _isClosing
              ? themeData.primaryTextTheme.labelLarge.color.withOpacity(0.4)
              : themeData.primaryTextTheme.labelLarge.color,
        ),
      ),
    );
  }

  void _handleExitConditions(SatscardOpStatus status) {
    if (_isClosing == true) {
      return;
    }
    if (status is SatscardOpStatusSlotInitialized) {
      _onFinish(delay: true);
    }
  }

  void _onFinish({bool delay = true}) {
    _isClosing = true;
    widget._bloc.actionsSink.add(DisableListening());
    void closeFunc() {
      Navigator.removeRoute(context, _currentRoute);
    }

    if (delay) {
      Future.delayed(const Duration(seconds: 5), closeFunc);
    } else {
      closeFunc();
    }
  }
}
