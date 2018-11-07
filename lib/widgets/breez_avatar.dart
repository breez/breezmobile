import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/user_profile/default_profile_generator.dart' as generator;

final _breezAvatarColors = {
  "salmon": Color(0xFFFA8072),
  "blue": Color(0xFF4169E1),
  "turquoise": Color(0xFF00CED1),
  "orchid": Color(0xFF9932CC),
  "purple": Color(0xFF800080),
  "tomato": Color(0xFFFF6347),
  "cyan": Color(0xFF008B8B),
  "crimson": Color(0xFFDC143C),
  "orange": Color(0xFFFFA500),
  "lime": Color(0xFF32CD32),
  "pink": Color(0xFFFF69B4),
  "green": Color(0xFF00A644),
  "red": Color(0xFFFF2727),
  "yellow": Color(0xFFEECA0C),
  "azure": Color(0xFF00C4FF),
  "silver": Color(0xFF53687F),
  "magenta": Color(0xFFFF00FF),
  "olive": Color(0xFF808000),
  "violet": Color(0xFF7F01FF),
  "rose": Color(0xFF7F01FF),
  "wine": Color(0xFF950347),
  "mint": Color(0xFF7ADEB8),
  "indigo": Color(0xFF4B0082),
  "jade": Color(0xFF00B27A),
  "coral": Color(0xFFFF7F50),
};

class BreezAvatar extends StatelessWidget {
  final String avatarURL;
  final double radius;
  final Color backgroundColor;

  BreezAvatar(this.avatarURL, {this.radius = 20.0,  this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    Color avatarBgColor = this.backgroundColor ?? theme.sessionAvatarBackgroundColor;
    if (avatarURL != null && avatarURL.isNotEmpty) {
      if (avatarURL.startsWith("breez://profile_image?")) {
        var queryParams = Uri.parse(avatarURL).queryParameters;        
        return _GeneratedAvatar(radius, queryParams["animal"], queryParams["color"], avatarBgColor);
      }
      
      return _NetworkImageAvatar(avatarURL, radius);
    }

    return _UnknownAvatar(radius, avatarBgColor);
  }
}

class _UnknownAvatar extends StatelessWidget {
  final double radius;
  final Color backgroundColor;

  _UnknownAvatar(this.radius, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: radius,
      child: ImageIcon(
          AssetImage("src/icon/alien.png"),
          color: Color.fromARGB(255, 0, 166, 68),
          size: 0.70 * radius * 2,
      ) // Used to be: Icon(Icons.person, color: theme.BreezColors.blue[500], size: 0.7 * radius * 2,)
    );
  }
}

class _GeneratedAvatar extends StatelessWidget {
  final double radius;
  final String animal;
  final String color;
  final Color backgroundColor;

  _GeneratedAvatar(this.radius, this.animal, this.color, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: new BoxDecoration(
          color: theme.sessionAvatarBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: new Icon(IconData(0xe900 + generator.animals.indexOf(animal), fontFamily: 'animals'),
              size: radius * 2 * 0.75, color: _breezAvatarColors[color.toLowerCase()]),
        ));
  }
}

class _NetworkImageAvatar extends StatelessWidget {
  final double radius;
  final String avatarURL;

  _NetworkImageAvatar(this.avatarURL, this.radius);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AdvancedNetworkImage(avatarURL, useDiskCache: true),
    );
  }
}
