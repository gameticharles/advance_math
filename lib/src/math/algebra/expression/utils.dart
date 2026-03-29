part of 'expression.dart';

/// Returns a list of all the variables in the expression.
final Map<String, dynamic> defaultContext = {
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
  'log': log,
  'ln': log,
  'abs': (dynamic x) => abs(x),
  'sqrt': (dynamic x) => sqrt(x),
  'cbrt': (dynamic x) => cbrt(x),
  'nthRoot': (dynamic x, dynamic n) =>
      nthRoot(x, n is Complex ? n.real.toInt() : (n as num).toInt()),
  'exp': (dynamic x) => exp(x),
  'pow': (dynamic x, dynamic y) => pow(x, y),
  'logBase': (dynamic b, dynamic x) => logBase(b, x),
  'log10': (dynamic x) => log10(x),
  'fact': (dynamic x) =>
      factorial(x is Complex ? x.real.toInt() : (x as num).toInt()),
  'factorial': (dynamic x) =>
      factorial(x is Complex ? x.real.toInt() : (x as num).toInt()),
  'factorial2': (dynamic x) =>
      factorial2(x is Complex ? x.real.toInt() : (x as num).toInt()),
  'doubleFactorial': (dynamic x) =>
      doubleFactorial(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
  'step': (dynamic x) => step((x is Complex ? x.real : x as num).toDouble()),
  'rect': (dynamic x) => rect((x is Complex ? x.real : x as num).toDouble()),
  'sign': (dynamic x) => sign((x is Complex ? x.real : x as num).toDouble()),
  'modF': (dynamic x) => modF((x is Complex ? x.real : x as num).toDouble()),

  'mod': (dynamic x, dynamic y) => mod(x, y),
  'modInv': (dynamic a, dynamic m) => modInv(
      a is Complex ? a.real : a as num, m is Complex ? m.real : m as num),
  'nChooseRModPrime': (dynamic n, dynamic r, dynamic p) => nChooseRModPrime(
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
  'hypot': (dynamic x, dynamic y) =>
      hypot(x is Complex ? x.real : x as num, y is Complex ? y.real : y as num),
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
  'roundTo': (dynamic x, dynamic n) => round(x is Complex ? x.real : x as num,
      n is Complex ? n.real.toInt() : (n as num).toInt()),
  'clamp': (dynamic x, dynamic min, dynamic max) => clamp(
      x is Complex ? x.real : x as num,
      min is Complex ? min.real : min as num,
      max is Complex ? max.real : max as num),
  'lerp': (dynamic a, dynamic b, dynamic t) => lerp(
      a is Complex ? a.real : a as num,
      b is Complex ? b.real : b as num,
      t is Complex ? t.real : t as num),
  'rec': (dynamic r, dynamic theta) => rec(r is Complex ? r.real : r as num,
      theta is Complex ? theta.real : theta as num),
  'pol': (dynamic x, dynamic y) =>
      pol(x is Complex ? x.real : x as num, y is Complex ? y.real : y as num),
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
  'fib': (dynamic n) => fib(n is Complex ? n.real.toInt() : (n as num).toInt()),
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
  'isArmstrongNumber': (dynamic n) =>
      isArmstrongNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'isPerfectNumber': (dynamic n) =>
      isPerfectNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'trunc': (dynamic x) => trunc((x is Complex ? x.real : x as num).toDouble()),

  'factors': (dynamic n) =>
      factors(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'factorsOf': (dynamic n) =>
      factors(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'primeFactors': (dynamic n) =>
      primeFactors(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'nthTriangleNumber': (dynamic n) =>
      nthTriangleNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'nthPentagonalNumber': (dynamic n) =>
      nthPentagonalNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'nthHexagonalNumber': (dynamic n) =>
      nthHexagonalNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'nthTetrahedralNumber': (dynamic n) =>
      nthTetrahedralNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'nthHarmonicNumber': (dynamic n) =>
      nthHarmonicNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
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
  'isKaprekarNumber': (dynamic n) =>
      isKaprekarNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'isNarcissisticNumber': (dynamic n) =>
      isNarcissisticNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'isHappyNumber': (dynamic n) =>
      isHappyNumber(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'isMersennePrime': (dynamic n) =>
      isMersennePrime(n is Complex ? n.real.toInt() : (n as num).toInt()),
  'frexp': (dynamic x) => frexp(x is Complex ? x.real : x as num),
  'ldexp': (dynamic x, dynamic n) => ldexp(x is Complex ? x.real : x as num,
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
  'integrate': (dynamic exp) => Expression.parse(exp.toString()).integrate(),
  'simplify': (dynamic exp) => Expression.parse(exp.toString()).simplify(),

  // Trigonometric functions
  'sin': (dynamic x) => sin(x is Complex ? x : degToRad(x as num)),
  'cos': (dynamic x) => cos(x is Complex ? x : degToRad(x as num)),
  'tan': (dynamic x) => tan(x is Complex ? x : degToRad(x as num)),
  'csc': (dynamic x) => csc(x is Complex ? x : degToRad(x as num)),
  'sec': (dynamic x) => sec(x is Complex ? x : degToRad(x as num)),
  'cot': (dynamic x) => cot(x is Complex ? x : degToRad(x as num)),
  'asin': (dynamic x) =>
      x is Complex ? asin(x) : radToDeg((asin(x) as Complex).simplify()),
  'acos': (dynamic x) =>
      x is Complex ? acos(x) : radToDeg((acos(x) as Complex).simplify()),
  'atan': (dynamic x) =>
      x is Complex ? atan(x) : radToDeg((atan(x) as Complex).simplify()),
  'atan2': (dynamic a, dynamic b) => a is Complex || b is Complex
      ? atan2(a, b)
      : radToDeg(atan2(a as num, b as num)),
  'asec': (dynamic x) =>
      x is Complex ? asec(x) : radToDeg((asec(x) as Complex).simplify()),
  'acsc': (dynamic x) =>
      x is Complex ? acsc(x) : radToDeg((acsc(x) as Complex).simplify()),
  'acot': (dynamic x) =>
      x is Complex ? acot(x) : radToDeg((acot(x) as Complex).simplify()),
  'sinh': (dynamic x) => sinh(x is Complex ? x : x as num),
  'cosh': (dynamic x) => cosh(x is Complex ? x : x as num),
  'tanh': (dynamic x) => tanh(x is Complex ? x : x as num),
  'csch': (dynamic x) => csch(x is Complex ? x : x as num),
  'sech': (dynamic x) => sech(x is Complex ? x : x as num),
  'coth': (dynamic x) => coth(x is Complex ? x : x as num),
  'asinh': (dynamic x) => asinh(x is Complex ? x : x as num),
  'acosh': (dynamic x) => acosh(x is Complex ? x : x as num),
  'atanh': (dynamic x) => atanh(x is Complex ? x : x as num),
  'acsch': (dynamic x) => acsch(x is Complex ? x : x as num),
  'asech': (dynamic x) => asech(x is Complex ? x : x as num),
  'acoth': (dynamic x) => acoth(x is Complex ? x : x as num),
  'vers': (dynamic x) => vers((x is Complex ? x.real : (x as num)).toDouble()),
  'covers': (dynamic x) =>
      covers((x is Complex ? x.real : (x as num)).toDouble()),
  'havers': (dynamic x) =>
      havers((x is Complex ? x.real : (x as num)).toDouble()),
  'exsec': (dynamic x) =>
      exsec((x is Complex ? x.real : (x as num)).toDouble()),
  'excsc': (dynamic x) =>
      excsc((x is Complex ? x.real : (x as num)).toDouble()),

  'sawtooth': (dynamic x) => sawtooth(x is Complex ? x.real : x as num),
  'squareWave': (dynamic x) =>
      squareWave(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
  'triangleWave': (dynamic x) =>
      triangleWave(x is Complex ? x.real.toDouble() : (x as num).toDouble()),

  // Statistic functions
  'avg': (dynamic dat) => avg(dat),
  'max': (dynamic dat) => max(dat),
  'min': (dynamic dat) => min(dat),
  'sum': (dynamic dat) => sum(dat),

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

  'mean': (dynamic dat) => mean(dat),
  'average': (dynamic dat) => mean(dat),
  'median': (dynamic dat) => median(dat),
  'mode': (dynamic dat) => mode(dat),
  'variance': (dynamic dat) => variance(dat),
  'standardDeviation': (dynamic dat) => stdDev(dat),
  'stdDev': (dynamic dat) => stdDev(dat),
  'stdErrMean': (dynamic dat) => stdErrMean(dat),
  'stdErrEst': (dynamic x, dynamic y) =>
      stdErrEst(_sanitizeList(x), _sanitizeList(y)),
  'tValue': (dynamic dat) => tValue(dat),
  'quartiles': (dynamic dat) => quartiles(dat),
  'gcf': (dynamic dat) => gcd(dat),
  'gcd': (dynamic dat) => gcd(dat),

  'lcm': (dynamic dat) => lcm(dat),
  'correlation': (dynamic x, dynamic y) =>
      correlation(_sanitizeList(x), _sanitizeList(y)),
  'confidenceInterval': (dynamic dat, dynamic confidence) => confidenceInterval(
      _sanitizeList(dat),
      confidence is Complex
          ? confidence.real.toDouble()
          : (confidence as num).toDouble()),
  'regression': (dynamic x, dynamic y) =>
      regression(_sanitizeList(x), _sanitizeList(y)),

  // Missing Basic Math Functions
  'sinc': (dynamic x) =>
      sinc(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
  'sumUpTo': (dynamic start, dynamic end, [dynamic step = 1]) => sumUpTo(
      start is Complex ? start.real : start as num,
      end is Complex ? end.real : end as num,
      step: step is Complex ? step.real : step as num),

  'isClose': (dynamic a, dynamic b,
          [dynamic rel = 1e-9, dynamic absValue = 1e-15]) =>
      isClose(a is Complex ? a.real.toDouble() : (a as num).toDouble(),
          b is Complex ? b.real.toDouble() : (b as num).toDouble(),
          relTol:
              rel is Complex ? rel.real.toDouble() : (rel as num).toDouble(),
          absTol: absValue is Complex
              ? absValue.real.toDouble()
              : (absValue as num).toDouble()),
  'integerPart': (dynamic x) =>
      integerPart(x is Complex ? x.real.toDouble() : (x as num).toDouble()),
  'fibRange': (dynamic start, dynamic end) => fibRange(
      start is Complex ? start.real.toInt() : (start as num).toInt(),
      end is Complex ? end.real.toInt() : (end as num).toInt()),

  // Calculus Helpers
  'simpson': _simpsonWrapper,
  'numIntegrate': _numIntegrateWrapper,
  'diff': _diffWrapper,

  // Random (Robustness)
  'rand': VarArgsFunction((args, kwargs) {
    var min = args.isNotEmpty
        ? (args[0] is Complex ? (args[0] as Complex).real : args[0] as num?)
        : null;
    var max = args.length > 1
        ? (args[1] is Complex ? (args[1] as Complex).real : args[1] as num?)
        : null;
    var r = Random();
    if (min == null && max == null) return r.nextDouble();
    if (min != null && max == null) return r.nextDouble() * min;
    if (min != null && max != null) {
      return min + r.nextDouble() * (max - min);
    }
    return r.nextDouble();
  }),
  'randint': (dynamic max) => Random()
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

List<num> _sanitizeList(dynamic dat) {
  if (dat is! List) return (dat as List<num>);
  return dat
      .map((e) {
        if (e is Complex) return e.real;
        return e as num;
      })
      .toList()
      .cast<num>();
}

dynamic _simpsonWrapper(dynamic f, dynamic a, dynamic b) {
  num Function(num) fn;
  if (f is String) {
    final expr = ExpressionParser().parse(f);
    fn = (x) {
      final val = expr.evaluate(<String, dynamic>{
        ...defaultContext,
        'x': x is num ? Complex(x, 0) : x
      });

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
      final val = expr.evaluate(
          <String, dynamic>{...defaultContext, 'x': Complex(x.toDouble(), 0)});

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
      final val = expr.evaluate(
          <String, dynamic>{...defaultContext, 'x': Complex(x.toDouble(), 0)});

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
