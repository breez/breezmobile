import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String themeId = "DARK";

class CustomData {
  BlendMode loaderColorBlendMode;
  String loaderAssetPath;
  Color pendingTextColor;
  Color dashboardBgColor;
  Color paymentListBgColor;
  Color paymentListDividerColor;
  Color navigationDrawerHeaderBgColor;
  Color navigationDrawerBgColor;

  CustomData(
      {this.loaderColorBlendMode,
      this.loaderAssetPath,
      this.pendingTextColor,
      this.dashboardBgColor,
      this.paymentListBgColor,
      this.paymentListDividerColor,
      this.navigationDrawerHeaderBgColor,
      this.navigationDrawerBgColor});
}

final Map<String, ThemeData> themeMap = {"BLUE": blueTheme, "DARK": darkTheme};
final CustomData blueThemeCustomData = CustomData(
  loaderColorBlendMode: BlendMode.multiply,
  loaderAssetPath: 'src/images/breez_loader_blue.gif',
  dashboardBgColor: Colors.white,
  pendingTextColor: const Color(0xff4D88EC),
  paymentListBgColor: const Color(0xFFf9f9f9),
  paymentListDividerColor: const Color.fromRGBO(0, 0, 0, 0.12),
  navigationDrawerBgColor: BreezColors.blue[500],
  navigationDrawerHeaderBgColor: const Color.fromRGBO(0, 103, 255, 1),
);
final CustomData darkThemeCustomData = CustomData(
  loaderColorBlendMode: BlendMode.srcIn,
  loaderAssetPath: 'src/images/breez_loader_dark.gif',
  pendingTextColor: const Color(0xff4D88EC),
  dashboardBgColor: const Color(0xFF0D1F33),
  paymentListBgColor: const Color(0xFF152a3d),
  paymentListDividerColor: const Color.fromRGBO(255, 255, 255, 0.12),
  navigationDrawerBgColor: const Color(0xFF152a3d),
  navigationDrawerHeaderBgColor: const Color.fromRGBO(13, 32, 50, 1),
);
final Map<String, CustomData> customData = {
  "BLUE": blueThemeCustomData,
  "DARK": darkThemeCustomData
};

final ThemeData blueTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromRGBO(255, 255, 255, 1.0),
  primaryColorDark: BreezColors.blue[900],
  primaryColorLight: const Color.fromRGBO(0, 133, 251, 1.0),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(0, 133, 251, 1.0),
  ),
  canvasColor: BreezColors.blue[500],
  bottomAppBarTheme: const BottomAppBarTheme(
    elevation: 0,
    color: Color(0xFF0085fb),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    backgroundColor: BreezColors.blue[500],
    iconTheme: const IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    actionsIconTheme: const IconThemeData(
      color: Color.fromRGBO(0, 120, 253, 1.0),
    ),
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        letterSpacing: 0.22,
      ),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        letterSpacing: 0.22,
      ),
    ).titleLarge,
  ),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(
      color: BreezColors.grey[600],
      fontSize: 20.5,
      letterSpacing: 0.25,
    ),
    contentTextStyle: TextStyle(
      color: BreezColors.grey[500],
      fontSize: 16.0,
      height: 1.5,
    ),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  ),
  dialogBackgroundColor: Colors.transparent,
  dividerColor: const Color(0x33ffffff),
  cardColor: BreezColors.blue[500],
  highlightColor: BreezColors.blue[200],
  textTheme: TextTheme(
    titleSmall: TextStyle(
      color: BreezColors.grey[600],
      fontSize: 14.3,
      letterSpacing: 0.2,
    ),
    headlineSmall: TextStyle(color: BreezColors.grey[600], fontSize: 26.0),
    labelLarge: TextStyle(
      color: BreezColors.blue[500],
      fontSize: 14.3,
      letterSpacing: 1.25,
    ),
    headlineMedium: const TextStyle(
      color: Color(0xffffe685),
      fontSize: 18.0,
    ),
    titleLarge: const TextStyle(
      color: Colors.white,
      fontSize: 12.3,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.22,
    ),
  ),
  primaryTextTheme: TextTheme(
    headlineMedium: TextStyle(
      color: BreezColors.grey[500],
      fontSize: 14.0,
      letterSpacing: 0.0,
      height: 1.28,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    displaySmall: TextStyle(
      color: BreezColors.grey[500],
      fontSize: 14.0,
      letterSpacing: 0.0,
      height: 1.28,
    ),
    headlineSmall: TextStyle(
      color: BreezColors.grey[500],
      fontSize: 24.0,
      letterSpacing: 0.0,
      height: 1.28,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    bodyMedium: TextStyle(
      color: BreezColors.blue[900],
      fontSize: 16.4,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    titleSmall: TextStyle(
      color: BreezColors.white[500],
      fontSize: 10.0,
      letterSpacing: 0.09,
    ),
    labelLarge: TextStyle(
      color: BreezColors.blue[500],
      fontSize: 14.3,
      letterSpacing: 1.25,
    ),
    bodySmall: TextStyle(
      color: BreezColors.grey[500],
      fontSize: 12.0,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color.fromRGBO(0, 133, 251, 0.25),
    selectionHandleColor: Color(0xFF0085fb),
  ),
  primaryIconTheme: IconThemeData(color: BreezColors.grey[500]),
  fontFamily: 'IBMPlexSans',
  textButtonTheme: const TextButtonThemeData(),
  outlinedButtonTheme: const OutlinedButtonThemeData(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF0085fb);
        } else {
          return const Color(0x8a000000);
        }
      },
    ),
  ),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: Colors.white,
    secondary: Colors.white,
    background: Colors.white,
    error: const Color(0xffffe685),
  ),
);

