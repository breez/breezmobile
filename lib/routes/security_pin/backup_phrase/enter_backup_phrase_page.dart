import 'dart:async';

import 'package:bip39/bip39.dart' as bip39;
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/single_button_bottom_bar.dart';
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
  int _currentPage;
  int _lastPage = 2;
  AutovalidateMode _autoValidateMode;
  bool _hasError;

  @override
  void initState() {
    super.initState();
    if (widget.is24Word) {
      focusNodes = List<FocusNode>.generate(24, (_) => FocusNode());
      textEditingControllers = List<TextEditingController>.generate(
        24,
        (_) => TextEditingController(),
      );
      _lastPage = 4;
    }
    _currentPage = 1;
    _autoValidateMode = AutovalidateMode.disabled;
    _hasError = false;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    final query = MediaQuery.of(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: themeData.appBarTheme.iconTheme,
          textTheme: themeData.appBarTheme.textTheme,
          backgroundColor: themeData.canvasColor,
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(
            onPressed: () {
              if (_currentPage == 1) {
                Navigator.pop(context);
              } else if (_currentPage > 1) {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _currentPage--;
                });
              }
            },
          ),
          title: Text(
            texts.enter_backup_phrase(
              _currentPage.toString(),
              _lastPage.toString(),
            ),
            // style: themeData.appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: query.size.height - kToolbarHeight - query.padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildRestoreFormContent(context, userProfileBloc),
            ),
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(6, (index) {
            final itemIndex = index + (6 * (_currentPage - 1));
            return _typeAheadFormField(itemIndex);
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
      hideOnEmpty: true,
      autoFlipDirection: true,
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
                color: theme.ClovrLabsWalletColors.dark_grey[500],
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
      text: _currentPage + 1 == (_lastPage + 1)
          ? texts.enter_backup_phrase_action_restore
          : texts.enter_backup_phrase_action_next,
      onPressed: () {
        setState(() {
          _hasError = false;
          if (_formKey.currentState.validate() && !_hasError) {
            _autoValidateMode = AutovalidateMode.disabled;
            if (_currentPage + 1 == (_lastPage + 1)) {
              _validateBackupPhrase(userProfileBloc);
            } else {
              _currentPage++;
            }
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

  Future<bool> _onWillPop() async {
    if (_currentPage == 1) {
      return true;
    } else if (_currentPage > 1) {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        _currentPage--;
      });
      return false;
    }
    return false;
  }
}
