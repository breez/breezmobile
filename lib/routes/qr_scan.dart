import 'dart:io';

import 'package:breez/logger.dart';
import 'package:breez/widgets/scan_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QRScanState();
  }
}

class QRScanState extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var popped = false;
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0.0,
            top: 0.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: MobileScanner(
                    key: qrKey,
                    controller: cameraController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        log.info("Barcode detected: $barcode");
                        if (popped || !mounted) return;
                        if (barcode.rawValue == null) {
                          log.warning("Failed to scan QR code.");
                        } else {
                          popped = true;
                          final String code = barcode.rawValue;
                          log.info("Popping read QR code $code");
                          Navigator.of(context).pop(code);
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 5,
            child: ImagePickerButton(cameraController),
          ),
          Positioned(
            bottom: 30.0,
            right: 0,
            left: 0,
            child: defaultTargetPlatform == TargetPlatform.iOS
                ? const QRScanCancelButton()
                : const SizedBox(),
          ),
          const ScanOverlay(),
        ],
      ),
    );
  }
}

class ImagePickerButton extends StatelessWidget {
  final MobileScannerController cameraController;

  const ImagePickerButton(
    this.cameraController, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return IconButton(
      padding: const EdgeInsets.fromLTRB(0, 32, 24, 0),
      icon: SvgPicture.asset(
        "src/icon/image.svg",
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcATop,
        ),
        width: 32,
        height: 32,
      ),
      onPressed: () async {
        final picker = ImagePicker();
        XFile pickedFile = await picker
            .pickImage(source: ImageSource.gallery)
            .catchError((err) {
          log.warning("Failed to pick image", err);
        });
        log.info("Picked image: ${pickedFile.path}");
        final File file = File(pickedFile.path);
        try {
          final found = await cameraController.analyzeImage(file.path);
          if (!found) {
            log.info("No QR code found in image");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(texts.qr_scan_gallery_failed),
              ),
            );
          } else {
            log.info("QR code found in image");
          }
        } catch (err) {
          log.warning("Failed to analyze image", err);
        }
      },
    );
  }
}

class QRScanCancelButton extends StatelessWidget {
  const QRScanCancelButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(color: Colors.white.withOpacity(0.8))),
        child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(right: 35, left: 35),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              texts.qr_scan_action_cancel,
              style: const TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
