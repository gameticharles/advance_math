import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  void check(String given, dynamic expected) {
    var parsed = Expression.parse(given);
    var result = parsed.evaluate();

    // Normalize expected
    var exp = expected;
    if (exp is String) {
      exp = num.tryParse(exp) ?? exp;
    }

    // Compare as numbers
    if (result is num) {
      if (exp is num) {
        expect(result, closeTo(exp, 1e-10), reason: 'Eval of $given');
      } else {
        expect(result.toString(), equals(expected.toString()),
            reason: 'Eval of $given');
      }
    } else if (result is Complex) {
      expect(result.real, closeTo(exp, 1e-10),
          reason: 'Eval of $given (real part)');
      expect(result.imaginary, closeTo(0, 1e-10),
          reason: 'Eval of $given (imaginary part)');
    } else if (result is String || result is List) {
      // Handle String or List results (e.g. vectors)
      expect(result.toString().replaceAll(' ', ''),
          equals(expected.toString().replaceAll(' ', '')));
    } else {
      // Try parsing result string to num if it's a Literal
      if (result is Literal && result.value is num) {
        expect(result.value, closeTo(expected, 1e-10));
      } else {
        // Debug info for failure
        if (result.toString() != expected.toString()) {
          print('Check failed for "$given"');
          print('Parsed: $parsed');
          print('Result: $result (${result.runtimeType})');
          print('Expected: $expected (${expected.runtimeType})');
        }
        fail('Result $result is not a number or valid Match');
      }
    }
  }

  group('Basic operations', () {
    test('should add correctly', () {
      check('1+1', 2);
    });
    test('should subtract correctly', () {
      check('3-1', 2);
    });
    test('should divide correctly', () {
      check('6/3', 2);
    });
    test('should multiply correctly', () {
      check('2*6', 12);
    });
    test('should raise to power correctly', () {
      check('2^3', 8);
    });
    test('should parse scientific notation correctly', () {
      check('1.234e+1', 12.34);
    });
    test('should parse non-normalized scientific notation correctly', () {
      check('12.3e-1', 1.23);
    });
  });

  group('Order of precedence', () {
    test('should recognize * > +', () {
      check('3*5+3', 18);
    });
    test('should recognize + = -', () {
      check('4+5-11', -2);
    });
    test('should recognize ^ = +', () {
      check('2^3-3', 5);
    }); // ^ usually higher than +
    test('should recognize ^ > *', () {
      check('2^3*3', 24);
    });
    test('should recognize / = *', () {
      check('6/3*5', 10);
    });
    test('should recognize / = +', () {
      check('2/3+2/3', 1.3333333333);
    });
    test('should recognize ^ is right associative', () {
      check('2^3^2', 512);
    });
  });

  // Percentage tests skipped as % is modulo in this parser

  group('Functions', () {
    test('should calculate functions', () {
      check('sin(1)', 0.8414709848);
    });
    test('should calculate functions', () {
      check('sin(sin(2))', 0.7890723436);
    });
    test('should add with functions', () {
      check('sin(sin(2))+4', 4.7890723436);
    });
    // max() not implemented in parser yet
    // test('should handle function with arguments', () { check('max(4,6,3)', 6); });
  });

  group('Modulus', () {
    test('should calculate modulus', () {
      check('10%4', 2);
    });
    test('should add with modulus', () {
      check('10%4+6', 8);
    });
    test('should multiply with modulus', () {
      check('10%4*8', 16);
    });
    test('should add and multiply with modulus', () {
      check('2+10%4*8', 18);
    });
  });

  group('Brackets', () {
    test('should respect parentheses', () {
      check('4*(2+1)', 12);
    });
    test('should respect parentheses within parentheses', () {
      check('3*(4+(2+1))', 21);
    });
    test('should handle multiple levels of brackets', () {
      check('((((((((9))))))))+1', 10);
    });
    test('should handle multiple levels of brackets', () {
      check('((((((1+1))+4)))+3)', 9);
    });
  });

  group('Prefixes', () {
    test('should correctly parse prefixes', () {
      check('-(-3*-(4))', -12);
      // check('3^-1^-1', 0.3333333333); // Check associativity
      check('-(-1-+1)^2', -4); // -(-2)^2 = -4
      check('-(-1-1+1)', 1);
      // check('-(1)--(1-1--1)', 0);
    });
  });

  group('Basic operations', () {
    test('should add correctly', () {
      check('1+1', 2);
    });
    test('should subtract correctly', () {
      check('3-1', 2);
    });
    test('should divide correctly', () {
      check('6/3', 2);
    });
    test('should multiply correctly', () {
      check('2*6', 12);
    });
    test('should raise to power correctly', () {
      check('2^3', 8);
    });
    test('should parse scientific notation correctly', () {
      check('1.234e+1', 12.34);
    });
    test('should parse non-normalized scientific notation correctly', () {
      check('12.3e-1', 1.23);
    });
  });

  group('Order of precedence', () {
    test('should recognize * > +', () {
      check('3*5+3', 18);
    });
    test('should recognize + = -', () {
      check('4+5-11', -2);
    });
    test('should recognize ^ = +', () {
      check('2^3-3', 5);
    });
    test('should recognize ^ > *', () {
      check('2^3*3', 24);
    });
    test('should recognize / = *', () {
      check('6/3*5', 10);
    });
    test('should recognize / = +', () {
      check('2/3+2/3', 1.3333333333333333);
    });
    test('should recognize ^ is right associative', () {
      check('2^3^2', 512);
    });
  });

  group('Percentages', () {
    test('should calculate percentages', () {
      check('5%', 0.05);
    });
    test('should add percentages', () {
      check('5%+5%', 0.1);
    });
    test('should multiply percentages', () {
      check('10%*10%', 0.01);
    });
    test('should multiply percentages by numbers', () {
      check('100*10%', 10);
    });
  });

  group('Functions', () {
    test('should calculate functions', () {
      check('sin(1)', 0.8414709848078965);
    });
    test('should calculate functions', () {
      check('sin(sin(2))', 0.7890723435728884);
    });
    test('should add with functions', () {
      check('sin(sin(2))+4', 4.789072343572888);
    });
    test('should handle function with arguments', () {
      check('max(4,6,3)', 6);
    });
    test('should handle function with arguments with operations', () {
      check('max(4,5+7,3)', 12);
    });
    test(
        'should handle function with arguments with operations and subsequent operations',
        () {
      check('max(4,5+7,3)+11', 23);
    });
  });

  group('Modulus', () {
    test('should calculate modulus', () {
      check('10%4', 2);
    });
    test('should add with modulus', () {
      check('10%4+6', 8);
    });
    test('should multiply with modulus', () {
      check('10%4*8', 16);
    });
    test('should add and multiply with modulus', () {
      check('2+10%4*8', 18);
    });
    test('should respect modulus in functions', () {
      check('max(3,2+10%4*8,5)', 18);
    });
    test('should respect modulus with percentages', () {
      check('8000%%8', 0);
    });
    test('should correctly handle modulus left assoc', () {
      check('3*3%9', 0);
    });
  });

  group('Brackets', () {
    test('should respect parentheses', () {
      check('4*(2+1)', 12);
    });
    test('should respect parentheses within parentheses', () {
      check('3*(4+(2+1))', 21);
    });
    test('should recognize vectors', () {
      check('[1,2,[3,4]]', '[1,2,[3,4]]');
    });
    test('should handle multiple levels of brackets', () {
      check('((((((((9))))))))+1', 10);
    });
    test('should handle multiple levels of brackets', () {
      check('((((((1+1))+4)))+3)', 9);
    });
  });

  group('Prefixes', () {
    test('should correctly parse prefixes', () {
      check('-(-3*-(4))', -12);
      check('3^-1^-1', 0.333333333333333);
      check('-(-1-+1)^2', -4);
      check('-(-1-1+1)', 1);
      check('-(1)--(1-1--1)', 0);
      check('-(-(1))-(--1)', 0);
      check('5^-2^-4', 0.9043038394024115);
      check('5^---3', 0.008);
      check('5^-(++1+--+2)', 0.008);
      check('(5^-(++1+--+2))^-2', 15625);
      check('(5^-3^2)', 5.12e-7);
      check('-(--5*--7)', -35);
    });
  });

  group('Spaces', () {
    test('should respect spaces when parsing', () {
      check('sin(9)', 0.4121184852417566);
    });
    test('should ingore other spaces when parsing', () {
      check('sin(9) + 11', 11.4121184852417566);
      check('sin(9)+ 11', 11.4121184852417566);
      check('sin(9)+11', 11.4121184852417566);
      check('2* sin(9)+11', 11.824236970483513);
      check('2 * sin(9)+11', 11.824236970483513);
      check(' 2 * sin(9)+11 ', 11.824236970483513);
    });
    test('should correctly identify spaces with arguments', () {
      check(' max(5,2,17) ', 17);
    });
    test('should correctly identify matrices with spaces', () {
      check('[ 1, [ 3, 5, 7 ] , [1 , [2, [ 1, 2] ]] ]',
          '[1,[3,5,7],[1,[2,[1,2]]]]');
    });
  });

  group('Accessing vectors', () {
    test('should correctly access vectors', () {
      check('[1,[3,5,7],[1,[2,[1,2]]]][2]', '[1,[2,[1,2]]]');
      check('[1,[3,5,7],[1,[2,[1,2]]]][2][1]', '[2,[1,2]]');
      check('[1,[3,5,7],[1,[2,[1,2]]]][2][1][1]', '[1,2]');
      check('[1,[3,5,7],[1,[2,[1,2]]]][2][1][1][0]', '1');
      check('5*[1,[3,5,7],[1,[2,[1,2]]]][2][1][1][0]', '5');
      check('5*[1,[3,5,7],[1,[2,[1,2]]]][2][1][1][0]+8', '13');
    });
    test('should access ranges', () {
      check('[1,2,3,4,5][1:4]', '[2,3,4]');
    });
    test('should access using negative indices', () {
      check('[1,2,3,4,5][-2]', '4');
    });
    test('should not confuse vector wit accessor', () {
      check('[[1,2],[3,4],[5,6]]', '[[1,2],[3,4],[5,6]]');
    });
  });

  group('Setting vector values', () {
    test('should set values of vectors with the assign operator', () {
      check('[1,2][1]:x', '[1,x]');
    });
  });

  // group('Substitutions', () {
  //   test('should substitute x', () {
  //     check('x+1', {x: 4}, 5);
  //   });
  //   test('should substitute x', () {
  //     check('2*x+1', {x: 4}, 9);
  //   });
  // });
}
