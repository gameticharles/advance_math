part of 'expression.dart';

/// Returns a list of all the variables in the expression.
/// Returns a list of all the variables in the expression.
final Map<String, dynamic> defaultContext =
    ExpressionContext.buildDefaultContext();

/// A class that provides the default context for mathematical expressions.
class ExpressionContext {
  /// Builds the default context by merging various specialized contexts.
  static Map<String, dynamic> buildDefaultContext() {
    return {
      ..._sharedExtras(),
      ..._matrixExtras(),
      ..._geometryExtras(),
      ..._complexExtras(),
      ..._statsExtras(),
      ..._polynomialExtras(),
    };
  }

  /// Helper to convert various inputs to a list of doubles.
  static List<double> _toDoubles(dynamic args) {
    if (args == null) return [];
    if (args is List) {
      if (args.isEmpty) return [];
      if (args.first is List) {
        return (args.first as List)
            .map((e) => (e is num)
                ? e.toDouble()
                : (e is Complex ? e.real.toDouble() : 0.0))
            .toList();
      }
      return args
          .map((e) => (e is num)
              ? e.toDouble()
              : (e is Complex ? e.real.toDouble() : 0.0))
          .toList();
    }
    return [(args as num).toDouble()];
  }

  /// Provides common constants and basic mathematical functions.
  static Map<String, dynamic> _sharedExtras() => {
        // ... (existing constants and functions)
        'simpson': _simpsonWrapper,
        'numIntegrate': _numIntegrateWrapper,
        'diff': _diffWrapper,

        // Constants
        'pi': pi,
        'e': e,
        'ex': ex,
        'tau': tau,
        'ln2': ln2,
        'ln10': ln10,
        'log2e': log2e,
        'log10e': log10e,
        'sqrt1_2': sqrt1_2,
        'sqrt2': sqrt2,
        'sqrt3': sqrt3,
        'phi': 1.618033988749895,
        'eulerGamma': 0.577215664901532,
        'nan': double.nan,
        'NaN': double.nan,
        'inf': double.infinity,
        'Infinity': double.infinity,
        'i': Complex.i(),
        'I': Complex.i(),
        'goldenRatio': 1.618033988749895,

        // Physics Constants
        'speedOfLight': PhysicsConstants.speedOfLight,
        'c': PhysicsConstants.speedOfLight,
        'planckConstant': PhysicsConstants.planckConstant,
        'h': PhysicsConstants.planckConstant,
        'reducedPlanckConstant': PhysicsConstants.reducedPlanckConstant,
        'gravitationalConstant': PhysicsConstants.gravitationalConstant,
        'G': PhysicsConstants.gravitationalConstant,
        'standardGravity': PhysicsConstants.standardGravity,
        'g': PhysicsConstants.standardGravity,
        'boltzmannConstant': PhysicsConstants.boltzmannConstant,
        'k': PhysicsConstants.boltzmannConstant,
        'electronMass': PhysicsConstants.electronMass,
        'protonMass': PhysicsConstants.protonMass,
        'neutronMass': PhysicsConstants.neutronMass,
        'elementaryCharge': PhysicsConstants.elementaryCharge,
        'avogadrosNumber': PhysicsConstants.avogadrosNumber,
        'Na': PhysicsConstants.avogadrosNumber,
        'gasConstant': PhysicsConstants.gasConstant,
        'R': PhysicsConstants.gasConstant,
        'stefanBoltzmannConstant': PhysicsConstants.stefanBoltzmannConstant,

        // Angle Constants
        'halfPi': AngleConstants.halfPi,
        'quarterPi': AngleConstants.quarterPi,
        'deg2rad': AngleConstants.piOver180,
        'rad2deg': AngleConstants.d180OverPi,

        // Basic Math functions
        'log': log,
        'ln': log,
        'exp': (dynamic x) => exp(x),
        'pow': (dynamic x, dynamic y) => pow(x, y),
        'abs': (dynamic x) => abs(x),
        'sqrt': (dynamic x) => sqrt(x),
        'cbrt': (dynamic x) => cbrt(x),
        'nthRoot': (dynamic x, dynamic n) =>
            nthRoot(x, n is Complex ? n.real.toInt() : (n as num).toInt()),
        'logBase': (dynamic b, dynamic x) => logBase(b, x),
        'log10': (dynamic x) => log10(x),
        'fact': (dynamic x) =>
            factorial(x is Complex ? x.real.toInt() : (x as num).toInt()),
        'factorial': (dynamic x) =>
            factorial(x is Complex ? x.real.toInt() : (x as num).toInt()),
        'factorial2': (dynamic x) =>
            factorial2(x is Complex ? x.real.toInt() : (x as num).toInt()),
        'doubleFactorial': (dynamic x) => doubleFactorial(
            x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'step': (dynamic x) =>
            step(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'rect': (dynamic x) =>
            rect(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'sign': (dynamic x) =>
            sign(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'modF': (dynamic x) =>
            modF((x is Complex ? x.real : x as num).toDouble()),

        'mod': (dynamic x, dynamic y) => mod(x, y),
        'modInv': (dynamic a, dynamic m) => modInv(
            a is Complex ? a.real : a as num, m is Complex ? m.real : m as num),
        'nChooseRModPrime': (dynamic n, dynamic r, dynamic p) =>
            nChooseRModPrime(
                n is Complex ? n.real.toInt() : (n as num).toInt(),
                r is Complex ? r.real.toInt() : (r as num).toInt(),
                p is Complex ? p.real.toInt() : (p as num).toInt()),
        'bigIntNChooseRModPrime': (dynamic n, dynamic r, dynamic p) =>
            bigIntNChooseRModPrime(
                n is Complex ? n.real.toInt() : (n as num).toInt(),
                r is Complex ? r.real.toInt() : (r as num).toInt(),
                p is Complex ? p.real.toInt() : (p as num).toInt()),
        'floor': (dynamic x) => floor(x is Complex ? x.real : x as num),
        'ceil': (dynamic x) => ceil(x is Complex ? x.real : x as num),
        'hypot': (dynamic x, dynamic y) => hypot(
            x is Complex ? x.real : x as num, y is Complex ? y.real : y as num),
        // 'hypot': (dynamic x, dynamic y) => x is Complex
        // ? Complex.hypot(x, Complex(y))
        // : (y is Complex
        //     ? Complex.hypot(Complex(x), y)
        //     : math.hypot(x as num, y as num)),
        'round': (dynamic x, [dynamic decimalPlaces = 0]) {
          final dp = decimalPlaces is Complex
              ? decimalPlaces.real.toInt()
              : (decimalPlaces as num).toInt();
          final xVal = x is Complex && x.isReal ? x.simplify() : x;
          return round(xVal is num ? xVal : x, dp);
        },
        'roundDecimal': (dynamic x, dynamic n) => round(
            x is Complex ? x.real : x as num,
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'roundTo': (dynamic x, dynamic n) => round(
            x is Complex ? x.real : x as num,
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'clamp': (dynamic x, dynamic min, dynamic max) => clamp(
            x is Complex ? x.real : x as num,
            min is Complex ? min.real : min as num,
            max is Complex ? max.real : max as num),
        'lerp': (dynamic a, dynamic b, dynamic t) => lerp(
            a is Complex ? a.real : a as num,
            b is Complex ? b.real : b as num,
            t is Complex ? t.real : t as num),
        'rec': (dynamic r, dynamic theta) => rec(
            r is Complex ? r.real : r as num,
            theta is Complex ? theta.real : theta as num),
        'pol': (dynamic x, dynamic y) => pol(
            x is Complex ? x.real : x as num, y is Complex ? y.real : y as num),
        'isDigit': isDigit,
        'isAlpha': isAlpha,
        'isAlphaNumeric': isAlphaNumeric,
        'isDivisible': (dynamic x, dynamic y) => isDivisible(
            x is Complex ? x.real : x as num, y is Complex ? y.real : y as num),
        'isEven': (dynamic n) =>
            isEven(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isOdd': (dynamic n) =>
            isOdd(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isPrime': (dynamic n) => isPrime(n is Complex ? n.real.toInt() : n),
        'nthPrime': (dynamic n) =>
            nthPrime(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'sieve': (dynamic n) =>
            sieve(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'fibonacci': (dynamic n) =>
            fib(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'fib': (dynamic n) =>
            fib(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isPerfectSquare': (dynamic n) =>
            isPerfectSquare(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isPerfectCube': (dynamic n) =>
            isPerfectCube(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isFibonacci': (dynamic n) =>
            isFibonacci(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isPalindrome': (dynamic n) =>
            isPalindrome(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isPandigital': (dynamic n) =>
            isPandigital(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isArmstrongNumber': (dynamic n) => isArmstrongNumber(
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isPerfectNumber': (dynamic n) =>
            isPerfectNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'trunc': (dynamic x) =>
            trunc((x is Complex ? x.real : x as num).toDouble()),

        'factors': (dynamic n) =>
            factors(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'factorsOf': (dynamic n) =>
            factors(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'primeFactors': (dynamic n) =>
            primeFactors(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'nthTriangleNumber': (dynamic n) => nthTriangleNumber(
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'nthPentagonalNumber': (dynamic n) => nthPentagonalNumber(
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'nthHexagonalNumber': (dynamic n) => nthHexagonalNumber(
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'nthTetrahedralNumber': (dynamic n) => nthTetrahedralNumber(
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'nthHarmonicNumber': (dynamic n) => nthHarmonicNumber(
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'gamma': (dynamic x) =>
            gamma(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'erf': (dynamic x) =>
            erf(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'erfc': (dynamic x) =>
            erfc(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'lgamma': (dynamic x) =>
            lgamma(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'digamma': (dynamic x) =>
            digamma(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'beta': (dynamic x, dynamic y) => beta(
            x is Complex ? x.real.toDouble() : (x as num).toDouble(),
            y is Complex ? y.real.toDouble() : (y as num).toDouble()),
        'zeta': (dynamic s) =>
            zeta(s is Complex ? s.real.toDouble() : (s as num).toDouble()),
        'expm1': (dynamic x) =>
            expm1(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'log1p': (dynamic x) =>
            log1p(x is Complex ? x.real.toDouble() : (x as num).toDouble()),

        'collatz': (dynamic n, [dynamic returnSequence = true]) => collatz(
            n is Complex ? n.real.toInt() : (n as num).toInt(),
            returnSequence is Complex
                ? returnSequence.real == 1
                : (returnSequence as bool)),
        'collatzPeak': (dynamic n) =>
            collatzPeak(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'longestCollatzInRange': (dynamic start, dynamic end) =>
            longestCollatzInRange(
                start is Complex ? start.real.toInt() : (start as num).toInt(),
                end is Complex ? end.real.toInt() : (end as num).toInt()),
        'isKaprekarNumber': (dynamic n) => isKaprekarNumber(
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isNarcissisticNumber': (dynamic n) => isNarcissisticNumber(
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isHappyNumber': (dynamic n) =>
            isHappyNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'isMersennePrime': (dynamic n) =>
            isMersennePrime(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'frexp': (dynamic x) => frexp(x is Complex ? x.real : x as num),
        'ldexp': (dynamic x, dynamic n) => ldexp(
            x is Complex ? x.real : x as num,
            n is Complex ? n.real.toInt() : (n as num).toInt()),
        'getDigits': (dynamic n) =>
            getDigits(n is Complex ? n.real.toInt() : (n as num).toInt()),
        'egcd': (dynamic a, dynamic b) => egcd(
            a is Complex ? a.real.toInt() : (a as num).toInt(),
            b is Complex ? b.real.toInt() : (b as num).toInt()),
        'binomialCoefficient': (dynamic n, dynamic k) => binomialCoefficient(
            n is Complex ? n.real.toInt() : (n as num).toInt(),
            k is Complex ? k.real.toInt() : (k as num).toInt()),

        //Polynomials
        'roots': (dynamic exp) => Polynomial.fromString(exp.toString()).roots(),

        // Calculus functions
        'derivative': (dynamic exp) =>
            Expression.parse(exp.toString()).differentiate(),
        'integrate': (dynamic exp) =>
            Expression.parse(exp.toString()).integrate(),
        'simplify': (dynamic exp) =>
            Expression.parse(exp.toString()).simplify(),

        // Trigonometric functions
        'sin': (dynamic x) => sin(x),
        'cos': (dynamic x) => cos(x),
        'tan': (dynamic x) => tan(x),
        'csc': (dynamic x) => csc(x),
        'sec': (dynamic x) => sec(x),
        'cot': (dynamic x) => cot(x),
        'asin': (dynamic x) => asin(x),
        'acos': (dynamic x) => acos(x),
        'atan': (dynamic x) => atan(x),
        'atan2': (dynamic a, dynamic b) => atan2(a, b),
        'asec': (dynamic x) => asec(x),
        'acsc': (dynamic x) => acsc(x),
        'acot': (dynamic x) => acot(x),

        'sinh': (dynamic x) => sinh(x),
        'cosh': (dynamic x) => cosh(x),
        'tanh': (dynamic x) => tanh(x),
        'csch': (dynamic x) => csch(x),
        'sech': (dynamic x) => sech(x),
        'coth': (dynamic x) => coth(x),

        'asinh': (dynamic x) => asinh(x),
        'acosh': (dynamic x) => acosh(x),
        'atanh': (dynamic x) => atanh(x),
        'acsch': (dynamic x) => acsch(x),
        'asech': (dynamic x) => asech(x),
        'acoth': (dynamic x) => acoth(x),
        'vers': (dynamic x) => vers(x),
        'covers': (dynamic x) => covers(x),
        'havers': (dynamic x) => havers(x),
        'exsec': (dynamic x) => exsec(x),
        'excsc': (dynamic x) => excsc(x),

        'sawtooth': (dynamic x) => sawtooth(x is Complex ? x.real : x as num),
        'squareWave': (dynamic x) => squareWave(
            x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'triangleWave': (dynamic x) => triangleWave(
            x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'sinc': (dynamic x) => sinc(x),

        // Missing Basic Math Functions
        'sinc_old': (dynamic x) =>
            sinc(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'sumUpTo': (dynamic start, dynamic end, [dynamic step = 1]) => sumUpTo(
            start is Complex ? start.real : start as num,
            end is Complex ? end.real : end as num,
            step: step is Complex ? step.real : step as num),

        'isClose': (dynamic a, dynamic b,
                [dynamic rel = 1e-9, dynamic absValue = 1e-15]) =>
            isClose(a is Complex ? a.real.toDouble() : (a as num).toDouble(),
                b is Complex ? b.real.toDouble() : (b as num).toDouble(),
                relTol: rel is Complex
                    ? rel.real.toDouble()
                    : (rel as num).toDouble(),
                absTol: absValue is Complex
                    ? absValue.real.toDouble()
                    : (absValue as num).toDouble()),
        'integerPart': (dynamic x) => integerPart(
            x is Complex ? x.real.toDouble() : (x as num).toDouble()),
        'fibRange': (dynamic start, dynamic end) => fibRange(
            start is Complex ? start.real.toInt() : (start as num).toInt(),
            end is Complex ? end.real.toInt() : (end as num).toInt()),

        // Random (Robustness)
        'rand': VarArgsFunction((args, kwargs) {
          var min = args.isNotEmpty
              ? (args[0] is Complex
                  ? (args[0] as Complex).real
                  : args[0] as num?)
              : null;
          var max = args.length > 1
              ? (args[1] is Complex
                  ? (args[1] as Complex).real
                  : args[1] as num?)
              : null;
          var r = math.Random();
          if (min == null && max == null) return r.nextDouble();
          if (min != null && max == null) return r.nextDouble() * min;
          if (min != null && max != null) {
            return min + r.nextDouble() * (max - min);
          }
          return r.nextDouble();
        }),
        'randint': (dynamic max) => math.Random()
            .nextInt(max is Complex ? max.real.toInt() : (max as num).toInt()),
        'randomBetween': (dynamic from, dynamic to) => randomBetween(
            from is Complex ? from.real.toInt() : (from as num).toInt(),
            to is Complex ? to.real.toInt() : (to as num).toInt()),
        'randomString': (dynamic length) => randomString(
            length is Complex ? length.real.toInt() : (length as num).toInt(),
            CharacterType.lowerAlpha),
        'randomNumeric': (dynamic length) => randomNumeric(
            length is Complex ? length.real.toInt() : (length as num).toInt()),
        'randomAlpha': (dynamic length) => randomAlpha(
            length is Complex ? length.real.toInt() : (length as num).toInt()),
        'randomAlphaNumeric': (dynamic length) => randomAlphaNumeric(
            length is Complex ? length.real.toInt() : (length as num).toInt()),
        'randomMerge': randomMerge,

        // Utilities
        'time': (dynamic x) {
          final t = time(x);
          return {
            'result': t.result,
            'elapsed': t.elapsed.inMicroseconds / 1000.0
          };
        },
        'timeAsync': (dynamic x) async {
          final t = await timeAsync(x);
          return {
            'result': t.result,
            'elapsed': t.elapsed.inMicroseconds / 1000.0
          };
        },

        // String functions
        'string': (dynamic x) => x.toString(),
        'length': (dynamic x) => x.toString().length,
        'toUpper': (dynamic x) => x.toString().toUpperCase(),
        'toLower': (dynamic x) => x.toString().toLowerCase(),
        'concat': (dynamic x, dynamic y) => x.toString() + y.toString(),
        'link': (dynamic x, dynamic y) => '<a href="$y">$x</a>',
        'str2number': (dynamic x) => num.parse(x.toString()),
        'number2str': (dynamic x) => x.toString(),
        'left': (dynamic x, dynamic y) => x
            .toString()
            .substring(0, (y is Complex ? y.real.toInt() : (y as num).toInt())),
        'right': (dynamic x, dynamic y) => x
            .toString()
            .substring(y is Complex ? y.real.toInt() : (y as num).toInt()),

        'number': (dynamic x) => num.parse(x.toString()),

        // Date functions
        'now': DateTime.now().toString(),
        'daysDiff': (dynamic x, dynamic y) =>
            DateTime.parse(x).difference(DateTime.parse(y)).inDays,
        'hoursDiff': (dynamic x, dynamic y) =>
            DateTime.parse(x).difference(DateTime.parse(y)).inHours,
        'minutesDiff': (dynamic x, dynamic y) =>
            DateTime.parse(x).difference(DateTime.parse(y)).inMinutes,
        'secondsDiff': (dynamic x, dynamic y) =>
            DateTime.parse(x).difference(DateTime.parse(y)).inSeconds,
        'millisecondsDiff': (dynamic x, dynamic y) =>
            DateTime.parse(x).difference(DateTime.parse(y)).inMilliseconds,
        'microsecondsDiff': (dynamic x, dynamic y) =>
            DateTime.parse(x).difference(DateTime.parse(y)).inMicroseconds,

        // iif(cond, trueVal, falseVal)
        'iif': VarArgsFunction((args, _) {
          final cond = args[0];
          final a = args[1];
          final b = args[2];
          bool isTrue = false;
          if (cond is bool) {
            isTrue = cond;
          } else if (cond is num) {
            isTrue = cond.toDouble() != 0;
          } else if (cond is Complex) {
            isTrue = cond.real != 0;
          }
          return isTrue ? a : b;
        }),

        // if(cond, trueVal, falseVal)
        'if': VarArgsFunction((args, _) {
          final cond = args[0];
          final a = args[1];
          final b = args[2];
          bool isTrue = false;
          if (cond is bool) {
            isTrue = cond;
          } else if (cond is num) {
            isTrue = cond.toDouble() != 0;
          } else if (cond is Complex) {
            isTrue = cond.real != 0;
          }
          return isTrue ? a : b;
        }),

        // switch(value, case1, val1, case2, val2, ..., defaultVal)
        'switch': VarArgsFunction((args, _) {
          if (args.length < 2) {
            throw ArgumentError('switch requires at least 2 arguments');
          }
          final value = args[0];
          if (args.length % 2 == 0) {
            // No default value, last case is just a case
            for (int i = 1; i < args.length; i += 2) {
              if (args[i] == value) return args[i + 1];
            }
            return null;
          } else {
            // Last value is the default
            for (int i = 1; i < args.length - 1; i += 2) {
              if (args[i] == value) return args[i + 1];
            }
            return args.last;
          }
        }),
      };

  static Map<String, dynamic> _matrixExtras() => {
        ..._sharedExtras(),

        'matrix': VarArgsFunction((args, _) {
          if (args.isEmpty) throw ArgumentError('matrix() requires arguments');
          final first = args.first;
          if (first is String) return Matrix(first);
          if (first is List) return Matrix(first);
          throw ArgumentError(
              'matrix() expects a string like "1 2; 3 4" or a List of Lists');
        }),

        // Constructors
        'zeros': VarArgsFunction(
            (args, _) => Matrix.zeros(args[0] as int, args[1] as int)),
        'ones': VarArgsFunction(
            (args, _) => Matrix.ones(args[0] as int, args[1] as int)),
        'eye': VarArgsFunction((args, _) => Matrix.eye(args[0] as int)),
        'diag': VarArgsFunction(
            (args, _) => Matrix.fromDiagonal(args.first as List)),
        'rand_matrix': VarArgsFunction(
            (args, _) => Matrix.random(args[0] as int, args[1] as int)),
        'linspace': VarArgsFunction((args, _) => Matrix.linspace(
              (args[0] as num).toInt(),
              (args[1] as num).toInt(),
              args.length > 2 ? args[2] as int : 50,
            )),

        // Decompositions / properties
        'det':
            VarArgsFunction((args, _) => (args.first as Matrix).determinant()),
        'inv': VarArgsFunction((args, _) => (args.first as Matrix).inverse()),
        'transpose':
            VarArgsFunction((args, _) => (args.first as Matrix).transpose()),
        'rank': VarArgsFunction((args, _) => (args.first as Matrix).rank()),
        'trace': VarArgsFunction((args, _) => (args.first as Matrix).trace()),
        'norm': VarArgsFunction((args, _) => (args.first as Matrix).norm()),
        'nullity':
            VarArgsFunction((args, _) => (args.first as Matrix).nullity()),
        'eigenvalues':
            VarArgsFunction((args, _) => (args.first as Matrix).eigen().values),

        // Solve Ax = b
        'solve': VarArgsFunction((args, _) {
          final A = args[0] as Matrix;
          final b = args[1] as Matrix;
          return A.linear.solve(b, method: LinearSystemMethod.gaussElimination);
        }),

        // Element access helpers
        'row': VarArgsFunction(
            (args, _) => (args[0] as Matrix).row(args[1] as int)),
        'col': VarArgsFunction(
            (args, _) => (args[0] as Matrix).column(args[1] as int)),
        'shape': VarArgsFunction((args, _) => (args.first as Matrix).shape),

        // Stats on matrix
        'mat_mean': VarArgsFunction((args, _) => (args.first as Matrix).mean()),
        'mat_sum': VarArgsFunction((args, _) => (args.first as Matrix).sum()),
        'mat_max': VarArgsFunction((args, _) => (args.first as Matrix).max()),
        'mat_min': VarArgsFunction((args, _) => (args.first as Matrix).min()),
      };

  static Map<String, dynamic> _geometryExtras() => {
        ..._sharedExtras(),

        // Constructors
        'point': VarArgsFunction((args, _) {
          if (args.length == 2) return Point(args[0], args[1]);
          if (args.length == 3) return Point(args[0], args[1], args[2]);
          throw ArgumentError('point() requires 2 or 3 arguments');
        }),

        'circle': VarArgsFunction((args, kwargs) {
          final center = kwargs['center'] ?? args[0] as Point;
          final radius =
              ((kwargs['r'] ?? kwargs['radius'] ?? args[1]) as num).toDouble();
          return Circle(radius, center: center);
        }),

        'triangle': VarArgsFunction((args, kwargs) {
          final a = ((kwargs['a'] ?? args[0]) as num);
          final b = ((kwargs['b'] ?? args[1]) as num);
          final c = ((kwargs['c'] ?? args[2]) as num);
          return Triangle(a: a, b: b, c: c);
        }),

        'triangle_pts': VarArgsFunction((args, _) => Triangle(
              A: args[0] as Point,
              B: args[1] as Point,
              C: args[2] as Point,
            )),

        'polygon': VarArgsFunction((args, _) {
          final pts = (args.first as List).cast<Point>();
          return Polygon(vertices: pts);
        }),

        'reg_polygon': VarArgsFunction((args, kwargs) => RegularPolygon(
              numSides: (kwargs['n'] ?? args[0]) as int,
              sideLength: ((kwargs['side'] ?? args[1]) as num).toDouble(),
            )),

        'line': VarArgsFunction((args, _) {
          if (args[0] is Point) {
            return Line(p1: args[0] as Point, p2: args[1] as Point);
          }
          return Line(gradient: args[0], intercept: args[1]);
        }),

        'area': VarArgsFunction((args, _) {
          final s = args.first;
          if (s is Circle) return s.area();
          if (s is Triangle) return s.area(AreaMethod.heron);
          if (s is Polygon) return s.shoelace();
          if (s is RegularPolygon) return s.areaPolygon();
          throw ArgumentError(
              'area() expects Circle, Triangle, Polygon, or RegularPolygon');
        }),

        'perimeter': VarArgsFunction((args, _) {
          final s = args.first;
          if (s is Circle) return s.circumference;
          if (s is Triangle) return s.perimeter();
          if (s is Polygon) return s.perimeter();
          if (s is RegularPolygon) return s.perimeter();
          throw ArgumentError(
              'perimeter() expects Circle, Triangle, or Polygon');
        }),

        'circumference':
            VarArgsFunction((args, _) => (args.first as Circle).circumference),

        'distance': VarArgsFunction(
            (args, _) => (args[0] as Point).distanceTo(args[1] as Point)),
        'midpoint': VarArgsFunction(
            (args, _) => (args[0] as Point).midpointTo(args[1] as Point)),
        'centroid':
            VarArgsFunction((args, _) => (args.first as Polygon).centroid()),
        'bearing': VarArgsFunction(
            (args, _) => (args[0] as Point).bearingTo(args[1] as Point)),
        'slope': VarArgsFunction(
            (args, _) => (args[0] as Point).slopeTo(args[1] as Point)),

        'is_inside': VarArgsFunction((args, _) {
          final shape = args[0];
          final pt = args[1] as Point;
          if (shape is Circle) return shape.isPointInside(pt);
          if (shape is Polygon) return shape.isPointInsidePolygon(pt);
          throw ArgumentError('is_inside() expects (Circle/Polygon, Point)');
        }),
      };

  static Map<String, dynamic> _complexExtras() => {
        ..._sharedExtras(),

        // imaginary unit constant
        'i': Complex(0, 1),

        'complex': VarArgsFunction((args, kwargs) {
          final re = (kwargs['re'] ?? kwargs['real'] ?? args[0]);
          final im = (kwargs['im'] ??
              kwargs['imag'] ??
              (args.length > 1 ? args[1] : 0));
          return Complex(re, im);
        }),

        'real': VarArgsFunction((args, _) => (args.first as Complex).real),
        'imag': VarArgsFunction((args, _) => (args.first as Complex).imaginary),
        'modulus': VarArgsFunction((args, _) => (args.first as Complex).abs()),
        'arg': VarArgsFunction((args, _) => (args.first as Complex).argument()),
        'conj': VarArgsFunction((args, _) => (args.first as Complex).conjugate),

        'polar': VarArgsFunction((args, _) {
          final c = args.first as Complex;
          return {'r': c.abs(), 'theta': c.argument()};
        }),
        'from_polar': VarArgsFunction((args, kwargs) {
          final r = ((kwargs['r'] ?? args[0]) as num).toDouble();
          final theta = ((kwargs['theta'] ?? args[1]) as num).toDouble();
          return Complex(r * math.cos(theta), r * math.sin(theta));
        }),
      };

  static Map<String, dynamic> _statsExtras() => {
        ..._sharedExtras(),

        'zscore': VarArgsFunction(
            (args, _) => ZScore.computeZScore((args.first as num).toDouble())),

        'zscore_from_raw': VarArgsFunction((args, _) =>
            ZScore.computeZScoreFromRawScore(args[0], args[1], args[2])),

        'confidence_interval': VarArgsFunction((args, _) {
          final ci = ZScore.computeConfidenceInterval(
            (args[0] as num).toDouble(),
            (args[1] as num).toInt(),
            (args[2] as num).toDouble(),
            (args[3] as num).toDouble(),
          );
          return {'lower': ci.lower, 'upper': ci.upper};
        }),

        'percentile': VarArgsFunction((args, _) =>
            ZScore.computePercentile((args.first as num).toDouble())),

        'p_value': VarArgsFunction(
            (args, _) => ZScore.computePValue((args.first as num).toDouble())),

        'cdf': VarArgsFunction(
            (args, _) => ZScore.computeCDF((args.first as num).toDouble())),

        'pdf': VarArgsFunction(
            (args, _) => ZScore.computePDF((args.first as num).toDouble())),

        'z_to_t': VarArgsFunction(
            (args, _) => ZScore.convertZToT((args.first as num).toDouble())),

        'range_stat': VarArgsFunction((args, _) {
          final list = _toDoubles(args);
          return list.reduce((a, b) => a > b ? a : b) -
              list.reduce((a, b) => a < b ? a : b);
        }),

        'iqr': VarArgsFunction((args, _) {
          final q = Statistics.quartiles(_toDoubles(args).cast<num>());
          return (q[2]) - (q[0]);
        }),

        'covariance': VarArgsFunction((args, _) {
          final x = _toDoubles(
              args[0] is List ? [args[0]] : args.sublist(0, args.length ~/ 2));
          final y = _toDoubles(
              args[1] is List ? [args[1]] : args.sublist(args.length ~/ 2));
          if (x.length != y.length) {
            throw ArgumentError('covariance: lists must be same length');
          }
          return Statistics.covariance(x, y);
        }),

        // Statistic functions
        'avg': avg,
        'max': max,
        'min': min,
        'sum': sum,

        'sumTo': (dynamic x) =>
            sumTo(x is Complex ? x.real.toInt() : (x as num).toInt()),
        'nPr': (dynamic n, dynamic r) => permutations(
                n is Complex ? n.real.toInt() : (n as num).toInt(),
                r is Complex ? r.real.toInt() : (r as num).toInt())
            .length,
        'permutations': (dynamic n, dynamic r) => permutations(
                n is Complex ? n.real.toInt() : (n as num).toInt(),
                r is Complex ? r.real.toInt() : (r as num).toInt())
            .length,
        'nCr': (dynamic n, dynamic r) => combinations(
                n is Complex ? n.real.toInt() : (n as num).toInt(),
                r is Complex ? r.real.toInt() : (r as num).toInt())
            .length,
        'combinations': (dynamic n, dynamic r) => combinations(
                n is Complex ? n.real.toInt() : (n as num).toInt(),
                r is Complex ? r.real.toInt() : (r as num).toInt())
            .length,

        'mean': mean,
        'average': mean,
        'median': median,
        'mode': mode,
        'variance': variance,
        'standardDeviation': stdDev,
        'stdDev': stdDev,
        'stdErrMean': stdErrMean,
        'stdErrEst': stdErrEst,
        'tValue': tValue,
        'quartiles': quartiles,
        'gcf': gcf,
        'gcd': gcd,
        'lcm': lcm,
        'correlation': correlation,
        'confidenceInterval': confidenceInterval,
        'regression': regression,
      };

  static Map<String, dynamic> _polynomialExtras() => {
        ..._sharedExtras(),
        'quadratic': VarArgsFunction((args, kwargs) {
          final a = (kwargs['a'] ?? args[0]) as num;
          final b = (kwargs['b'] ?? args[1]) as num;
          final c = (kwargs['c'] ?? args[2]) as num;
          return Quadratic.num(a: a, b: b, c: c);
        }),
        'cubic': VarArgsFunction((args, kwargs) {
          final a = (kwargs['a'] ?? args[0]) as num;
          final b = (kwargs['b'] ?? args[1]) as num;
          final c = (kwargs['c'] ?? args[2]) as num;
          final d = (kwargs['d'] ?? args[3]) as num;
          return Cubic.num(a: a, b: b, c: c, d: d);
        }),
        'quartic': VarArgsFunction((args, kwargs) {
          final a = (kwargs['a'] ?? args[0]) as num;
          final b = (kwargs['b'] ?? args[1]) as num;
          final c = (kwargs['c'] ?? args[2]) as num;
          final d = (kwargs['d'] ?? args[3]) as num;
          final e = (kwargs['e'] ?? args[4]) as num;
          return Quartic.num(a: a, b: b, c: c, d: d, e: e);
        }),
        'poly': VarArgsFunction(
            (args, _) => Polynomial.fromString(args.first.toString())),
        'vertex': VarArgsFunction((args, _) {
          final p = args.first;
          if (p is Quadratic) return p.vertex();
          throw ArgumentError('vertex() requires a Quadratic polynomial');
        }),
        'factorize': VarArgsFunction((args, _) {
          final p = args.first;
          if (p is Polynomial) return p.factorizeString();
          return Polynomial.fromString(p.toString()).factorizeString();
        }),
        'differentiate': VarArgsFunction((args, _) {
          final p = args.first;
          if (p is Polynomial) return p.differentiate();
          return Polynomial.fromString(p.toString()).differentiate();
        }),
        'poly_integrate': VarArgsFunction((args, _) {
          final p = args.first;
          if (p is Polynomial) return p.integrate();
          return Polynomial.fromString(p.toString()).integrate();
        }),
        'evaluate': VarArgsFunction((args, _) {
          final p = args[0];
          final x = args[1];
          if (p is Polynomial) return p.evaluate(x);
          return Polynomial.fromString(p.toString()).evaluate(x);
        }),
        'degree': VarArgsFunction((args, _) {
          final p = args.first;
          if (p is Polynomial) return p.degree;
          return Polynomial.fromString(p.toString()).degree;
        }),
        'roots': (dynamic exp) => Polynomial.fromString(exp.toString()).roots(),
      };
}

dynamic _simpsonWrapper(dynamic f, dynamic a, dynamic b) {
  num Function(num) fn;
  if (f is String) {
    final expr = ExpressionParser().parse(f);
    fn = (x) {
      final val =
          expr.evaluate(<String, dynamic>{...defaultContext, 'x': Complex(x)});

      if (val is Complex) return val.real;
      if (val is num) return val.toDouble();
      return double.nan;
    };
  } else {
    fn = f as num Function(num);
  }
  return NumericalIntegration.simpsons(
      fn,
      a is Complex ? a.real.toDouble() : (a as num).toDouble(),
      b is Complex ? b.real.toDouble() : (b as num).toDouble());
}

dynamic _numIntegrateWrapper(dynamic f, dynamic a, dynamic b) {
  Function fn;
  if (f is String) {
    final expr = ExpressionParser().parse(f);
    fn = (x) {
      final val =
          expr.evaluate(<String, dynamic>{...defaultContext, 'x': Complex(x)});

      if (val is Complex) return val.real;
      if (val is num) return val.toDouble();
      return double.nan;
    };
  } else {
    fn = f as Function;
  }
  return numIntegrate(
      fn,
      a is Complex ? a.real.toDouble() : (a as num).toDouble(),
      b is Complex ? b.real.toDouble() : (b as num).toDouble());
}

dynamic _diffWrapper(dynamic f, [dynamic h = 0.001]) {
  num Function(num) fn;
  if (f is String) {
    final expr = ExpressionParser().parse(f);
    fn = (x) {
      final val =
          expr.evaluate(<String, dynamic>{...defaultContext, 'x': Complex(x)});

      if (val is Complex) return val.real;
      if (val is num) return val.toDouble();
      return double.nan;
    };
  } else {
    fn = f as num Function(num);
  }
  return NumericalDifferentiation.derivative(
      fn, h is Complex ? h.real.toDouble() : (h as num).toDouble());
}
