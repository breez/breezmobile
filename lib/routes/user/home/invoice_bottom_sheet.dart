import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class InvoiceBottomSheet extends StatefulWidget {
  final InvoiceBloc invoiceBloc;
  final bool isSmallView;

  InvoiceBottomSheet(this.invoiceBloc, this.isSmallView);

  @override
  State createState() => InvoiceBottomSheetState();
}

class InvoiceBottomSheetState extends State<InvoiceBottomSheet> with TickerProviderStateMixin {
  bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        transform: isExpanded ? Matrix4.translationValues(0, 0, 0) : Matrix4.translationValues(0, 112.0, 0),
        duration: Duration(milliseconds: 150),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildInvoiceMenuItem("INVOICE", "src/icon/invoice.png", () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              }, isFirst: true),
              _buildInvoiceMenuItem("PAY", "src/icon/qr_scan.png", () async {
                String decodedQr = await BarcodeScanner.scan();
                widget.invoiceBloc.decodeInvoiceSink.add(decodedQr);
              }),
              _buildInvoiceMenuItem("CREATE", "src/icon/paste.png", () => Navigator.of(context).pushNamed('/create_invoice')),
            ]));
  }

  Widget _buildInvoiceMenuItem(String title, String iconPath, Function function, {bool isFirst = false}) {
    return AnimatedContainer(
      width: widget.isSmallView ? 56.0 : 136.0,
      height: isFirst ? 50.0 : 56.0,
      duration: Duration(milliseconds: 150),
      child: RaisedButton(
        onPressed: function,
        color: isFirst ? Colors.white : Color.fromRGBO(0, 133, 251, 1.0),
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        shape: isFirst
            ? RoundedRectangleBorder(borderRadius: new BorderRadius.only(topLeft: Radius.circular(20.0)))
            : Border(top: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.12), width: 1, style: BorderStyle.solid)),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            children: widget.isSmallView
                ? <Widget>[
                    ImageIcon(
                      AssetImage(iconPath),
                      color: isFirst ? Color.fromRGBO(0, 133, 251, 1.0) : Colors.white,
                      size: 24.0,
                    )
                  ]
                : <Widget>[
                    ImageIcon(
                      AssetImage(iconPath),
                      color: isFirst ? Color.fromRGBO(0, 133, 251, 1.0) : Colors.white,
                      size: 24.0,
                    ),
                    Padding(padding: EdgeInsets.only(left: 8.0)),
                    Expanded(
                      child: AutoSizeText(
                        title.toUpperCase(),
                        style: theme.bottomSheetMenuItemStyle.copyWith(
                          color: isFirst ? Color.fromRGBO(0, 133, 251, 1.0) : Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ]),
      ),
    );
  }
}