// Color(0xFF121212) values are tbd
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF0085FB),
  primaryColorDark: const Color(0xFF00081C),
  primaryColorLight: const Color(0xFF0085FB),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF0085fb),
  ),
  canvasColor: const Color(0xFF0c2031),
  bottomAppBarTheme: const BottomAppBarTheme(
    elevation: 0,
    color: Color(0xFF0085fb),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    backgroundColor: const Color(0xFF0c2031),
    iconTheme: const IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    actionsIconTheme: const IconThemeData(color: Colors.white),
    toolbarTextStyle: const TextTheme(
      titleLarge:
          TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge:
          TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
    ).titleLarge,
  ),
  dialogTheme: const DialogTheme(
    titleTextStyle:
        TextStyle(color: Colors.white, fontSize: 20.5, letterSpacing: 0.25),
    contentTextStyle:
        TextStyle(color: Colors.white70, fontSize: 16.0, height: 1.5),
    backgroundColor: Color(0xFF152a3d),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  ),
  dialogBackgroundColor: Colors.transparent,
  dividerColor: const Color(0x337aa5eb),
  cardColor: const Color(0xFF121212),
  highlightColor: const Color(0xFF0085fb),
  textTheme: const TextTheme(
    titleSmall:
        TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 0.2),
    headlineSmall: TextStyle(color: Colors.white, fontSize: 26.0),
    labelLarge:
        TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 1.25),
    headlineMedium: TextStyle(
      color: Color(0xffffe685),
      fontSize: 18.0,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 12.3,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.22,
    ),
  ),
  primaryTextTheme: TextTheme(
    headlineMedium: const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      letterSpacing: 0.0,
      height: 1.28,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    displaySmall: const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      letterSpacing: 0.0,
      height: 1.28,
    ),
    headlineSmall: const TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      letterSpacing: 0.0,
      height: 1.28,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontSize: 16.4,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    labelLarge: const TextStyle(
      color: Colors.white,
      fontSize: 14.3,
      letterSpacing: 1.25,
    ),
    titleSmall: TextStyle(
      color: BreezColors.white[500],
      fontSize: 10.0,
      letterSpacing: 0.09,
    ),
    bodySmall: TextStyle(
      color: BreezColors.white[400],
      fontSize: 12.0,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color.fromRGBO(255, 255, 255, 0.5),
    selectionHandleColor: Color(0xFF0085fb),
  ),
  primaryIconTheme: const IconThemeData(color: Colors.white),
  fontFamily: 'IBMPlexSans',
  textButtonTheme: const TextButtonThemeData(),
  outlinedButtonTheme: const OutlinedButtonThemeData(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B89EB)),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      return Colors.white;
    }),
  ),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: Colors.white,
    secondary: Colors.white,
    background: const Color(0xFF152a3d),
    error: const Color(0xFFeddc97),
  ),
);

