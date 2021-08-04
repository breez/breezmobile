import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/services/breezlib/data/rpc.pbgrpc.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

void showLNURLSuccessAction(BuildContext context, SuccessAction sa) {
  final AutoSizeGroup _labelGroup = AutoSizeGroup();
  promptMessage(
      context,
      "Purchase Information",
      Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                sa.description?.isNotEmpty != true
                    ? SizedBox(
                        height: 0,
                      )
                    : _TextMessage(
                        description: sa.description, group: _labelGroup),
                sa.message?.isNotEmpty != true
                    ? SizedBox(
                        height: 0,
                      )
                    : _TextMessage(description: sa.message, group: _labelGroup),
                sa.url?.isNotEmpty != true
                    ? SizedBox(
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: _URLRow(sharedValue: sa.url),
                      ),
              ])));
}

class _TextMessage extends StatelessWidget {
  final String description;
  final AutoSizeGroup group;

  const _TextMessage({Key key, this.description, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        description,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class _URLRow extends StatelessWidget {
  final String sharedValue;

  const _URLRow({Key key, this.sharedValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _expansionTileTheme = Theme.of(context).copyWith(
        unselectedWidgetColor: Theme.of(context).primaryTextTheme.button.color,
        colorScheme: ColorScheme.dark(
          secondary: Theme.of(context).primaryTextTheme.button.color,
        ),
        dividerColor: Theme.of(context).backgroundColor);
    return Theme(
        data: _expansionTileTheme,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: GestureDetector(
                    onTap: () => launch(sharedValue),
                    child: Text('$sharedValue',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        maxLines: 4,
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontSize: 12, color: Colors.blue)),
                  ),
                ),
              ),
              Expanded(
                  flex: 0,
                  child: Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.zero,
                            iconSize: 16.0,
                            color:
                                Theme.of(context).primaryTextTheme.button.color,
                            icon: Icon(
                              IconData(0xe90b, fontFamily: 'icomoon'),
                            ),
                            onPressed: () {
                              ServiceInjector()
                                  .device
                                  .setClipboardText(sharedValue);
                              showFlushbar(context,
                                  message: "link was copied to your clipboard.",
                                  duration: Duration(seconds: 4));
                            },
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16.0,
                            color:
                                Theme.of(context).primaryTextTheme.button.color,
                            icon: Icon(Icons.share),
                            onPressed: () {
                              ShareExtend.share(sharedValue, "text");
                            },
                          ),
                        ],
                      )))
            ]));
  }
}
