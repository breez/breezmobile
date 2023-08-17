import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_bloc.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class CustomClipsDurationDialog extends StatefulWidget {
  const CustomClipsDurationDialog({Key key}) : super(key: key);

  @override
  State<CustomClipsDurationDialog> createState() =>
      _CustomClipsDurationDialogState();
}

class _CustomClipsDurationDialogState extends State<CustomClipsDurationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _durationFocusNode = FocusNode();
  TextEditingController _clipDurationTextEditingController;

  @override
  void initState() {
    super.initState();
    _clipDurationTextEditingController = TextEditingController();
    _clipDurationTextEditingController.addListener(() {
      setState(() {});
    });
    if (_clipDurationTextEditingController.text.isEmpty) {
      _durationFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        texts.podcast_clips_dialog_title,
        style: theme.dialogTheme.titleTextStyle.copyWith(
          fontSize: 16,
        ),
        maxLines: 1,
      ),
      content: _buildDurationDialogWidget(theme),
      actions: _buildActions(),
    );
  }

  Widget _buildDurationDialogWidget(ThemeData theme) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: TextFormField(
        controller: _clipDurationTextEditingController,
        validator: (dur) => _Validator.validateDuration(dur),
        keyboardType: TextInputType.number,
        focusNode: _durationFocusNode,
        maxLength: 3,
        style: theme.dialogTheme.contentTextStyle.copyWith(height: 1.0),
      ),
    );
  }

  List<Widget> _buildActions() {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final podcastClipBloc = AppBlocsProvider.of<PodcastClipBloc>(context);

    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.podcast_boost_action_cancel,
          style: themeData.primaryTextTheme.labelLarge,
        ),
      ),
    ];
    if (_clipDurationTextEditingController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              int durationInSeconds = int.parse(
                _clipDurationTextEditingController.text,
              );
              podcastClipBloc.setPodcastClipDuration(
                durationInSeconds: durationInSeconds,
              );
            }
          },
          child: Text(
            texts.podcast_clips_dialog_done,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      );
    }
    return actions;
  }
}

class _Validator {
  static String validateDuration(String value) {
    num duration = num.parse(value);
    if (duration < 10 || duration > 120) {
      return "Duration must be between 10 and 120";
    }

    return null;
  }
}
