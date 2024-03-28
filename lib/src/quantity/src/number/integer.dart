import 'complex.dart';
import 'double.dart';
import 'imaginary.dart';
import 'number.dart';
import 'real.dart';

/// Wraps Dart's core [int] type, so that it can share a common base type with other [Number]s.
class Integer extends Real {
  /// Constructs a instance.
  Integer(this._value);

  /// Constructs a constant Integer.
  const Integer.constant(this._value) : super.constant();

  /// Constructs a instance.
  Integer.parse(String str, {int radix = 10})
      : _value = int.parse(str, radix: radix);

  /// Parse [source] as a double literal and return its value.
  ///
  /// Like [parse], except that this function returns null for invalid inputs instead of throwing.
  ///
  /// Example:
  /// ```dart
  /// print(int.tryParse('2021')); // 2021
  /// print(int.tryParse('1f')); // null
  /// // From binary (base 2) value.
  /// print(int.tryParse('1100', radix: 2)); // 12
  /// print(int.tryParse('00011111', radix: 2)); // 31
  /// print(int.tryParse('011111100101', radix: 2)); // 2021
  /// // From octal (base 8) value.
  /// print(int.tryParse('14', radix: 8)); // 12
  /// print(int.tryParse('37', radix: 8)); // 31
  /// print(int.tryParse('3745', radix: 8)); // 2021
  /// // From hexadecimal (base 16) value.
  /// print(int.tryParse('c', radix: 16)); // 12
  /// print(int.tryParse('1f', radix: 16)); // 31
  /// print(int.tryParse('7e5', radix: 16)); // 2021
  /// // From base 35 value.
  /// print(int.tryParse('y1', radix: 35)); // 1191 == 34 * 35 + 1
  /// print(int.tryParse('z1', radix: 35)); // null
  /// // From base 36 value.
  /// print(int.tryParse('y1', radix: 36)); // 1225 == 34 * 36 + 1
  /// print(int.tryParse('z1', radix: 36)); // 1261 == 35 * 36 + 1
  /// ```
  static int? tryParse(String source, {int radix = 10}) =>
      int.tryParse(source, radix: radix);

  /// Construct an Integer from a Map:
  ///     { 'i': integer value }
  ///
  /// If the map contents are not recognized, [Integer.zero] is returned.
  factory Integer.fromMap(Map<String, int>? m) {
    if (m?['i'] is int) return Integer(m?['i'] as int);
    return Integer.zero;
  }

  final int _value;

  /// Zero, as an Integer.
  static const Integer zero = Integer.constant(0);

  /// One, as an Integer.
  static const Integer one = Integer.constant(1);

  /// Negative one, as an Integer.
  static const Integer negOne = Integer.constant(-1);

  /// Ten, as an Integer.
  static const Integer ten = Integer.constant(10);

  /// One hundred, as an Integer.
  static const Integer hundred = Integer.constant(100);

  /// One thousand, as an Integer.
  static const Integer thousand = Integer.constant(1000);

  @override
  int get value => _value;

  @override
  bool get isInfinite => false;

  @override
  bool get isNaN => false;

  @override
  bool get isNegative => value < 0;

  @override
  int toInt() => value.toInt();

  @override
  double toDouble() => value.toDouble();

