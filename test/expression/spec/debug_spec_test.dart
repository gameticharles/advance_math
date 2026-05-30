import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  test('defint singularity test', () {
    var expr = Expression.parse('log(2*cos(x/2))');
    double a = -math.pi;
    double b = math.pi;

    num f(num x) {
      final val = expr.evaluate({'x': x.toDouble()});
      if (val is num) return val;
      if (val is Complex) return val.real;
      return double.nan;
    }

    final resPrev = NumericalIntegration.adaptiveSimpson(f, a, b,
        tolerance: 1e-10, maxDepth: 60);
    final resNew = NumericalIntegration.adaptiveSimpson(f, a, b,
        tolerance: 1e-12, maxDepth: 25);

    print('Previous setup (1e-10, 60): ${resPrev.toDouble()}');
    print('New setup (1e-12, 25): ${resNew.toDouble()}');
  });
}
