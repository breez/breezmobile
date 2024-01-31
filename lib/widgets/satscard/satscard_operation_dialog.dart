import 'dart:async';
import 'dart:io';

import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/bloc/satscard/satscard_op_status.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<T> showSatscardOperationDialog<T>(
    BuildContext context, SatscardBloc bloc, String cardId) {
  return showDialog(
    useRootNavigator: false,
    barrierDismissible: false,
    context: context,
    builder: (_) => SatscardOperationDialog(bloc, cardId),
  );
}

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
  NFCService _nfc;
  bool _isClosing;
  _BuildInfo _info;
  StreamSubscription<SatscardOpStatus> _operationSubscription;

  static const _iconHeight = 64.0;

  @override
  void dispose() {
    _animationController?.dispose();
    _operationSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

    // We need to initialize NFC on iOS devices
    _nfc = ServiceInjector().nfc;
    if (Platform.isIOS) {
      _startNfcSession(context.texts());
    }
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
          _setBuildInfo(_BuildInfo(data, widget._cardId, texts));

          return FadeTransition(
            opacity: _opacityAnimation,
            child: SimpleDialog(
              title: _buildTitle(themeData, texts),
              titlePadding: const EdgeInsets.fromLTRB(20.0, 22.0, 20.0, 8.0),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              children: <Widget>[
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

  Widget _buildTitle(ThemeData themeData, BreezTranslations texts) {
    final text = Text(
      texts.satscard_operation_dialog_title,
      style: themeData.dialogTheme.titleTextStyle,
    );

    // We don't need to show an NFC icon on Android as we constantly scan in the background
    if (Platform.isIOS) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: text),
          IconButton(
            icon: _buildNfcIcon(themeData),
            onPressed: () => _startNfcSession(texts),
          ),
        ],
      );
    } else {
      return text;
    }
  }

  Widget _buildContentForState(BuildContext context, SatscardOpStatus status) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    // Communicating with the user is handled by the system UI on iOS so we
    // don't need to update the dialog box
    if (Platform.isIOS) {
      return Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Text(
          texts.satscard_operation_dialog_content_ios_label,
          style: TextStyle(color: themeData.dialogTheme.contentTextStyle.color),
          textAlign: TextAlign.center,
        ),
      );
    }
    switch (_info.mode) {
      case _PresentMode.prompt:
        return _buildTextPrompt(
            themeData, _buildNfcIcon(themeData), _info.message);
      case _PresentMode.progress:
        return _buildProgressIndicator(themeData, _info.message,
            value: _info.progress);
      case _PresentMode.success:
        return _buildTextPrompt(
            themeData, _buildSuccessIcon(themeData), _info.message);
      default:
        return _buildTextPrompt(
            themeData, _buildErrorIcon(themeData), _info.message);
    }
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
      children: <Widget>[
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
    double height;
    Color color;
    if (Platform.isIOS) {
      color = themeData.primaryTextTheme.labelLarge.color;
    } else {
      height = _iconHeight;
      color = themeData.primaryColorLight;
    }
    return SvgPicture.asset(
      "src/icon/nfc.svg",
      height: height,
      fit: BoxFit.fitHeight,
      colorFilter: ColorFilter.mode(
        color,
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

  void _handleExitConditions(SatscardOpStatus status) {
    if (_isClosing == true) {
      return;
    } else if (status is SatscardOpStatusSuccess) {
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

  void _setBuildInfo(_BuildInfo info) {
    // On iOS we need to update system messages and the NFC status. We make
    // sure to do so only when the state has changed
    bool hasStateChanged = Platform.isIOS && _info != info;
    _info = info;

    if (hasStateChanged) {
      switch (info.mode) {
        case _PresentMode.prompt:
        case _PresentMode.progress:
          _nfc.updateAlert(info.message);
          break;
        case _PresentMode.success:
          // Close session with a success message
          _nfc.stopSession(iosAlert: info.message);
          break;
        case _PresentMode.error:
          // Close session with an error message
          _nfc.stopSession(iosError: info.message);
          break;
      }
    }
  }

  void _startNfcSession(BreezTranslations texts) {
    _nfc.startSession(
      autoClose: false,
      satscardOnly: true,
      iosAlert: texts
          .satscard_operation_dialog_present_satscards_label(widget._cardId),
    );
  }
}

class _BuildInfo {
  final _PresentMode mode;
  final String message;
  final double progress;

  factory _BuildInfo(SatscardOpStatus s, String id, BreezTranslations texts) {
    if (s is SatscardOpStatusInProgress) {
      return _BuildInfo.progress(
          texts.satscard_operation_dialog_in_progress_label, null);
    }
    if (s is SatscardOpStatusWaiting) {
      final nominator = s.initialAuthDelay - s.currentAuthDelay;
      final percentage = nominator / s.initialAuthDelay;
      return _BuildInfo.progress(
          Platform.isIOS
              ? texts.satscard_operation_dialog_waiting_ios_label(percentage)
              : texts.satscard_operation_dialog_waiting_label,
          percentage);
    }
    if (s is SatscardOpStatusSuccess) {
      return _BuildInfo.success(texts.satscard_operation_dialog_success_label);
    }
    if (s is SatscardOpStatusBadAuth) {
      return _BuildInfo.error(
          texts.satscard_operation_dialog_incorrect_code_label);
    }
    if (s is SatscardOpStatusIncorrectCard) {
      return _BuildInfo.error(
          texts.satscard_operation_dialog_incorrect_card_label(id));
    }
    if (s is SatscardOpStatusStaleCard) {
      return _BuildInfo.error(texts.satscard_operation_dialog_stale_card_label);
    }
    if (s is SatscardOpStatusNfcError) {
      return _BuildInfo.error(texts.satscard_operation_dialog_nfc_error_label);
    }
    if (s is SatscardOpStatusProtocolError) {
      return _BuildInfo.error(
          texts.satscard_operation_dialog_protocol_error_label(
              s.e.code, s.e.literal, s.e.message));
    }
    if (s is SatscardOpStatusUnexpectedError) {
      return _BuildInfo.error(
          texts.satscard_operation_dialog_unknown_error_label(s.message));
    }
    return _BuildInfo.prompt(
        texts.satscard_operation_dialog_present_satscards_label(id));
  }

  _BuildInfo.prompt(this.message)
      : mode = _PresentMode.prompt,
        progress = null;
  _BuildInfo.progress(this.message, this.progress)
      : mode = _PresentMode.progress;
  _BuildInfo.success(this.message)
      : mode = _PresentMode.success,
        progress = null;
  _BuildInfo.error(this.message)
      : mode = _PresentMode.error,
        progress = null;

  @override
  bool operator ==(Object obj) =>
      obj is _BuildInfo &&
      obj.mode == mode &&
      obj.message == message &&
      obj.progress == progress;

  @override
  int get hashCode => Object.hash(mode, message, progress);
}

enum _PresentMode {
  prompt,
  progress,
  success,
  error,
}
