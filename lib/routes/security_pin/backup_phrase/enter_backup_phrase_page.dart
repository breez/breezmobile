import 'dart:async';

import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'wordlist.dart';

class EnterBackupPhrasePage extends StatefulWidget {
  final bool is24Word;
  final Function(String phrase) onPhraseSubmitted;

  const EnterBackupPhrasePage(
      {Key key, this.is24Word = false, @required this.onPhraseSubmitted})
      : super(key: key);

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
    if (widget.is24Word) {
      focusNodes = List<FocusNode>.generate(24, (_) => FocusNode());
      textEditingControllers = List<TextEditingController>.generate(
          24, (_) => TextEditingController());
      _lastPage = 4;
    }
    _currentPage = 1;
    _autoValidateMode = AutovalidateMode.disabled;
    _hasError = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc =
        AppBlocsProvider.of<UserProfileBloc>(context);

    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(
            onPressed: () {
              if (_currentPage == 1) {
                Navigator.pop(context);
              } else if (_currentPage > 1) {
                _formKey.currentState.reset();
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _currentPage--;
                });
              }
            },
          ),
          title: Text(
            "Enter your backup phrase ($_currentPage/$_lastPage)",
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              MediaQuery.of(context).padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildRestoreFormContent(userProfileBloc),
          ),
        ),
      ),
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(6, (index) {
            var itemIndex = index + (6 * (_currentPage - 1));
            return _typeAheadFormField(itemIndex);
          }),
        ),
      ),
    );
  }

  List<Widget> _buildRestoreFormContent(UserProfileBloc userProfileBloc) {
    List<Widget> restoreFormContent = [];
    restoreFormContent..add(_buildForm());
    if (_hasError) {
      restoreFormContent
        ..add(_buildErrorMessage(
            "Failed to restore from backup. Please make sure backup phrase was correctly entered and try again."));
    }
    restoreFormContent..add(_buildBottomBtn(userProfileBloc));
    return restoreFormContent;
  }

  _buildErrorMessage(String errorMessage) {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Text(errorMessage,
            style:
                Theme.of(context).textTheme.headline4.copyWith(fontSize: 12)));
  }

  TypeAheadFormField<String> _typeAheadFormField(int itemIndex) {
    return TypeAheadFormField(
      textFieldConfiguration: _textFieldConfiguration(itemIndex),
      autovalidateMode: _autoValidateMode,
      validator: _onValidate,
      suggestionsCallback: _getSuggestions,
      autoFlipDirection: true,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.white,
        constraints:
            BoxConstraints(minWidth: 180, maxWidth: 180, maxHeight: 180),
      ),
      itemBuilder: (context, suggestion) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.5, color: theme.BreezColors.blue[500]))),
          child: ListTile(
              title: Text(suggestion,
                  overflow: TextOverflow.ellipsis,
                  style: theme.autoCompleteStyle)),
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
    return suggestionList.length > 0 ? suggestionList : null;
  }

  String _onValidate(text) {
    if (text.length == 0) {
      return "Missing word";
    }
    if (!WORDLIST.contains(text.toLowerCase().trim())) {
      return "Invalid word";
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

  _buildBottomBtn(UserProfileBloc userProfileBloc) {
    return SingleButtonBottomBar(
      text: _currentPage + 1 == (_lastPage + 1) ? "RESTORE" : "NEXT",
      onPressed: () {
        setState(() {
          _hasError = false;
          if (_formKey.currentState.validate() && !_hasError) {
            _autoValidateMode = AutovalidateMode.disabled;
            if (_currentPage + 1 == (_lastPage + 1)) {
              _validateBackupPhrase(userProfileBloc);
            } else {
              _formKey.currentState.reset();
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
    var mnemonic = textEditingControllers
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
