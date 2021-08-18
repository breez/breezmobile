import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/sats_rooms/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

import 'sats_room_item.dart';

const BOTTOM_PADDING = 8.0;

class SatsZonesList extends StatelessWidget {
  final List<SatsZone> _satsZones;

  SatsZonesList(this._satsZones);

  @override
  Widget build(BuildContext context) {
    if (_satsZones?.length == 0) {
      return _showNoSatsZonesText(context);
    } else {
      return ListView.builder(
          itemCount: _satsZones.length + 1,
          itemBuilder: (context, index) {
            // return the header
            if (index == 0) {
              return _buildHeader(context);
            }
            index -= 1;
            return SatsZoneItem(_satsZones[index]);
          });
    }
  }

  _showNoSatsZonesText(BuildContext context) {
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
              "Create a Sats Zone using the 'CREATE' button",
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

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: theme.customData[theme.themeId].paymentListBgColor,
          height: 60,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 0.0),
                child: Text(
                  "My Sats Zone",
                  style: Theme.of(context).accentTextTheme.subtitle2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
