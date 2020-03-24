import 'package:flutter/material.dart';

String themeId = "BLUE";

class CustomData {
  BlendMode loaderColorBlendMode;
  String loaderAssetPath;

  CustomData({this.loaderColorBlendMode, this.loaderAssetPath});
}

final Map<String, ThemeData> themeMap = {"BLUE": blueTheme, "DARK": darkTheme};
final CustomData blueThemeCustomData = CustomData(
    loaderColorBlendMode: BlendMode.multiply,
    loaderAssetPath: 'src/images/breez_loader_blue.gif');
final CustomData darkThemeCustomData = CustomData(
    loaderColorBlendMode: BlendMode.srcIn,
    loaderAssetPath: 'src/images/breez_loader_dark.gif');
final Map<String, CustomData> customData = {
  "BLUE": blueThemeCustomData,
  "DARK": darkThemeCustomData
};

final ThemeData blueTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color.fromRGBO(255, 255, 255, 1.0),
  primaryColorDark: BreezColors.blue[900],
  primaryColorLight: Color.fromRGBO(0, 133, 251, 1.0),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(0, 133, 251, 1.0)),
  accentColor: Colors.white,
  canvasColor: BreezColors.blue[500],
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    textTheme: TextTheme(
      headline6:
          TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    color: Colors.transparent,
    actionsIconTheme: IconThemeData(color: Color.fromRGBO(0, 120, 253, 1.0)),
    brightness: Brightness.dark,
  ),
  dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
          color: BreezColors.grey[600], fontSize: 20.5, letterSpacing: 0.25),
      contentTextStyle:
          TextStyle(color: BreezColors.grey[500], fontSize: 16.0, height: 1.5),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)))),
  dialogBackgroundColor: Colors.transparent,
  errorColor: Color(0xffffe685),
  dividerColor: Color(0x33ffffff),
  buttonColor: Colors.white,
  cardColor: BreezColors.blue[500],
  highlightColor: BreezColors.blue[200],
  textTheme: TextTheme(
    subtitle2: TextStyle(
        color: BreezColors.grey[600], fontSize: 14.3, letterSpacing: 0.2),
    headline5: TextStyle(color: BreezColors.grey[600], fontSize: 26.0),
    button: TextStyle(
        color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25),
    headline4: TextStyle(
      color: Color(0xffffe685),
      fontSize: 18.0,
    ),
  ),
  primaryTextTheme: TextTheme(
    headline4: TextStyle(
        color: BreezColors.grey[500],
        fontSize: 14.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    headline3: TextStyle(
        color: BreezColors.grey[500],
        fontSize: 14.0,
        letterSpacing: 0.0,
        height: 1.28),
    headline5: TextStyle(
        color: BreezColors.grey[500],
        fontSize: 24.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    bodyText2: TextStyle(
        color: BreezColors.blue[900],
        fontSize: 16.4,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    subtitle2: TextStyle(
        color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09),
    button: TextStyle(
        color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25),
    caption: TextStyle(color: BreezColors.grey[500], fontSize: 12.0),
  ),
  textSelectionColor: Color.fromRGBO(255, 255, 255, 0.5),
  primaryIconTheme: IconThemeData(color: BreezColors.grey[500]),
  textSelectionHandleColor: Color(0xFF0085fb),
  fontFamily: 'IBMPlexSans',
);

// Color(0xFF121212) values are tbd
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF7aa5eb),
  primaryColorDark: Color(0xFF00081C),
  primaryColorLight: Color(0xFF4B89EB),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: Color(0xFF4B89EB)),
  accentColor: Colors.white,
  canvasColor: Color(0xFF0c2031),
  backgroundColor: Color(0xFF152a3d),
  appBarTheme: AppBarTheme(
    textTheme: TextTheme(
      headline6:
          TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    color: Colors.white,
    actionsIconTheme: IconThemeData(color: Colors.white),
    brightness: Brightness.dark,
  ),
  dialogTheme: DialogTheme(
      titleTextStyle:
          TextStyle(color: Colors.white, fontSize: 20.5, letterSpacing: 0.25),
      contentTextStyle:
          TextStyle(color: Colors.white70, fontSize: 16.0, height: 1.5),
      backgroundColor: Color(0xFF152a3d),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)))),
  dialogBackgroundColor: Colors.transparent,
  errorColor: Color(0xFFeddc97),
  dividerColor: Color(0x337aa5eb),
  buttonColor: Color(0xFF4B89EB),
  cardColor: Color(0xFF121212),
  highlightColor: Color(0xFF4B88EB),
  textTheme: TextTheme(
    subtitle2:
        TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 0.2),
    headline5: TextStyle(color: Colors.white, fontSize: 26.0),
    button: TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 1.25),
    headline4: TextStyle(
      color: Color(0xffffe685),
      fontSize: 18.0,
    ),
  ),
  primaryTextTheme: TextTheme(
    headline4: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    headline3: TextStyle(
        color: Colors.white, fontSize: 14.0, letterSpacing: 0.0, height: 1.28),
    headline5: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    bodyText2: TextStyle(
        color: Colors.white,
        fontSize: 16.4,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    button: TextStyle(
        color: Color(0xFF7aa5eb), fontSize: 14.3, letterSpacing: 1.25),
    subtitle2: TextStyle(
        color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09),
    caption: TextStyle(color: BreezColors.white[400], fontSize: 12.0),
  ),
  primaryIconTheme: IconThemeData(color: Color(0xFF7aa5eb)),
  textSelectionColor: Color.fromRGBO(255, 255, 255, 0.5),
  textSelectionHandleColor: Color(0xFF0085fb),
  fontFamily: 'IBMPlexSans',
);

