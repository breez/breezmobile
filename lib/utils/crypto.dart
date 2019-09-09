import 'package:crypto/crypto.dart';

List<int> hash256(List<int> bytes) {
  return sha256.convert(bytes).bytes;
}