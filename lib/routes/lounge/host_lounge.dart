import 'package:breez/bloc/lounge/bloc.dart';
import 'package:breez/bloc/lounge/actions.dart';
import 'package:breez/bloc/lounge/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HostLounge extends StatefulWidget {
  final LoungesBloc loungesBloc;
  final Function(Lounge lounge) onCreate;

  const HostLounge(this.loungesBloc, this.onCreate);

  @override
  _HostLoungeState createState() => _HostLoungeState();
}

class _HostLoungeState extends State<HostLounge> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final String _title = "Host Lounge";
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: Add Lounge options
    return _buildScaffold(
      Padding(
        padding: EdgeInsets.only(top: 16, left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          onChanged: () => _formKey.currentState.save(),
          child: TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
                labelText: "Lounge Title",
                hintText: "Enter a lounge title",
                border: UnderlineInputBorder()),
            style: theme.FieldTextStyle.textStyle,
            validator: (text) {
              if (text.length == 0) {
                return "Lounge title is required.";
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScaffold(Widget body, [List<Widget> actions]) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          _title,
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
      bottomNavigationBar: SingleButtonBottomBar(
        text: "HOST LOUNGE",
        onPressed: () {
          {
            if (_formKey.currentState.validate()) {
              Lounge lounge =
                  Lounge(title: _titleController.text, isHosted: true);
              AddLounge addLounge = AddLounge(_titleController.text);

              widget.loungesBloc.actionsSink.add(addLounge);
              addLounge.future.then((_) {
                Navigator.pop(context);
                widget.onCreate(lounge);
              });
            }
          }
        },
      ),
    );
  }
}
