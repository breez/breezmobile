import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/lounge/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

import 'lounge_item.dart';

const BOTTOM_PADDING = 8.0;

class LoungesList extends StatelessWidget {
  final List<Lounge> _lounges;

  LoungesList(this._lounges);

  @override
  Widget build(BuildContext context) {
    if (_lounges?.length == 0) {
      return _showNoLoungesText(context);
    } else {
      return ListView.builder(
          itemCount: _lounges.length + 1,
          itemBuilder: (context, index) {
            // return the header
            if (index == 0) {
              return _buildHeader(context);
            }
            index -= 1;
            return LoungeItem(_lounges[index]);
          });
    }
  }

  _showNoLoungesText(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.meeting_room_rounded,
            size: 75,
            color: theme.themeId == "BLUE"
                ? Color.fromRGBO(0, 133, 251, 1.0)
                : Color(0xFF4B89EB),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
            child: AutoSizeText(
              "Host a lounge using the 'HOST' button",
              style: theme.themeId == "BLUE"
                  ? Typography.material2018(platform: TargetPlatform.android)
                      .black
                      .headline6
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 14.3)
                  : Typography.material2018(platform: TargetPlatform.android)
                      .white
                      .headline6
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 14.3),
              textAlign: TextAlign.center,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    bool _isHostedView = true;
    var itemWidth = (MediaQuery.of(context).size.width) / 2;
    // This method is a work-around to center align the buttons
    // Use Align to stick items to center and set padding to give equal distance
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 64,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: EdgeInsets.only(right: itemWidth / 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Hosted",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .button
                                          .color
                                          .withOpacity(
                                              _isHostedView ? 1 : 0.5)),
                            )
                          ],
                        ),
                      )),
                ),
              ),
              Container(
                height: 20,
                child: VerticalDivider(
                  color: Theme.of(context).primaryTextTheme.button.color,
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(left: itemWidth / 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Entered",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .button
                                          .color
                                          .withOpacity(
                                              !_isHostedView ? 1 : 0.5)),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
