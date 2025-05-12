import '../number/complex.dart';
import '../number/double.dart';
import '../number/imaginary.dart';
import '../number/integer.dart';
import '../number/number.dart';
import '../number/precision.dart';

export '../number/fraction.dart';
export '../number/complex.dart';
export '../number/double.dart';
export '../number/imaginary.dart';
export '../number/integer.dart';
export '../number/number.dart';
export '../number/precision.dart';
export '../number/real.dart';
export 'jenkins_hash.dart';

/// Converts an [object] to a Number.  The [object]
/// must be either a [num] or [Number], otherwise
/// an Exception is thrown.
Number objToNumber(Object object) {
  if (object is num) return numToNumber(object);
  if (object is Number) return object;
  throw Exception('num or Number expected');
}

/// Converts a num [value] to associated [Number] object
/// ([Integer] for `int`s and `double`s that have an integer value,
/// [Double] for other `double`s).
Number numToNumber(num value) {
  if (value is int) return Integer(value);
  if (value.toInt() == value) return Integer(value.toInt());
  return Double(value.toDouble());
}

/// Converts a Number to the equivalent [num].
num numberToNum(Number number) {
  if (number is Double) return number.value;
  if (number is Integer) return number.value;
  if (number is Imaginary) return 0;
  if (number is Complex) return number.real.toDouble();
  if (number is Precision) {
    if (number.isInteger) return number.toInt();
    return number.toDouble();
  } else {
    return number.toDouble();
  }
}