final VendorTheme bitrefill = VendorTheme(iconBgColor: const Color(0xFF002B28));
final VendorTheme lnpizza = VendorTheme(
  iconBgColor: const Color(0xFF000000),
  iconFgColor: const Color(0xFFf8e71c),
);
final VendorTheme fixedfloat = VendorTheme(
  iconBgColor: const Color(0xFF0B4E7B),
);
final VendorTheme lnmarkets = VendorTheme(iconBgColor: const Color(0xFF384697));
final VendorTheme fold = VendorTheme(iconBgColor: const Color(0xFFFFCF30));
final VendorTheme boltz = VendorTheme(iconBgColor: const Color(0xFF001524));
final VendorTheme lightnite = VendorTheme(iconBgColor: const Color(0xFF530709));
final VendorTheme spendl = VendorTheme(iconBgColor: const Color(0xFFffffff));
final VendorTheme kollider = VendorTheme(
  iconBgColor: const Color.fromRGBO(21, 23, 25, 1),
  iconFgColor: const Color.fromRGBO(217, 227, 234, 1),
  textColor: const Color.fromRGBO(217, 227, 234, 1),
);
final VendorTheme fastbitcoins = VendorTheme(
    iconBgColor: const Color(0xFFff7c10),
    iconFgColor: const Color(0xFF1f2a44),
    textColor: const Color(0xFF1f2a44));
final VendorTheme xsats = VendorTheme(iconBgColor: const Color(0xFF000000));
final VendorTheme geyser =
    VendorTheme(iconBgColor: const Color.fromRGBO(41, 241, 205, 1));
final VendorTheme wavlake = VendorTheme(iconBgColor: const Color(0xFF171817));
final VendorTheme lightsats = VendorTheme(
  iconBgColor: Colors.black,
  iconFgColor: Colors.white,
);

final Map<String, VendorTheme> vendorTheme = {
  "bitrefill": bitrefill,
  "ln.pizza": lnpizza,
  "fixedfloat": fixedfloat,
  "lnmarkets": lnmarkets,
  "boltz": boltz,
  "lightnite": lightnite,
  "spendl": spendl,
  "kollider": kollider,
  "fastbitcoins": fastbitcoins,
  "xsats": xsats,
  "geyser": geyser,
  "fold": fold,
  "wavlake": wavlake,
  "lightsats": lightsats,
};

const TextStyle drawerItemTextStyle =
    TextStyle(height: 1.2, letterSpacing: 0.25, fontSize: 14.3);
final TextStyle notificationTextStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 10.0,
    letterSpacing: 0.06,
    height: 1.10);
final TextStyle addFundsBtnStyle = TextStyle(
    color: BreezColors.white[400], fontSize: 16.0, letterSpacing: 1.25);
const TextStyle bottomAppBarBtnStyle = TextStyle(
    color: Colors.white,
    fontSize: 13.5,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
    height: 1.24,
    fontFamily: 'IBMPlexSans');
const TextStyle bottomSheetTextStyle = TextStyle(
    fontFamily: 'IBMPlexSans',
    fontSize: 15,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w400,
    height: 1.30);
final TextStyle addFundsItemsStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 1.25,
    height: 1.16,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle bottomSheetMenuItemStyle = TextStyle(
    color: BreezColors.white[400], fontSize: 14.3, letterSpacing: 0.55);
const TextStyle autoCompleteStyle =
    TextStyle(color: Colors.black, fontSize: 14.0);
final TextStyle blueLinkStyle =
    TextStyle(color: BreezColors.blue[500], fontSize: 16.0, height: 1.5);
final TextStyle avatarDialogStyle = TextStyle(
    color: BreezColors.blue[900],
    fontSize: 16.4,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
const TextStyle errorStyle = TextStyle(color: errorColor, fontSize: 12.0);
final TextStyle textStyle =
    TextStyle(color: BreezColors.white[400], fontSize: 16.0);
const TextStyle navigationDrawerHandleStyle = TextStyle(
  fontSize: 16.0,
  letterSpacing: 0.2,
  color: Color.fromRGBO(255, 255, 255, 0.6),
);
const TextStyle warningStyle = TextStyle(color: errorColor, fontSize: 16.0);
final TextStyle instructionStyle =
    TextStyle(color: BreezColors.white[400], fontSize: 14.3);
const TextStyle validatorStyle =
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
const TextStyle posWithdrawalTransactionTitleStyle = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.7),
    fontSize: 14.4,
    letterSpacing: 0.44,
    height: 1.28);
const TextStyle posWithdrawalTransactionAmountStyle = TextStyle(
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
const TextStyle sessionActionBtnStyle = TextStyle(fontSize: 12.3);
const TextStyle sessionNotificationStyle = TextStyle(fontSize: 14.2);
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
final TextStyle fiatConversionTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 16.3,
    letterSpacing: 0.25,
    height: 1.2);
