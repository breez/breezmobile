import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';

class PosSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    return StreamBuilder<BreezUserModel>(
        stream: _userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _PosSettingsPage(_userProfileBloc, snapshot.data);
          }

          return StaticLoader();
        });
  }
}

class _PosSettingsPage extends StatefulWidget {
  _PosSettingsPage(this._userProfileBloc, this.currentProfile);

  final String _title = "POS Settings";
  final UserProfileBloc _userProfileBloc;
  final BreezUserModel currentProfile;

  @override
  State<StatefulWidget> createState() {
    return PosSettingsPageState();
  }
}

class PosSettingsPageState extends State<_PosSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancellationTimeoutValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cancellationTimeoutValueController.text =
        widget.currentProfile.cancellationTimeoutValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: backBtn.BackButton(),
        automaticallyImplyLeading: false,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          widget._title,
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        elevation: 0.0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 32.0, bottom: 19.0, left: 16.0),
              child: Text(
                "Payment Cancellation Timeout (in seconds)",
                style: TextStyle(
                    fontSize: 12.4,
                    letterSpacing: 0.11,
                    height: 1.24,
                    color: Color.fromRGBO(255, 255, 255, 0.87)),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 304.0,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Slider(
                          value: widget.currentProfile.cancellationTimeoutValue,
                          label:
                              '${widget.currentProfile.cancellationTimeoutValue.toStringAsFixed(0)}',
                          min: 30.0,
                          max: 180.0,
                          divisions: 5,
                          onChanged: (double value) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _cancellationTimeoutValueController.text =
                                value.toString();
                            widget._userProfileBloc.userSink.add(widget
                                .currentProfile
                                .copyWith(cancellationTimeoutValue: value));
                          }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 16.0),
                    child: Text(
                      num.parse(_cancellationTimeoutValueController.text)
                          .toStringAsFixed(0),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.4,
                          letterSpacing: 0.11),
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
