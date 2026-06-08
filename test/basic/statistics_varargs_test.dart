import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Statistics VarArgs Refactoring', () {
    test('mean/avg works with list and varargs', () {
      expect(mean(1, 2, 3).toString(), equals('2'));
      expect(mean([1, 2, 3]).toString(), equals('2'));
      expect(avg(1, 2, 3, 4, 5).toString(), equals('3'));
      expect(avg([1, 2, 3, 4, 5]).toString(), equals('3'));
    });

    test('median works with list and varargs', () {
      expect(median(1, 3, 2).toString(), equals('2'));
      expect(median([1, 3, 2]).toString(), equals('2'));
      expect(median(1, 2, 3, 4).toString(), equals('2.5'));
    });

    test('mode works with list and varargs', () {
      expect(mode(1, 2, 2, 3).toString(), equals('[2]'));
      expect(mode([1, 2, 2, 3]).toString(), equals('[2]'));
    });

    test('variance works with list and varargs', () {
      expect(variance(1, 2, 3, 4, 5).toString(), equals('2.5'));
      expect(variance([1, 2, 3, 4, 5]).toString(), equals('2.5'));
    });

    test('stdDev works with list and varargs', () {
      expect(stdDev(1, 2, 3, 4, 5).toString(),
          equals(Complex(1.5811388300841898).toString()));
      expect(stdDev([1, 2, 3, 4, 5]).toString(),
          equals(Complex(1.5811388300841898).toString()));
    });

    test('gcd works with list and varargs', () {
      expect(gcd(48, 18, 24).toString(), equals('6'));
      expect(gcd([48, 18, 24]).toString(), equals('6'));
    });

    test('lcm works with list and varargs', () {
      expect(lcm(15, 20).toString(), equals('60'));
      expect(lcm([15, 20]).toString(), equals('60'));
    });

    test('correlation works with two lists', () {
      var x = [1, 2, 3, 4, 5];
      var y = [1, 2, 3, 4, 5];
      expect(correlation(x, y).toString(), equals('1'));
    });

    test('regression works with two lists', () {
      var x = [1, 2, 3];
      var y = [2, 4, 6];
      var reg = regression(x, y); // y = 2x + 0
      expect(reg[0].toString(), equals('2')); // slope
      expect(reg[1].toString(), equals('0')); // intercept
    });
  });
}