final TextStyle fiatConversionDescriptionStyle =
    TextStyle(color: BreezColors.white[200], fontSize: 14.3);
final BoxDecoration boxDecoration = BoxDecoration(
  border: Border(
    bottom: BorderSide(color: BreezColors.white[500], width: 1.5),
  ),
);
final BoxDecoration autoCompleteBoxDecoration = BoxDecoration(
  color: BreezColors.white[500],
  borderRadius: BorderRadius.circular(3.0),
);
final Color whiteColor = BreezColors.white[500];
const podcastHistoryTileBackGroundColorBlue = Color.fromRGBO(0, 117, 255, 1.0);

final Color snackBarBackgroundColor = BreezColors.blue[300];
final Color avatarBackgroundColor = BreezColors.blue[500];
final Color sessionAvatarBackgroundColor = BreezColors.white[500];
const Color pulseAnimationColor = Color.fromRGBO(100, 155, 230, 1.0);
const Color marketplaceButtonColor = Color.fromRGBO(229, 238, 251, 0.09);
const Color errorColor = Color(0xffffe685);
final Color circularLoaderColor = BreezColors.blue[200].withOpacity(0.7);
const Color warningBoxColor = Color.fromRGBO(251, 233, 148, 0.1);
final BorderSide greyBorderSide = BorderSide(color: BreezColors.grey[500]);

ThemeData get calendarTheme =>
    themeId == "BLUE" ? calendarLightTheme : calendarDarkTheme;

Color get buttonColor =>
    themeId == "BLUE" ? Colors.white : const Color(0xFF4B89EB);

final ThemeData calendarLightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light(
    primary: Color.fromRGBO(5, 93, 235, 1.0),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: BreezColors.blue[500]),
  ),
  dialogTheme: const DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
    ),
  ),
);

final ThemeData calendarDarkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF4B89EB), // header bg color
    onPrimary: Colors.white, // header text color
    onSurface: Colors.white, // body text color
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFF7aa5eb)),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF152a3d),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
    ),
  ),
);

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

extension ThemeExtensions on ThemeData {
  bool get isLightTheme => primaryColor == blueTheme.primaryColor;

  // Replaces accentTextTheme.bodyMedium
  TextStyle get statusTextStyle => isLightTheme
      ? TextStyle(color: BreezColors.grey[600])
      : const TextStyle(color: Colors.white);

  // Replaces accentTextTheme.titleSmall
  TextStyle get paymentItemTitleTextStyle => isLightTheme
      ? const TextStyle(
          color: Colors.black,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          height: 1.2,
          letterSpacing: 0.25,
        )
      : const TextStyle(
          color: Colors.white,
          fontSize: 12.25,
          fontWeight: FontWeight.w400,
          height: 1.2,
          letterSpacing: 0.25,
        );

  // Replaces accentTextTheme.titleLarge
  TextStyle get paymentItemAmountTextStyle => isLightTheme
      ? const TextStyle(
          color: Colors.black,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          height: 1.2,
          letterSpacing: 0.5,
        )
      : const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          height: 1.28,
          letterSpacing: 0.5,
        );

  // Replaces accentTextTheme.bodySmall
  TextStyle get paymentItemSubtitleTextStyle => isLightTheme
      ? const TextStyle(
          color: Color(0xb3303234),
          fontSize: 10.5,
          fontWeight: FontWeight.w400,
          height: 1.16,
          letterSpacing: 0.39,
        )
      : TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 10.5,
          fontWeight: FontWeight.w400,
          height: 1.16,
          letterSpacing: 0.39,
        );

  // Replaces accentTextTheme.headlineMedium
  TextStyle get walletDashboardHeaderTextStyle => isLightTheme
      ? const TextStyle(
          color: Color.fromRGBO(0, 133, 251, 1.0),
          fontSize: 30.0,
          fontWeight: FontWeight.w600,
          height: 1.52)
      : const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.w600,
          height: 1.56);

  // Replaces accentTextTheme.titleMedium
  TextStyle get walletDashboardFiatTextStyle => isLightTheme
      ? const TextStyle(
          color: Color.fromRGBO(0, 133, 251, 1.0),
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.24,
          letterSpacing: 0.2)
      : const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.24,
          letterSpacing: 0.2);
}
