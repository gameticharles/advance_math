part of '../../geometry.dart';

/// A class representing a Parallelogram in 2D space.
class Parallelogram extends PlaneGeometry {
  /// The base length of the Parallelogram.
  num base;

  /// The side length of the Parallelogram.
  num side;

  /// The first height of the Parallelogram.
  num? height1;

  /// The second height of the Parallelogram.
  num? height2;

  /// The first angle between the base and the side in radians.
  num? angle1;

  /// The second angle between the base and the side in radians.
  num? angle2;

  /// Constructs a Parallelogram with a given [base], [side], [height1], [height2], [angle1], and [angle2].
  ///
  /// Requires the base length, side length, and optionally the height and angle.
  /// If height is provided, angle is calculated. If angle is provided, height is calculated.
  Parallelogram(this.base, this.side,
      {num? height1, num? height2, this.angle1, this.angle2})
      : height2 = height2,
        height1 = height1,
        super("Parallelogram") {
    if (height1 == null && angle1 == null) {
      throw ArgumentError('Either height or angle must be provided.');
    }
    height1 ??= side * sin(angle1!);
    angle1 ??= asin(height1 / side);
  }

  /// Named constructor to create a Parallelogram from various parameters.
  ///
  /// You must specify exactly three of the following parameters:
  /// - [base], [side], and [height1]
  /// - [base], [side], and [height2]
  /// - [base], [side], and [angle1]
  /// - [base], [side], and [angle2]
  /// - [base], [height1], and [height2]
  /// - [side], [height1], and [height2]
  /// - [base], [height1], and [angle1]
  /// - [base], [height2], and [angle2]
  /// - [side], [height1], and [angle1]
  /// - [side], [height2], and [angle2]
  /// - [base], [angle1], and [angle2]
  /// - [side], [angle1], and [angle2]
  ///
  /// Throws [ArgumentError] if insufficient or too many parameters are provided.
  Parallelogram.from({
    num? base,
    num? side,
    num? height1,
    num? height2,
    num? angle1,
    num? angle2,
    num? area,
    num? perimeter,
  })  : base = base ??
            (perimeter != null && side != null
                ? (perimeter - 2 * side) / 2
                : area != null && height1 != null
                    ? area / height1
                    : height1 != null && height2 != null
                        ? height1 / sin(angle1!)
                        : throw ArgumentError(
                            'Insufficient parameters provided.')),
        side = side ??
            (perimeter != null && base != null
                ? (perimeter - 2 * base) / 2
                : height1 != null && base != null
                    ? area! / height1
                    : height1 != null && height2 != null
                        ? height2 / sin(angle2!)
                        : throw ArgumentError(
                            'Insufficient parameters provided.')),
        height1 = height1 ??
            (area != null && base != null
                ? area / base
                : area != null && side != null && perimeter != null
                    ? area / ((perimeter - 2 * side) / 2)
                    : base != null && side != null && height2 != null
                        ? (side * height2) / base
                        : angle1 != null && base != null
                            ? side! * sin(angle1)
                            : side != null && angle1 != null
                                ? side * sin(angle1)
                                : throw ArgumentError(
                                    'Insufficient parameters provided.')),
        height2 = height2 ??
            (area != null && side != null
                ? area / side
                : area != null && side != null
                    ? area / side
                    : base != null && side != null && height1 != null
                        ? (base * height1) / side
                        : base != null && angle2 != null
                            ? base * sin(angle2)
                            : throw ArgumentError(
                                'Insufficient parameters provided.')),
        angle1 = angle1 ??
            (height2 != null && base != null
                ? asin(height2 / base)
                : height1 != null && side != null
                    ? asin(height1 / side) + (pi / 2)
                    : throw ArgumentError('Insufficient parameters provided.')),
        angle2 = angle2 ??
            (angle1 != null
                ? pi - angle1
                : height1 != null && side != null
                    ? acos(height1 / side) + (pi / 2)
                    : height2 != null && base != null
                        ? asin(height2 / base) + (pi / 2)
                        : throw ArgumentError(
                            'Insufficient parameters provided.')),
        super("Parallelogram");

  /// Calculates the area of the Parallelogram.
  ///
  /// Formula: base * height1 or base * height2 or base * side * sin(angle1) or base * side * sin(angle2)
  /// Returns the area as a [double].
  @override
  double area() {
    return base.toDouble() * (side * sin(angle1!));
  }

  /// Calculates the perimeter of the Parallelogram.
  ///
  /// Formula: 2 * (base + side)
  /// Returns the perimeter as a [double].
  @override
  double perimeter() {
    return 2.0 * (base + side);
  }

  /// Calculates the length of the first diagonal of the Parallelogram.
  ///
  /// Uses the law of cosines to find the diagonal length.
  /// Returns the length of the first diagonal as a [double].
  double diagonal1() {
    return sqrt(base * base + side * side - 2 * base * side * cos(angle1!));
  }

  /// Calculates the length of the second diagonal of the Parallelogram.
  ///
  /// Uses the law of cosines to find the diagonal length.
  /// Returns the length of the second diagonal as a [double].
  double diagonal2() {
    double angleBeta = pi - angle1!;
    return sqrt(base * base + side * side - 2 * base * side * cos(angleBeta));
  }

  /// Calculates the angles between the sides of the Parallelogram.
  ///
  /// Uses the angle property to find the angles.
  /// Returns a [List] of two [double] values representing the angles in radians.
  ({Angle a, Angle b}) angles() {
    return (a: Angle(rad: angle1!), b: Angle(rad: pi - angle1!));
  }

  /// Calculates the angles between the diagonals of the parallelogram.
  ///
  /// Returns a list of angles in radians.
  ({Angle a, Angle b}) anglesBetweenDiagonals() {
    double yeta = asin((2 * area()) / (diagonal1() * diagonal2()));

    return (a: Angle(rad: yeta), b: Angle(rad: pi - yeta));
  }

  /// Verifies the correlation between the diagonals and sides of the Parallelogram.
  ///
  /// Formula: D² + d² = 2(a² + b²)
  /// Returns true if the correlation holds, false otherwise.
  bool verifyDiagonalsCorrelation() {
    double d1 = diagonal1();
    double d2 = diagonal2();
    return (d1 * d1 + d2 * d2).toDouble() ==
        (2 * (base * base + side * side)).toDouble();
  }
}
