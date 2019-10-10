import 'dart:async';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_profile/pos_profile_bloc.dart';
import 'package:breez/bloc/pos_profile/pos_profile_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/avatar_picker.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';

class PosSettingsPage extends StatelessWidget { 

  @override
  Widget build(BuildContext context) {
    var posProfileBloc = AppBlocsProvider.of<POSProfileBloc>(context);
    return new StreamBuilder<POSProfileModel>(
        stream: posProfileBloc.posProfileStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _PosSettingsPage(posProfileBloc, snapshot.data);
          }

          return StaticLoader();
        });
  }
}

class _PosSettingsPage extends StatefulWidget {
  _PosSettingsPage(this._posProfileBloc, this.currentProfile);

  final String _title = "Settings";
  final int _logoScaledWidth = 200;
  final int _logoRenderedWidt = 96;
  final POSProfileBloc _posProfileBloc;
  final POSProfileModel currentProfile;

  @override
  State<StatefulWidget> createState() {
    return new PosSettingsPageState();
  }
}

class PosSettingsPageState extends State<_PosSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<Exception> _errorStreamSubscription;
  var _invoiceStringController = new TextEditingController();
  var _cancellationTimeoutValueController = new TextEditingController();
  final FocusNode _invoiceStringFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cancellationTimeoutValueController.text = widget.currentProfile.cancellationTimeoutValue.toString();
    _invoiceStringController.text = widget.currentProfile.invoiceString;
    _errorStreamSubscription = widget._posProfileBloc.profileUpdatesErrorStream.listen(
      (data) {},
      onError: (error) {
        promptError(context, "Upload Logo Failed", Text(error.toString()));
      },
    );
  }

  @override
  void dispose() {
    _invoiceStringFocusNode.dispose();
    _errorStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        leading: backBtn.BackButton(),
        automaticallyImplyLeading: false,
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: theme.BreezColors.blue[500],
        title: new Text(
          widget._title,
          style: theme.appBarTextStyle,
        ),
        elevation: 0.0,
      ),
      body: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Center(
              child: widget.currentProfile == null ||
                      widget.currentProfile != null && widget.currentProfile.uploadInProgress
                  ? new Padding(padding: EdgeInsets.only(top: 24.0),child:new Container(child:CircularProgressIndicator(),height: 88.0,width: 88.0,))
                  : AvatarPicker(widget.currentProfile.logoLocalPath,
                      (newSelectedImage) => widget._posProfileBloc.uploadLogoSink.add(newSelectedImage),
                      radius: 44.0,
                      renderLoading: widget.currentProfile == null ? false : widget.currentProfile.uploadInProgress,
                      scaledWidth: widget._logoScaledWidth,
                      renderedWidth: widget._logoRenderedWidt),
            ),
            new Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  maxLines: 1,
                  focusNode: _invoiceStringFocusNode,
                  controller: _invoiceStringController,
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.solid, color: Color.fromRGBO(255, 255, 255, 0.12))),
                    contentPadding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                    hintText: "Enter your business name",
                    hintStyle: TextStyle(
                        fontSize: 16.4,
                        color: Color.fromRGBO(255, 255, 255, 0.48),
                        letterSpacing: 0.0,
                        fontFamily: "IBMPlexSans"),
                  ),
                  style: new TextStyle(
                      fontFamily: "IBMPlexSansMedium", fontSize: 16.4, letterSpacing: 0.0, color: Colors.white),
                  onChanged: (text) {
                    widget._posProfileBloc.posProfileSink.add(widget.currentProfile.copyWith(invoiceString: text));
                  },
                ),
                new Padding(
                    padding: EdgeInsets.only(right: 13.0),
                    child: IconButton(
                      icon: new ImageIcon(
                        AssetImage("src/icon/edit.png"),
                        color: Colors.white,
                        size: 24.0,
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(_invoiceStringFocusNode);
                      },
                    )),
              ],
            ),
            new Container(
              padding: EdgeInsets.only(top: 32.0, bottom: 19.0, left: 16.0),
              child: new Text(
                "Payment Cancellation Timeout (in seconds)",
                style: TextStyle(
                    fontSize: 12.4, letterSpacing: 0.11, height: 1.24, color: Color.fromRGBO(255, 255, 255, 0.87)),
              ),
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 304.0,
                    child: new Padding(
                      padding: EdgeInsets.zero,
                      child: new Slider(
                          value: widget.currentProfile.cancellationTimeoutValue,
                          label: '${widget.currentProfile.cancellationTimeoutValue.toStringAsFixed(0)}',
                          min: 30.0,
                          max: 180.0,
                          divisions: 5,
                          onChanged: (double value) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _cancellationTimeoutValueController.text = value.toString();
                            widget._posProfileBloc.posProfileSink
                                .add(widget.currentProfile.copyWith(cancellationTimeoutValue: value));
                          }),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 16.0),
                    child: new Text(
                      num.parse(_cancellationTimeoutValueController.text).toStringAsFixed(0),
                      style: TextStyle(color: Colors.white, fontSize: 12.4, letterSpacing: 0.11),
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
