import 'dart:async';

import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'wordlist.dart';

class EnterBackupPhrasePage extends StatefulWidget {
  @override
  EnterBackupPhrasePageState createState() => new EnterBackupPhrasePageState();
}

class EnterBackupPhrasePageState extends State<EnterBackupPhrasePage> {
  final _formKey = GlobalKey<FormState>();

  List<FocusNode> focusNodes = List<FocusNode>(24);
  List<TextEditingController> textEditingControllers = List<TextEditingController>(24);
  int _currentPage;
  bool _autoValidate;
  bool _hasError;

  @override
  void initState() {
    _createFocusNodes();
    _createTextEditingControllers();
    _currentPage = 1;
    _autoValidate = false;
    _hasError = false;
    super.initState();
  }

  _createFocusNodes() {
    for (var i = 0; i < focusNodes.length; i++) {
      FocusNode focusNode = new FocusNode();
      focusNodes[i] = focusNode;
    }
  }

  _createTextEditingControllers() {
    for (var i = 0; i < textEditingControllers.length; i++) {
      TextEditingController textEditingController = new TextEditingController();
      textEditingControllers[i] = textEditingController;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return Scaffold(
      appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(
            onPressed: () {
              if (_currentPage == 1) {
                Navigator.pop(context);
              } else if (_currentPage > 1) {
                _formKey.currentState.reset();
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  _currentPage--;
                });
              }
            },
          ),
          title: new Text(
            "Enter your backup phrase ($_currentPage/4)",
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
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
      child: new Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 24.0),
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
    List<Widget> restoreFormContent = List();
    restoreFormContent..add(_buildForm());
    if (_hasError) {
      restoreFormContent
        ..add(_buildErrorMessage("Failed to restore from backup. Please make sure backup phrase was correctly entered and try again."));
    }
    restoreFormContent..add(_buildBottomBtn(userProfileBloc));
    return restoreFormContent;
  }

  _buildErrorMessage(String errorMessage) {
    return Padding(padding: EdgeInsets.only(left: 16, right: 16), child: Text(errorMessage, style: theme.errorStyle));
  }

  TypeAheadFormField<String> _typeAheadFormField(int itemIndex) {
    return TypeAheadFormField(
      textFieldConfiguration: _textFieldConfiguration(itemIndex),
      autovalidate: _autoValidate,
      validator: _onValidate,
      suggestionsCallback: _getSuggestions,
      autoFlipDirection: true,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.white,
        constraints: BoxConstraints(minWidth: 180, maxWidth: 180, maxHeight: 180),
      ),
      itemBuilder: (context, suggestion) {
        return Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: theme.BreezColors.blue[500]))),
          child: ListTile(title: Text(suggestion, overflow: TextOverflow.ellipsis, style: theme.autoCompleteStyle)),
        );
      },
      onSuggestionSelected: (suggestion) {
        textEditingControllers[itemIndex].text = suggestion;
        FocusScope.of(context).requestFocus((itemIndex < 23) ? focusNodes[itemIndex + 1] : FocusNode());
      },
    );
  }

  FutureOr<List<String>> _getSuggestions(pattern) {
    var suggestionList = WORDLIST.where((item) => item.startsWith(pattern)).toList();
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
        FocusScope.of(context).requestFocus((itemIndex < 23) ? focusNodes[itemIndex + 1] : FocusNode());
      },
      focusNode: focusNodes[itemIndex],
      decoration: new InputDecoration(
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
    return Padding(
      padding: new EdgeInsets.only(bottom: 40),
      child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        SizedBox(
          height: 48.0,
          width: 168.0,
          child: new RaisedButton(
            child: new Text(
              _currentPage + 1 == 5 ? "RESTORE" : "NEXT",
              style: theme.buttonStyle,
            ),
            color: theme.BreezColors.white[500],
            elevation: 0.0,
            shape: const StadiumBorder(),
            onPressed: () {
              setState(() {
                if (_formKey.currentState.validate()) {
                  _autoValidate = false;
                  if (_currentPage + 1 == 5) {
                    _validateBackupPhrase(userProfileBloc);
                  } else {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _formKey.currentState.reset();
                    _currentPage++;
                  }
                } else {
                  _autoValidate = true;
                }
              });
            },
          ),
        )
      ]),
    );
  }

  Future _validateBackupPhrase(UserProfileBloc userProfileBloc) async {
    var mnemonic = textEditingControllers.map((controller) => controller.text.toLowerCase().trim()).toList().join(" ");
    var validateAction = ValidateBackupPhrase(mnemonic);
    userProfileBloc.userActionsSink.add(validateAction);
    return validateAction.future.then((isValid) {
      if (isValid) {
        Navigator.pop(context, bip39.mnemonicToEntropy(mnemonic));
      } else {
        setState(() {
          _hasError = true;
        });
      }
    });
  }
}
