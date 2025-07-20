part of '../../../expression.dart';

class Term {
  final dynamic coefficient;
  final Map<String, int> variables;

  Term(dynamic coefficient, this.variables)
      : coefficient = Complex(coefficient).simplify();

  @override
  String toString() {
    if (variables.isEmpty) return coefficient.toString();
    List<String> parts = [];
    variables.forEach((key, value) {
      parts.add("$key^$value");
    });
    return '$coefficient${parts.join()}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Term) {
      return coefficient == other.coefficient &&
          _mapEquals(variables, other.variables);
    }
    return false;
  }

  @override
  int get hashCode => coefficient.hashCode ^ variables.hashCode;

  dynamic evaluate(Map<String, num> values) {
    dynamic result = coefficient;
    variables.forEach((varName, power) {
      if (values.containsKey(varName)) {
        result *= pow(values[varName], power);
      } else {
        throw ArgumentError('Missing value for variable $varName.');
      }
    });
    return result;
  }
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  // ignore: unnecessary_null_comparison
  if (a == null && b == null) return true;
  // ignore: unnecessary_null_comparison
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;

  for (K key in a.keys) {
    if (!b.containsKey(key)) return false;
    if (a[key] != b[key]) return false;
  }

  return true;
}
