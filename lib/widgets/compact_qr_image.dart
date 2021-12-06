import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

var _versionsToMaxCharacters = [
  17,
  32,
  53,
  78,
  106,
  134,
  154,
  192,
  230,
  271,
  321,
  367,
  425,
  458,
  520,
  586,
  644,
  718,
  792,
  858,
  929,
  1003,
  1091,
  1171,
  1273,
  1367,
  1465,
  1528,
  1628,
  1732,
  1840,
  1952,
  2068,
  2188,
  2303,
  2431,
  2563,
  2699,
  2809,
  2953
];

class CompactQRImage extends StatelessWidget {
  final String data;
  final double size;

  CompactQRImage({Key key, this.data, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImage(
      backgroundColor: Colors.white,
      version: _calculateVersion(),
      /*
         Bech32 addresses consisting of uppercase and digits results in more compact QR codes.
         NB. If we ever generate BIP21 URI's that have query parameters, this will have to be fixed so that
         we will not change the case of the parameters because BIP21 parameters are case sensitive.
         Ref. https://bitcoinops.org/en/bech32-sending-support/#creating-more-efficient-qr-codes-with-bech32-addresses
      */
      data: data?.toUpperCase(),
      size: this.size,
    );
  }

  int _calculateVersion() {
    int index;
    for (index = 0; index < _versionsToMaxCharacters.length; ++index) {
      if (_versionsToMaxCharacters[index] > data.length) {
        break;
      }
    }
    return index + 1;
  }
}
