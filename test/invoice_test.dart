import 'package:breez/utils/bip21.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('invoice_tests', () {   
    test("should extract bolt11 from bip21 full info", () async {
      String bolt11 = extractBolt11FromBip21("bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?amount=0.000001&lightning=1234");
      expect(bolt11, "1234");
    });

    test("should extract bolt11 from bip21 no amount", () async {
      String bolt11 = extractBolt11FromBip21("bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?lightning=1234");
      expect(bolt11, "1234");
    });

    test("should extract bolt11 from bip21 amount last", () async {
      String bolt11 = extractBolt11FromBip21("bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?lightning=1234&amount=0.000001");
      expect(bolt11, "1234");
    });

    test("should extract bolt11 from bip21 upper case", () async {
      String bolt11 = extractBolt11FromBip21("BITCOIN:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?amount=0.000001&lightning=1234");
      expect(bolt11, "1234");
    });

    test("should extract bolt11 from bip21 negative, no lightning", () async {
      String bolt11 = extractBolt11FromBip21("bitcoin:1DamianM2k8WfNEeJmyqSe2YW1upB7UATx?amount=0.000001");
      expect(bolt11, null);
    });
  });
}