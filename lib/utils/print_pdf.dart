import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintService {
  final BreezUserModel currentUser;
  final CurrencyWrapper currentCurrency;
  final AccountModel account;
  final Sale submittedSale;

  PrintService(
      this.currentUser, this.currentCurrency, this.account, this.submittedSale);

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
                _buildTable(fontMap)
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

  pw.Text _buildTitle() {
    return pw.Text(
      currentUser.name,
      style: pw.TextStyle(fontSize: 24, letterSpacing: 0.25),
    );
  }

  pw.Text _buildAddress() {
    return pw.Text(
      currentUser.businessAddress.toString(),
      style: pw.TextStyle(
        fontSize: 16,
      ),
    );
  }

  pw.Table _buildTable(Map<String, ByteData> fontMap) {
    return pw.Table(
        children: _buildTableContent(fontMap),
        border: pw.TableBorder(width: 1),
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
    submittedSale.saleLines.forEach((saleLine) {
      CurrencyWrapper saleCurrency =
          CurrencyWrapper.fromShortName(saleLine.currency, account);
      double priceInFiat = saleLine.pricePerItem;
      double totalPriceInFiat = saleLine.pricePerItem * saleLine.quantity;
      double totalPriceInSats =
          saleCurrency.satConversionRate * totalPriceInFiat;
      String totalPriceInSaleCurrency = "";
      if (saleCurrency.symbol != currentCurrency.symbol) {
        String totalSalePrice = currentCurrency.format(
            totalPriceInSats / currentCurrency.satConversionRate,
            includeCurrencySymbol: true,
            removeTrailingZeros: true);
        totalPriceInSaleCurrency = saleCurrency.rtl ? "($totalSalePrice) " : " ($totalSalePrice)";
      }
      pw.TextStyle textStyle = pw.TextStyle(
        fontSize: 12.3,
      );
      saleLines.add(pw.TableRow(children: [
        _buildTableItem(
          saleLine.itemName,
          style: textStyle,
        ),
        _buildTableItem(
          "${saleCurrency.format(priceInFiat, removeTrailingZeros: true, includeCurrencySymbol: true)}",
          style: textStyle,
        ),
        _buildTableItem(
          "${saleLine.quantity}",
          style: textStyle,
        ),
        _buildTableItem(
          "${saleCurrency.format(totalPriceInFiat, removeTrailingZeros: true, includeCurrencySymbol: true)}$totalPriceInSaleCurrency",
          style: textStyle,
        ),
      ]));
    });
    return saleLines;
  }

  _addTotalLineToTable(Map<String, ByteData> fontMap) {
    double totalAmount =
        submittedSale.totalChargeSat / currentCurrency.satConversionRate;
    return pw.TableRow(
      children: [
        pw.SizedBox(),
        pw.SizedBox(),
        _buildTableItem("Total"),
        _buildTableItem(
            "${currentCurrency.format(totalAmount, removeTrailingZeros: true)} ${currentCurrency.shortName}",
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
}
