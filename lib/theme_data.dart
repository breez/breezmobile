import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

final ThemeData breezThemeData = new ThemeData(
  brightness: Brightness.light,
  backgroundColor: BreezColors.blue[500],
  accentColor: BreezColors.white[500],
);

final VendorTheme bitrefill = VendorTheme(iconFgColor: Color.fromRGBO(68, 155, 247, 1.0), iconBgColor: Color(0xFFffffff),textColor: Color.fromRGBO(47, 47, 47, 1.0));
final VendorTheme fastbitcoins = VendorTheme(iconBgColor: Color(0xFFff7c10), iconFgColor: Color(0xFF1f2a44), textColor: Color(0xFF1f2a44));
final VendorTheme lnpizza = VendorTheme(iconBgColor:  Color(0xFF000000), iconFgColor: Color(0xFFf8e71c));
final TextTheme appBarTextTheme = new TextTheme(title:appBarTextStyle);
final IconThemeData appBarIconTheme = new IconThemeData(color: BreezColors.white[500]);
final TextStyle drawerItemTextStyle = new TextStyle(height: 1.2, letterSpacing: 0.25, fontSize: 14.3);
final TextStyle notificationTextStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 10.0, letterSpacing: 0.06, height: 1.10);
final TextStyle headline = new TextStyle(color: BreezColors.grey[600],fontSize: 26.0);
final TextStyle subtitle = new TextStyle(color: BreezColors.grey[600],fontSize: 14.3,letterSpacing: 0.2);
final TextStyle addFundsBtnStyle = new TextStyle(color: BreezColors.white[400], fontSize: 16.0, letterSpacing: 1.25);
final TextStyle autoCompleteStyle = new TextStyle(color: Colors.black, fontSize: 14.0);
final TextStyle dialogBlackStye = TextStyle(color: Colors.black, fontSize: 16.0, height: 1.5);
final TextStyle dialogGrayStyle = TextStyle(color: BreezColors.grey[500], fontSize: 16.0, height: 1.5);
final TextStyle blueLinkStyle = new TextStyle(color: BreezColors.blue[500], fontSize: 16.0, height: 1.5);
final TextStyle avatarDialogStyle = new TextStyle(color: BreezColors.blue[900], fontSize: 16.4, letterSpacing: 0.15, fontFamily:'IBMPlexSansMedium');
final TextStyle errorStyle = new TextStyle(color: errorColor, fontSize: 12.0);
final TextStyle textStyle = new TextStyle(color: BreezColors.white[400], fontSize: 16.0);
final TextStyle navigationDrawerHandleStyle = new TextStyle(fontSize: 16.0, letterSpacing: 0.2, color:  Color.fromRGBO(255, 255, 255, 0.6));
final TextStyle warningStyle = new TextStyle(color: errorColor, fontSize: 16.0);
final TextStyle createInvoiceDialogWarningStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 12.0);
final TextStyle alertStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 16.0, height: 1.5);
final TextStyle bolt11Style = new TextStyle(color: BreezColors.grey[500], fontSize: 9.0);
final TextStyle alertTitleStyle = new TextStyle(color: BreezColors.grey[600], fontSize: 20.5, letterSpacing: 0.25);
final TextStyle instructionStyle = new TextStyle(color: BreezColors.white[400], fontSize: 14.3);
final TextStyle validatorStyle = new TextStyle(color: Color(0xFFe3b42f), fontSize: 12.0, height: 1.25);
final TextStyle welcomeTextStyle = new TextStyle(color: BreezColors.white[500], fontSize: 16.0, height: 1.1);
final TextStyle skipStyle = new TextStyle(color: BreezColors.white[500], fontSize: 16.0, letterSpacing: 1.25);
final TextStyle buttonStyle = new TextStyle(color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25);
final TextStyle whiteButtonStyle = new TextStyle(color: BreezColors.white[500], fontSize: 14.3, letterSpacing: 1.25);
final TextStyle appBarLogoStyle = new TextStyle(color: BreezColors.logo[2], fontSize: 23.5, letterSpacing: 0.15, fontFamily:'Breez Logo', height: 0.9);
final TextStyle posTransactionTitleStyle = new TextStyle(color: BreezColors.white[500], fontSize: 14.4, letterSpacing: 0.44, height: 1.28);
final TextStyle transactionTitleStyle = new TextStyle(color: BreezColors.white[500], fontSize: 14.3, letterSpacing: 0.25, height: 1.2);
final TextStyle transactionSubtitleStyle = new TextStyle(color: BreezColors.white[200], fontSize: 12.3, letterSpacing: 0.4, height: 1.16);
final TextStyle transactionAmountStyle = new TextStyle(color: BreezColors.white[500], fontSize: 16.4, letterSpacing: 0.5, height: 1.28, fontFamily:'IBMPlexSansMedium');
final TextStyle posWithdrawalTransactionTitleStyle = new TextStyle(color: Color.fromRGBO(255,255,255, 0.7), fontSize: 14.4, letterSpacing: 0.44, height: 1.28);
final TextStyle posWithdrawalTransactionAmountStyle = new TextStyle(color: Color.fromRGBO(255,255,255, 0.7), fontSize: 16.4, letterSpacing: 0.5, height: 1.28, fontFamily:'IBMPlexSansMedium');
final TextStyle paymentRequestTitleStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 16.0, letterSpacing: 0.0, height: 1.28, fontFamily:'IBMPlexSansMedium');
final TextStyle paymentRequestSubtitleStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 16.0, letterSpacing: 0.0, height: 1.28);
final TextStyle paymentRequestAmountStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 24.0, letterSpacing: 0.0, height: 1.28, fontFamily:'IBMPlexSansMedium');
final TextStyle cancelButtonStyle = TextStyle(color: BreezColors.red[600], letterSpacing: 1.25, height: 1.16, fontSize: 14.0, fontFamily: "IBMPlexSansMedium");
final TextStyle invoiceMemoStyle = new TextStyle( color: BreezColors.grey[500], fontSize: 12.3, height: 1.16, letterSpacing: 0.4);
final TextStyle invoiceChargeAmountStyle = TextStyle(color: BreezColors.white[500], fontSize: 14.3, height: 1.16, letterSpacing: 1.25);
final TextStyle invoiceAmountStyle = TextStyle(color: BreezColors.grey[600], fontSize: 22.0, height: 1.32, letterSpacing: 0.2);
final TextStyle currencyDropdownStyle = TextStyle(color: BreezColors.grey[600], fontSize: 16.3, height: 1.32, letterSpacing: 0.15);
final TextStyle numPadNumberStyle = new TextStyle(color: BreezColors.white[500], fontSize: 20.0, letterSpacing: 0.18);
final TextStyle numPadAdditionStyle = new TextStyle(color: BreezColors.white[500], fontSize: 32.0, letterSpacing: 0.18);
final TextStyle appBarTextStyle = new TextStyle(color: BreezColors.white[500], fontSize: 18.0, letterSpacing: 0.22);
final TextStyle smallTextStyle = new TextStyle(color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09);
final TextStyle linkStyle = new TextStyle(color: BreezColors.white[300], fontSize: 12.3, letterSpacing: 0.4, height: 1.2, decoration: TextDecoration.underline);
final TextStyle restoreLinkStyle = new TextStyle(color: BreezColors.white[300], fontSize: 12.0, letterSpacing: 0.4, height: 1.2, decoration: TextDecoration.underline);
final TextStyle snackBarStyle = new TextStyle(color: BreezColors.white[500], fontSize: 14.0, letterSpacing: 0.25, height: 1.2);
final TextStyle sessionNotificationStyle = TextStyle(fontSize: 14.2);
final TextStyle sessionNotificationWarningStyle = new TextStyle(color: errorColor, fontSize: 14.2);
final TextStyle paymentDetailsTitleStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 14.0, letterSpacing: 0.0, height: 1.28, fontFamily:'IBMPlexSansMedium');
final TextStyle paymentDetailsSubtitleStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 14.0, letterSpacing: 0.0, height: 1.28);
final TextStyle paymentDetailsNodeIdStyle = new TextStyle(color: BreezColors.grey[500], fontSize: 10.0, letterSpacing: 0.0, height: 1.28);
final TextStyle fastbitcoinsTextStyle = new TextStyle(color: fastbitcoins.textColor, fontSize: 11.0, letterSpacing: 0.0, fontFamily:'ComfortaaBold');
final TextStyle vendorTitleStyle = new  TextStyle(color: BreezColors.white[500], fontSize: 36.0, fontWeight: FontWeight.w600, letterSpacing: 1.1, fontFamily: 'Roboto');
final BoxDecoration boxDecoration = new BoxDecoration(border: new Border(bottom: new BorderSide(color: BreezColors.white[500], width: 1.5)));
final BoxDecoration autoCompleteBoxDecoration = new BoxDecoration(color: BreezColors.white[500], borderRadius: new BorderRadius.circular(3.0));
final BoxDecoration qrImageStyle = new BoxDecoration(border: new Border.all(color: BreezColors.blue[800], width: 1.0), borderRadius: new BorderRadius.circular(3.0));
final Color whiteColor = BreezColors.white[500];
final Color massageBackgroundColor = BreezColors.blue[900];
final Color messageTextColor = BreezColors.white[300];
final Color snackBarBackgroundColor = BreezColors.blue[300];
final Color avatarBackgroundColor = BreezColors.blue[500];
final Color sessionAvatarBackgroundColor = BreezColors.white[500];
final Color pulseAnimationColor = Color.fromRGBO(100, 155, 230, 1.0);
final Color marketplaceButtonColor = Color.fromRGBO(229,	238,	251, 0.09);
final Color errorColor = Color(0xffffe685);
final Color circularLoaderColor = BreezColors.blue[200].withOpacity(0.7);
final BorderSide greyBorderSide = BorderSide(color: BreezColors.grey[500]);

