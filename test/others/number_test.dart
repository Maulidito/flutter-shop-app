import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('test number', () {
    test('format number', () {
      String value = "2000";

      var f = NumberFormat.decimalPattern();
      var newValue = f.format(double.parse(value));
      debugPrint(newValue);
      expect(newValue, "200");
    }, skip: true);
  });
}
