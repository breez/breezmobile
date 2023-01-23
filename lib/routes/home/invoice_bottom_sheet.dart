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
import 'package:breez_translations/breez_translations_locales.dart';

class InvoiceBottomSheet extends StatefulWidget {
  final InvoiceBloc invoiceBloc;
  final bool isSmallView;
  final UserProfileBloc userProfileBloc;
  final GlobalKey firstPaymentItemKey;

  const InvoiceBottomSheet(
    this.invoiceBloc,
    this.isSmallView,
    this.userProfileBloc,
    this.firstPaymentItemKey,
  );

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
    final texts = context.texts();
    final navigator = Navigator.of(context);

    return StreamBuilder<BreezUserModel>(
      stream: widget.userProfileBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return AnimatedContainer(
          transform: isExpanded
              ? Matrix4.translationValues(0, 0, 0)
              : Matrix4.translationValues(0, 112.0, 0),
          duration: Duration(milliseconds: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildInvoiceMenuItem(
                context,
                texts.invoice_bottom_sheet_action_invoice,
                "src/icon/invoice.png",
                () => setState(() {
                  isExpanded = !isExpanded;
                }),
                snapshot.data.themeId,
                isFirst: true,
              ),
              _buildInvoiceMenuItem(
                context,
                texts.invoice_bottom_sheet_action_pay,
                "src/icon/qr_scan.png",
                () async {
                  final decodedQr = await Navigator.pushNamed<String>(
                    context,
                    "/qr_scan",
                  );
                  if (decodedQr == null) return;

                  if (decodedQr.isEmpty) {
                    showFlushbar(
                      context,
                      message: texts.invoice_bottom_sheet_error_qrcode,
                    );
                    return;
                  }

                  final nodeID = parseNodeId(decodedQr);
                  if (nodeID == null) {
                    widget.invoiceBloc.decodeInvoiceSink.add(decodedQr);
                  } else {
                    navigator.push(FadeInRoute(
                      builder: (_) => SpontaneousPaymentPage(
                        nodeID,
                        widget.firstPaymentItemKey,
                      ),
                    ));
                  }
                },
                snapshot.data.themeId,
              ),
              _buildInvoiceMenuItem(
                context,
                texts.invoice_bottom_sheet_action_receive,
                "src/icon/paste.png",
                () => navigator.pushNamed('/create_invoice'),
                snapshot.data.themeId,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInvoiceMenuItem(
    BuildContext context,
    String title,
    String iconPath,
    Function function,
    String themeId, {
    bool isFirst = false,
  }) {
    final themeData = Theme.of(context);
    final blueTheme = themeId == "BLUE";

    return AnimatedContainer(
      width: widget.isSmallView ? 56.0 : 126.0,
      height: isFirst ? 50.0 : 56.0,
      duration: Duration(milliseconds: 150),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: blueTheme
              ? isFirst
                  ? Colors.white
                  : themeData.primaryColorLight
              : isFirst
                  ? themeData.buttonColor
                  : themeData.backgroundColor,
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          shape: isFirst
              ? RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                  ),
                )
              : Border(
                  top: BorderSide(
                    color: themeData.dividerColor.withOpacity(0.12),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
        ),
        onPressed: function,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: widget.isSmallView
              ? [
                  ImageIcon(
                    AssetImage(iconPath),
                    color: blueTheme && isFirst
                        ? themeData.primaryColorLight
                        : Colors.white,
                    size: 24.0,
                  )
                ]
              : [
                  ImageIcon(
                    AssetImage(iconPath),
                    color: blueTheme && isFirst
                        ? themeData.primaryColorLight
                        : Colors.white,
                    size: 24.0,
                  ),
                  Padding(padding: const EdgeInsets.only(left: 8.0)),
                  Expanded(
                    child: AutoSizeText(
                      title.toUpperCase(),
                      style: theme.bottomSheetMenuItemStyle.copyWith(
                        color: blueTheme && isFirst
                            ? themeData.primaryColorLight
                            : Colors.white,
                      ),
                      maxLines: 1,
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                      group: _autoSizeGroup,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
