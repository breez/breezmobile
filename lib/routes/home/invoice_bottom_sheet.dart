import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/utils/node_id.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class InvoiceBottomSheet extends StatefulWidget {
  final InvoiceBloc invoiceBloc;
  final bool isSmallView;
  final UserProfileBloc userProfileBloc;
  final GlobalKey firstPaymentItemKey;

  InvoiceBottomSheet(this.invoiceBloc, this.isSmallView, this.userProfileBloc,
      this.firstPaymentItemKey);

  @override
  State createState() => InvoiceBottomSheetState();
}

class InvoiceBottomSheetState extends State<InvoiceBottomSheet>
    with TickerProviderStateMixin {
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BreezUserModel>(
        stream: widget.userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return AnimatedContainer(
              transform: isExpanded
                  ? Matrix4.translationValues(0, 0, 0)
                  : Matrix4.translationValues(0, 112.0, 0),
              duration: Duration(milliseconds: 150),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _buildInvoiceMenuItem("INVOICE", "src/icon/invoice.png",
                        () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    }, snapshot.data.themeId, isFirst: true),
                    _buildInvoiceMenuItem("PAY", "src/icon/qr_scan.png",
                        () async {
                      String decodedQr = await Navigator.pushNamed<String>(
                          context, "/qr_scan");
                      if (decodedQr.isEmpty) {
                        showFlushbar(context,
                            message: "QR code wasn't detected.");
                        return;
                      }
                      var nodeID = parseNodeId(decodedQr);
                      if (nodeID == null) {
                        widget.invoiceBloc.decodeInvoiceSink.add(decodedQr);
                      } else {
                        Navigator.of(context).push(FadeInRoute(
                          builder: (_) => SpontaneousPaymentPage(
                              nodeID, widget.firstPaymentItemKey),
                        ));
                      }
                    }, snapshot.data.themeId),
                    _buildInvoiceMenuItem(
                        "RECEIVE",
                        "src/icon/paste.png",
                        () =>
                            Navigator.of(context).pushNamed('/create_invoice'),
                        snapshot.data.themeId),
                  ]));
        });
  }

  Widget _buildInvoiceMenuItem(
      String title, String iconPath, Function function, String themeId,
      {bool isFirst = false}) {
    return AnimatedContainer(
      width: widget.isSmallView ? 56.0 : 126.0,
      height: isFirst ? 50.0 : 56.0,
      duration: Duration(milliseconds: 150),
      child: RaisedButton(
        onPressed: function,
        color: (themeId == "BLUE")
            ? isFirst
                ? Colors.white
                : Theme.of(context).primaryColorLight
            : isFirst
                ? Theme.of(context).buttonColor
                : Theme.of(context).backgroundColor,
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        shape: isFirst
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0)))
            : Border(
                top: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.12),
                    width: 1,
                    style: BorderStyle.solid)),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            children: widget.isSmallView
                ? <Widget>[
                    ImageIcon(
                      AssetImage(iconPath),
                      color: (themeId == "BLUE")
                          ? isFirst
                              ? Theme.of(context).primaryColorLight
                              : Colors.white
                          : Colors.white,
                      size: 24.0,
                    )
                  ]
                : <Widget>[
                    ImageIcon(
                      AssetImage(iconPath),
                      color: (themeId == "BLUE")
                          ? isFirst
                              ? Theme.of(context).primaryColorLight
                              : Colors.white
                          : Colors.white,
                      size: 24.0,
                    ),
                    Padding(padding: EdgeInsets.only(left: 8.0)),
                    Expanded(
                      child: AutoSizeText(
                        title.toUpperCase(),
                        style: theme.bottomSheetMenuItemStyle.copyWith(
                          color: (themeId == "BLUE")
                              ? isFirst
                                  ? Theme.of(context).primaryColorLight
                                  : Colors.white
                              : Colors.white,
                        ),
                        maxLines: 1,
                        minFontSize: MinFontSize(context).minFontSize,
                        stepGranularity: 0.1,
                        group: _autoSizeGroup,
                      ),
                    )
                  ]),
      ),
    );
  }
}
