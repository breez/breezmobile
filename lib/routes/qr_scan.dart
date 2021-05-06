import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class QRScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QRScanState();
  }
}

class QRScanState extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        Positioned(
            left: 0,
            right: 0,
            bottom: 0.0,
            top: 0.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300,
                    ),
                  ),
                )
              ],
            )),
        Positioned(
            right: 10,
            top: 5,
            child: Container(
                child: IconButton(
              padding: EdgeInsets.fromLTRB(0, 32, 24, 0),
              icon: SvgPicture.asset(
                "src/icon/image.svg",
                color: Colors.white,
                width: 32,
                height: 32,
              ),
              onPressed: () async {
                final _picker = ImagePicker();
                PickedFile pickedFile =
                    await _picker.getImage(source: ImageSource.gallery).catchError((err) {
                });
                final File file = File(pickedFile.path);
                try {
                  if (file == null) {
                    return;
                  }
                  String data = await QrCodeToolsPlugin.decodeFrom(file.path);
                  Navigator.of(context).pop(data);
                } catch (e) {}
              },
            ))),
        Positioned(
            bottom: 30.0,
            right: 0,
            left: 0,
            child: defaultTargetPlatform == TargetPlatform.iOS
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.8))),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.only(right: 35, left: 35),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )
                : SizedBox())
      ]),
      //),
    );
  }

  @override
  void dispose() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      this.controller?.pauseCamera();
    }
    this.controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    StreamSubscription sub;
    sub = controller.scannedDataStream.listen((scanData) async {
      if (scanData.code?.isNotEmpty == true) {
        await sub.cancel();
        Navigator.of(context).pop(scanData);
      }
    });
  }
}
