import 'dart:async';

import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/wordlist.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class RestoreForm extends StatefulWidget {
  final GlobalKey formKey;
  final int currentPage;
  final int lastPage;
  final List<TextEditingController> textEditingControllers;
  final AutovalidateMode autoValidateMode;
  final bool is24Word;

  const RestoreForm({
    this.formKey,
    this.currentPage,
    this.lastPage,
    this.textEditingControllers,
    this.autoValidateMode,
    this.is24Word = false,
  });

  @override
  RestoreFormState createState() => RestoreFormState();
}

class RestoreFormState extends State<RestoreForm> {
  List<FocusNode> focusNodes;
  AutovalidateMode _autoValidateMode;

  @override
  void initState() {
    super.initState();
    _autoValidateMode = AutovalidateMode.disabled;
    focusNodes =
        List<FocusNode>.generate(widget.is24Word ? 24 : 12, (_) => FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(6, (index) {
            final itemIndex = index + (6 * (widget.currentPage - 1));
            return TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: widget.textEditingControllers[itemIndex],
                textInputAction: TextInputAction.next,
                onSubmitted: (text) {
                  widget.textEditingControllers[itemIndex].text = text;
                  if (itemIndex + 1 < focusNodes.length) {
                    focusNodes[itemIndex + 1].requestFocus();
                  }
                },
                focusNode: focusNodes[itemIndex],
                decoration: InputDecoration(
                  labelText: "${itemIndex + 1}",
                ),
                style: theme.FieldTextStyle.textStyle,
              ),
              autovalidateMode: _autoValidateMode,
              validator: (text) => _onValidate(text),
              suggestionsCallback: _getSuggestions,
              hideOnEmpty: true,
              autoFlipDirection: true,
              suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                color: Colors.white,
                constraints: BoxConstraints(
                  minWidth: 180,
                  maxWidth: 180,
                  maxHeight: 180,
                ),
              ),
              itemBuilder: (context, suggestion) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Color.fromRGBO(5, 93, 235, 1.0),
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
                widget.textEditingControllers[itemIndex].text = suggestion;
                if (itemIndex + 1 < focusNodes.length) {
                  focusNodes[itemIndex + 1].requestFocus();
                }
              },
            );
          }),
        ),
      ),
    );
  }

  String _onValidate(String text) {
    final texts = context.texts();
    if (text.isEmpty) {
      return texts.enter_backup_phrase_missing_word;
    }
    if (!WORDLIST.contains(text.toLowerCase().trim())) {
      return texts.enter_backup_phrase_invalid_word;
    }
    return null;
  }

  FutureOr<List<String>> _getSuggestions(pattern) {
    var suggestionList =
        WORDLIST.where((item) => item.startsWith(pattern)).toList();
    return suggestionList.isNotEmpty ? suggestionList : List.empty();
  }
}
