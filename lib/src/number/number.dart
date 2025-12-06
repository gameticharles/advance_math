/// The _quantity package_ accepts both Dart's `num` types and the `Number`s defined by this
/// _number library_ as quantity values and for quantity operations.
///
/// The classes in this library can be used to model quantities having values with arbitrary precision
/// as well as imaginary or complex numbers.  It is independent of the quantity classes and can be
/// used in a purely mathematical context.
library number;

// export 'number/complex.dart';
export 'number/double.dart';
export 'number/precision.dart';
export 'number/imaginary.dart';
export 'number/integer.dart';
export 'roman_numerals/roman_numerals.dart';
export 'number/number.dart';
export 'number/number_exception.dart';
export 'number/real.dart';

// export 'complex/complex.dart';
export 'large_numbers/large.dart';

export 'util/converters.dart';

export 'util/jenkins_hash.dart';
export 'util/romans_exception.dart';

export 'decimal/rational.dart';
export 'perfect_number.dart';
