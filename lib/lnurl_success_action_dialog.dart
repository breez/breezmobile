import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/services/breezlib/data/rpc.pbgrpc.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
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
                    : Container(
                        height: 36.0,
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AutoSizeText(
                                sa.description,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                group: _labelGroup,
                              ),
                            ),
                          ],
                        ),
                      ),
                sa.message?.isNotEmpty != true
                    ? SizedBox(
                        height: 0,
                      )
                    : Container(
                        height: 36.0,
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AutoSizeText(
                                sa.message,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4
                                    .copyWith(color: Colors.black),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                group: _labelGroup,
                              ),
                            ),
                          ],
                        ),
                      ),
                sa.url?.isNotEmpty != true
                    ? SizedBox(
                        height: 0,
                      )
                    : Container(
                        height: 36.0,
                        padding: EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            launch(sa.url);
                          },
                          child: Text(
                            sa.url,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ))
              ])));
}
