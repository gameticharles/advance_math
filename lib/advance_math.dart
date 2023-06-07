library advance_math;

/// Dart package for matrix or list operations
/// The library was developed, documented, and published by
/// [Charles Gameti]

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'src/math/basic/math.dart' as math;
import 'src/math/matrix/matrix.dart';

//export 'advance_math.dart';
export 'src/math/basic/math.dart';
export 'src/math/geometry/geometry.dart';
export 'src/math/matrix/matrix.dart';
export 'src/math/vector/vector.dart';
export 'src/math/complex.dart';
export 'src/math/algebra/linear/linear.dart';

part 'src/interoperability/interoperability.dart';

part 'src/math/algebra/nonlinear/nonlinear.dart';
part 'src/math/algebra/least_squares/base_least_square.dart';
part 'src/math/algebra/least_squares/special_least_square.dart';
