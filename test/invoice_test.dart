import 'package:breez/utils/bip21.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('invoice_tests', () {
    test("should extract bolt11 from bip21 full info", () async {
      String bolt11 = extractBolt11FromBip21(
        "bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?amount=0.000001&lightning=1234",
      );
      expect(bolt11, "1234");
    });

    test("should extract bolt11 from bip21 no amount", () async {
      String bolt11 = extractBolt11FromBip21(
          "bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?lightning=1234");
      expect(bolt11, "1234");
    });

    test("should extract bolt11 from bip21 amount last", () async {
      String bolt11 = extractBolt11FromBip21(
        "bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?lightning=1234&amount=0.000001",
      );
      expect(bolt11, "1234");
    });

    test("should extract bolt11 from bip21 upper case", () async {
      String bolt11 = extractBolt11FromBip21(
        "BITCOIN:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?amount=0.000001&lightning=1234",
      );
      expect(bolt11, "1234");
    });

    test("should extract bolt11 from bip21 negative, no lightning", () async {
      String bolt11 = extractBolt11FromBip21(
          "bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?amount=0.000001");
      expect(bolt11, null);
    });

    test("should extract bitcoin addresss from bip21 full info legacy address", () async {
      String bitcoinAddress = extractBitcoinAddress(
        "bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?amount=0.000001&lightning=1234",
      );
      expect(bitcoinAddress, "1DamianM2k8WfNEeJmyqSe2YW1upB7UATx");
    });

    test("should extract bitcoin address from bip 21 nested segwit", () async {
      String bitcoinAddress = extractBitcoinAddress(
        "BITCOIN:3K2CfYmqYuD99CDyqrdzt481F9jkLKirEn?amount=0.00001&label=sbddesign%3A%20For%20lunch%20Tuesday&message=For%20lunch%20Tuesday&lightning=LNBC10U1P3PJ257PP5YZTKWJCZ5FTL5LAXKAV23ZMZEKAW37ZK6KMV80PK4XAEV5QHTZ7QDPDWD3XGER9WD5KWM36YPRX7U3QD36KUCMGYP282ETNV3SHJCQZPGXQYZ5VQSP5USYC4LK9CHSFP53KVCNVQ456GANH60D89REYKDNGSMTJ6YW3NHVQ9QYYSSQJCEWM5CJWZ4A6RFJX77C490YCED6PEMK0UPKXHY89CMM7SCT66K8GNEANWYKZGDRWRFJE69H9U5U0W57RRCSYSAS7GADWMZXC8C6T0SPJAZUP6",
      );
      expect(bitcoinAddress, "3K2CfYmqYuD99CDyqrdzt481F9jkLKirEn");
    });

    test("should extract bitcoin address from bip 21 bech32", () async {
      String bitcoinAddress = extractBitcoinAddress(
        "BITCOIN:BC1QYLH3U67J673H6Y6ALV70M0PL2YZ53TZHVXGG7U?amount=0.00001&label=sbddesign%3A%20For%20lunch%20Tuesday&message=For%20lunch%20Tuesday&lightning=LNBC10U1P3PJ257PP5YZTKWJCZ5FTL5LAXKAV23ZMZEKAW37ZK6KMV80PK4XAEV5QHTZ7QDPDWD3XGER9WD5KWM36YPRX7U3QD36KUCMGYP282ETNV3SHJCQZPGXQYZ5VQSP5USYC4LK9CHSFP53KVCNVQ456GANH60D89REYKDNGSMTJ6YW3NHVQ9QYYSSQJCEWM5CJWZ4A6RFJX77C490YCED6PEMK0UPKXHY89CMM7SCT66K8GNEANWYKZGDRWRFJE69H9U5U0W57RRCSYSAS7GADWMZXC8C6T0SPJAZUP6",
      );
      expect(bitcoinAddress, "bc1qylh3u67j673h6y6alv70m0pl2yz53tzhvxgg7u");
    });

    test("should extract the same address as it receives", () {
      String bitcoinAddress =
          extractBitcoinAddress("3K2CfYmqYuD99CDyqrdzt481F9jkLKirEn");
      expect(bitcoinAddress, "3K2CfYmqYuD99CDyqrdzt481F9jkLKirEn");
    });

    test("should extract the address from bip21 scheme", () async {
      String bitcoinAddress = extractBitcoinAddress(
          "BITCOIN:BC1QYLH3U67J673H6Y6ALV70M0PL2YZ53TZHVXGG7U");
      expect(bitcoinAddress, "bc1qylh3u67j673h6y6alv70m0pl2yz53tzhvxgg7u");
    });

    test("should extract the same address as it receives", () {
      String bitcoinAddress =
          extractBitcoinAddress("BItCOiN:3K2CfYmqYuD99CDyqrdzt481F9jkLKirEn");
      expect(bitcoinAddress, "3K2CfYmqYuD99CDyqrdzt481F9jkLKirEn");
    });
  });
}
