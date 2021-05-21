import 'dart:io';

import 'package:breez/bloc/user_profile/default_profile_generator.dart'
    as generator;
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

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

  BreezAvatar(this.avatarURL, {this.radius = 20.0, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    Color avatarBgColor =
        this.backgroundColor ?? theme.sessionAvatarBackgroundColor;

    if (avatarURL != null && avatarURL.isNotEmpty) {
      if (avatarURL.startsWith("breez://profile_image?")) {
        var queryParams = Uri.parse(avatarURL).queryParameters;
        return _GeneratedAvatar(
            radius, queryParams["animal"], queryParams["color"], avatarBgColor);
      }

      if (avatarURL.startsWith("src/icon/vendors/")) {
        return _VendorAvatar(radius, avatarURL);
      }

      if (Uri.tryParse(avatarURL)?.scheme?.startsWith("http") ?? false) {
        return _NetworkImageAvatar(avatarURL, radius);
      }

      return _FileImageAvatar(radius, avatarURL);
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
        child: SvgPicture.asset("src/icon/alien.svg",
            color: Color.fromARGB(255, 0, 166, 68),
            width: 0.70 * radius * 2,
            height: 0.70 *
                radius *
                2) // Used to be: Icon(Icons.person, color: theme.BreezColors.blue[500], size: 0.7 * radius * 2,)
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
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.sessionAvatarBackgroundColor,
      child: Icon(
        IconData(0xe900 + generator.animals.indexOf(animal),
            fontFamily: 'animals'),
        size: radius * 2 * 0.75,
        color: _breezAvatarColors[color.toLowerCase()],
      ),
    );
  }
}

class _FileImageAvatar extends StatelessWidget {
  final double radius;
  final String filePath;

  _FileImageAvatar(this.radius, this.filePath);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.yellow,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image(
          image: FileImage(
            File(filePath),
          ),
        ),
      ),
    );
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: OptimizedCacheImage(
          imageUrl: avatarURL,
          imageBuilder: (context, imageProvider) => Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VendorAvatar extends StatelessWidget {
  final double radius;
  final String avatarURL;

  _VendorAvatar(this.radius, this.avatarURL);

  Widget _fastbitcoinsAvatar() {
    return CircleAvatar(
      backgroundColor: theme.fastbitcoins.iconBgColor,
      radius: radius,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ImageIcon(
          AssetImage(avatarURL),
          color: theme.fastbitcoins.iconFgColor,
          size: 0.6 * radius * 2,
        ),
      ),
    );
  }

  Widget _vendorAvatar() {
    String _vendorName =
        new RegExp("(?<=vendors/)(.*)(?=_logo)").stringMatch(avatarURL);
    var _bgColor = theme.vendorTheme[_vendorName]?.iconBgColor ?? Colors.white;
    var _fgColor =
        theme.vendorTheme[_vendorName]?.iconFgColor ?? Colors.transparent;
    return CircleAvatar(
      radius: radius,
      child: Container(
        decoration: ShapeDecoration(
            color: _bgColor,
            shape: CircleBorder(side: BorderSide(color: _bgColor)),
            image: DecorationImage(
                image: AssetImage(avatarURL),
                colorFilter: ColorFilter.mode(_fgColor, BlendMode.color))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (avatarURL.contains("fastbitcoins")) {
      return _fastbitcoinsAvatar();
    } else {
      return _vendorAvatar();
    }
  }
}
