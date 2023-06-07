library algebra;

import 'dart:collection';
import '../complex.dart';
import '/src/math/basic/math.dart' as math;

part 'utils/utils.dart';
part 'matrix/matrix_base.dart';

part 'enum/matrix_align.dart';
part 'enum/norm.dart';
part 'enum/rescale.dart';
part 'enum/matrix_types.dart';
part 'enum/distance_types.dart';
part 'enum/linear_methods.dart';
part 'enum/sparse_format.dart';
part 'enum/decomposition_methods.dart';

part 'matrix/eigen/eigen.dart';
part 'matrix/eigen/divide_conqour.dart';

part 'matrix/iterators/matrix_iterator.dart';
part 'matrix/iterators/vector_iterator.dart';
part 'matrix/iterators/element_iterator.dart';

part 'matrix/row.dart';
part 'matrix/column.dart';
part 'matrix/diagonal.dart';
part 'matrix/sparse_matrix.dart';
part 'matrix/special_matrix.dart';

part 'matrix/extension/list_extension.dart';
part 'matrix/extension/manipulate.dart';
part 'matrix/extension/stats.dart';
part 'matrix/extension/operations.dart';
part 'matrix/extension/advance_operations.dart';
part 'matrix/extension/structure.dart';
part 'matrix/extension/matrix_functions.dart';

part 'matrix/extension/matrix_factory.dart';
part 'matrix/extension/decomposition/decomposition.dart';
part 'matrix/extension/decomposition/svd.dart';
part 'matrix/extension/decomposition/lu.dart';
part 'matrix/extension/decomposition/models.dart';

part 'vector/vector_base.dart';
part 'vector/vector_special.dart';
part 'vector/complex_vectors.dart';
part 'vector/matrix_vector.dart';
part 'vector/vector_matrix.dart';
part 'vector/operations.dart';

part 'nonlinear/nonlinear.dart';
part 'linear/linear.dart';
part 'least_squares/base_least_square.dart';
part 'least_squares/special_least_square.dart';
