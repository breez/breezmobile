import 'dart:async';

import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'wordlist.dart';

class EnterBackupPhrasePage extends StatefulWidget {
  final bool is24Word;
  final Function(String phrase) onPhraseSubmitted;

  const EnterBackupPhrasePage({
    Key key,
    this.is24Word = false,
    @required this.onPhraseSubmitted,
  }) : super(key: key);

  @override
  EnterBackupPhrasePageState createState() => EnterBackupPhrasePageState();
}

class EnterBackupPhrasePageState extends State<EnterBackupPhrasePage> {
  final _formKey = GlobalKey<FormState>();

  List<FocusNode> focusNodes = List<FocusNode>.generate(12, (_) => FocusNode());
  List<TextEditingController> textEditingControllers =
      List<TextEditingController>.generate(12, (_) => TextEditingController());
  AutovalidateMode _autoValidateMode;
  bool _hasError;

  @override
  void initState() {
    if (widget.is24Word) {
      focusNodes = List<FocusNode>.generate(24, (_) => FocusNode());
      textEditingControllers = List<TextEditingController>.generate(
        24,
        (_) => TextEditingController(),
      );
    }
    _autoValidateMode = AutovalidateMode.disabled;
    _hasError = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        automaticallyImplyLeading: false,
        leading: backBtn.BackButton(),
        title: Text(
          texts.enter_backup_phrase,
          style: themeData.appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: _buildRestoreFormContent(context, userProfileBloc),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.is24Word ? 24 : 12, (index) {
            return _typeAheadFormField(index);
          }),
        ),
      ),
    );
  }

  List<Widget> _buildRestoreFormContent(
    BuildContext context,
    UserProfileBloc userProfileBloc,
  ) {
    final texts = AppLocalizations.of(context);
    List<Widget> restoreFormContent = [];
    restoreFormContent..add(_buildForm());
    if (_hasError) {
      restoreFormContent
        ..add(_buildErrorMessage(
          context,
          texts.enter_backup_phrase_error,
        ));
    }
    restoreFormContent..add(_buildBottomBtn(context, userProfileBloc));
    return restoreFormContent;
  }

  Widget _buildErrorMessage(BuildContext context, String errorMessage) {
    final themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        errorMessage,
        style: themeData.textTheme.headline4.copyWith(
          fontSize: 12,
        ),
      ),
    );
  }

  TypeAheadFormField<String> _typeAheadFormField(int itemIndex) {
    return TypeAheadFormField(
      textFieldConfiguration: _textFieldConfiguration(itemIndex),
      autovalidateMode: _autoValidateMode,
      validator: (text) => _onValidate(context, text),
      suggestionsCallback: _getSuggestions,
      autoFlipDirection: true,
      hideOnEmpty: true,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.white,
        constraints: BoxConstraints(
          minWidth: 180,
          maxWidth: 180,
          maxHeight: 180,
        ),
      ),
      itemBuilder: (context, suggestion) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: theme.BreezColors.blue[500],
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              suggestion,
              overflow: TextOverflow.ellipsis,
              style: theme.autoCompleteStyle,
            ),
          ),
        );
      },
      onSuggestionSelected: (suggestion) {
        textEditingControllers[itemIndex].text = suggestion;
        focusNodes[itemIndex + 1].requestFocus();
      },
    );
  }

  FutureOr<List<String>> _getSuggestions(pattern) {
    var suggestionList =
        WORDLIST.where((item) => item.startsWith(pattern)).toList();
    return suggestionList.length > 0 ? suggestionList : List.empty();
  }

  String _onValidate(BuildContext context, String text) {
    final texts = AppLocalizations.of(context);
    if (text.length == 0) {
      return texts.enter_backup_phrase_missing_word;
    }
    if (!WORDLIST.contains(text.toLowerCase().trim())) {
      return texts.enter_backup_phrase_invalid_word;
    }
    return null;
  }

  TextFieldConfiguration _textFieldConfiguration(int itemIndex) {
    return TextFieldConfiguration(
      controller: textEditingControllers[itemIndex],
      textInputAction: TextInputAction.next,
      onSubmitted: (text) {
        textEditingControllers[itemIndex].text = text;
        focusNodes[itemIndex + 1].requestFocus();
      },
      focusNode: focusNodes[itemIndex],
      decoration: InputDecoration(
        labelText: "${itemIndex + 1}",
      ),
      style: theme.FieldTextStyle.textStyle,
    );
  }

  T exceptionAware<T>(T Function() f) {
    try {
      return f();
    } catch (_) {
      return null;
    }
  }

  Widget _buildBottomBtn(
    BuildContext context,
    UserProfileBloc userProfileBloc,
  ) {
    final texts = AppLocalizations.of(context);
    return SingleButtonBottomBar(
      text: texts.enter_backup_phrase_action_restore,
      onPressed: () {
        setState(() {
          _hasError = false;
          if (_formKey.currentState.validate() && !_hasError) {
            _autoValidateMode = AutovalidateMode.disabled;
            _validateBackupPhrase(userProfileBloc);
          } else {
            _autoValidateMode = AutovalidateMode.always;
          }
        });
      },
    );
  }

  Future _validateBackupPhrase(UserProfileBloc userProfileBloc) async {
    final mnemonic = textEditingControllers
        .map((controller) => controller.text.toLowerCase().trim())
        .toList()
        .join(" ");
    String enteredBackupPhrase;
    try {
      enteredBackupPhrase = bip39.mnemonicToEntropy(mnemonic);
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      throw Exception(e.toString());
    }
    widget.onPhraseSubmitted(enteredBackupPhrase);
  }
}
