import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Statistics VarArgs Refactoring', () {
    test('mean/avg works with list and varargs', () {
      expect(mean(1, 2, 3), equals(2.0));
      expect(mean([1, 2, 3]), equals(2.0));
      expect(avg(1, 2, 3, 4, 5), equals(3.0));
      expect(avg([1, 2, 3, 4, 5]), equals(3.0));
    });

    test('median works with list and varargs', () {
      expect(median(1, 3, 2), equals(2));
      expect(median([1, 3, 2]), equals(2));
      expect(median(1, 2, 3, 4), equals(2.5));
    });

    test('mode works with list and varargs', () {
      expect(mode(1, 2, 2, 3), equals([2]));
      expect(mode([1, 2, 2, 3]), equals([2]));
    });

    test('variance works with list and varargs', () {
      expect(variance(1, 2, 3, 4, 5), equals(2.5));
      expect(variance([1, 2, 3, 4, 5]), equals(2.5));
    });

    test('stdDev works with list and varargs', () {
      expect(stdDev(1, 2, 3, 4, 5), closeTo(1.581, 0.001));
      expect(stdDev([1, 2, 3, 4, 5]), closeTo(1.581, 0.001));
    });

    test('gcd works with list and varargs', () {
      expect(gcd(48, 18, 24), equals(6));
      expect(gcd([48, 18, 24]), equals(6));
    });

    test('lcm works with list and varargs', () {
      expect(lcm(15, 20), equals(60));
      expect(lcm([15, 20]), equals(60));
    });

    test('correlation works with two lists', () {
      var x = [1, 2, 3, 4, 5];
      var y = [1, 2, 3, 4, 5];
      expect(correlation(x, y), equals(1.0));
    });

    test('regression works with two lists', () {
      var x = [1, 2, 3];
      var y = [2, 4, 6];
      var reg = regression(x, y); // y = 2x + 0
      expect(reg[0], equals(2.0)); // slope
      expect(reg[1], equals(0.0)); // intercept
    });
  });
}
