import 'package:mysqlsimple/mysqlsimple.dart';
import 'package:test/test.dart';

/// TODO: Add test :D

void main() {
  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });
}
