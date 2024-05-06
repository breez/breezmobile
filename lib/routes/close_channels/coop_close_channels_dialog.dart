import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/exceptions.dart';
import 'package:breez/utils/external_browser.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

final _log = Logger("CoopCloseChannelsDialog");

class CoopCloseChannelsDialog extends StatefulWidget {
  final String closingAddress;

  const CoopCloseChannelsDialog({
    Key key,
    this.closingAddress,
  }) : super(key: key);

  @override
  State<CoopCloseChannelsDialog> createState() => _CoopCloseChannelsDialogState();
}

class _CoopCloseChannelsDialogState extends State<CoopCloseChannelsDialog> {
  ModalRoute _currentRoute;

  String dialogMessage = "";
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _closeChannels();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute = ModalRoute.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final loaderThemeData = theme.customData[theme.themeId];

    return WillPopScope(
      onWillPop: () {
        final isInProgress = (dialogMessage.isEmpty && hasError == false);
        return Future.value(!isInProgress);
      },
      child: AlertDialog(
        title: (dialogMessage.isEmpty && hasError == false)
            ? LoadingAnimatedText(
                texts.close_channels_dialog_title,
                textStyle: themeData.dialogTheme.titleTextStyle,
                textAlign: TextAlign.center,
              )
            : Text(
                texts.close_channels_dialog_title,
                style: themeData.dialogTheme.titleTextStyle,
                textAlign: TextAlign.center,
              ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            dialogMessage.isEmpty && hasError == false
                ? LoadingAnimatedText(
                    texts.close_channels_dialog_message,
                    textStyle: themeData.dialogTheme.contentTextStyle,
                    textAlign: TextAlign.center,
                  )
                : Text(
                    dialogMessage,
                    style: themeData.dialogTheme.contentTextStyle,
                    textAlign: TextAlign.center,
                  ),
            if (dialogMessage.isEmpty && hasError == false) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Image.asset(
                  loaderThemeData.loaderAssetPath,
                  height: 64.0,
                  colorBlendMode: loaderThemeData.loaderColorBlendMode ?? BlendMode.srcIn,
                  gaplessPlayback: true,
                ),
              ),
            ],
            if (hasError) ...[
              RichText(
                text: TextSpan(
                  style: themeData.dialogTheme.contentTextStyle,
                  text: texts.close_channels_dialog_failure_message_start,
                  children: [
                    TextSpan(
                      text: texts.close_channels_dialog_failure_message_middle,
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          // If device can't handle mailto: link, share the e-mail
                          try {
                            await launchLinkOnExternalBrowser(
                              "mailto:contact@breez.technology",
                            );
                          } catch (e) {
                            final RenderBox box = context.findRenderObject();
                            final offset = box.localToGlobal(Offset.zero) & box.size;
                            final rect = Rect.fromPoints(
                              offset.topLeft,
                              offset.bottomRight,
                            );
                            Share.share(
                              "contact@breez.technology",
                              subject: texts.close_channels_dialog_failure_message_middle,
                              sharePositionOrigin: rect,
                            );
                          }
                        },
                    ),
                    TextSpan(
                      text: texts.close_channels_dialog_failure_message_end,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: (dialogMessage.isNotEmpty || hasError == true)
            ? [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.transparent;
                      }
                      return null; // Defer to the widget's default.
                    }),
                  ),
                  child: Text(
                    texts.close_channels_dialog_action_close,
                    style: themeData.primaryTextTheme.labelLarge,
                  ),
                  onPressed: () => Navigator.of(context).removeRoute(_currentRoute),
                ),
              ]
            : null,
      ),
    );
  }

  Future<void> _closeChannels() async {
    final texts = context.texts();
    final themeData = Theme.of(context);
    try {
      final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      final closeChannelAction = CloseChannelsAction(widget.closingAddress);
      accountBloc.userActionsSink.add(closeChannelAction);
      await closeChannelAction.future.then((result) {
        final closedChannels = result as List<CloseChannelResult>;
        if (closedChannels.any((c) => !c.isSkipped || !c.failErr.isNotEmpty)) {
          _isCompleted();
          _log.info(
            "Closed channels successfully.\n"
            "List of closed channels: ${closedChannels.toString()}",
          );
          return;
        } else {
          _isCompleted(hasError: true);
          _log.warning("Failed to close all channels.");
          for (var channel in closedChannels) {
            _log.warning(
              "Closing TX ID: ${channel.closingTxid}\nChannel Point: ${channel.channelPoint}",
            );
            if (channel.isSkipped) {
              _log.warning("Is Skipped: ${channel.isSkipped}");
            }
            if (channel.failErr.isNotEmpty) {
              _log.severe("Fail Error: ${channel.failErr}");
            }
          }
        }
      }).catchError((err) {
        throw err;
      });
    } catch (e) {
      _isCompleted(hasError: true);
      _log.severe("Failed to close channels cooperatively.", e);
      if (_currentRoute.isActive) {
        Navigator.of(context).removeRoute(_currentRoute);
      }

      if (!context.mounted) {
        return;
      }

      promptError(
        context,
        texts.close_channels_error_dialog_title,
        Text(
          texts.close_channels_error_dialog_message(extractExceptionMessage(e)),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
      rethrow;
    }
  }

  void _isCompleted({bool hasError = false}) {
    final texts = context.texts();

    setState(() {
      dialogMessage = hasError ? "" : texts.close_channels_dialog_success_message;
      this.hasError = hasError;
    });
  }
}
