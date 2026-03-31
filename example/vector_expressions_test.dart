import 'package:advance_math/advance_math.dart';

void main() {
  // Provided v0 and v2
  var v0 = Vector.random(3);
  var v2 = Vector.random(3);

  final Map<String, dynamic> context = {
    ...defaultContext,
    'v0': v0,
    'v2': v2,
  };

  print('--- Vector Expression Context Test ---');
  print('v0: $v0');
  print('v2: $v2\n');

  final testCases = [
    // Creators
    'vector(1, 2, 3)',
    'vector([1, 2, 3])',
    'vector("1 2 3")',
    'vector("1+2i, 3-4i, 5")',
    'linspaceVector(5, 0, 10)',
    'rangeVector(10, 0, 2)',
    'randomVector(3)',
    'randomVector(3, 0, 100)',
    'zerosVector(3)',
    'onesVector(3)',

    // Operations
    'dot(v0, v2)',
    'cross(v0, v2)',
    'innerProduct(v0, v2)',
    'outerProduct(v0, v2)',
    'mag(v0)',
    'magnitude(v0)',
    'angle(v0, v2)',
    'projection(v0, v2)',
    'isParallelTo(v0, v2)',
    'isPerpendicularTo(v0, v2)',
    'unit(v0)',
    'normalize(v0)',
    'distance(v0, v2)',

    // Conversions
    'toSpherical(v0)',
    'toCylindrical(v0)',
    'toPolar(vector(3, 4))',
  ];

  for (var exprStr in testCases) {
    try {
      final expr = Expression.parse(exprStr);
      final result = expr.evaluate(context);
      print('Expression: $exprStr');
      print('Result: $result\n');
    } catch (e, stack) {
      print('Error evaluating "$exprStr":');
      print('Type: ${e.runtimeType}');
      print('Message: $e');
      print('Stack trace:\n$stack\n');
    }
  }
}
