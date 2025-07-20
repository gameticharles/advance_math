/// Dart package for matrix or list operations
/// The library was developed, documented, and published by
/// [Charles Gameti]
library advance_math;

import 'dart:async';

import 'src/math/basic/math.dart' as math;
import 'src/number/complex/complex.dart';

export 'src/number/complex/complex.dart';
export 'src/math/basic/math.dart';
export 'src/math/geometry/geometry.dart';
export 'src/math/algebra/algebra.dart';
export 'src/quantity/quantity.dart' hide Complex, Imaginary;
export 'src/interpolate/interpolate.dart';
export 'src/code_translator/num_words/num_words.dart';
export 'src/code_translator/morse_code.dart';

part 'src/utils/args.dart';
part 'src/utils/memoize.dart';
part 'src/utils/ext.dart';
part 'src/utils/num_ext.dart';
part 'src/utils/string_ext.dart';
part 'src/utils/iterable_ext.dart';
part 'src/utils/func_ext.dart';
part 'src/utils/chinese_remainder_theorem.dart';
part 'src/utils/compressed_prime_sieve.dart';