final VendorTheme bitrefill = VendorTheme(
    iconFgColor: Color.fromRGBO(68, 155, 247, 1.0),
    iconBgColor: Color(0xFFffffff),
    textColor: Color.fromRGBO(47, 47, 47, 1.0));
final VendorTheme fastbitcoins = VendorTheme(
    iconBgColor: Color(0xFFff7c10),
    iconFgColor: Color(0xFF1f2a44),
    textColor: Color(0xFF1f2a44));
final VendorTheme lnpizza =
    VendorTheme(iconBgColor: Color(0xFF000000), iconFgColor: Color(0xFFf8e71c));
final VendorTheme xsats = VendorTheme(
  iconBgColor: Color(0xFF000000),
);
final VendorTheme lightnite = VendorTheme(
  iconBgColor: Color(0xFF530709),
);

final Map<String, VendorTheme> vendorTheme = {
  "bitrefill": bitrefill,
  "fastbitcoins": fastbitcoins,
  "ln.pizza": lnpizza,
  "xsats": xsats,
  "lightnite": lightnite
};

final TextStyle drawerItemTextStyle =
    TextStyle(height: 1.2, letterSpacing: 0.25, fontSize: 14.3);
final TextStyle notificationTextStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 10.0,
    letterSpacing: 0.06,
    height: 1.10);
final TextStyle addFundsBtnStyle = TextStyle(
    color: BreezColors.white[400], fontSize: 16.0, letterSpacing: 1.25);
final TextStyle addFundsItemsStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 1.25,
    height: 1.16,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle bottomSheetMenuItemStyle = TextStyle(
    color: BreezColors.white[400], fontSize: 14.3, letterSpacing: 0.55);
final TextStyle autoCompleteStyle =
    TextStyle(color: Colors.black, fontSize: 14.0);
final TextStyle blueLinkStyle =
    TextStyle(color: BreezColors.blue[500], fontSize: 16.0, height: 1.5);
