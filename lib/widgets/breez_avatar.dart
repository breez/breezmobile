import 'dart:io';

import 'package:breez/bloc/user_profile/profile_animal.dart';
import 'package:breez/bloc/user_profile/profile_color.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter_svg/svg.dart';

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

      if (avatarURL.startsWith("breez://avatar/possale")) {
        return _PosSaleAvatar(radius, avatarBgColor);
      }

      if (Uri.tryParse(avatarURL)?.scheme?.startsWith("http") ?? false) {
        return _NetworkImageAvatar(avatarURL, radius);
      }

      if (Uri.tryParse(avatarURL)?.scheme?.startsWith("data") ?? false) {
        return _DataImageAvatar(avatarURL, radius);
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
    final texts = context.texts();
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.sessionAvatarBackgroundColor,
      child: Icon(
        profileAnimalFromName(animal, texts).iconData,
        size: radius * 2 * 0.75,
        color: profileColorFromName(color, texts).color,
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
        child: ExtendedImage.network(avatarURL),
      ),
    );
  }
}

class _DataImageAvatar extends StatelessWidget {
  final double radius;
  final String avatarURL;

  _DataImageAvatar(this.avatarURL, this.radius);

  @override
  Widget build(BuildContext context) {
      final uri = UriData.parse(this.avatarURL);
      final _bytes = uri.contentAsBytes();
    return CircleAvatar(
        backgroundColor: theme.sessionAvatarBackgroundColor,
      radius: radius,
      child: ClipOval(
        child: Image.memory(_bytes) ,
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

class _PosSaleAvatar extends StatelessWidget {
  final double radius;
  final Color backgroundColor;

  const _PosSaleAvatar(
    this.radius,
    this.backgroundColor,
  );

  @override
  Widget build(BuildContext context) {
    final size = 0.6 * radius * 2;
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: radius,
      child: SvgPicture.asset(
        "src/icon/pos_sale_avatar.svg",
        color: theme.BreezColors.blue[500],
        width: size,
        height: size,
      ),
    );
  }
}
