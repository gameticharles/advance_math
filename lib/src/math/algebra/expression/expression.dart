library expression;


import '../../../../advance_math.dart' hide Complex,Number, Integer, Double;
import '../../../number/complex/complex.dart';
import 'package:petitparser/petitparser.dart';


part 'parser.dart';
part 'utils.dart';

part 'components/binary_unary_operation/binary_expression.dart';
part 'components/binary_unary_operation/binary_operations_expression.dart';
part 'components/binary_unary_operation/subtract.dart';
part 'components/binary_unary_operation/division.dart';
part 'components/binary_unary_operation/multiply.dart';
part 'components/binary_unary_operation/power.dart';
part 'components/binary_unary_operation/add.dart';

part 'components/simple/variable.dart';
part 'components/simple/identifier.dart';
part 'components/simple/literal.dart';
part 'components/simple/expression.dart';
part 'components/simple/conditional.dart';

part 'components/functions/function.dart';
part 'components/functions/predefined.dart';
part 'components/functions/trigonometric.dart';
part 'components/functions/trig/sin.dart';
part 'components/functions/trig/cos.dart';
part 'components/functions/trig/tan.dart';
part 'components/functions/trig/sec.dart';
part 'components/functions/trig/csc.dart';
part 'components/functions/trig/cot.dart';
part 'components/functions/trig/trig_expression.dart';
part 'components/functions/rational.dart';
part 'components/functions/abs.dart';
part 'components/functions/ln.dart';

part 'components/polynomial/constant.dart';
part 'components/polynomial/cubic.dart';
part 'components/polynomial/linear.dart';
part 'components/polynomial/quadratic.dart';
part 'components/polynomial/quartic.dart';
part 'components/polynomial/durand_kerner.dart';
part 'components/polynomial/polynomial.dart';
part 'components/polynomial/multi_polynomial/multi_variable_poly.dart';
part 'components/polynomial/multi_polynomial/term.dart';

part 'components/structured/call_expression.dart';
part 'components/structured/indexing_expression.dart';
part 'components/structured/member_expression.dart';
part 'components/structured/negation_expression.dart';
part 'components/structured/unary_operator_expression.dart';
