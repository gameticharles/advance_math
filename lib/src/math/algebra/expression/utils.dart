part of 'expression.dart';

/// Returns a list of all the variables in the expression.
/// Returns a list of all the variables in the expression.
final Map<String, dynamic> defaultContext =
    ExpressionContext.buildDefaultContext();

int _toInt(dynamic v) => v is Complex ? v.real.toInt() : (v as num).toInt();

List<dynamic> _flattenArgs(List<dynamic> args) {
  if (args.isEmpty) return [];
  if (args.length == 1 && args.first is List) {
    return args.first as List;
  }
  if (args.length == 1 && args.first is Vector) {
    return (args.first as Vector).toList();
  }
  return args;
}

/// A class that provides the default context for mathematical expressions.
class ExpressionContext {
  /// Builds the default context by merging various specialized contexts.
  static Map<String, dynamic> buildDefaultContext() {
    return {
      ..._sharedExtras(),
      ..._flowExtras(),
      ..._vectorExtras(),
      ..._numberExtras(),
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
        'log': (dynamic x) => log(x),
        'ln': (dynamic x) => log(x),
        'exp': (dynamic x) => exp(x),
        'pow': (dynamic x, dynamic y) => pow(x, y),
        'abs': (dynamic x) => abs(x),
        'sqrt': (dynamic x) => sqrt(x),

        'cbrt': (dynamic x) => cbrt(x),
        'nthRoot': (dynamic x, dynamic n) => nthRoot(x, n),
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
        'floor': (dynamic x) => x is Complex ? x.floor() : floor(x as num),
        'ceil': (dynamic x) => x is Complex ? x.ceil() : ceil(x as num),
        'hypot': (dynamic x, dynamic y) => hypot(x, y),
        // 'hypot': (dynamic x, dynamic y) => x is Complex
        // ? Complex.hypot(x, Complex(y))
        // : (y is Complex
        //     ? Complex.hypot(Complex(x), y)
        //     : math.hypot(x as num, y as num)),
        'round': (dynamic x, [dynamic decimalPlaces = 0]) {
          final dp = decimalPlaces is Complex
              ? decimalPlaces.real.toInt()
              : (decimalPlaces as num).toInt();
          return round(x, dp);
        },
        'roundDecimal': (dynamic x, dynamic n) =>
            round(x, n is Complex ? n.real.toInt() : (n as num).toInt()),
        'roundTo': (dynamic x, dynamic n) =>
            round(x, n is Complex ? n.real.toInt() : (n as num).toInt()),
        'clamp': (dynamic x, dynamic min, dynamic max) => clamp(
            x,
            min is Complex ? min.real : min as num,
            max is Complex ? max.real : max as num),
        'lerp': (dynamic a, dynamic b, dynamic t) =>
            lerp(a, b, t is Complex ? t.real : t as num),
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

        // Roman Numerals
        'roman': (dynamic n) {
          if (n is String) return RomanNumerals.fromRoman(n).value;
          int val = n is Complex ? n.real.toInt() : (n as num).toInt();
          return RomanNumerals(val).toString();
        },

        // Perfect Numbers
        'nthPerfectNumber': (dynamic n) {
          int val = n is Complex ? n.real.toInt() : (n as num).toInt();
          return PerfectNumber(val).perfectNumber;
        },
        'nthMersennePrime': (dynamic n) {
          int val = n is Complex ? n.real.toInt() : (n as num).toInt();
          return PerfectNumber(val).mersennePrime;
        },
        'nthMersenneExponent': (dynamic n) {
          int val = n is Complex ? n.real.toInt() : (n as num).toInt();
          return PerfectNumber(val).mersenneExponent;
        },

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

        'sawtooth': (dynamic x) => sawtooth(x),
        'squareWave': (dynamic x) => squareWave(x),
        'triangleWave': (dynamic x) => triangleWave(x),
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
      };

  static Map<String, dynamic> _flowExtras() => {
        // iif(cond, trueVal, falseVal)
        'iif': VarArgsFunction((args, _) {
          final cond = args[0];
          bool isTrue = false;
          if (cond is bool) {
            isTrue = cond;
          } else if (cond is num) {
            isTrue = cond != 0;
          } else if (cond is Complex) {
            isTrue = cond.real != 0;
          } else if (cond is Vector) {
            isTrue = cond.magnitude != 0;
          }
          return isTrue ? args[1] : args[2];
        }),
        // if(cond, trueVal, falseVal)
        'if': VarArgsFunction((args, _) {
          final cond = args[0];
          bool isTrue = false;
          if (cond is bool) {
            isTrue = cond;
          } else if (cond is num) {
            isTrue = cond != 0;
          } else if (cond is Complex) {
            isTrue = cond.real != 0;
          } else if (cond is Vector) {
            isTrue = cond.magnitude != 0;
          }
          return isTrue ? args[1] : args[2];
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
        'coalesce': VarArgsFunction((args, _) {
          for (var arg in args) {
            if (arg != null) return arg;
          }
          return null;
        }),
        'choose': VarArgsFunction((args, _) {
          if (args.isEmpty) {
            throw ArgumentError('choose() requires at least one argument');
          }
          final index = _toInt(args[0]);
          if (index < 1 || index >= args.length) {
            throw ArgumentError('choose() index $index out of bounds');
          }
          return args[index];
        }),
        'cond': VarArgsFunction((args, _) {
          for (int i = 0; i < args.length - 1; i += 2) {
            final test = args[i];
            bool isTrue = false;
            if (test is bool) {
              isTrue = test;
            } else if (test is num) {
              isTrue = test != 0;
            } else if (test is Complex) {
              isTrue = test.real != 0;
            } else if (test is Vector) {
              isTrue = test.magnitude != 0;
            }

            if (isTrue) return args[i + 1];
          }
          if (args.length % 2 != 0) return args.last;
          return null;
        }),
        'any': VarArgsFunction((args, _) {
          for (var arg in _flattenArgs(args)) {
            bool isTrue = false;
            if (arg is bool) {
              isTrue = arg;
            } else if (arg is num) {
              isTrue = arg != 0;
            } else if (arg is Complex) {
              isTrue = arg.real != 0;
            } else if (arg is Vector) {
              isTrue = arg.magnitude != 0;
            }
            if (isTrue) return true;
          }
          return false;
        }),
        'all': VarArgsFunction((args, _) {
          final flat = _flattenArgs(args);
          if (flat.isEmpty) return true;
          for (var arg in flat) {
            bool isTrue = false;
            if (arg is bool) {
              isTrue = arg;
            } else if (arg is num) {
              isTrue = arg != 0;
            } else if (arg is Complex) {
              isTrue = arg.real != 0;
            } else if (arg is Vector) {
              isTrue = arg.magnitude != 0;
            }
            if (!isTrue) return false;
          }
          return true;
        }),
      };

  static Map<String, dynamic> _vectorExtras() => {
        'vector': VarArgsFunction((args, _) {
          if (args.isEmpty) throw ArgumentError('vector() requires arguments');
          final first = args.first;
          if (first is List) return Vector.fromList(first);
          if (first is Vector) return first;
          if (first is String) {
            // Minimal string parsing for vector: "1 2 3" or "1, 2, 3"
            final cleaned = first.replaceAll(',', ' ');
            final parts = cleaned
                .split(RegExp(r'\s+'))
                .where((s) => s.isNotEmpty)
                .map((s) => Complex.parse(s))
                .toList();
            return Vector.fromList(parts);
          }
          // If multiple numeric args
          return Vector.fromList(args);
        }),
        'linspaceVector': VarArgsFunction((args, _) => Vector.linspace(
              _toInt(args[0]),
              _toInt(args[1]),
              args.length > 2 ? _toInt(args[2]) : 50,
            )),
        'rangeVector': VarArgsFunction((args, _) => Vector.range(
              _toInt(args[0]),
              start: args.length > 1 ? _toInt(args[1]) : 0,
              step: args.length > 2 ? _toInt(args[2]) : 1,
            )),
        'randomVector': VarArgsFunction((args, _) => Vector.random(
              _toInt(args[0]),
              min: args.length > 1 ? (args[1] as num).toDouble() : 0.0,
              max: args.length > 2 ? (args[2] as num).toDouble() : 1.0,
            )),
        'dot': VarArgsFunction(
            (args, _) => (args[0] as Vector).dot(args[1] as Vector)),
        'cross': VarArgsFunction(
            (args, _) => (args[0] as Vector).cross(args[1] as Vector)),
        'innerProduct': VarArgsFunction(
            (args, _) => (args[0] as Vector).innerProduct(args[1] as Vector)),
        'outerProduct': VarArgsFunction(
            (args, _) => (args[0] as Vector).outerProduct(args[1] as Vector)),
        'mag': VarArgsFunction((args, _) => (args.first as Vector).magnitude),
        'magnitude':
            VarArgsFunction((args, _) => (args.first as Vector).magnitude),
        'angle': VarArgsFunction(
            (args, _) => (args[0] as Vector).angle(args[1] as Vector)),
        'projection': VarArgsFunction(
            (args, _) => (args[0] as Vector).projection(args[1] as Vector)),
        'isParallelTo': VarArgsFunction(
            (args, _) => (args[0] as Vector).isParallelTo(args[1] as Vector)),
        'isPerpendicularTo': VarArgsFunction((args, _) =>
            (args[0] as Vector).isPerpendicularTo(args[1] as Vector)),
        'toSpherical':
            VarArgsFunction((args, _) => (args.first as Vector).toSpherical()),
        'toCylindrical': VarArgsFunction(
            (args, _) => (args.first as Vector).toCylindrical()),
        'toPolar':
            VarArgsFunction((args, _) => (args.first as Vector).toPolar()),
        'unit':
            VarArgsFunction((args, _) => (args.first as Vector).normalize()),
        'normalize':
            VarArgsFunction((args, _) => (args.first as Vector).normalize()),
        'distance': VarArgsFunction(
            (args, _) => (args[0] as Vector).distance(args[1] as Vector)),
        'zerosVector': VarArgsFunction((args, _) => Vector(_toInt(args[0]))),
        'onesVector': VarArgsFunction(
            (args, _) => Vector(List.filled(_toInt(args[0]), 1))),
      };

  static Map<String, dynamic> _numberExtras() => {
        'toRoman': VarArgsFunction(
            (args, _) => RomanNumerals(_toInt(args[0])).toRoman()),
        'fromRoman': VarArgsFunction(
            (args, _) => RomanNumerals.fromRoman(args[0].toString()).value),
        'romanDate': VarArgsFunction(
            (args, _) => RomanNumerals.dateToRoman(args[0].toString())),
        'isPerfect':
            VarArgsFunction((args, _) => PerfectNumber.isPerfect(args[0])),
        'nthPerfect': VarArgsFunction((args, _) {
          final n = _toInt(args[0]);
          return PerfectNumber(n).perfectNumber;
        }),
        'perfectProps': VarArgsFunction((args, _) {
          final n = _toInt(args[0]);
          return PerfectNumber(n).properties;
        }),

        // PI Calculation
        'piCalc': VarArgsFunction((args, _) {
          final algoStr = args[0].toString().toLowerCase();
          final prec = args.length > 1 ? _toInt(args[1]) : 100;
          PiCalcAlgorithm algo = PiCalcAlgorithm.Ramanujan;
          if (algoStr.contains('chudnovsky')) algo = PiCalcAlgorithm.Chudnovsky;
          if (algoStr.contains('gauss')) algo = PiCalcAlgorithm.GaussLegendre;
          if (algoStr.contains('bbp')) algo = PiCalcAlgorithm.BBP;
          if (algoStr.contains('madhava')) algo = PiCalcAlgorithm.Madhava;
          if (algoStr.contains('ramanujan')) algo = PiCalcAlgorithm.Ramanujan;
          if (algoStr.contains('newton')) algo = PiCalcAlgorithm.NewtonEuler;
          return PI(algorithm: algo, precision: prec).value;
        }),
        'nthPiDigit': VarArgsFunction((args, _) {
          final n = _toInt(args[0]);
          final prec = args.length > 1 ? _toInt(args[1]) : (n + 10);
          return PI(precision: prec).getNthDigit(n);
        }),

        'piDigits': (dynamic start, dynamic end) {
          int s =
              start is Complex ? start.real.toInt() : (start as num).toInt();
          int e = end is Complex ? end.real.toInt() : (end as num).toInt();
          return PI(precision: e).getDigits(s, e);
        },
      };

  static Map<String, dynamic> _matrixExtras() => {
        ..._sharedExtras(),

        // Creators
        'matrix': VarArgsFunction((args, _) {
          if (args.isEmpty) throw ArgumentError('matrix() requires arguments');
          final first = args.first;
          if (first is String) return Matrix(first);
          if (first is List) return Matrix(first);
          if (first is Matrix) return first;
          throw ArgumentError(
              'matrix() expects a string like "1 2; 3 4" or a List of Lists');
        }),

        // Constructors
        'zeros': VarArgsFunction(
            (args, _) => Matrix.zeros(_toInt(args[0]), _toInt(args[1]))),
        'ones': VarArgsFunction(
            (args, _) => Matrix.ones(_toInt(args[0]), _toInt(args[1]))),
        'eye': VarArgsFunction((args, _) => Matrix.eye(_toInt(args[0]))),
        'diag': VarArgsFunction(
            (args, _) => Matrix.fromDiagonal(args.first as List)),
        'diagonalMatrix': VarArgsFunction(
            (args, _) => Matrix.fromDiagonal(args.first as List)),
        'rand_matrix': VarArgsFunction(
            (args, _) => Matrix.random(_toInt(args[0]), _toInt(args[1]))),
        'fill': VarArgsFunction((args, _) =>
            Matrix.fill(_toInt(args[0]), _toInt(args[1]), args[2])),
        'linspace': VarArgsFunction((args, _) => Matrix.linspace(
              _toInt(args[0]),
              _toInt(args[1]),
              args.length > 2 ? _toInt(args[2]) : 50,
            )),
        'rowVector':
            VarArgsFunction((args, _) => RowMatrix(args.first as List)),
        'colVector':
            VarArgsFunction((args, _) => ColumnMatrix(args.first as List)),

        // Properties
        'det':
            VarArgsFunction((args, _) => (args.first as Matrix).determinant()),
        'inv': VarArgsFunction((args, _) => (args.first as Matrix).inverse()),
        'pinv': VarArgsFunction(
            (args, _) => (args.first as Matrix).pseudoInverse()),
        'transpose':
            VarArgsFunction((args, _) => (args.first as Matrix).transpose()),
        'rank': VarArgsFunction((args, _) => (args.first as Matrix).rank()),
        'trace': VarArgsFunction((args, _) => (args.first as Matrix).trace()),
        'norm': VarArgsFunction((args, _) {
          final m = args.first;
          if (m is Vector) {
            if (args.length > 1) {
              final normType = args[1];
              if (normType == 'manhattan' || normType == 1) {
                return m.norm(Norm.manhattan);
              }
              if (normType == 'frobenius') return m.norm(Norm.frobenius);
              if (normType == 'chebyshev' || normType == double.infinity) {
                return m.norm(Norm.chebyshev);
              }
            }
            return m.norm();
          }
          if (m is Matrix) {
            if (args.length > 1) {
              final normType = args[1];
              if (normType == 'manhattan' || normType == 1) {
                return m.norm(Norm.manhattan);
              }
              if (normType == 'frobenius') return m.norm(Norm.frobenius);
              if (normType == 'chebyshev' || normType == double.infinity) {
                return m.norm(Norm.chebyshev);
              }
            }
            return m.norm();
          }
          throw ArgumentError('norm() expects a Vector or Matrix');
        }),
        'nullity':
            VarArgsFunction((args, _) => (args.first as Matrix).nullity()),
        'cond': VarArgsFunction(
            (args, _) => (args.first as Matrix).conditionNumber()),
        'rowCount':
            VarArgsFunction((args, _) => (args.first as Matrix).rowCount),
        'colCount':
            VarArgsFunction((args, _) => (args.first as Matrix).columnCount),
        'shape': VarArgsFunction((args, _) => (args.first as Matrix).shape),
        'isSquare': VarArgsFunction(
            (args, _) => (args.first as Matrix).isSquareMatrix()),
        'isSymmetric': VarArgsFunction(
            (args, _) => (args.first as Matrix).isSymmetricMatrix()),
        'isDiagonal': VarArgsFunction(
            (args, _) => (args.first as Matrix).isDiagonalMatrix()),
        'isIdentity': VarArgsFunction(
            (args, _) => (args.first as Matrix).isIdentityMatrix()),
        'isOrthogonal': VarArgsFunction(
            (args, _) => (args.first as Matrix).isOrthogonalMatrix()),
        'isSingular': VarArgsFunction(
            (args, _) => (args.first as Matrix).isSingularMatrix()),
        'isPositiveDefinite': VarArgsFunction(
            (args, _) => (args.first as Matrix).isPositiveDefiniteMatrix()),
        'isUpperTriangular': VarArgsFunction(
            (args, _) => (args.first as Matrix).isUpperTriangular()),
        'isLowerTriangular': VarArgsFunction(
            (args, _) => (args.first as Matrix).isLowerTriangular()),

        // Manipulation
        'reshape': VarArgsFunction((args, _) =>
            (args[0] as Matrix).reshape(_toInt(args[1]), _toInt(args[2]))),
        'flatten':
            VarArgsFunction((args, _) => (args.first as Matrix).flatten()),
        'hcat': VarArgsFunction((args, _) {
          List<Matrix> matrices = args.map((e) => e as Matrix).toList();
          return Matrix.concatenate(matrices, axis: 1);
        }),
        'vcat': VarArgsFunction((args, _) {
          List<Matrix> matrices = args.map((e) => e as Matrix).toList();
          return Matrix.concatenate(matrices, axis: 0);
        }),
        'ref': VarArgsFunction(
            (args, _) => (args.first as Matrix).rowEchelonForm()),
        'rref': VarArgsFunction(
            (args, _) => (args.first as Matrix).reducedRowEchelonForm()),
        'solve': VarArgsFunction((args, _) {
          final A = args[0] as Matrix;
          final b = args[1] as Matrix;
          return A.linear.solve(b);
        }),

        // Element access helpers
        'row': VarArgsFunction(
            (args, _) => (args[0] as Matrix).row(_toInt(args[1]))),
        'col': VarArgsFunction(
            (args, _) => (args[0] as Matrix).column(_toInt(args[1]))),

        // Stats
        'mat_mean': VarArgsFunction((args, _) {
          final m = args.first as Matrix;
          final axis = args.length > 1 ? _toInt(args[1]) : null;
          if (axis == 0) {
            return List.generate(
                m.columnCount,
                (j) =>
                    m.column(j).elements.reduce((a, b) => a + b) / m.rowCount);
          } else if (axis == 1) {
            return List.generate(
                m.rowCount,
                (i) =>
                    m.row(i).elements.reduce((a, b) => a + b) / m.columnCount);
          } else {
            return m.elements.reduce((a, b) => a + b) /
                (m.rowCount * m.columnCount);
          }
        }),
        'mat_sum': VarArgsFunction((args, _) {
          final m = args.first as Matrix;
          final axis = args.length > 1 ? _toInt(args[1]) : null;
          return m.sum(axis: axis);
        }),
        'mat_max': VarArgsFunction((args, _) {
          final m = args.first as Matrix;
          final axis = args.length > 1 ? _toInt(args[1]) : null;
          return m.max(axis: axis);
        }),
        'mat_min': VarArgsFunction((args, _) {
          final m = args.first as Matrix;
          final axis = args.length > 1 ? _toInt(args[1]) : null;
          return m.min(axis: axis);
        }),
        'mat_var':
            VarArgsFunction((args, _) => (args.first as Matrix).variance()),
        'mat_std': VarArgsFunction(
            (args, _) => (args.first as Matrix).standardDeviation()),
        'mat_median':
            VarArgsFunction((args, _) => (args.first as Matrix).median()),

        // Decompositions (as Maps for easy access)
        'lu': VarArgsFunction((args, _) {
          final lu = (args.first as Matrix)
              .decomposition
              .luDecompositionDoolittlePartialPivoting();
          return {'L': lu.L, 'U': lu.U, 'P': lu.P};
        }),
        'qr': VarArgsFunction((args, _) {
          final qr =
              (args.first as Matrix).decomposition.qrDecompositionHouseholder();
          return {'Q': qr.Q, 'R': qr.R};
        }),
        'svd': VarArgsFunction((args, _) {
          final svd =
              (args.first as Matrix).decomposition.singularValueDecomposition();
          return {'U': svd.U, 'S': svd.S, 'V': svd.V};
        }),
        'cholesky': VarArgsFunction((args, _) {
          final chol =
              (args.first as Matrix).decomposition.choleskyDecomposition();
          return {'L': chol.L};
        }),
        'eigen': VarArgsFunction((args, _) {
          final eigen =
              (args.first as Matrix).decomposition.eigenvalueDecomposition();
          return {'D': eigen.D, 'V': eigen.V};
        }),
        'schur': VarArgsFunction((args, _) {
          final schur =
              (args.first as Matrix).decomposition.schurDecomposition();
          return {'T': schur.T, 'Q': schur.Q};
        }),
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
        'arg': VarArgsFunction((args, _) => (args.first as Complex).argument),
        'conj': VarArgsFunction((args, _) => (args.first as Complex).conjugate),

        'polar': VarArgsFunction((args, _) {
          final c = args.first as Complex;
          return {'r': c.abs(), 'theta': c.argument};
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
        'product': VarArgsFunction((args, _) {
          final first = args.first;
          if (first is Vector) return first.product();
          if (first is List) {
            return first.fold<num>(1, (a, b) => a * b);
          }
          return args.reduce((a, b) => a * b);
        }),

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

  static Polynomial _toPoly(dynamic p) {
    if (p is Polynomial) {
      // Re-dispatch through fromList to ensure we have the most specific subclass (Quadratic, etc.)
      return Polynomial.fromList(p.coefficients, variable: p.variable);
    }
    return Polynomial.fromString(p.toString());
  }

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
        'poly_from_list': VarArgsFunction((args, _) {
          final list = args[0] as List;
          final varName = args.length > 1 ? args[1].toString() : 'x';
          return Polynomial.fromList(list, variable: Variable(varName));
        }),
        'poly_gcd': gcd,
        'poly_lcm': lcm,
        'poly_expand':
            VarArgsFunction((args, _) => _toPoly(args.first).expand()),
        'poly_discriminant': VarArgsFunction((args, context) {
          return _toPoly(args[0]).discriminant().evaluate(context);
        }),
        'vertex': VarArgsFunction((args, _) {
          final p = args.first;
          if (p is Quadratic) return p.vertex();
          return _toPoly(p)
              .roots(); // Fallback to roots if not quadratic? No, vertex is quad specific.
        }),
        'coeffs':
            VarArgsFunction((args, _) => _toPoly(args.first).coefficients),
        'factorize':
            VarArgsFunction((args, _) => _toPoly(args.first).factorizeString()),
        'differentiate':
            VarArgsFunction((args, _) => _toPoly(args.first).differentiate()),
        'poly_integrate':
            VarArgsFunction((args, _) => _toPoly(args.first).integrate()),
        'evaluate': VarArgsFunction((args, _) {
          final p = args[0];
          final x = args[1];
          return _toPoly(p).evaluate(x);
        }),
        'degree': VarArgsFunction((args, _) => _toPoly(args.first).degree),
        'deg': VarArgsFunction((args, _) => _toPoly(args.first).degree),
        'roots': (dynamic exp) => _toPoly(exp).roots(),
        'isPoly': (dynamic exp) => Polynomial.isPolynomial(exp.toString()),

        // Quadratic specific properties
        'quad_sum_roots': VarArgsFunction((args, context) {
          final p = _toPoly(args[0]);
          if (p is Quadratic) return p.sumOfRoots().evaluate(context);
          throw ArgumentError('Expected a quadratic polynomial');
        }),
        'quad_prod_roots': VarArgsFunction((args, context) {
          final p = _toPoly(args[0]);
          if (p is Quadratic) return p.productOfRoots().evaluate(context);
          throw ArgumentError('Expected a quadratic polynomial');
        }),
        'quad_opening': VarArgsFunction((args, _) {
          final p = args.first;
          if (p is Quadratic) return p.directionOfOpening();
          final poly = _toPoly(p);
          if (poly is Quadratic) return poly.directionOfOpening();
          throw ArgumentError('quad_opening() expects a Quadratic polynomial');
        }),
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
