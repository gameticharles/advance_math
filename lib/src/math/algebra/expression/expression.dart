part of algebra;

abstract class Expression {
  Number evaluate(dynamic x);
  dynamic differentiate(); //Expression
  dynamic integrate(); //Expression
  bool isIndeterminate(num x);
  bool isInfinity(num x);
}