final TextStyle avatarDialogStyle = TextStyle(
    color: BreezColors.blue[900],
    fontSize: 16.4,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle errorStyle = TextStyle(color: errorColor, fontSize: 12.0);
final TextStyle textStyle =
    TextStyle(color: BreezColors.white[400], fontSize: 16.0);
final TextStyle navigationDrawerHandleStyle = TextStyle(
    fontSize: 16.0,
    letterSpacing: 0.2,
    color: Color.fromRGBO(255, 255, 255, 0.6));
final TextStyle warningStyle = TextStyle(color: errorColor, fontSize: 16.0);
final TextStyle instructionStyle =
    TextStyle(color: BreezColors.white[400], fontSize: 14.3);
final TextStyle validatorStyle =
    TextStyle(color: Color(0xFFe3b42f), fontSize: 12.0, height: 1.25);
final TextStyle welcomeTextStyle =
    TextStyle(color: BreezColors.white[500], fontSize: 16.0, height: 1.1);
final TextStyle skipStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 16.0, letterSpacing: 1.25);
final TextStyle buttonStyle = TextStyle(
    color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25);
final TextStyle whiteButtonStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 14.3, letterSpacing: 1.25);
final TextStyle appBarLogoStyle = TextStyle(
    color: BreezColors.logo[2],
    fontSize: 23.5,
    letterSpacing: 0.15,
    fontFamily: 'Breez Logo',
    height: 0.9);
final TextStyle posTransactionTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.4,
    letterSpacing: 0.44,
    height: 1.28);
final TextStyle transactionTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 0.25,
    height: 1.2);
final TextStyle transactionSubtitleStyle = TextStyle(
    color: BreezColors.white[200],
    fontSize: 12.3,
    letterSpacing: 0.4,
    height: 1.16);
final TextStyle transactionAmountStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 16.4,
    letterSpacing: 0.5,
    height: 1.28,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle posWithdrawalTransactionTitleStyle = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.7),
    fontSize: 14.4,
    letterSpacing: 0.44,
    height: 1.28);
final TextStyle posWithdrawalTransactionAmountStyle = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.7),
    fontSize: 16.4,
    letterSpacing: 0.5,
    height: 1.28,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle cancelButtonStyle = TextStyle(
    color: BreezColors.red[600],
    letterSpacing: 1.25,
    height: 1.16,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle backupPhraseInformationTextStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 0.4,
    height: 1.16);
final TextStyle backupPhraseConfirmationTextStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 1.25,
    height: 1.16,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle mnemonicsTextStyle = TextStyle(
    color: BreezColors.white[400],
    fontSize: 16.4,
    letterSpacing: 0.73,
    height: 1.25);
final TextStyle invoiceMemoStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 12.3,
    height: 1.16,
    letterSpacing: 0.4);
final TextStyle invoiceChargeAmountStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    height: 1.16,
    letterSpacing: 1.25);
final TextStyle invoiceAmountStyle = TextStyle(
    color: BreezColors.grey[600],
    fontSize: 18.0,
    height: 1.32,
    letterSpacing: 0.2);
final TextStyle currencyDropdownStyle = TextStyle(
    color: BreezColors.grey[600],
    fontSize: 16.3,
    height: 1.32,
    letterSpacing: 0.15);
final TextStyle numPadNumberStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 20.0, letterSpacing: 0.18);
final TextStyle numPadAdditionStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 32.0, letterSpacing: 0.18);
final TextStyle smallTextStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09);
final TextStyle linkStyle = TextStyle(
    color: BreezColors.white[300],
    fontSize: 12.3,
    letterSpacing: 0.4,
    height: 1.2,
    decoration: TextDecoration.underline);
final TextStyle restoreLinkStyle = TextStyle(
    color: BreezColors.white[300],
    fontSize: 12.0,
    letterSpacing: 0.4,
    height: 1.2,
    decoration: TextDecoration.underline);
final TextStyle snackBarStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.0,
    letterSpacing: 0.25,
    height: 1.2);
