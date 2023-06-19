import 'package:breez/utils/exceptions.dart';
import 'package:breez_translations/generated/breez_translations_de.dart';
import 'package:breez_translations/generated/breez_translations_el.dart';
import 'package:breez_translations/generated/breez_translations_en.dart';
import 'package:breez_translations/generated/breez_translations_es.dart';
import 'package:breez_translations/generated/breez_translations_fi.dart';
import 'package:breez_translations/generated/breez_translations_fr.dart';
import 'package:breez_translations/generated/breez_translations_it.dart';
import 'package:breez_translations/generated/breez_translations_pt.dart';
import 'package:breez_translations/generated/breez_translations_sv.dart';
import 'package:breez_translations/generated/breez_translations_sk.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/unit_logger.dart';

void main() {
  setUpLogger();

  group('extractExceptionMessage on known string', () {
    for (var clearTrailingDot in [true, false]) {
      test('detail message (clearTrailingDot=$clearTrailingDot)', () {
        expect(
          extractExceptionMessage(
            '"lnurlw://sats.pw/withdraw/api/v1/lnurl/5NGw5bvHKudKNDWiaQeAai" '
            'does not contain an LNURL : unknown response tag {"detail":'
            '"Withdraw link does not exist."} method: fetchLnurl',
            clearTrailingDot: clearTrailingDot,
          ),
          clearTrailingDot
              ? 'Withdraw link does not exist'
              : 'Withdraw link does not exist.',
        );
      });

      test('nsLocalized message (clearTrailingDot=$clearTrailingDot)', () {
        expect(
          extractExceptionMessage(
            'Error Domain=go Code=1 "Link not working" UserInfo={'
            'NSLocalizedDescription=Link not working}',
            clearTrailingDot: clearTrailingDot,
          ),
          'Link not working',
        );
      });

      test('nsLocalized message 2 (clearTrailingDot=$clearTrailingDot)', () {
        expect(
          extractExceptionMessage(
            'Error Domain=go Code=1 "getpairs get https://boltz.exchange/api/'
            'getpairs: Get "https://boltz.exchange/api/getnodes": http: server '
            'gave HTTP response to HTTPS client" UserInfo={'
            'NSLocalizedDescription=getpairs get https://boltz.exchange/api/'
            'getpairs: Get "https://boltz.exchange/api/getnodes": http: server '
            'gave HTTP response to HTTPS client!}',
            clearTrailingDot: clearTrailingDot,
          ),
          clearTrailingDot
              ? 'getpairs get https://boltz.exchange/api/getpairs: Get '
                  '"https://boltz.exchange/api/getnodes": http: server gave '
                  'HTTP response to HTTPS client'
              : 'getpairs get https://boltz.exchange/api/getpairs: Get '
                  '"https://boltz.exchange/api/getnodes": http: server gave '
                  'HTTP response to HTTPS client!',
        );
      });

      test('lnUrl message (clearTrailingDot=$clearTrailingDot)', () {
        expect(
          extractExceptionMessage(
            '"lnurlw://legend.Inbits.com/boltcards/api/v1/scan/redacted?p=60239397C290247187E63D6D341CDF65&c=7D2F283B09C41D8F" does not contain an LNURL: Max daily limit spent. method: fetchLnurl',
            clearTrailingDot: clearTrailingDot,
          ),
          clearTrailingDot ? 'Max daily limit spent' : 'Max daily limit spent.',
        );
      });

      test('high fees (clearTrailingDot=$clearTrailingDot)', () {
        expect(
          extractExceptionMessage(
            PlatformException(
              code: "Method Error",
              message:
                  "Error Domain=go Code=1 \"rpc error: code = Unknown desc = fees are too high for the "
                  "given amount transaction output amount is negative\" UserInfo={NSLocalizedDescription=rpc "
                  "error: code = Unknown desc = fees are too high for the given amount transaction output "
                  "amount is negative}",
              details:
                  "Error Domain=go Code=1 \"rpc error: code = Unknown desc = fees are too high for the "
                  "given amount transaction output amount is negative\" UserInfo={NSLocalizedDescription=rpc "
                  "error: code = Unknown desc = fees are too high for the given amount transaction output "
                  "amount is negative}",
            ),
            clearTrailingDot: clearTrailingDot,
          ),
          "fees are too high for the given amount transaction output amount is negative",
        );
      });

      test('_extractInnerErrorMessage from error message', () {
        expect(
          extractExceptionMessage(
            "rpc error: code = Unknown desc = error in payment response: payment is in transition",
          ),
          "error in payment response: payment is in transition",
        );
      });
    }
  });

  final locales = {
    "de": BreezTranslationsDe(),
    "en": BreezTranslationsEn(),
    "el": BreezTranslationsEl(),
    "es": BreezTranslationsEs(),
    "fi": BreezTranslationsFi(),
    "fr": BreezTranslationsFr(),
    "it": BreezTranslationsIt(),
    "pt": BreezTranslationsPt(),
    "sv": BreezTranslationsSv(),
    "sk": BreezTranslationsSk(),
  };
  group("localizedExceptionMessage", () {
    for (final locale in locales.values) {
      test("invalid pair hash for ${locale.locale}", () {
        expect(
          extractExceptionMessage("invalid pair hash", texts: locale),
          locale.localized_error_message_invalid_pair_hash,
        );
      });
    }
  });
}
