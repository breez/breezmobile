import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'verify_backup_phrase_page.dart';

class GenerateBackupPhrasePage extends StatefulWidget {
  final List<String> mnemonics;
  final int phase;
  final List randomlySelectedIndexes;
  final List<String> verifyInputList;
  final List<String> verificationFormValues;

  GenerateBackupPhrasePage({this.mnemonics, this.phase, this.randomlySelectedIndexes, this.verifyInputList, this.verificationFormValues});

  @override
  GenerateBackupPhrasePageState createState() => new GenerateBackupPhrasePageState();
}

class GenerateBackupPhrasePageState extends State<GenerateBackupPhrasePage> {
  List<String> _mnemonics;

  double itemHeight;
  double itemWidth;

  int _phase;

  @override
  void initState() {
    _phase = widget.phase ?? 1;
    _mnemonics = widget.mnemonics ?? bip39.generateMnemonic(strength: 256).split(" ");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 16) / 8;
    itemWidth = (MediaQuery.of(context).size.width) / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(
            onPressed: () {
              if (_phase == 1) {
                Navigator.popUntil(context, ModalRoute.withName("/security"));
              } else if (_phase > 1) {
                setState(() {
                  _phase--;
                });
              }
            },
          ),
          title: new Text(
            "Write these words ($_phase/2)",
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
      body: _buildMnemonicSeedList(),
      bottomNavigationBar: _buildNextBtn(),
    );
  }

  Padding _buildMnemonicSeedList() {
    return Padding(
      padding: const EdgeInsets.only(top: 44),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        children: List.generate(
          _mnemonics.length ~/ 2,
          (index) {
            return _buildMnemonicItem(
                index + (_mnemonics.length ~/ 2 * (_phase - 1)), _mnemonics[index + (_mnemonics.length ~/ 2 * (_phase - 1))]);
          },
        ),
      ),
    );
  }

  _buildMnemonicItem(int index, String mnemonic) {
    return Center(
      child: Container(
        height: 48,
        width: 150,
        decoration: BoxDecoration(border: Border.all(color: Colors.white30)),
        child: Center(
          child: Text(
            '${index + 1}. $mnemonic',
            style: theme.mnemonicsTextStyle,
          ),
        ),
      ),
    );
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
              if (_phase + 1 == 3) {
              } else {
                setState(() {
                  _phase++;
                });
              }
            },
          ),
        )
      ]),
    );
  }
}
