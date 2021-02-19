import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/entities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeedSelector extends StatefulWidget {
  final ValueChanged<double> onChanged;

  SpeedSelector({this.onChanged});

  @override
  _SpeedSelectorState createState() => _SpeedSelectorState();
}

class _SpeedSelectorState extends State<SpeedSelector> {
  @override
  Widget build(BuildContext context) {
    var settingsBloc = Provider.of<SettingsBloc>(context);

    return StreamBuilder<AppSettings>(
      stream: settingsBloc.settings,
      initialData: AppSettings.sensibleDefaults(),
      builder: (context, snapshot) {
        return DropdownButtonHideUnderline(
          child: ButtonTheme(
            child: DropdownButton(
              iconSize: 0,
              value: snapshot.data.playbackSpeed,
              style: Theme.of(context).primaryTextTheme.subtitle2,
              items: _buildDropdownMenuItems(),
              onChanged: (double value) {
                setState(() {
                  settingsBloc.setPlaybackSpeed(value);

                  if (widget.onChanged != null) {
                    widget.onChanged(value);
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  List<DropdownMenuItem<double>> _buildDropdownMenuItems() {
    var speeds = {
      0: 0.5,
      1: 1.0,
      2: 1.25,
      3: 1.5,
      4: 2.0,
    };

    var items = <DropdownMenuItem<double>>[];
    for (var value in speeds.values) {
      items.add(
        DropdownMenuItem(
          value: value,
          child: Text(
            '${(value % 1 == 0) ? value.toStringAsFixed(0).toString() : value}x',
            style: Theme.of(context).primaryTextTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).buttonColor,
                ),
          ),
        ),
      );
    }
    return items;
  }
}