class FieldTextStyle {
  FieldTextStyle._();
  static TextStyle textStyle = new TextStyle(color: BreezColors.white[500], fontSize: 16.4, letterSpacing: 0.15);
  static TextStyle labelStyle = new TextStyle(color: BreezColors.white[200], letterSpacing: 0.4);
}

class BreezColors {
  BreezColors._(); // this basically makes it so you can instantiate this class

  static const Map<int, Color> blue = const <int, Color>{
    200: const Color.fromRGBO(0, 117, 255, 1.0),
    300: const Color.fromRGBO(51, 69, 96, 1.0),
    500: const Color.fromRGBO(5, 93, 235, 1.0),
    800: const Color.fromRGBO(51, 255, 255, 0.3),
    900: const Color.fromRGBO(19 , 85 , 191, 1.0),
  };

  static const Map<int, Color> white = const <int, Color>{
    200: const Color(0x99ffffff),
    300: const Color(0xccffffff),
    400: const Color(0xdeffffff),
    500: const Color(0xFFffffff),
  };

  static const Map<int, Color> grey = const <int, Color>{
    500: const Color(0xFF4d5d75),
    600: const Color(0xFF334560),
  };

  static const Map<int, Color> red = const <int, Color>{
    500: const Color(0xFFff2036),
    600: const Color(0xFFff1d24),
  };
  static const Map<int, Color> logo = const <int, Color>{
    1: const Color.fromRGBO(0, 156, 249, 1.0),
    2: const Color.fromRGBO(0, 137, 252, 1.0),
    3: const Color.fromRGBO(0, 120, 253, 1.0),
  };
}

class VendorTheme {
  final Color iconBgColor;
  final Color iconFgColor;
  final Color textColor;

  VendorTheme({this.iconBgColor, this.iconFgColor, this.textColor});
}