  /// Tests whether this Integer is equal to another Object [obj].
  /// Only [num] and [Number] objects having the same real
  /// integer value (and no imaginary component) are considered equal.
  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic obj) {
    if (obj is Number || obj is num) return obj == value;
    if (obj is Complex) {
      return obj.real.value == value && obj.imaginary.value.value == 0.0;
    }
    if (obj is Imaginary) return value == 0.0 && obj.value.value == 0.0;

    return false;
  }

  /// Returns the same hash as the [int] with the same value.
  @override
  int get hashCode => _value.hashCode;

  @override
  bool get isInteger => true;

  @override
  Number operator +(dynamic addend) {
    if (addend is int) return Integer(addend + value);
    if (addend is Integer) return Integer(addend.value + value);
    return super + addend;
  }

  /// Negation operator.
  @override
  Integer operator -() => Integer(-value);

  @override
  Number operator -(dynamic subtrahend) {
    if (subtrahend is int) return Integer(value - subtrahend);
    if (subtrahend is Integer) return Integer(value - subtrahend.value);
    return super - subtrahend;
  }

  @override
  Number operator *(dynamic multiplicand) {
    if (multiplicand is int) return Integer(multiplicand * value);
    if (multiplicand is Integer) return Integer(multiplicand.value * value);
    return super * multiplicand;
  }

  /// The modulo operator.
  @override
  Number operator %(dynamic divisor) {
    if (divisor is int) return Integer(_value % divisor);
    if (divisor is Integer) return Integer(_value % divisor._value);
    return super % divisor;
  }

  // --- Bitwise and shift operators ---

  /// Bitwise AND.
  Number operator &(dynamic n) {
    if (n is int) return Integer(_value & n);
    if (n is Integer) return Integer(_value & n._value);
    throw UnsupportedError(
        'Bitwise AND operations are only supported for int and Integer objects');
  }

  /// Bitwise OR.
  Number operator |(dynamic n) {
    if (n is int) return Integer(_value | n);
    if (n is Integer) return Integer(_value | n._value);
    throw UnsupportedError(
        'Bitwise OR operations are only supported for int and Integer objects');
  }

  /// Shift the bits of this integer to the left by n.
  Number operator <<(dynamic n) {
    if (n is int) return Integer(_value << n);
    if (n is Integer) return Integer(_value << n._value);
    throw UnsupportedError(
        'Bit shift operations are only supported for int and Integer objects');
  }

  /// Shift the bits of this integer to the right by n.
  Number operator >>(dynamic n) {
    if (n is int) return Integer(_value >> n);
    if (n is Integer) return Integer(_value >> n._value);
    throw UnsupportedError(
        'Bit shift operations are only supported for int and Integer objects');
  }

  /// A substitute method to perform bitwise XOR operation on integers.
  /// The caret operator is overridden to provide a power operator for all Numbers.
  Integer bitwiseXor(dynamic n) {
    if (n is int) return Integer(_value ^ n);
    if (n is Integer) return Integer(_value ^ n._value);
    throw UnsupportedError(
        'Bitwise XOR operations are only supported for int and Integer objects');
  }

  /// The bit-wise negate operator.
  Integer operator ~() => Integer(~_value);

  /// The absolute value, returned as an [Integer].
  /// Returns itself if its value is greater than or equal to zero.
  @override
  Integer abs() => _value >= 0 ? this : Integer(value.abs());

  @override
  Number ceil() => this;

  @override
  Number clamp(dynamic lowerLimit, dynamic upperLimit) {
    final lower = lowerLimit is num
        ? lowerLimit
        : lowerLimit is Number
            ? lowerLimit.toDouble()
            : 0;
    final upper = upperLimit is num
        ? upperLimit
        : upperLimit is Number
            ? upperLimit.toDouble()
            : 0;
    final clamped = value.clamp(lower, upper);
    return clamped.toInt() == clamped
        ? Integer(clamped.toInt())
        : Double(clamped.toDouble());
  }

  @override
  Number floor() => this;

  @override
  Number truncate() => this;

  /// Support [dart:json] stringify.
  ///
  /// Map Contents:
  ///     'i' : int value
  @override
  Map<String, int> toJson() => <String, int>{'i': value};
}

/// Represents an integer as a binary number.
class Binary extends Integer {
  /// Constructs a instance.
  Binary(String binaryStr) : super.parse(binaryStr, radix: 2);

  @override
  String toString() => _value.toRadixString(2);
}

/// Represents an integer as an octal number.
class Octal extends Integer {
  /// Constructs a instance.
  Octal(String octalStr) : super.parse(octalStr, radix: 8);

  @override
  String toString() => _value.toRadixString(8);
}

/// Represents an integer as a hexadecimal number.
class Hexadecimal extends Integer {
  /// Constructs a instance.
  Hexadecimal(String hexStr) : super.parse(hexStr, radix: 16);

  @override
  String toString() => _value.toRadixString(16);
}
