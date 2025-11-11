part of '../../advance_math.dart';

void printLine([String s = '']) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

/// A class representing a range along.
class Range {
  final dynamic min;
  final dynamic max;

  Range(this.min, this.max);

  @override
  String toString() {
    return 'Range(min: $min, max: $max)';
  }
}

/// A class representing a domain along the major axis of an ellipse.
class Domain {
  final double minX;
  final double maxX;

  Domain(this.minX, this.maxX);

  @override
  String toString() {
    return 'Domain(min: $minX, max: $maxX)';
  }
}