final TextStyle sessionActionBtnStyle = TextStyle(fontSize: 12.3);
final TextStyle sessionNotificationStyle = TextStyle(fontSize: 14.2);
final TextStyle sessionNotificationWarningStyle =
    TextStyle(color: errorColor, fontSize: 14.2);
final TextStyle paymentDetailsTitleStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 14.0,
    letterSpacing: 0.0,
    height: 1.28,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle paymentDetailsSubtitleStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 14.0,
    letterSpacing: 0.0,
    height: 1.28);
final TextStyle fastbitcoinsTextStyle = TextStyle(
    color: fastbitcoins.textColor,
    fontSize: 11.0,
    letterSpacing: 0.0,
    fontFamily: 'ComfortaaBold');
final TextStyle vendorTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    fontFamily: 'Roboto');
final BoxDecoration boxDecoration = BoxDecoration(
    border:
        Border(bottom: BorderSide(color: BreezColors.white[500], width: 1.5)));
final BoxDecoration autoCompleteBoxDecoration = BoxDecoration(
    color: BreezColors.white[500], borderRadius: BorderRadius.circular(3.0));
final Color whiteColor = BreezColors.white[500];
final Color snackBarBackgroundColor = BreezColors.blue[300];
final Color avatarBackgroundColor = BreezColors.blue[500];
final Color sessionAvatarBackgroundColor = BreezColors.white[500];
final Color pulseAnimationColor = Color.fromRGBO(100, 155, 230, 1.0);
final Color marketplaceButtonColor = Color.fromRGBO(229, 238, 251, 0.09);
final Color errorColor = Color(0xffffe685);
final Color circularLoaderColor = BreezColors.blue[200].withOpacity(0.7);
final BorderSide greyBorderSide = BorderSide(color: BreezColors.grey[500]);

class FieldTextStyle {
  FieldTextStyle._();

  static TextStyle textStyle = TextStyle(
      color: BreezColors.white[500], fontSize: 16.4, letterSpacing: 0.15);
  static TextStyle labelStyle =
      TextStyle(color: BreezColors.white[200], letterSpacing: 0.4);
}

class BreezColors {
  BreezColors._(); // this basically makes it so you can instantiate this class

  static const Map<int, Color> blue = <int, Color>{
    200: Color.fromRGBO(0, 117, 255, 1.0),
    300: Color.fromRGBO(51, 69, 96, 1.0),
    500: Color.fromRGBO(5, 93, 235, 1.0),
    800: Color.fromRGBO(51, 255, 255, 0.3),
    900: Color.fromRGBO(19, 85, 191, 1.0),
  };

  static const Map<int, Color> white = <int, Color>{
    200: Color(0x99ffffff),
    300: Color(0xccffffff),
    400: Color(0xdeffffff),
    500: Color(0xFFffffff),
  };

  static const Map<int, Color> grey = <int, Color>{
    500: Color(0xFF4d5d75),
    600: Color(0xFF334560),
  };

  static const Map<int, Color> red = <int, Color>{
    500: Color(0xFFff2036),
    600: Color(0xFFff1d24),
  };
  static const Map<int, Color> logo = <int, Color>{
    1: Color.fromRGBO(0, 156, 249, 1.0),
    2: Color.fromRGBO(0, 137, 252, 1.0),
    3: Color.fromRGBO(0, 120, 253, 1.0),
  };
}

class VendorTheme {
  final Color iconBgColor;
  final Color iconFgColor;
  final Color textColor;

  VendorTheme({this.iconBgColor, this.iconFgColor, this.textColor});
}

extension CustomStyles on TextTheme {
  TextStyle get itemTitleStyle =>
      TextStyle(color: BreezColors.white[500], fontSize: 16.4);

  TextStyle get itemPriceStyle => TextStyle(
      color: BreezColors.white[500], letterSpacing: 0.5, fontSize: 14.3);
}

extension CustomIconThemes on IconThemeData {
  IconThemeData get deleteBadgeIconTheme =>
      IconThemeData(color: BreezColors.grey[500], size: 20.0);
}
