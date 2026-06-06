import 'package:advance_math/advance_math.dart';

void main() {
  // Trace: what does the parser see as args[0] for partfrac?
  // Simulate by checking what parse() produces for the expr alone
  var inner = ExpressionParser().parse('(3*x+2)/(x^2+x)');
  print('Inner expression type: ${inner.runtimeType}');
  print('Inner expression: $inner');

  if (inner is Divide) {
    print('  Is Divide: yes');
    print('  Left: ${inner.left} (${inner.left.runtimeType})');
    print('  Right: ${inner.right} (${inner.right.runtimeType})');

    var numExpr = inner.left;
    var denExpr = inner.right;

    // Unwrap GroupExpression
    while (numExpr is GroupExpression) {
      numExpr = (numExpr as GroupExpression).expression;
    }
    while (denExpr is GroupExpression) {
      denExpr = (denExpr as GroupExpression).expression;
    }
    print('  Unwrapped num: $numExpr (${numExpr.runtimeType})');
    print('  Unwrapped den: $denExpr (${denExpr.runtimeType})');

    var numStr = numExpr.toString().trim();
    var denStr = denExpr.toString().trim();
    while (numStr.startsWith('(') && numStr.endsWith(')')) {
      numStr = numStr.substring(1, numStr.length - 1);
    }
    while (denStr.startsWith('(') && denStr.endsWith(')')) {
      denStr = denStr.substring(1, denStr.length - 1);
    }
    print('  numStr: "$numStr"');
    print('  denStr: "$denStr"');

    try {
      var numPoly = Polynomial.fromString(numStr);
      print('  numPoly: $numPoly (degree ${numPoly.degree})');
    } catch (e) {
      print('  numPoly error: $e');
    }
    try {
      var denPoly = Polynomial.fromString(denStr);
      print('  denPoly: $denPoly (degree ${denPoly.degree})');
      var factors = denPoly.factorize();
      print('  factors: $factors');
      print('  factors count: ${factors.length}');
    } catch (e) {
      print('  denPoly/factors error: $e');
    }
  }

  // Also check what happens when parsing through the full partfrac path
  print('\n--- Testing through parser directly ---');
  // This will trigger our partfrac code
  try {
    var result = ExpressionParser().parse('partfrac((3*x+2)/(x^2+x),x)');
    print('Result type: ${result.runtimeType}');
    print('Result: $result');
  } catch (e) {
    print('Error: $e');
  }
}
