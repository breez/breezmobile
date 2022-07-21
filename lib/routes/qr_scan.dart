import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan/scan.dart';

import '../widgets/scan_overlay.dart';

class QRScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QRScanState();
  }
}

class QRScanState extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController cameraController = MobileScannerController(
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
                    allowDuplicates: false,
                    controller: cameraController,
                    onDetect: (barcode, args) {
                      if (barcode.rawValue == null) {
                        debugPrint('Failed to scan QR code.');
                      } else {
                        final String code = barcode.rawValue;
                        Navigator.of(context).pop(code);
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
            child: const ImagePickerButton(),
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
  /*
  Positioned buildSwitchCameraButton() {
    return Positioned(
      right: 32,
      bottom: 96,
      child: IconButton(
        color: Colors.white,
        icon: ValueListenableBuilder(
          valueListenable: cameraController.cameraFacingState,
          builder: (context, state, child) {
            switch (state as CameraFacing) {
              case CameraFacing.front:
                return const Icon(Icons.camera_rear_outlined);
              case CameraFacing.back:
                return const Icon(Icons.camera_front_outlined);
            }
          },
        ),
        iconSize: 32.0,
        onPressed: () => cameraController.switchCamera(),
      ),
    );
  }

  Positioned buildToggleFlashButton() {
    return Positioned(
      left: 32,
      bottom: 96,
      child: ValueListenableBuilder(
        valueListenable: cameraController.cameraFacingState,
        builder: (context, state, child) {
          switch (state as CameraFacing) {
            case CameraFacing.front:
              return const SizedBox();
            case CameraFacing.back:
              return IconButton(
                color: Colors.white,
                icon: ValueListenableBuilder(
                  valueListenable: cameraController.torchState,
                  builder: (context, state, child) {
                    switch (state as TorchState) {
                      case TorchState.off:
                        return const Icon(Icons.flash_on_outlined);
                      case TorchState.on:
                        return const Icon(Icons.flash_off_outlined);
                    }
                  },
                ),
                iconSize: 32.0,
                onPressed: () => cameraController.toggleTorch(),
              );
          }
        },
      ),
    );
  }
  */
}

class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.fromLTRB(0, 32, 24, 0),
      icon: SvgPicture.asset(
        "src/icon/image.svg",
        color: Colors.white,
        width: 32,
        height: 32,
      ),
      onPressed: () async {
        final picker = ImagePicker();
        XFile pickedFile = await picker
            .pickImage(source: ImageSource.gallery)
            .catchError((err) {});
        final File file = File(pickedFile.path);
        try {
          String data = await Scan.parse(file.path);
          Navigator.of(context).pop(data);
        } catch (_) {}
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
    final texts = AppLocalizations.of(context);

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
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
