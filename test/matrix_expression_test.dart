import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Matrix Expressions', () {
    late Map<String, dynamic> context;

    setUp(() {
      context = ExpressionContext.buildDefaultContext();
    });

    test('Matrix Creation and Basic Arithmetic', () {
      final exprAdd =
          Expression.parse('matrix("1 2; 3 4") + matrix("5 6; 7 8")');
      final resAdd = exprAdd.evaluate(context) as Matrix;
      print(
          'Element type: ${resAdd[0][0].runtimeType}, Value: ${resAdd[0][0]}');
      expect(resAdd[0][0], Complex(6));
      expect(resAdd[1][1], Complex(12));

      final exprSub =
          Expression.parse('matrix("10 20; 30 40") - matrix("5 6; 7 8")');
      final resSub = exprSub.evaluate(context) as Matrix;
      expect(resSub[0][0], Complex(5));
      expect(resSub[1][1], Complex(32));

      final exprDiv = Expression.parse('matrix("10 20; 30 40") / 2');
      final resDiv = exprDiv.evaluate(context) as Matrix;
      expect(resDiv[0][0], Complex(5));
      expect(resDiv[1][1], Complex(20));

      final exprNeg = Expression.parse('-matrix("1 2; 3 4")');
      final resNeg = exprNeg.evaluate(context) as Matrix;
      expect(resNeg[0][0], Complex(-1));
    });

    test('Matrix Creation (zeros, ones, eye)', () {
      final resZeros =
          Expression.parse('zeros(2, 2)').evaluate(context) as Matrix;
      expect(resZeros[0][0], Complex(0));
      expect(resZeros[0][0], isA<Complex>());

      final resOnes =
          Expression.parse('ones(2, 2)').evaluate(context) as Matrix;
      expect(resOnes[0][0], Complex(1));
      expect(resOnes[0][0], isA<Complex>());

      final resEye = Expression.parse('eye(2)').evaluate(context) as Matrix;
      expect(resEye[0][0], Complex(1));
      expect(resEye[1][1], Complex(1));
      expect(resEye[0][1], Complex(0));
    });

    test('Matrix Multiplication', () {
      final expr = Expression.parse('matrix("1 2; 3 4") * matrix("5 6; 7 8")');
      final result = expr.evaluate(context) as Matrix;
      // [1*5 + 2*7, 1*6 + 2*8] = [19, 22]
      // [3*5 + 4*7, 3*6 + 4*8] = [43, 50]
      expect(result[0][0], Complex(19));
      expect(result[0][1], Complex(22));
      expect(result[1][0], Complex(43));
      expect(result[1][1], Complex(50));
    });

    test('Matrix Functions (sin, exp, log)', () {
      final exprSin = Expression.parse('sin(matrix("0 1; 1 0"))');
      final resSin = exprSin.evaluate(context) as Matrix;
      expect(resSin[0][0], Complex(0));
      expect(resSin[0][1].real, closeTo(0.84147, 1e-5));

      final exprExp = Expression.parse('exp(matrix("0 0; 0 0"))');
      final resExp = exprExp.evaluate(context) as Matrix;
      expect(resExp[0][0], Complex(1));
      expect(resExp[1][1], Complex(1));
    });

    test('Matrix Properties', () {
      expect(Expression.parse('det(matrix("1 2; 3 4"))').evaluate(context),
          Complex(-2));
      expect(Expression.parse('trace(matrix("1 2; 3 4"))').evaluate(context),
          Complex(5));
      expect(Expression.parse('isSquare(matrix("1 2; 3 4"))').evaluate(context),
          isTrue);
      expect(Expression.parse('rowCount(matrix("1 2; 3 4"))').evaluate(context),
          2);
    });

    test('Matrix Stats', () {
      final m = Matrix("1 2; 3 4");
      context['A'] = m;
      expect(Expression.parse('mat_sum(A)').evaluate(context), Complex(10));
      expect(Expression.parse('mat_mean(A)').evaluate(context), Complex(2.5));

      final rowSum =
          Expression.parse('mat_sum(A, 1)').evaluate(context) as List;
      expect(rowSum[0], Complex(3));
      expect(rowSum[1], Complex(7));

      final colMean =
          Expression.parse('mat_mean(A, 0)').evaluate(context) as List;
      expect(colMean[0], Complex(2));
      expect(colMean[1], Complex(3));
    });

    test('Matrix Decompositions', () {
      final expr = Expression.parse('lu(matrix("4 3; 6 3"))');
      final result = expr.evaluate(context) as Map;
      expect(result.containsKey('L'), isTrue);
      expect(result.containsKey('U'), isTrue);

      final L = result['L'] as Matrix;
      final U = result['U'] as Matrix;
      final P = result['P'] as Matrix;

      // Verification: P * A = L * U?
      final A = Matrix("4 3; 6 3");
      final pa = P * A;
      final lu = L * U;
      expect(pa.isAlmostEqual(lu), isTrue);
    });

    test('Matrix Member Access', () {
      final expr = Expression.parse('lu(matrix("4 3; 6 3")).L');
      final result = expr.evaluate(context) as Matrix;
      expect(result.rowCount, 2);
      expect(result[0][0], Complex(1));
    });

    test('Matrix Pow (Matrix Exponentiation vs Element-wise)', () {
      // pow(A, 2) in utils.dart is MatrixFunctions(A).pow(2) => Matrix power
      final expr = Expression.parse('matrix("1 2; 3 4") ^ 2');
      final result = expr.evaluate(context) as Matrix;
      // [1*1 + 2*3, 1*2 + 2*4] = [7, 10]
      // [3*1 + 4*3, 3*2 + 4*4] = [15, 22]
      expect(result[0][0], Complex(7));
      expect(result[1][1], Complex(22));
    });
  });
}
