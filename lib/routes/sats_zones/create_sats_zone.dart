import 'package:breez/bloc/sats_rooms/actions.dart';
import 'package:breez/bloc/sats_rooms/bloc.dart';
import 'package:breez/bloc/sats_rooms/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateSatsRoom extends StatefulWidget {
  final SatsZoneBloc satsRoomsBloc;

  const CreateSatsRoom(this.satsRoomsBloc);

  @override
  _CreateSatsRoomState createState() => _CreateSatsRoomState();
}

class _CreateSatsRoomState extends State<CreateSatsRoom> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final String _title = "Create Sats Room";
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: Add Sats Room options
    return _buildScaffold(
      Padding(
        padding: EdgeInsets.only(top: 16, left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          onChanged: () => _formKey.currentState.save(),
          child: TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
                labelText: "Room Title",
                hintText: "Enter a room title",
                border: UnderlineInputBorder()),
            style: theme.FieldTextStyle.textStyle,
            validator: (text) {
              if (text.length == 0) {
                return "Room title is required.";
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
        text: "CREATE SATS ROOM",
        onPressed: () {
          {
            if (_formKey.currentState.validate()) {
              var satsRoomID = Uuid().v1().split('-')[0];
              AddSatsZone addSatsRoom = AddSatsZone(
                SatsZone(
                  zoneID: satsRoomID,
                  title: _titleController.text,
                ),
              );

              widget.satsRoomsBloc.actionsSink.add(addSatsRoom);
              addSatsRoom.future.then((_) {
                Navigator.pop(context);
              });
            }
          }
        },
      ),
    );
  }
}
