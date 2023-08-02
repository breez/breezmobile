import 'dart:async';

import 'package:breez/routes/initial_walkthrough/mnemonics/restore_form_page.dart';
import 'package:breez/widgets/back_button.dart' as back_button;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class EnterMnemonicsPage extends StatefulWidget {
  final bool is24Word;

  const EnterMnemonicsPage({
    this.is24Word = false,
  });

  @override
  EnterMnemonicsPageState createState() => EnterMnemonicsPageState();
}

class EnterMnemonicsPageState extends State<EnterMnemonicsPage> {
  int _currentPage = 1;
  int _lastPage = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lastPage = widget.is24Word ? 4 : 2;
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final query = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: back_button.BackButton(
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
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: query.size.height - kToolbarHeight - query.padding.top,
            child: RestoreFormPage(
              currentPage: _currentPage,
              lastPage: _lastPage,
              is24Word: widget.is24Word,
              changePage: () {
                setState(() {
                  _currentPage++;
                });
              },
            ),
          ),
        ),
      ),
    );
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
