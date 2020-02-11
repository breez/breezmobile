import 'dart:async';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/pos_profile/pos_profile_bloc.dart';
import 'package:breez/bloc/pos_profile/pos_profile_model.dart';
import 'package:breez/widgets/avatar_picker.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/theme_data.dart' as theme;

class PosSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var posProfileBloc = AppBlocsProvider.of<POSProfileBloc>(context);
    return StreamBuilder<POSProfileModel>(
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
    return PosSettingsPageState();
  }
}

class PosSettingsPageState extends State<_PosSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<Exception> _errorStreamSubscription;
  var _invoiceStringController = TextEditingController();
  var _cancellationTimeoutValueController = TextEditingController();
  final FocusNode _invoiceStringFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cancellationTimeoutValueController.text =
        widget.currentProfile.cancellationTimeoutValue.toString();
    _invoiceStringController.text = widget.currentProfile.invoiceString;
    _errorStreamSubscription =
        widget._posProfileBloc.profileUpdatesErrorStream.listen(
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
            Center(
              child: widget.currentProfile == null ||
                      widget.currentProfile != null &&
                          widget.currentProfile.uploadInProgress
                  ? Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Container(
                        child: CircularProgressIndicator(),
                        height: 88.0,
                        width: 88.0,
                      ))
                  : AvatarPicker(
                      widget.currentProfile.logoLocalPath,
                      (newSelectedImage) => widget
                          ._posProfileBloc.uploadLogoSink
                          .add(newSelectedImage),
                      radius: 44.0,
                      renderLoading: widget.currentProfile == null
                          ? false
                          : widget.currentProfile.uploadInProgress,
                      scaledWidth: widget._logoScaledWidth,
                      renderedWidth: widget._logoRenderedWidt),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  maxLines: 1,
                  focusNode: _invoiceStringFocusNode,
                  controller: _invoiceStringController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Color.fromRGBO(255, 255, 255, 0.12))),
                    contentPadding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                    hintText: "Enter your business name",
                    hintStyle: TextStyle(
                        fontSize: 16.4,
                        color: Color.fromRGBO(255, 255, 255, 0.48),
                        letterSpacing: 0.0,
                        fontFamily: "IBMPlexSans"),
                  ),
                  style: TextStyle(
                      fontFamily: "IBMPlexSansMedium",
                      fontSize: 16.4,
                      letterSpacing: 0.0,
                      color: Colors.white),
                  onChanged: (text) {
                    widget._posProfileBloc.posProfileSink.add(
                        widget.currentProfile.copyWith(invoiceString: text));
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(right: 13.0),
                    child: IconButton(
                      icon: ImageIcon(
                        AssetImage("src/icon/edit.png"),
                        color: Colors.white,
                        size: 24.0,
                      ),
                      onPressed: () {
                        FocusScope.of(context)
                            .requestFocus(_invoiceStringFocusNode);
                      },
                    )),
              ],
            ),
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
                            widget._posProfileBloc.posProfileSink.add(widget
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
