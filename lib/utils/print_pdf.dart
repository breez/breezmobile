import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/print_parameters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintService {
  final PrintParameters printParameters;
  final _satCurrency = CurrencyWrapper.fromBTC(Currency.SAT);

  PrintService(
    this.printParameters,
  );

  printAsPDF(BuildContext context) async {
    final texts = AppLocalizations.of(context);

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
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                pw.SizedBox(height: 8),
                _buildTransactionTime(texts),
                pw.SizedBox(height: 8),
                _buildAddress(),
                pw.SizedBox(height: 40),
                _buildTable(texts, fontMap),
                pw.SizedBox(height: 8),
                _buildDescription(texts),
                pw.SizedBox(height: 40),
                _buildPaymentInfo(texts),
              ],
            );
            // Center
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (_) async => doc.save());
    } on PlatformException catch (error) {
      throw error;
    }
  }

  _buildTitle() {
    return pw.Text(
      printParameters.currentUser.name,
      style: pw.TextStyle(fontSize: 24, letterSpacing: 0.25),
    );
  }

  _buildTransactionTime(AppLocalizations texts) {
    final creationTimestamp = printParameters.paymentInfo?.creationTimestamp;

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.max,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        creationTimestamp != null
            ? pw.Column(
                children: [
                  pw.Text(
                    texts.utils_print_pdf_transaction_time,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    BreezDateUtils.formatYearMonthDayHourMinute(
                      DateTime.fromMillisecondsSinceEpoch(
                        creationTimestamp.toInt() * 1000,
                      ),
                    ),
                    style: pw.TextStyle(
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              )
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

  pw.Table _buildTable(
    AppLocalizations texts,
    Map<String, ByteData> fontMap,
  ) {
    return pw.Table(
      children: _buildTableContent(texts, fontMap),
      border: pw.TableBorder.all(width: 1),
      defaultColumnWidth: pw.IntrinsicColumnWidth(),
    );
  }

  _buildTableContent(
    AppLocalizations texts,
    Map<String, ByteData> fontMap,
  ) {
    List<pw.TableRow> saleLines = [];
    saleLines.add(_addTableHeader(texts));
    saleLines = _addSales(saleLines, fontMap);
    saleLines.add(_addTotalLineToTable(texts, fontMap));
    return saleLines;
  }

  _addTableHeader(AppLocalizations texts) {
    return pw.TableRow(
      children: [
        _buildTableItem(texts.utils_print_pdf_header_item),
        _buildTableItem(texts.utils_print_pdf_header_price),
        _buildTableItem(texts.utils_print_pdf_header_quantity),
        _buildTableItem(texts.utils_print_pdf_header_amount),
      ],
    );
  }

  _addSales(List<pw.TableRow> saleLines, Map<String, ByteData> fontMap) {
    printParameters.submittedSale.saleLines.forEach((saleLine) {
      CurrencyWrapper saleCurrency = CurrencyWrapper.fromShortName(
        saleLine.currency,
        printParameters.account,
      );
      double priceInFiat = saleLine.pricePerItem;
      double totalPriceInFiat = saleLine.totalFiat;
      double totalPriceInSats = saleLine.totalSats;
      pw.TextStyle textStyle = pw.TextStyle(
        fontSize: 12.3,
      );
      saleLines.add(
        pw.TableRow(
          children: [
            _buildTableItem(
              saleLine.itemName,
              style: textStyle,
            ),
            _buildPrice(saleCurrency, priceInFiat, fontMap),
            _buildTableItem(
              "${saleLine.quantity}",
              style: textStyle,
            ),
            _buildAmount(
              totalPriceInFiat,
              totalPriceInSats,
              saleCurrency: saleCurrency,
              fontMap: fontMap,
            ),
          ],
        ),
      );
    });
    return saleLines;
  }

  _addTotalLineToTable(
    AppLocalizations texts,
    Map<String, ByteData> fontMap,
  ) {
    final sale = printParameters.submittedSale;
    final totalAmount = sale.totalAmountInSats;

    var totalMsg = _satCurrency.format(totalAmount, removeTrailingZeros: true);
    totalMsg = "$totalMsg ${_satCurrency.shortName}";
    final totalAmountInFiat = sale.totalAmountInFiat;
    if (totalAmountInFiat.length == 1) {
      final entry = totalAmountInFiat.entries.first;
      final currency = entry.key;
      final total = entry.value;
      if (currency != _satCurrency.shortName) {
        CurrencyWrapper saleCurrency = CurrencyWrapper.fromShortName(
          currency,
          printParameters.account,
        );
        final fiatTotalMsg = saleCurrency.format(
          total,
          removeTrailingZeros: true,
          includeCurrencySymbol: true,
        );
        totalMsg = "$totalMsg ($fiatTotalMsg)";
      }
    }

    return pw.TableRow(
      children: [
        pw.SizedBox(),
        pw.SizedBox(),
        _buildTableItem(texts.utils_print_pdf_header_total),
        _buildTableItem(
          totalMsg,
          style: pw.TextStyle(
            font: pw.Font.ttf(fontMap["ltr"]),
            fontSize: 14.3,
          ),
        ),
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

  pw.Padding _buildPrice(
    CurrencyWrapper saleCurrency,
    double amount,
    Map<String, ByteData> fontMap, {
    bool addParenthesis = false,
    pw.EdgeInsets padding = const pw.EdgeInsets.all(8),
  }) {
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
                  ),
                ),
                pw.Text(
                  "${saleCurrency.symbol}",
                  textDirection: pw.TextDirection.rtl,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    font: pw.Font.ttf(fontMap["rtl"]),
                    fontSize: 12.3,
                  ),
                ),
                pw.Text(
                  (addParenthesis ? " )" : ""),
                  style: pw.TextStyle(
                    font: pw.Font.ttf(fontMap["ltr"]),
                    fontSize: 12.3,
                  ),
                )
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
              ],
      ),
    );
  }

  pw.Row _buildAmount(
    double totalPriceInFiat,
    double totalPriceInSats, {
    Map<String, ByteData> fontMap,
    CurrencyWrapper saleCurrency,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: (saleCurrency.symbol != _satCurrency.symbol)
          ? [
              _buildPrice(
                saleCurrency,
                totalPriceInFiat,
                fontMap,
                padding: pw.EdgeInsets.only(
                  left: 8,
                  top: 8,
                  bottom: 8,
                ),
              ),
              _buildPrice(
                _satCurrency,
                totalPriceInSats,
                fontMap,
                addParenthesis: true,
                padding: pw.EdgeInsets.all(8),
              ),
            ]
          : [
              _buildPrice(
                saleCurrency,
                totalPriceInFiat,
                fontMap,
              ),
            ],
    );
  }

  pw.Widget _buildDescription(AppLocalizations texts) {
    return printParameters.submittedSale.note != null
        ? pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                texts.utils_print_pdf_header_description,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(printParameters.submittedSale.note),
            ],
          )
        : pw.SizedBox();
  }

  pw.Widget _buildPaymentInfo(AppLocalizations texts) {
    final preimage = printParameters.paymentInfo?.preimage;
    return preimage != null && preimage.isNotEmpty
        ? pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                texts.utils_print_pdf_header_payment_preimage,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(preimage),
            ],
          )
        : pw.SizedBox();
  }
}
