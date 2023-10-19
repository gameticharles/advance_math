/// The _quantity package_ accepts both Dart's `num` types and the `Number`s defined by this
/// _number library_ as quantity values and for quantity operations.
///
/// The classes in this library can be used to model quantities having values with arbitrary precision
/// as well as imaginary or complex numbers.  It is independent of the quantity classes and can be
/// used in a purely mathematical context.
library number;

export 'src/number/complex.dart';
export 'src/number/double.dart';
export 'src/number/fraction.dart';
export 'src/number/imaginary.dart';
export 'src/number/integer.dart';
export 'src/number/roman_numerals.dart';
export 'src/number/number.dart';
export 'src/number/number_exception.dart';
export 'src/number/precise.dart';
export 'src/number/real.dart';
export 'src/number/util/converters.dart';
export 'src/number/util/erf.dart';
export 'src/number/util/jenkins_hash.dart';
export 'src/number/util/romans_exception.dart';
