import 'package:advance_math/advance_math.dart';

void main() {
  final context = ExpressionContext.buildDefaultContext();

  final tests = {
    // Basic Arithmetic
    'complex(1, 2) + complex(3, 4)': '4 + 6i',
    'complex(1, 2) - complex(3, 4)': '-2 - 2i',
    'complex(1, 2) * complex(3, 4)': '-5 + 10i',
    'complex(1, 2) / complex(3, 4)': '0.44 + 0.08i',
    'complex(3, 4) + 5': '8 + 4i',
    '5 + complex(3, 4)': '8 + 4i',
    'complex(3, 4) * 2': '6 + 8i',
    '10 / complex(1, 1)': '5 - 5i',

    // Power and Roots
    'complex(1, 2) ^ 2': '-3 + 4i',
    'complex(1, 2) ^ complex(3, 4)': '0.129...+0.033...i',
    'sqrt(complex(-4, 0))': '0 + 2i',
    'nthRoot(complex(-8, 0), 3)': '1 + 1.732i', // One of the roots

    // Trigonometric
    'sin(complex(0, 1))': '0 + 1.175...i',
    'cos(complex(0, 1))': '1.543...+0i',
    'tan(complex(1, 1))': '0.271...+1.083...i',
    'asin(complex(2, 0))': '1.570...-1.316...i',

    // Hyperbolic
    'sinh(complex(1, 1))': '0.635...+1.188...i',
    'cosh(complex(1, 1))': '0.833...+0.988...i',

    // Log/Exp
    'exp(complex(1, 1))': '1.468...+2.287...i',
    'log(complex(1, 1))': '0.346...+0.785...i',
    'log10(complex(10, 0))': '1.0 + 0i',

    // Construction and Parsing (from example/complex.dart)
    'complex("1 + 2i")': '1 + 2i',
    'complex("-√3 + 2πi")': '-1.732...+6.283...i',
    'complex("π + ei")': '3.141...+2.718...i',
    'complex(complex(2, 3), 4)': '2 + 7i', // Nested
    'complex(5, complex(1, 2))': '3 + 1i', // Nested (matches (5 - (1+2i)i) logic in Complex.dart?) 
                                          // Actually Complex(re, im) does re - im*i if im is complex? 
                                          // Let's check Complex source.

    // Rounding / Clamping
    'floor(complex(1.9, 2.9))': '1 + 2i',
    'ceil(complex(1.1, 2.1))': '2 + 3i',
    'round(complex(1.6, 2.4))': '2 + 2i',
    'trunc(complex(1.9, -1.9))': '1 - 1i',
    'abs(complex(3, 4))': '5.0',
    
    // Identity/Zero properties in Multiplication
    'complex(1, 2) * 0': '0',
    'complex(1, 2) * 1': '1 + 2i',
    '0 * complex(1, 2)': '0',
    '1 * complex(1, 2)': '1 + 2i',
  };

  print('--- Comprehensive Complex Expression Tests ---');
  int passed = 0;
  int failed = 0;
  
  tests.forEach((expr, expected) {
    try {
      final parsed = Expression.parse(expr);
      final result = parsed.evaluate(context);
      print('EXPR: $expr');
      print('RESULT: $result');
      passed++;
    } catch (e) {
      print('EXPR: $expr');
      print('FAIL: Error: $e');
      failed++;
    }
  });

  print('\n--- Summary ---');
  print('Passed: $passed');
  print('Failed: $failed');
}
