// import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

const precision = 400;
Decimal pi() {
  Decimal three = Decimal.parse('3');
  Decimal lasts = Decimal.zero;
  Decimal t = three;
  Decimal s = Decimal.parse('3');
  Decimal n = Decimal.one;
  Decimal na = Decimal.zero;
  Decimal d = Decimal.zero;
  Decimal da = Decimal.parse('24');

  while (s != lasts) {
    lasts = s;
    n = n + na;
    na = na + Decimal.parse('8');
    d = d + da;
    da = da + Decimal.parse('32');
    t = ((t * n) / d).toDecimal(scaleOnInfinitePrecision: precision + 10);
    s = s + t;
  }

  return s;
}

Decimal exp(Decimal x) {
  int i = 0;
  Decimal lasts = Decimal.zero;
  Decimal s = Decimal.one;
  Decimal fact = Decimal.one;
  Decimal num = Decimal.one;

  while ((s - lasts).abs() > Decimal.parse('1e-$precision')) {
    lasts = s;
    i += 1;
    fact *= Decimal.fromInt(i);
    num *= x;
    s += (num / fact).toDecimal(scaleOnInfinitePrecision: precision + 10);
  }

  return s;
}

Decimal ln(Decimal x) {
  if (x <= Decimal.zero) {
    throw ArgumentError('ln(x) is undefined for x <= 0');
  }

  Rational sum = Rational.zero;
  var term = ((x - Decimal.one) / (x + Decimal.one));
  var termSquared = term * term;
  var currentTerm = term;

  for (int n = 1; n <= precision; n += 2) {
    sum += currentTerm / Rational.fromInt(n);
    currentTerm *= termSquared;
  }

  return Decimal.fromInt(2) *
      sum.toDecimal(scaleOnInfinitePrecision: precision);
}

Decimal pow(Decimal base, Decimal exponent) {
  if (base == Decimal.zero) {
    if (exponent == Decimal.zero) {
      throw ArgumentError('0^0 is undefined');
    }
    return Decimal.zero;
  }

  if (exponent == Decimal.zero) {
    return Decimal.one;
  } else if (exponent.isInteger) {
    var exp = exponent.toBigInt().toInt();
    Decimal result = Decimal.one;
    Decimal factor = base;

    while (exp > 0) {
      if (exp % 2 == 1) {
        result *= factor;
      }
      factor *= factor;
      exp ~/= 2;
    }

    return result;
  } else {
    return exp(exponent * ln(base));
  }
}

Decimal cos(Decimal x) {
  int i = 0;
  Decimal lasts = Decimal.zero;
  Decimal s = Decimal.one;
  Decimal fact = Decimal.one;
  Decimal num = Decimal.one;
  Decimal sign = Decimal.one;

  while (s != lasts) {
    lasts = s;
    i += 2;
    fact *= Decimal.fromInt(i) * Decimal.fromInt(i - 1);
    num *= x * x;
    sign *= Decimal.fromInt(-1);
    s += (num / fact).toDecimal(scaleOnInfinitePrecision: precision) * sign;
  }

  return s;
}

Decimal sin(Decimal x) {
  int i = 1;
  Decimal lasts = Decimal.zero;
  Decimal s = x;
  Decimal fact = Decimal.one;
  Decimal num = x;
  Decimal sign = Decimal.one;

  while (s != lasts) {
    lasts = s;
    i += 2;
    fact *= Decimal.fromInt(i) * Decimal.fromInt(i - 1);
    num *= x * x;
    sign *= Decimal.fromInt(-1);
    s += (num / fact).toDecimal(scaleOnInfinitePrecision: precision) * sign;
  }

  return s;
}

Decimal tan(Decimal x) {
  return (sin(x) / cos(x)).toDecimal(scaleOnInfinitePrecision: precision);
}

void main() {
  print(pi()); // Output: ~3.141592653589793238462643383

  // print(exp(Decimal.parse('1'))); // Output: ~2.718281828459045235360287471
  // print(exp(Decimal.parse('2'))); // Output: ~7.389056098930650227230427461

  print(cos(Decimal.parse('0.5'))); // Output: ~0.8775825618903727161162815826
  print(sin(Decimal.parse('0.5'))); // Output: ~0.4794255386042030002732879352
  print(tan(Decimal.parse('0.5'))); // Output: ~0.5463024898437905
  print(exp(Decimal.parse('0.5')));
  // print(pow(Decimal.parse('2.0'), Decimal.parse('0.5')));
}

final _i0 = BigInt.zero;
final _i1 = BigInt.one;
final _i2 = BigInt.two;
final _i5 = BigInt.from(5);
final _r10 = Rational.fromInt(10);

class Decimal implements Comparable<Decimal> {
  Decimal._(this._rational) : assert(_rational.hasFinitePrecision);

  factory Decimal.fromBigInt(BigInt value) => value.toRational().toDecimal();
  factory Decimal.fromInt(int value) => Decimal.fromBigInt(BigInt.from(value));
  factory Decimal.parse(String source) => Rational.parse(source).toDecimal();
  factory Decimal.fromJson(String value) => Decimal.parse(value);

  final Rational _rational;

  static Decimal zero = Decimal.fromInt(0);
  static Decimal one = Decimal.fromInt(1);
  static Decimal ten = Decimal.fromInt(10);

  Rational toRational() => _rational;

  bool get isInteger => _rational.isInteger;
  Rational get inverse => _rational.inverse;

