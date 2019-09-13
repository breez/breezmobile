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
  int _selectedIndex;
  bool _showWordList;
  List<String> _wordsShow = List();
  List<String> _mnemonicsList = List();
  bool _autoValidate;

  @override
  void initState() {
    _createFocusNodes();
    _createTextEditingControllers();
    _currentPage = 1;
    _selectedIndex = 0;
    _showWordList = false;
    _autoValidate = false;
    super.initState();
  }

  _createFocusNodes() {
    for (var i = 0; i < focusNodes.length; i++) {
      FocusNode focusNode = new FocusNode();
      focusNodes[i] = focusNode;
      focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    setState(() {
      _showWordList = false;
    });
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
                _addToUserInput();
                _formKey.currentState.reset();
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  _showWordList = false;
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
      body: _buildForm(),
      bottomNavigationBar: _buildBottomBtn(userProfileBloc),
    );
  }

  _buildForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: new Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
          child: Stack(
            children: [
              new Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(6, (index) {
                  var itemIndex = index + (6 * (_currentPage - 1));
                  return TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: textEditingControllers[itemIndex],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusNodes[itemIndex + 1]);
                      },
                      focusNode: focusNodes[itemIndex],
                      decoration: new InputDecoration(
                        labelText: "${itemIndex + 1}",
                      ),
                      style: theme.FieldTextStyle.textStyle,
                    ),
                    autovalidate: _autoValidate,
                    validator: (text) {
                      if (text.length == 0) {
                        return "Missing word";
                      }
                      if (!WORDLIST.contains(text.toLowerCase().trim())) {
                        return "Invalid word";
                      }
                      return null;
                    },
                    suggestionsCallback: (pattern) {
                      var suggestionList = WORDLIST.where((item) => item.startsWith(pattern)).toList();
                      return suggestionList.length > 0 ? suggestionList : null;
                    },
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      color: Colors.white,
                      constraints: BoxConstraints(maxHeight: 120, minHeight: 60, minWidth: 180, maxWidth: 180),
                    ),
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion, overflow: TextOverflow.ellipsis, style: theme.autoCompleteStyle),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      textEditingControllers[itemIndex].text = suggestion;
                      FocusScope.of(context).requestFocus(focusNodes[itemIndex + 1]);
                    },
                  );
                }),
              ),
              _showWordList
                  ? new Container(
                      padding: new EdgeInsets.only(top: (61 * (_selectedIndex + 1) + 3).toDouble()),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                              flex: 200, child: new Container(decoration: theme.autoCompleteBoxDecoration, child: _getFutureWidgetWords())),
                          new Expanded(flex: 128, child: new Container())
                        ],
                      ))
                  : new Container()
            ],
          ),
        ),
      ),
    );
  }

  _addToUserInput() {
    textEditingControllers.asMap().forEach((index, textEditingController) {
      if (exceptionAware<String>(() => _mnemonicsList.elementAt(index)) != null) {
        _mnemonicsList.removeAt(index);
      }
      _mnemonicsList.insert(index, textEditingController.text.toLowerCase().trim());
    });
  }

  T exceptionAware<T>(T Function() f) {
    try {
      return f();
    } catch (_) {
      return null;
    }
  }

  Widget _getFutureWidgetWords() {
    List<InkWell> list = new List();
    int number = _wordsShow.length > 2 ? 3 : _wordsShow.length;
    for (int i = 0; i < number; i++) {
      list.add(new InkWell(
        child: new Container(
            padding: new EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            height: 35.0,
            child: new Text(_wordsShow[i], overflow: TextOverflow.ellipsis, style: theme.autoCompleteStyle)),
        onTap: () {
          setState(() {
            textEditingControllers[_selectedIndex].text = _wordsShow[i];
            _wordsShow.clear();
            FocusScope.of(context).requestFocus((_selectedIndex < 23) ? focusNodes[_selectedIndex + 1] : FocusNode());
          });
        },
      ));
    }

    return new Container(height: list.length * 35.0, width: MediaQuery.of(context).size.width, child: new ListView(children: list));
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
                _showWordList = false;
                if (_formKey.currentState.validate()) {
                  _autoValidate = false;
                  _addToUserInput();
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
    var validateAction = ValidateBackupPhrase(_mnemonicsList.join(" "));
    userProfileBloc.userActionsSink.add(validateAction);
    return validateAction.future.then((_) => Navigator.pop(context, bip39.mnemonicToEntropy(_mnemonicsList.join(" "))));
  }
}
