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
  'phi': 1.618033988749895,
  'eulerGamma': 0.577215664901532,
  'nan': double.nan,
  'NaN': double.nan,
  'inf': double.infinity,
  'Infinity': double.infinity,

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
  'fact': (dynamic x) => factorial(x is Complex ? x.real.toInt() : (x as num).toInt()),
  'factorial': (dynamic x) => factorial(x is Complex ? x.real.toInt() : (x as num).toInt()),
  'factorial2': factorial2,
  'doubleFactorial': (dynamic x) => doubleFactorial(
      x is Complex ? x.real.toDouble() : (x as num).toDouble()),
  'step': step,
  'rect': rect,
  'sign': sign,
  'modF': modF,
  'mod': mod,
  'modInv': (dynamic a, dynamic m) => modInv(
      a is Complex ? a.real : a as num,
      m is Complex ? m.real : m as num),
  'nChooseRModPrime': nChooseRModPrime,
  'bigIntNChooseRModPrime': bigIntNChooseRModPrime,
  'floor': floor,
  'ceil': ceil,
  'hypot': hypot,
  'round': (dynamic x, [dynamic decimalPlaces = 0]) {
    final dp = decimalPlaces is Complex
        ? decimalPlaces.real.toInt()
        : (decimalPlaces as num).toInt();
    final xVal = x is Complex && x.isReal ? x.simplify() : x;
    return round(xVal is num ? xVal : x, dp);
  },
  'roundDecimal': (dynamic x, dynamic n) =>
      round(x is Complex ? x.real : x as num,
            n is Complex ? n.real.toInt() : (n as num).toInt()),
  'roundTo': (dynamic x, dynamic n) =>
      round(x is Complex ? x.real : x as num,
            n is Complex ? n.real.toInt() : (n as num).toInt()),
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
  'erf': erf,
  'erfc': erfc,
  'lgamma': lgamma,
  'digamma': digamma,
  'beta': beta,
  'zeta': zeta,
  'expm1': expm1,
  'log1p': log1p,

  'collatz': (dynamic n, [dynamic returnSequence = true]) => collatz(
      n is Complex ? n.real.toInt() : (n as num).toInt(),
      returnSequence is Complex ? returnSequence.real == 1 : (returnSequence as bool)),
  'collatzPeak': (dynamic n) => collatzPeak(
      n is Complex ? n.real.toInt() : (n as num).toInt()),
  'longestCollatzInRange': (dynamic start, dynamic end) => longestCollatzInRange(
      start is Complex ? start.real.toInt() : (start as num).toInt(),
      end is Complex ? end.real.toInt() : (end as num).toInt()),
  'isKaprekarNumber': (dynamic n) => isKaprekarNumber(
      n is Complex ? n.real.toInt() : (n as num).toInt()),
  'isNarcissisticNumber': (dynamic n) => isNarcissisticNumber(
      n is Complex ? n.real.toInt() : (n as num).toInt()),
  'isHappyNumber': (dynamic n) => isHappyNumber(
      n is Complex ? n.real.toInt() : (n as num).toInt()),
  'isMersennePrime': (dynamic n) => isMersennePrime(
      n is Complex ? n.real.toInt() : (n as num).toInt()),
  'frexp': frexp,
  'ldexp': (dynamic x, dynamic n) => ldexp(
      x is Complex ? x.real : x as num,
      n is Complex ? n.real.toInt() : (n as num).toInt()),
  'getDigits': (dynamic n) => getDigits(
      n is Complex ? n.real.toInt() : (n as num).toInt()),
  'egcd': egcd,
  'binomialCoefficient': (dynamic n, dynamic k) => binomialCoefficient(
      n is Complex ? n.real.toInt() : (n as num).toInt(),
      k is Complex ? k.real.toInt() : (k as num).toInt()),

  //Polynomials
  'roots': (dynamic exp) => Polynomial.fromString(exp.toString()).roots(),

  // Calculus functions
  'derivative': (dynamic exp) =>
      Expression.parse(exp.toString()).differentiate(),
  'integrate': (dynamic exp) => Expression.parse(exp.toString()).integrate(),
  'simplify': (dynamic exp) => Expression.parse(exp.toString()).simplify(),

  // Trigonometric functions
  'sin': (dynamic x) => sin(x is Complex ? x : degToRad(x as num)),
  'cos': (dynamic x) => cos(x is Complex ? x : degToRad(x as num)),
  'tan': (dynamic x) => tan(x is Complex ? x : degToRad(x as num)),
  'csc': (dynamic x) => csc(x is Complex ? x : degToRad(x as num)),
  'sec': (dynamic x) => sec(x is Complex ? x : degToRad(x as num)),
  'cot': (dynamic x) => cot(x is Complex ? x : degToRad(x as num)),
  'asin': (dynamic x) => x is Complex
      ? asin(x)
      : radToDeg((asin(x) as Complex).simplify()),
  'acos': (dynamic x) => x is Complex
      ? acos(x)
      : radToDeg((acos(x) as Complex).simplify()),
  'atan': (dynamic x) => x is Complex
      ? atan(x)
      : radToDeg((atan(x) as Complex).simplify()),
  'atan2': (dynamic a, dynamic b) => a is Complex || b is Complex
      ? atan2(a, b)
      : radToDeg(atan2(a as num, b as num)),
  'asec': (dynamic x) => x is Complex
      ? asec(x)
      : radToDeg((asec(x) as Complex).simplify()),
  'acsc': (dynamic x) => x is Complex
      ? acsc(x)
      : radToDeg((acsc(x) as Complex).simplify()),
  'acot': (dynamic x) => x is Complex
      ? acot(x)
      : radToDeg((acot(x) as Complex).simplify()),
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
  'avg': avg,
  'max': max,
  'min': min,
  'sum': sum,
  'sumTo': (dynamic x) => sumTo(
      x is Complex ? x.real.toInt() : (x as num).toInt()),
  'nPr': (dynamic n, dynamic r) => permutations(
      n is Complex ? n.real.toInt() : (n as num).toInt(),
      r is Complex ? r.real.toInt() : (r as num).toInt()).length,
  'permutations': (dynamic n, dynamic r) => permutations(
      n is Complex ? n.real.toInt() : (n as num).toInt(),
      r is Complex ? r.real.toInt() : (r as num).toInt()).length,
  'nCr': (dynamic n, dynamic r) => combinations(
      n is Complex ? n.real.toInt() : (n as num).toInt(),
      r is Complex ? r.real.toInt() : (r as num).toInt()).length,
  'combinations': (dynamic n, dynamic r) => combinations(
      n is Complex ? n.real.toInt() : (n as num).toInt(),
      r is Complex ? r.real.toInt() : (r as num).toInt()).length,

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

  // Missing Basic Math Functions
  'sinc': sinc,
  'sumUpTo': (num start, num end, [num step = 1]) =>
      sumUpTo(start, end, step: step),
  'isClose': (double a, double b, [double rel = 1e-9, double abs = 1e-15]) =>
      isClose(a, b, relTol: rel, absTol: abs),
  'integerPart': (double x) => integerPart(x),
  'fibRange': (int start, int end) => fibRange(start, end),

  // Calculus Helpers
  'simpson': (Function f, double a, double b) => simpson(f, a, b),
  'numIntegrate': (Function f, double a, double b) => numIntegrate(f, a, b),
  'diff': (Function f, [double h = 0.001]) => diff(f, h),

  // Random (Robustness)
  'rand': ([num? min, num? max]) {
    var r = Random();
    if (min == null && max == null) return r.nextDouble();
    if (min != null && max == null) return r.nextDouble() * min;
    if (min != null && max != null) {
      return min + r.nextDouble() * (max - min);
    }
    return r.nextDouble();
  },
  'randint': ([int max = 100]) => Random().nextInt(max),
  'randomBetween': randomBetween,
  'randomString': randomString,
  'randomNumeric': randomNumeric,
  'randomAlpha': randomAlpha,
  'randomAlphaNumeric': randomAlphaNumeric,
  'randomMerge': randomMerge,

  // Utilities
  'time': (dynamic x) {
    final t = time(x);
    return {'result': t.result, 'elapsed': t.elapsed.inMicroseconds / 1000.0};
  },
  'timeAsync': (dynamic x) async {
    final t = await timeAsync(x);
    return {'result': t.result, 'elapsed': t.elapsed.inMicroseconds / 1000.0};
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
