import 'dart:async';

import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/bloc/satscard/satscard_op_status.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SatscardOperationDialog extends StatefulWidget {
  final SatscardBloc _bloc;
  final String _cardId;

  const SatscardOperationDialog(
    this._bloc,
    this._cardId,
  );

  @override
  State<StatefulWidget> createState() => SatscardOperationDialogState();
}

class SatscardOperationDialogState extends State<SatscardOperationDialog>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacityAnimation;
  StreamSubscription<SatscardOpStatus> _operationSubscription;
  bool _isClosing;

  static const _iconHeight = 64.0;

  @override
  void initState() {
    super.initState();
    _isClosing = false;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
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
                SizedBox(
                  width: 310,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: _buildContentForState(context, data),
                  ),
                ),
                _buildCancelButton(themeData, texts),
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
          _buildNfcIcon(themeData),
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
    if (status is SatscardOpStatusSuccess) {
      return _buildTextPrompt(themeData, _buildSuccessIcon(themeData),
          texts.satscard_operation_dialog_success_label);
    }
    if (status is SatscardOpStatusBadAuth) {
      return _buildTextPrompt(themeData, _buildErrorIcon(themeData),
          texts.satscard_operation_dialog_incorrect_code_label);
    }
    if (status is SatscardOpStatusIncorrectCard) {
      return _buildTextPrompt(themeData, _buildErrorIcon(themeData),
          texts.satscard_operation_dialog_incorrect_card_label(widget._cardId));
    }
    if (status is SatscardOpStatusStaleCard) {
      return _buildTextPrompt(themeData, _buildErrorIcon(themeData),
          texts.satscard_operation_dialog_stale_card_label);
    }
    if (status is SatscardOpStatusNfcError) {
      return _buildTextPrompt(themeData, _buildNfcIcon(themeData),
          texts.satscard_operation_dialog_nfc_error_label);
    }
    if (status is SatscardOpStatusProtocolError) {
      return _buildTextPrompt(
          themeData,
          _buildErrorIcon(themeData),
          texts.satscard_operation_dialog_protocol_error_label(
              status.e.code, status.e.literal, status.e.message));
    }
    if (status is SatscardOpStatusUnexpectedError) {
      return _buildTextPrompt(themeData, _buildErrorIcon(themeData),
          texts.satscard_operation_dialog_unknown_error_label(status.message));
    }
    return Container();
  }

  Widget _buildProgressIndicator(ThemeData themeData, String title,
      {double value}) {
    return CircularProgress(
      color: themeData.dialogTheme.contentTextStyle.color,
      mainAxisAlignment: MainAxisAlignment.start,
      size: _iconHeight,
      title: title,
      value: value,
    );
  }

  Widget _buildTextPrompt(ThemeData themeData, Widget image, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        image,
        Padding(
          padding: const EdgeInsets.only(top: _iconHeight / 5),
          child: Text(
            label,
            style:
                TextStyle(color: themeData.dialogTheme.contentTextStyle.color),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessIcon(ThemeData themeData) {
    return Image(
      image: const AssetImage("src/icon/ic_done.png"),
      height: _iconHeight,
      fit: BoxFit.fitHeight,
      color: themeData.primaryColorLight,
    );
  }

  Widget _buildNfcIcon(ThemeData themeData) {
    return SvgPicture.asset(
      "src/icon/nfc.svg",
      height: _iconHeight,
      fit: BoxFit.fitHeight,
      colorFilter: ColorFilter.mode(
        themeData.primaryColorLight,
        BlendMode.srcATop,
      ),
    );
  }

  Widget _buildErrorIcon(ThemeData themeData) {
    return SvgPicture.asset(
      "src/icon/warning.svg",
      height: _iconHeight,
      fit: BoxFit.fitHeight,
      colorFilter: ColorFilter.mode(
        themeData.colorScheme.error,
        BlendMode.srcATop,
      ),
    );
  }

  Widget _buildCancelButton(ThemeData themeData, BreezTranslations texts) {
    return TextButton(
      onPressed: _isClosing ? null : () => _onFinish(false),
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
    } else if (status is SatscardOpStatusSlotInitialized) {
      _onFinish(status, delay: 1.5);
    } else if (status is SatscardOpStatusBadAuth) {
      _onFinish(status, delay: 1.5);
    }
  }

  void _onFinish<T>(T result, {double delay = 0.0}) async {
    if (_isClosing) {
      return;
    }
    _isClosing = true;
    widget._bloc.actionsSink.add(DisableListening());

    if (delay > 0.0) {
      await Future.delayed(Duration(milliseconds: (1000 * delay).toInt()));
      await _animationController.reverse();
    }
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }
}
