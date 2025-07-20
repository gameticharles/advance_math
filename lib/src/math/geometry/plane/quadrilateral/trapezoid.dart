part of '../../geometry.dart';

/// A class representing a Trapezoid in 2D space.
class Trapezoid extends PlaneGeometry {
  /// The lengths of the parallel sides (bases) of the Trapezoid.
  final num base1, base2;

  /// The lengths of the non-parallel sides of the Trapezoid.
  final num side1, side2;

  /// The height of the Trapezoid.
  final num height;

  /// Constructs a Trapezoid with the given [base1], [base2], [side1], [side2], and [height].
  ///
  /// Requires the lengths of the two parallel sides, two non-parallel sides, and the height.
  Trapezoid(this.base1, this.base2, this.side1, this.side2, this.height)
      : super("Trapezoid");

  /// Named constructor to create a Trapezoid from various parameters.
  ///
  /// You must specify exactly three of the following parameters:
  /// - [base1], [base2], and [height]
  /// - [base1], [side1], and [height]
  /// - [base2], [side2], and [height]
  /// - [side1], [side2], and [height]
  ///
  /// Throws [ArgumentError] if insufficient or too many parameters are provided.
  Trapezoid.from({
    num? base1,
    num? base2,
    num? side1,
    num? side2,
    num? height,
  })  : base1 = base1 ??
            (height != null
                ? (2 * height / (side1! + side2!))
                : throw ArgumentError('Insufficient parameters provided.')),
        base2 = base2 ??
            (height != null
                ? (2 * height / (side1! + side2!))
                : throw ArgumentError('Insufficient parameters provided.')),
        side1 = side1 ??
            (height != null
                ? (2 * height / (base1! + base2!))
                : throw ArgumentError('Insufficient parameters provided.')),
        side2 = side2 ??
            (height != null
                ? (2 * height / (base1! + base2!))
                : throw ArgumentError('Insufficient parameters provided.')),
        height = height ??
            (base1 != null && base2 != null
                ? (2 * side1! * side2!) / (base1 + base2)
                : throw ArgumentError('Insufficient parameters provided.')),
        super("Trapezoid");

  /// Calculates the area of the Trapezoid.
  ///
  /// Formula: A = (h / 2) * (a + b)
  /// Returns the area as a [double].
  @override
  double area() {
    return (height / 2) * (base1 + base2);
  }

  /// Calculates the perimeter of the Trapezoid.
  ///
  /// Formula: p = a + b + c + d
  /// Returns the perimeter as a [double].
  @override
  double perimeter() {
    return (base1 + base2 + side1 + side2).toDouble();
  }

  /// Calculates the length of the median of the Trapezoid.
  ///
  /// Formula: m = (a + b) / 2
  /// Returns the median length as a [double].
  double median() {
    return (base1 + base2) / 2;
  }

  /// Calculates the length of side `b` of the Trapezoid.
  ///
  /// Formula: b = a - h * (cot(α) + cot(β))
  double sideLengthB(double angleAlpha, double angleBeta) {
    return base1 - height * (1 / tan(angleAlpha) + 1 / tan(angleBeta));
  }

  /// Calculates the length of side `c` of the Trapezoid.
  ///
  /// Formula: c = h / sin(α)
  double sideLengthC(double angleAlpha) {
    return height / sin(angleAlpha);
  }

  /// Calculates the length of side `d` of the Trapezoid.
  ///
  /// Formula: d = h / sin(β)
  double sideLengthD(double angleBeta) {
    return height / sin(angleBeta);
  }

  /// Calculates the lengths of the diagonals of the Trapezoid.
  ///
  /// Uses the law of cosines to find the diagonal lengths.
  /// Returns the lengths of the diagonals as a [List<double>].
  List<double> diagonals() {
    double diagonal1 =
        sqrt(side1 * side1 + side2 * side2 + (base1 - base2) * (base1 - base2));
    double diagonal2 =
        sqrt(side1 * side1 + side2 * side2 + (base2 - base1) * (base2 - base1));
    return [diagonal1, diagonal2];
  }

  /// Calculates the angles between the sides of the Trapezoid.
  ///
  /// Uses trigonometric functions to find the angles.
  /// Returns a [List] of four [double] values representing the angles in radians.
  List<double> angles() {
    double angle1 = acos(
        (base2 - base1 + side1 * side1 + side2 * side2) / (2 * side1 * side2));
    double angle2 = acos(
        (base1 - base2 + side1 * side1 + side2 * side2) / (2 * side1 * side2));
    double angle3 = pi - angle1;
    double angle4 = pi - angle2;
    return [angle1, angle2, angle3, angle4];
  }
}

/// A class representing an Isosceles Trapezoid in 2D space.
class IsoscelesTrapezoid extends Trapezoid {
  /// Constructs an Isosceles Trapezoid with the given [base1], [base2], [side], and [height].
  IsoscelesTrapezoid(num base1, num base2, num side, num height)
      : super(base1, base2, side, side, height);

  /// Named constructor to create an Isosceles Trapezoid from various parameters.
  IsoscelesTrapezoid.from({
    super.base1,
    super.base2,
    num? side,
    super.height,
  }) : super.from(side1: side, side2: side);
}

/// A class representing a Right Trapezoid in 2D space.
class RightTrapezoid extends Trapezoid {
  /// Constructs a Right Trapezoid with the given [base1], [base2], [side], and [height].
  RightTrapezoid(num base1, num base2, num side, num height)
      : super(base1, base2, side, height, height);

  /// Named constructor to create a Right Trapezoid from various parameters.
  RightTrapezoid.from({
    super.base1,
    super.base2,
    num? side,
    super.height,
  }) : super.from(side1: side, side2: height);
}
