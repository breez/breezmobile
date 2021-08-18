import 'package:breez/bloc/sats_zones/actions.dart';
import 'package:breez/bloc/sats_zones/bloc.dart';
import 'package:breez/bloc/sats_zones/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateSatsZone extends StatefulWidget {
  final SatsZonesBloc satsZonesBloc;

  const CreateSatsZone(this.satsZonesBloc);

  @override
  _CreateSatsZoneState createState() => _CreateSatsZoneState();
}

class _CreateSatsZoneState extends State<CreateSatsZone> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final String _title = "Create Sats Zone";
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: Add Sats Zone options
    return _buildScaffold(
      Padding(
        padding: EdgeInsets.only(top: 16, left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          onChanged: () => _formKey.currentState.save(),
          child: TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
                labelText: "Zone Title",
                hintText: "Enter a zone title",
                border: UnderlineInputBorder()),
            style: theme.FieldTextStyle.textStyle,
            validator: (text) {
              if (text.length == 0) {
                return "Zone title is required.";
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
        text: "CREATE SATS ZONE",
        onPressed: () {
          {
            if (_formKey.currentState.validate()) {
              var satsZoneID = Uuid().v1().split('-')[0];
              AddSatsZone addSatsZone = AddSatsZone(
                SatsZone(
                  zoneID: satsZoneID,
                  title: _titleController.text,
                ),
              );

              widget.satsZonesBloc.actionsSink.add(addSatsZone);
              addSatsZone.future.then((_) {
                Navigator.pop(context);
              });
            }
          }
        },
      ),
    );
  }
}
