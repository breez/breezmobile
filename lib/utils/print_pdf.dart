import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/print_parameters.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintService {
  final PrintParameters printParameters;

  PrintService(this.printParameters);

  printAsPDF() async {
    try {
      final doc = pw.Document();
      // Use TrueType font to support unicode characters
      final ltrFont = await rootBundle.load("fonts/IBMPlexSans-Regular.ttf");
      final rtlFont = await rootBundle.load("fonts/Hacen-Tunisia.ttf");
      final Map<String, ByteData> fontMap = {"ltr": ltrFont, "rtl": rtlFont};

      // Create PDF
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                pw.SizedBox(height: 8),
                _buildAddress(),
                pw.SizedBox(height: 40),
                _buildTable(fontMap),
                pw.SizedBox(height: 8),
                _buildDescription(),
                pw.SizedBox(height: 40),
                _buildPaymentInfo(),
              ],
            );
            // Center
          },
        ),
      );

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save());
    } on PlatformException catch (error) {
      throw error;
    }
  }

  _buildTitle() {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.max,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          printParameters.currentUser.name,
          style: pw.TextStyle(fontSize: 24, letterSpacing: 0.25),
        ),
        printParameters.paymentInfo?.creationTimestamp != null
            ? pw.Column(children: [
                pw.Text("Transaction Time",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, letterSpacing: 0.5)),
                pw.SizedBox(height: 4),
                pw.Text(
                    BreezDateUtils.formatYearMonthDayHourMinute(
                        DateTime.fromMillisecondsSinceEpoch(printParameters
                                .paymentInfo.creationTimestamp
                                .toInt() *
                            1000)),
                    style: pw.TextStyle(letterSpacing: 0.5)),
              ])
            : pw.SizedBox(),
      ],
    );
  }

  pw.Text _buildAddress() {
    return pw.Text(
      printParameters.currentUser.businessAddress.toString(),
      style: pw.TextStyle(
        fontSize: 16,
      ),
    );
  }

  pw.Table _buildTable(Map<String, ByteData> fontMap) {
    return pw.Table(
        children: _buildTableContent(fontMap),
        border: pw.TableBorder.all(width: 1),
        defaultColumnWidth: pw.IntrinsicColumnWidth());
  }

  _buildTableContent(Map<String, ByteData> fontMap) {
    List<pw.TableRow> saleLines = [];
    saleLines.add(_addTableHeader());
    saleLines = _addSales(saleLines, fontMap);
    saleLines.add(_addTotalLineToTable(fontMap));
    return saleLines;
  }

  _addTableHeader() {
    return pw.TableRow(
      children: [
        _buildTableItem("Item"),
        _buildTableItem("Price"),
        _buildTableItem("Quantity"),
        _buildTableItem("Amount"),
      ],
    );
  }

  _addSales(List<pw.TableRow> saleLines, Map<String, ByteData> fontMap) {
    printParameters.submittedSale.saleLines.forEach((saleLine) {
      CurrencyWrapper saleCurrency = CurrencyWrapper.fromShortName(
          saleLine.currency, printParameters.account);
      double priceInFiat = saleLine.pricePerItem;
      double totalPriceInFiat = saleLine.pricePerItem * saleLine.quantity;
      double totalPriceInSats =
          saleCurrency.satConversionRate * totalPriceInFiat;
      pw.TextStyle textStyle = pw.TextStyle(
        fontSize: 12.3,
      );
      saleLines.add(pw.TableRow(children: [
        _buildTableItem(
          saleLine.itemName,
          style: textStyle,
        ),
        _buildPrice(saleCurrency, priceInFiat, fontMap),
        _buildTableItem(
          "${saleLine.quantity}",
          style: textStyle,
        ),
        _buildAmount(totalPriceInFiat, totalPriceInSats,
            saleCurrency: saleCurrency, fontMap: fontMap),
      ]));
    });
    return saleLines;
  }

  _addTotalLineToTable(Map<String, ByteData> fontMap) {
    double totalAmount = printParameters.submittedSale.totalChargeSat /
        printParameters.currentCurrency.satConversionRate;
    return pw.TableRow(
      children: [
        pw.SizedBox(),
        pw.SizedBox(),
        _buildTableItem("Total"),
        _buildTableItem(
            "${printParameters.currentCurrency.format(totalAmount, removeTrailingZeros: true)} ${printParameters.currentCurrency.shortName}",
            style: pw.TextStyle(
              font: pw.Font.ttf(fontMap["ltr"]),
              fontSize: 14.3,
            )),
      ],
    );
  }

  pw.Padding _buildTableItem(String text, {pw.TextStyle style}) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: style ??
            pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 14.3,
            ),
      ),
    );
  }

  pw.Padding _buildPrice(CurrencyWrapper saleCurrency, double amount,
      Map<String, ByteData> fontMap,
      {bool addParenthesis = false,
      pw.EdgeInsets padding = const pw.EdgeInsets.all(8)}) {
    return pw.Padding(
      padding: padding,
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: (saleCurrency.rtl)
              ? [
                  pw.Text(
                      (addParenthesis ? "(" : "") +
                          "${saleCurrency.format(amount, removeTrailingZeros: true, includeCurrencySymbol: false)} ",
                      style: pw.TextStyle(
                        font: pw.Font.ttf(fontMap["ltr"]),
                        fontSize: 12.3,
                      )),
                  pw.Text("${saleCurrency.symbol}",
                      textDirection: pw.TextDirection.rtl,
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: pw.Font.ttf(fontMap["rtl"]),
                        fontSize: 12.3,
                      )),
                  pw.Text((addParenthesis ? " )" : ""),
                      style: pw.TextStyle(
                        font: pw.Font.ttf(fontMap["ltr"]),
                        fontSize: 12.3,
                      ))
                ]
              : [
                  pw.Text(
                    (addParenthesis ? "(" : "") +
                        "${saleCurrency.format(amount, removeTrailingZeros: true, includeCurrencySymbol: true)}" +
                        (addParenthesis ? ")" : ""),
                    textDirection: saleCurrency.rtl
                        ? pw.TextDirection.rtl
                        : pw.TextDirection.ltr,
                    style: pw.TextStyle(
                      font: saleCurrency.rtl
                          ? pw.Font.ttf(fontMap["rtl"])
                          : pw.Font.ttf(fontMap["ltr"]),
                      fontSize: 12.3,
                    ),
                  ),
                ]),
    );
  }

  pw.Row _buildAmount(double totalPriceInFiat, double totalPriceInSats,
      {Map<String, ByteData> fontMap, CurrencyWrapper saleCurrency}) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: (saleCurrency.symbol !=
                printParameters.currentCurrency.symbol)
            ? [
                _buildPrice(saleCurrency, totalPriceInFiat, fontMap,
                    padding: pw.EdgeInsets.only(left: 8, top: 8, bottom: 8)),
                _buildPrice(
                    printParameters.currentCurrency,
                    totalPriceInSats /
                        printParameters.currentCurrency.satConversionRate,
                    fontMap,
                    addParenthesis: true,
                    padding: pw.EdgeInsets.all(8)),
              ]
            : [
                _buildPrice(saleCurrency, totalPriceInFiat, fontMap),
              ]);
  }

  pw.Widget _buildDescription() {
    return printParameters.submittedSale.note != null
        ? pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
                pw.Text("Description:",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, letterSpacing: 0.5)),
                pw.SizedBox(height: 4),
                pw.Text(printParameters.submittedSale.note)
              ])
        : pw.SizedBox();
  }

  pw.Widget _buildPaymentInfo() {
    return printParameters.paymentInfo?.preimage != null &&
            printParameters.paymentInfo.preimage.isNotEmpty
        ? pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
                pw.Text("Payment Preimage:",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, letterSpacing: 0.5)),
                pw.SizedBox(height: 4),
                pw.Text(printParameters.paymentInfo.preimage)
              ])
        : pw.SizedBox();
  }
}
