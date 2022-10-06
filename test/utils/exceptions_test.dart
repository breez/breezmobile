import 'package:breez/utils/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('extractExceptionMessage on known string', () {
    test('detail message', () {
      expect(
        extractExceptionMessage('"lnurlw://sats.pw/withdraw/api/v1/lnurl/5NGw5bvHKudKNDWiaQeAai" does not contain an LNURL : unknown response tag {"detail":"Withdraw link does not exist."} method: fetchLnurl'),
        'Withdraw link does not exist.',
      );
    });

    test('nsLocalized message', () {
      expect(
        extractExceptionMessage('Error Domain=go Code=1 "Link not working" UserInfo={NSLocalizedDescription=Link not working}'),
        'Link not working',
      );
    });

    test('lnUrl message', () {
      expect(
        extractExceptionMessage('"lnurlw://legend.Inbits.com/boltcards/api/v1/scan/redacted?p=60239397C290247187E63D6D341CDF65&c=7D2F283B09C41D8F" does not contain an LNURL: Max daily limit spent. method: fetchLnurl'),
        'Max daily limit spent.',
      );
    });
  });
}
