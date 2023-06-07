library matrix;

import 'dart:collection';

import '../../utils/utils.dart';
import '../algebra/linear/linear.dart';
import '../complex.dart';
import '../vector/vector.dart';
import '/src/math/basic/math.dart' as math;

part 'matrix_base.dart';

part 'enum/matrix_align.dart';
part 'enum/norm.dart';
part 'enum/rescale.dart';
part 'enum/matrix_types.dart';
part 'enum/distance_types.dart';
part 'enum/linear_methods.dart';
part 'enum/sparse_format.dart';
part 'enum/decomposition_methods.dart';

part 'eigen/eigen.dart';
part 'eigen/divide_conqour.dart';

part 'iterators/matrix_iterator.dart';
part 'iterators/vector_iterator.dart';
part 'iterators/element_iterator.dart';

part 'row.dart';
part 'column.dart';
part 'diagonal.dart';
part 'sparse_matrix.dart';
part 'special_matrix.dart';

part 'extension/list_extension.dart';
part 'extension/manipulate.dart';
part 'extension/stats.dart';
part 'extension/operations.dart';
part 'extension/advance_operations.dart';
part 'extension/structure.dart';
part 'extension/matrix_functions.dart';

part 'extension/matrix_factory.dart';
part 'extension/decomposition/decomposition.dart';
part 'extension/decomposition/svd.dart';
part 'extension/decomposition/lu.dart';
part 'extension/decomposition/models.dart';
