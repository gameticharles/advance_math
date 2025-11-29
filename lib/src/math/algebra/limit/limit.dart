part of '../algebra.dart';

class Limit {
  final Expression function;
  final num point;
  final String direction;

  Limit(this.function, this.point, {this.direction = 'both'});

  dynamic compute() {
    // Check for indeterminate forms
    if (function.isIndeterminate(point)) {
      try {
        return _applyLHopitalsRule();
      } catch (e) {
        return _numericalApproach(); // Fallback to a numerical approach
      }
    }

    if (direction == 'left') {
      return _leftLimit();
    } else if (direction == 'right') {
      return _rightLimit();
    } else {
      dynamic left = _leftLimit();
      dynamic right = _rightLimit();
      if (left == right) {
        return left;
      } else {
        throw Exception('Limit does not exist');
      }
    }
  }

  dynamic _applyLHopitalsRule() {
    Expression numerator;
    Expression denominator;

    if (function is RationalFunction) {
      RationalFunction ratio = function as RationalFunction;
      numerator = ratio.numerator;
      denominator = ratio.denominator;
    } else if (function is Divide) {
      Divide div = function as Divide;
      numerator = div.left;
      denominator = div.right;
    } else {
      throw Exception('L\'Hopital\'s rule not applicable: Not a fraction');
    }

    Expression newNumerator = numerator.differentiate();
    Expression newDenominator = denominator.differentiate();

    // Avoid infinite recursion if derivatives don't simplify
    if (newNumerator.toString() == numerator.toString() &&
        newDenominator.toString() == denominator.toString()) {
      return _numericalApproach();
    }

    Expression newFunction;
    if (function is RationalFunction &&
        newNumerator is Polynomial &&
        newDenominator is Polynomial) {
      newFunction = RationalFunction(newNumerator, newDenominator);
    } else {
      newFunction = Divide(newNumerator, newDenominator);
    }

    // Recursive application of L'Hopital's rule
    return Limit(newFunction, point, direction: direction).compute();
  }

  dynamic _leftLimit() {
    double h = 0.0001; // Small value
    return function.evaluate(point - h);
  }

  dynamic _rightLimit() {
    double h = 0.0001; // Small value
    return function.evaluate(point + h);
  }

  dynamic _numericalApproach() {
    // This is a basic numerical approximation. More sophisticated methods like adaptive algorithms can be used.
    return direction == 'both'
        ? (function.evaluate(point + 0.0001) +
                function.evaluate(point - 0.0001)) /
            2
        : direction == 'left'
            ? function.evaluate(point - 0.0001)
            : function.evaluate(point + 0.0001);
  }
}