  @override
  bool operator ==(Object other) =>
      other is Decimal && _rational == other._rational;

  @override
  int get hashCode => _rational.hashCode;

  @override
  String toString() {
    if (_rational.isInteger) return _rational.toString();
    var value = toStringAsFixed(scale);
    while (
        value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  String toJson() => toString();

  @override
  int compareTo(Decimal other) => _rational.compareTo(other._rational);

  Decimal operator +(Decimal other) =>
      (_rational + other._rational).toDecimal();
  Decimal operator -(Decimal other) =>
      (_rational - other._rational).toDecimal();
  Decimal operator *(Decimal other) =>
      (_rational * other._rational).toDecimal();
  Decimal operator %(Decimal other) =>
      (_rational % other._rational).toDecimal();
  Rational operator /(Decimal other) => _rational / other._rational;
  BigInt operator ~/(Decimal other) => _rational ~/ other._rational;
  Decimal operator -() => (-_rational).toDecimal();
  Decimal remainder(Decimal other) =>
      (_rational.remainder(other._rational)).toDecimal();

  bool operator <(Decimal other) => _rational < other._rational;
  bool operator <=(Decimal other) => _rational <= other._rational;
  bool operator >(Decimal other) => _rational > other._rational;
  bool operator >=(Decimal other) => _rational >= other._rational;

  Decimal abs() => _rational.abs().toDecimal();
  int get signum => _rational.signum;

  Decimal floor({int scale = 0}) => _scaleAndApply(scale, (e) => e.floor());
  Decimal ceil({int scale = 0}) => _scaleAndApply(scale, (e) => e.ceil());
  Decimal round({int scale = 0}) => _scaleAndApply(scale, (e) => e.round());

  Decimal _scaleAndApply(int scale, BigInt Function(Rational) f) {
    final scaleFactor = ten.pow(scale);
    return (f(_rational * scaleFactor).toRational() / scaleFactor).toDecimal();
  }

  Decimal truncate({int scale = 0}) =>
      _scaleAndApply(scale, (e) => e.truncate());
  Decimal shift(int value) => this * ten.pow(value).toDecimal();
  Decimal clamp(Decimal lowerLimit, Decimal upperLimit) =>
      _rational.clamp(lowerLimit._rational, upperLimit._rational).toDecimal();
  BigInt toBigInt() => _rational.toBigInt();
  double toDouble() => _rational.toDouble();

  int get precision {
    final value = abs();
    return value.scale + value.toBigInt().toString().length;
  }

  int get scale {
    var i = 0;
    var x = _rational;
    while (!x.isInteger) {
      i++;
      x *= _r10;
    }
    return i;
  }

  String toStringAsFixed(int fractionDigits) {
    assert(fractionDigits >= 0);
    if (fractionDigits == 0) return round().toBigInt().toString();
    final value = round(scale: fractionDigits);
    final intPart = value.toBigInt().abs();
    final decimalPart =
        (one + value.abs() - intPart.toDecimal()).shift(fractionDigits);
    return '${value < zero ? '-' : ''}$intPart.${decimalPart.toString().substring(1)}';
  }

  String toStringAsExponential([int fractionDigits = 0]) {
    assert(fractionDigits >= 0);

    final negative = this < zero;
    var value = abs();
    var eValue = 0;
    while (value < one && value > zero) {
      value *= ten;
      eValue--;
    }
    while (value >= ten) {
      value = (value / ten).toDecimal();
      eValue++;
    }
    value = value.round(scale: fractionDigits);
    if (value == ten) {
      value = (value / ten).toDecimal();
      eValue++;
    }

    return <String>[
      if (negative) '-',
      value.toStringAsFixed(fractionDigits),
      'e',
      if (eValue >= 0) '+',
      '$eValue',
    ].join();
  }

  String toStringAsPrecision(int precision) {
    assert(precision > 0);

    if (this == zero) {
      return <String>[
        '0',
        if (precision > 1) '.',
        for (var i = 1; i < precision; i++) '0',
      ].join();
    }

    final limit = ten.pow(precision).toDecimal();
    var shift = one;
    final absValue = abs();
    var pad = 0;
    while (absValue * shift < limit) {
      pad++;
      shift *= ten;
    }
    while (absValue * shift >= limit) {
      pad--;
      shift = (shift / ten).toDecimal();
    }
    final value = ((this * shift).round() / shift).toDecimal();
    return pad <= 0 ? value.toString() : value.toStringAsFixed(pad);
  }

  Rational pow(int exponent) => _rational.pow(exponent);
}

extension RationalExt on Rational {
  Decimal toDecimal({
    int? scaleOnInfinitePrecision,
    BigInt Function(Rational)? toBigInt,
  }) {
    if (scaleOnInfinitePrecision == null || hasFinitePrecision) {
      return Decimal._(this);
    }
    final scaleFactor = _r10.pow(scaleOnInfinitePrecision);
    toBigInt ??= (value) => value.truncate();
    return Decimal._(toBigInt(this * scaleFactor).toRational() / scaleFactor);
  }

  bool get hasFinitePrecision {
    var den = denominator;
    while (den % _i5 == _i0) {
      den = den ~/ _i5;
    }
    while (den % _i2 == _i0) {
      den = den ~/ _i2;
    }
    return den == _i1;
  }
}

extension BigIntExt on BigInt {
  Decimal toDecimal() => Decimal.fromBigInt(this);
}

extension IntExt on int {
  Decimal toDecimal() => Decimal.fromInt(this);
}
