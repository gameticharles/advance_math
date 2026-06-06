import 'package:advance_math/advance_math.dart';

// Simplified test to understand what's happening in the GCD parser logic
void main() {
  // Test flattenGcd behavior manually
  var a = Variable('a');
  var b = Variable('b');
  var c = Variable('c');
  var args = <Expression>[a, b, c];
  
  print('Testing flattenGcd manually:');
  
  List<Expression> flattenGcd(List<Expression> exprs) {
    List<Expression> res = [];
    for (var ex in exprs) {
      if (ex is CallExpression && ex.callee.toString() == 'gcd') {
        res.addAll(flattenGcd(ex.arguments));
      } else {
        res.add(ex is Variable ? ex : ex.simplify());
      }
    }
    return res;
  }
  
  var flattened = flattenGcd(args);
  print('  flattened: ${flattened.map((e) => e.toString())}');
  
  List<Expression> unique = [];
  for (var ex in flattened) {
    if (!unique.any((e) => e.toString() == ex.toString())) {
      unique.add(ex);
    }
  }
  print('  unique: ${unique.map((e) => e.toString())}');
  print('  unique.length: ${unique.length}');
  
  // Test parsing vs the parse cache
  print('\nTesting if ExpressionParser cache causes issues:');
  var parser = ExpressionParser();
  
  // Try gcd(c, c) first
  print('Parse gcd(c,c): ${parser.parse("gcd(c,c)")}');
  // Then gcd(a, b, c)
  print('Parse gcd(a, b, c): ${parser.parse("gcd(a, b, c)")}');
  // Then gcd(a,a,b,b,gcd(c,c))
  print('Parse gcd(a,a,b,b,gcd(c,c)): ${parser.parse("gcd(a,a,b,b,gcd(c,c))")}');
}
