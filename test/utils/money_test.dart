import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/utils/money.dart';

void main() {
  group('formatMoney', () {
    test('uses Indian digit grouping', () {
      expect(formatMoney(999), '999');
      expect(formatMoney(1000), '1,000');
      expect(formatMoney(129999), '1,29,999');
      expect(formatMoney(12345678), '1,23,45,678');
    });

    test('shows paise only when non-zero', () {
      expect(formatMoney(1299.5), '1,299.50');
      expect(formatMoney(1299.05), '1,299.05');
      expect(formatMoney(1299.004), '1,299');
    });

    test('handles zero and negatives', () {
      expect(formatMoney(0), '0');
      expect(formatMoney(-1500), '-1,500');
    });
  });
}
