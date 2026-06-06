import 'package:advance_math/advance_math.dart';

void main() {
  print('Testing Polynomial.fromString behavior:');

  try {
    var p = Polynomial.fromString('a', variable: Variable('a'));
    print(
        '  fromString("a", var=a): OK, degree=${p.degree}, coeffs=${p.coefficients}');
  } catch (e) {
    print('  fromString("a", var=a): THROWS $e');
  }

  try {
    var p = Polynomial.fromString('b', variable: Variable('a'));
    print(
        '  fromString("b", var=a): OK, degree=${p.degree}, coeffs=${p.coefficients}');
  } catch (e) {
    print('  fromString("b", var=a): THROWS $e');
  }

  try {
    var p = Polynomial.fromString('c', variable: Variable('a'));
    print(
        '  fromString("c", var=a): OK, degree=${p.degree}, coeffs=${p.coefficients}');
  } catch (e) {
    print('  fromString("c", var=a): THROWS $e');
  }

  // What does gcd([a], [b], [c]) return when allPolys path executes?
  print('\nTesting Variable.getVariableTerms:');
  var aVar = Variable('a');
  var terms = aVar.getVariableTerms();
  var nonI = terms.where((v) => v.identifier.name != 'i');
  print('  a.getVariableTerms(): $terms');
  print('  nonI.isNotEmpty: ${nonI.isNotEmpty}');

  // Test what allNumeric does for variables
  print('\nTesting allNumeric for Variables:');
  var a = Variable('a');
  var b = Variable('b');
  var c = Variable('c');
  var unique = [a, b, c];

  bool allNumeric = true;
  for (var ex in unique) {
    final nonI = ex.getVariableTerms().where((v) => v.identifier.name != 'i');
    if (nonI.isNotEmpty) {
      allNumeric = false;
      print('  $ex has non-i variable terms, allNumeric = false, breaking');
      break;
    }
  }
  print('  allNumeric: $allNumeric');

  // Test what polyVar detection does
  print('\nTesting polyVar detection:');
  String? polyVar;
  for (var ex in unique) {
    final vars = ex.getVariableTerms().where((v) => v.identifier.name != 'i');
    if (vars.isNotEmpty) {
      polyVar = vars.first.identifier.name;
      break;
    }
  }
  print('  polyVar: $polyVar');

  // Test Polynomial.fromString for each
  if (polyVar != null) {
    bool allPolys = true;
    var polys = <Polynomial>[];
    for (var ex in unique) {
      try {
        var p =
            Polynomial.fromString(ex.toString(), variable: Variable(polyVar));
        print('  fromString("$ex", var=$polyVar): OK, degree=${p.degree}');
        polys.add(p);
      } catch (e) {
        print('  fromString("$ex", var=$polyVar): THROWS $e');
        allPolys = false;
        break;
      }
    }
    print('  allPolys: $allPolys, polys.length: ${polys.length}');
    if (allPolys && polys.isNotEmpty) {
      var g = polys[0];
      for (int i = 1; i < polys.length; i++) {
        g = g.gcd(polys[i]);
      }
      print('  GCD: $g (degree=${g.degree})');
    }
  }
}
