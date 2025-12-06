part of 'expression.dart';

/// Returns a list of all the variables in the expression.
final defaultContext = {
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

  // Basic Math functions
  'abs': abs,
  'sqrt': sqrt,
  'cbrt': cbrt,
  'nthRoot': nthRoot,
  'exp': exp,
  'pow': pow,
  'logBase': logBase,
  'log10': log10,
  'log': log,
  'ln': log,
  'factorial': factorial,
  'factorial2': factorial2,
  'doubleFactorial': doubleFactorial,
  'step': step,
  'rect': rect,
  'sign': sign,
  'modF': modF,
  'mod': mod,
  'modInv': (num a, num m) => modInv(a, m),
  'nChooseRModPrime': nChooseRModPrime,
  'bigIntNChooseRModPrime': bigIntNChooseRModPrime,
  'floor': floor,
  'ceil': ceil,
  'hypot': hypot,
  'round': round,
  'roundDecimal': (num x, int n) => round(x, n),
  'roundTo': (num x, int n) => round(x, n),
  'clamp': clamp,
  'lerp': lerp,
  'rec': rec,
  'pol': pol,
  'isDigit': isDigit,
  'isAlpha': isAlpha,
  'isAlphaNumeric': isAlphaNumeric,
  'isDivisible': isDivisible,
  'isEven': isEven,
  'isOdd': isOdd,
  'isPrime': isPrime,
  'nthPrime': nthPrime,
  'sieve': sieve,
  'fibonacci': fib,
  'fib': fib,
  'isPerfectSquare': isPerfectSquare,
  'isPerfectCube': isPerfectCube,
  'isFibonacci': isFibonacci,
  'isPalindrome': isPalindrome,
  'isPandigital': isPandigital,
  'isArmstrongNumber': isArmstrongNumber,
  'isPerfectNumber': isPerfectNumber,
  'trunc': trunc,
  'factors': factors,
  'factorsOf': factors,
  'primeFactors': primeFactors,
  'nthTriangleNumber': nthTriangleNumber,
  'nthPentagonalNumber': nthPentagonalNumber,
  'nthHexagonalNumber': nthHexagonalNumber,
  'nthTetrahedralNumber': nthTetrahedralNumber,
  'nthHarmonicNumber': nthHarmonicNumber,
  'gamma': gamma,

  //Polynomials
  'roots': (dynamic exp) => Polynomial.fromString(exp.toString()).roots(),

  // Calculus functions
  'derivative': (dynamic exp) =>
      Expression.parse(exp.toString()).differentiate(),
  'integrate': (dynamic exp) => Expression.parse(exp.toString()).integrate(),
  'simplify': (dynamic exp) => Expression.parse(exp.toString()).simplify(),

  // Trigonometric functions
  'sin': (num x) => sin(degToRad(x)),
  'cos': (num x) => cos(degToRad(x)),
  'tan': (num x) => tan(degToRad(x)),
  'csc': (num x) => csc(degToRad(x)),
  'sec': (num x) => sec(degToRad(x)),
  'cot': (num x) => cot(degToRad(x)),
  'asin': (num x) => radToDeg(asin(x)),
  'acos': (num x) => radToDeg(acos(x)),
  'atan': (num x) => radToDeg(atan(x)),
  'atan2': (num x, num y) => radToDeg(atan2(x, y)),
  'asec': (num x) => radToDeg(asec(x)),
  'acsc': (num x) => radToDeg(acsc(x)),
  'acot': (num x) => radToDeg(acot(x)),
  'sinh': sinh,
  'cosh': cosh,
  'tanh': tanh,
  'csch': csch,
  'sech': sech,
  'coth': coth,
  'asinh': asinh,
  'acosh': acosh,
  'atanh': atanh,
  'acsch': acsch,
  'asech': asech,
  'acoth': acoth,
  'vers': vers,
  'covers': covers,
  'havers': havers,
  'exsec': exsec,
  'excsc': excsc,
  'sawtooth': sawtooth,
  'squareWave': squareWave,
  'triangleWave': triangleWave,

  // Statistic functions
  'max': (dynamic a, [dynamic b, dynamic c, dynamic d, dynamic e, dynamic f]) {
    var rawArgs = [a, b, c, d, e, f].where((e) => e != null).toList();
    var args = rawArgs.map((e) {
      if (e is Complex && e.isReal && e.imaginary == 0) return e.real;
      return e;
    }).toList();

    if (args.isEmpty) return 0;
    if (args.length == 1) {
      if (args[0] is List) {
        return (args[0] as List).map((e) {
          if (e is Complex && e.isReal && e.imaginary == 0) return e.real;
          return e;
        }).reduce((curr, next) => max(curr, next));
      }
      return args[0];
    }
    return args.reduce((curr, next) => max(curr, next));
  },
  'min': (dynamic a, [dynamic b, dynamic c, dynamic d, dynamic e, dynamic f]) {
    var rawArgs = [a, b, c, d, e, f].where((e) => e != null).toList();
    var args = rawArgs.map((e) {
      if (e is Complex && e.isReal && e.imaginary == 0) return e.real;
      return e;
    }).toList();

    if (args.isEmpty) return 0;
    if (args.length == 1) {
      if (args[0] is List) {
        return (args[0] as List).map((e) {
          if (e is Complex && e.isReal && e.imaginary == 0) return e.real;
          return e;
        }).reduce((curr, next) => min(curr, next));
      }
      return args[0];
    }
    return args.reduce((curr, next) => min(curr, next));
  },
  'sum': (num x, num y) => x + y,
  'sumTo': (num x) => sumTo(x.toInt()),
  'nPr': (num n, int r) => permutations(n, r).length,
  'permutations': (num n, int r) => permutations(n, r).length,
  'nCr': (num n, int r) => combinations(n, r).length,
  'combinations': (num n, int r) => combinations(n, r).length,
  // 'avg': avg,
  'avg': (List<dynamic> x) => mean([
        for (var element in x)
          if (element is num) element
      ]),
  'mean': (List<dynamic> x) => mean([
        for (var element in x)
          if (element is num) element
      ]),
  'median': (List<dynamic> x) => median([
        for (var element in x)
          if (element is num) element
      ]),
  'mode': (List<dynamic> x) => mode([
        for (var element in x)
          if (element is num) element
      ]),
  'variance': (List<dynamic> x) => variance([
        for (var element in x)
          if (element is num) element
      ]),
  'standardDeviation': (List<dynamic> x) => standardDeviation([
        for (var element in x)
          if (element is num) element
      ]),
  'stdDev': (List<dynamic> x) => standardDeviation([
        for (var element in x)
          if (element is num) element
      ]),
  'stdErrMean': (List<dynamic> x) => stdErrMean([
        for (var element in x)
          if (element is num) element
      ]),
  'tValue': (List<dynamic> x) => tValue([
        for (var element in x)
          if (element is num) element
      ]),
  'quartiles': (List<dynamic> x) => quartiles([
        for (var element in x)
          if (element is num) element
      ]),
  'gcf': (List<dynamic> x) => gcf([
        for (var element in x)
          if (element is num) element
      ]),
  'gcd': (List<dynamic> x) => gcd([
        for (var element in x)
          if (element is num) element
      ]),
  'lcm': (List<dynamic> x) => lcm([
        for (var element in x)
          if (element is num) element
      ]),

  // String functions
  'string': (dynamic x) => x.toString(),
  'length': (dynamic x) => x.toString().length,
  'toUpper': (dynamic x) => x.toString().toUpperCase(),
  'toLower': (dynamic x) => x.toString().toLowerCase(),
  'concat': (dynamic x, dynamic y) => x.toString() + y.toString(),
  'link': (dynamic x, dynamic y) => '<a href="$y">$x</a>',
  'str2number': (dynamic x) => num.parse(x.toString()),
  'number2str': (dynamic x) => x.toString(),
  'left': (dynamic x, dynamic y) => x.toString().substring(0, y.toInt()),
  'right': (dynamic x, dynamic y) => x.toString().substring(y.toInt()),
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
