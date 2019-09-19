import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'verify_backup_phrase_page.dart';

class GenerateBackupPhrasePage extends StatefulWidget {
  final String mnemonics;
  final int page;

  GenerateBackupPhrasePage({this.mnemonics, this.page});

  @override
  GenerateBackupPhrasePageState createState() => new GenerateBackupPhrasePageState();
}

class GenerateBackupPhrasePageState extends State<GenerateBackupPhrasePage> {
  String _mnemonics;
  List<String> _mnemonicsList;

  int _currentPage;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: new AppBar(
            iconTheme: theme.appBarIconTheme,
            textTheme: theme.appBarTextTheme,
            backgroundColor: theme.BreezColors.blue[500],
            automaticallyImplyLeading: false,
            leading: backBtn.BackButton(
              onPressed: () => _onWillPop(context),
            ),
            title: new Text(
              "Write these words ($_currentPage/2)",
              style: theme.appBarTextStyle,
            ),
            elevation: 0.0),
        body: _buildMnemonicSeedList(),
        bottomNavigationBar: _buildNextBtn(),
      ),
    );
  }

  @override
  void initState() {
    _currentPage = widget.page ?? 1;
    _mnemonics = widget.mnemonics ?? bip39.generateMnemonic(strength: 256);
    _mnemonicsList = _mnemonics.split(" ");
    super.initState();
  }

  _buildMnemonicItem(int index, String mnemonic) {
    return Center(
      child: Container(
        height: 48,
        width: 150,
        decoration: BoxDecoration(border: Border.all(color: Colors.white30), borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            '${index + 1}. $mnemonic',
            style: theme.mnemonicsTextStyle,
          ),
        ),
      ),
    );
  }

  Row _buildMnemonicSeedList() {
    return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: List<Widget>.generate(
          _mnemonicsList.length ~/ 4,
          (index) => _buildMnemonicItem(
            index + (_mnemonicsList.length ~/ 2 * (_currentPage - 1)),
            _mnemonicsList[index + (_mnemonicsList.length ~/ 2 * (_currentPage - 1))],
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: List<Widget>.generate(
          _mnemonicsList.length ~/ 4,
          (index) => _buildMnemonicItem(
            index + (_mnemonicsList.length ~/ 2 * (_currentPage - 1)) + _mnemonicsList.length ~/ 4,
            _mnemonicsList[index + (_mnemonicsList.length ~/ 2 * (_currentPage - 1)) + _mnemonicsList.length ~/ 4],
          ),
        ),
      ),
    ]);
  }

  _buildNextBtn() {
    return Padding(
      padding: new EdgeInsets.only(bottom: 40),
      child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        SizedBox(
          height: 48.0,
          width: 168.0,
          child: new RaisedButton(
            child: new Text(
              "NEXT",
              style: theme.buttonStyle,
            ),
            color: theme.BreezColors.white[500],
            elevation: 0.0,
            shape: const StadiumBorder(),
            onPressed: () {
              if (_currentPage + 1 == 3) {
                Navigator.push(
                  context,
                  FadeInRoute(
                    builder: (_) => VerifyBackupPhrasePage(_mnemonics),
                  ),
                );
              } else {
                setState(() {
                  _currentPage++;
                });
              }
            },
          ),
        )
      ]),
    );
  }

  _onWillPop(BuildContext context) {
    if (_currentPage == 1) {
      Navigator.popUntil(context, ModalRoute.withName("/security"));
    } else if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }
}
