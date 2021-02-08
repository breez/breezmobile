import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';

class SetHeightHintPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SetHeightHintPageState();
  }
}

class _SetHeightHintPageState extends State<SetHeightHintPage> {
  TextEditingController _channelPointController = new TextEditingController();
  TextEditingController _hintCacheController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _channelIDFocus = FocusNode();
  final FocusNode _heightHintFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _channelIDFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return Scaffold(
        appBar: AppBar(
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            textTheme: Theme.of(context).appBarTheme.textTheme,
            backgroundColor: Theme.of(context).canvasColor,
            automaticallyImplyLeading: false,
            leading: backBtn.BackButton(),
            title: Text(
              "Set Height Hint",
              style: Theme.of(context).appBarTheme.textTheme.headline6,
            ),
            elevation: 0.0),
        body: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    focusNode: _channelIDFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      _channelIDFocus.requestFocus();
                    },
                    controller: _channelPointController,
                    decoration: InputDecoration(
                      labelText: "Enter a channel point",
                    ),
                    style: theme.FieldTextStyle.textStyle,
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: 12.0),
                  TextFormField(
                    focusNode: _heightHintFocus,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: "Enter height hint",
                    ),
                    controller: _hintCacheController,
                    style: theme.FieldTextStyle.textStyle,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (_) {
                      _formKey.currentState.validate();
                    },
                  )
                ],
              )),
        ),
        bottomNavigationBar: SingleButtonBottomBar(
            text: "SUBMIT",
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                try {
                  final blockHeight = Int64.parseInt(_hintCacheController.text);
                  final action = ResetClosedChannelChainInfoAction(
                    _channelPointController.text,
                    blockHeight,
                  );
                  accountBloc.userActionsSink.add(action);
                  await action.future;
                  Navigator.of(context).pop(true);
                } catch (e) {
                  promptError(
                      context,
                      "Set Height Hint",
                      Text(e.toString(),
                          style:
                              Theme.of(context).dialogTheme.contentTextStyle));
                }
              }
            }));
  }
}
