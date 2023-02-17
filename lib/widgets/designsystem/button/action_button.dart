import 'package:breez/widgets/designsystem/variant.dart';
import 'package:breez/widgets/preview/preview.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

const _kDisabledOpacity = 0.8;

class ActionButton extends StatelessWidget {
  final String text;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final bool enabled;
  final bool fill;
  final Variant variant;
  final VoidCallback onPressed;

  const ActionButton({
    Key key,
    this.text,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.fill = false,
    this.variant = Variant.primary,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final button = ElevatedButton(
      onPressed: enabled ? (onPressed ?? () {}) : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          _backgroundColor(themeData),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          text != null
              ? const EdgeInsets.symmetric(horizontal: 16.0)
              : const EdgeInsets.all(0.0),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(40, 40),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          variant == Variant.primary || variant == Variant.fab
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: _foregroundColor(themeData),
                    width: 2.0,
                  ),
                ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (leadingIcon != null)
            Icon(
              leadingIcon,
              color: _foregroundColor(themeData),
            ),
          if (leadingIcon != null && text != null) const SizedBox(width: 8.0),
          if (text != null)
            Text(
              text,
              style: themeData.textTheme.labelLarge.copyWith(
                color: _foregroundColor(themeData),
              ),
            ),
          if (trailingIcon != null && text != null) const SizedBox(width: 8.0),
          if (trailingIcon != null)
            Icon(
              trailingIcon,
              color: _foregroundColor(themeData),
            ),
        ],
      ),
    );

    return fill
        ? button
        : Center(
            child: button,
          );
  }

  Color _backgroundColor(ThemeData themeData) {
    switch (variant) {
      case Variant.primary:
        return enabled
            ? themeData.primaryColorDark
            : themeData.primaryColorDark.withOpacity(_kDisabledOpacity);
      case Variant.secondary:
        return enabled
            ? themeData.colorScheme.onSurface
            : themeData.colorScheme.onSurface.withOpacity(_kDisabledOpacity);
      case Variant.fab:
        return enabled
            ? theme.buttonColor
            : theme.buttonColor.withOpacity(_kDisabledOpacity);
    }
    throw Exception('Unknown variant: $variant');
  }

  Color _foregroundColor(ThemeData themeData) {
    switch (variant) {
      case Variant.primary:
        return enabled
            ? themeData.colorScheme.onSurface
            : themeData.colorScheme.onSurface.withOpacity(_kDisabledOpacity);
      case Variant.secondary:
        return enabled
            ? themeData.primaryColorDark
            : themeData.primaryColorDark.withOpacity(_kDisabledOpacity);
      case Variant.fab:
        return enabled
            ? themeData.textTheme.labelLarge.color
            : themeData.textTheme.labelLarge.color
                .withOpacity(_kDisabledOpacity);
    }
    throw Exception('Unknown variant: $variant');
  }
}

// Preview

void main() {
  runApp(const Preview([
    ActionButton(
      text: 'Primary',
    ),
    ActionButton(
      text: 'Secondary',
      variant: Variant.secondary,
    ),
    ActionButton(
      text: 'Disabled',
      enabled: false,
    ),
    ActionButton(
      text: 'With leading icon',
      leadingIcon: Icons.arrow_back,
    ),
    ActionButton(
      text: 'With trailing icon',
      trailingIcon: Icons.arrow_forward,
    ),
    ActionButton(
      text: 'With leading and trailing icons',
      leadingIcon: Icons.add,
      trailingIcon: Icons.expand_more,
    ),
    ActionButton(
      text: 'Fill',
      fill: true,
    ),
    ActionButton(
      text: 'Variant secondary',
      variant: Variant.secondary,
    ),
    ActionButton(
      text: 'Variant secondary disabled',
      variant: Variant.secondary,
      enabled: false,
    ),
    ActionButton(
      variant: Variant.secondary,
      trailingIcon: Icons.close,
    ),
    ActionButton(
      variant: Variant.secondary,
      enabled: false,
      trailingIcon: Icons.close,
    ),
    ActionButton(
      leadingIcon: Icons.more_vert,
    ),
    ActionButton(
      leadingIcon: Icons.more_vert,
      enabled: false,
    ),
  ]));
}
