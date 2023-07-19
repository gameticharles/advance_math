part of algebra;

class Limit {
  final Expression function;
  final num point;
  final String direction;

  Limit(this.function, this.point, {this.direction = 'both'});

  Number compute() {
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
      Number left = _leftLimit();
      Number right = _rightLimit();
      if (left == right) {
        return left;
      } else {
        throw Exception('Limit does not exist');
      }
    }
  }

  Number _applyLHopitalsRule() {
    if (function is RationalFunction) {
      RationalFunction ratio = function as RationalFunction;
      Expression newNumerator = ratio.numerator.differentiate();
      Expression newDenominator = ratio.denominator.differentiate();

      RationalFunction newFunction = RationalFunction(
          newNumerator as Polynomial, newDenominator as Polynomial);

      // Recursive application of L'Hopital's rule
      return Limit(newFunction, point, direction: direction).compute();
    } else {
      throw Exception('L\'Hopital\'s rule not applicable');
    }
  }

  Number _leftLimit() {
    double h = 0.0001; // Small value
    return function.evaluate(point - h);
  }

  Number _rightLimit() {
    double h = 0.0001; // Small value
    return function.evaluate(point + h);
  }

  Number _numericalApproach() {
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
