import '../complex.dart';
import '../double.dart';
import '../imaginary.dart';
import '../integer.dart';
import '../number.dart';
import '../precise.dart';

export '../complex.dart';
export '../double.dart';
export '../fraction.dart';
export '../imaginary.dart';
export '../integer.dart';
export '../number.dart';
export '../precise.dart';
export '../real.dart';
export '../util/jenkins_hash.dart';

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
  if (number is Precise) {
    if (number.isInteger) return number.toInt();
    return number.toDouble();
  } else {
    return number.toDouble();
  }
}
