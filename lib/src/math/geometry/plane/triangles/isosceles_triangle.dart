part of '../../geometry.dart';

/// A class representing an isosceles triangle in 2D space.
///
/// An isosceles triangle has two sides of equal length and two equal angles.
///
/// Properties:
/// - Two sides are equal (the "equal sides")
/// - The third side is called the "base"
/// - Two angles are equal (the "base angles" opposite the equal sides)
/// - The angle between the equal sides is the "apex angle"
///
/// Example:
/// ```dart
/// var isosceles = IsoscelesTriangle.from(equalSide: 5.0, base: 6.0);
/// print('Area: ${isosceles.area()}');
/// print('Apex Angle: ${isosceles.apexAngle}');
/// ```
class IsoscelesTriangle extends Triangle {
  /// Creates an isosceles triangle from the length of the equal sides and the base.
  ///
  /// [equalSide] is the length of the two equal sides.
  /// [base] is the length of the third side (base).
  ///
  /// Throws [ArgumentError] if any parameter is not positive or if
  /// the triangle inequality is violated.
  IsoscelesTriangle(double equalSide, double base)
      : super(
          a: base,
          b: equalSide,
          c: equalSide,
        ) {
    if (equalSide <= 0 || base <= 0) {
      throw ArgumentError(
          'Side lengths must be positive. Got equalSide: $equalSide, base: $base');
    }
    // Triangle inequality: sum of any two sides must be greater than the third
    if (2 * equalSide <= base) {
      throw ArgumentError(
          'Triangle inequality violated. 2*equalSide must be > base. Got equalSide: $equalSide, base: $base');
    }
  }

  /// Creates an isosceles triangle from three vertices.
  ///
  /// Validates that exactly two sides are equal within a small tolerance.
  ///
  /// Throws [ArgumentError] if the vertices don't form an isosceles triangle.
  IsoscelesTriangle.fromVertices(Point pointA, Point pointB, Point pointC)
      : super(A: pointA, B: pointB, C: pointC) {
    const tolerance = 1e-10;
    bool abEqualsAc = (b! - c!).abs() < tolerance;
    bool abEqualsBc = (b! - a!).abs() < tolerance;
    bool acEqualsBc = (c! - a!).abs() < tolerance;

    int equalPairs =
        (abEqualsAc ? 1 : 0) + (abEqualsBc ? 1 : 0) + (acEqualsBc ? 1 : 0);

    if (equalPairs != 1) {
      throw ArgumentError(
          'Vertices must form an isosceles triangle (exactly two sides equal). Sides: a=$a, b=$b, c=$c');
    }
  }

  /// Named constructor following the pattern in existing code.
  ///
  /// Creates an isosceles triangle with [equalSide] and [base].
  factory IsoscelesTriangle.from(
      {required double equalSide, required double base}) {
    return IsoscelesTriangle(equalSide, base);
  }

  /// Creates an isosceles triangle from area and base length.
  ///
  /// Calculates the equal side from: equalSide = √(h² + (base/2)²)
  /// where h = 2×area / base
  ///
  /// Throws [ArgumentError] if area or base is not positive.
  factory IsoscelesTriangle.fromAreaAndBase({
    required double area,
    required double base,
  }) {
    if (area <= 0) throw ArgumentError('Area must be positive');
    if (base <= 0) throw ArgumentError('Base must be positive');

    double height = (2 * area) / base;
    double equalSide = sqrt(height * height + (base / 2) * (base / 2));

    return IsoscelesTriangle(equalSide, base);
  }

  /// Creates an isosceles triangle from perimeter and base length.
  ///
  /// Calculates: equalSide = (perimeter - base) / 2
  ///
  /// Throws [ArgumentError] if parameters don't form a valid triangle.
  factory IsoscelesTriangle.fromPerimeterAndBase({
    required double perimeter,
    required double base,
  }) {
    if (perimeter <= 0) throw ArgumentError('Perimeter must be positive');
    if (base <= 0) throw ArgumentError('Base must be positive');
    if (base >= perimeter) {
      throw ArgumentError('Base cannot be greater than or equal to perimeter');
    }

    double equalSide = (perimeter - base) / 2;

    if (equalSide <= 0 || 2 * equalSide <= base) {
      throw ArgumentError('Invalid perimeter for given base');
    }

    return IsoscelesTriangle(equalSide, base);
  }

  /// Gets the length of the equal sides.
  ///
  /// Returns the length of sides b and c (which are equal).
  double get equalSide => b!.toDouble();

  /// Gets the length of the base.
  ///
  /// Returns the length of side a.
  double get baseLength => a!.toDouble();

  /// Gets the apex angle (the angle between the two equal sides).
  ///
  /// This is angle A in the triangle.
  Angle get apexAngle => angleA!;

  /// Gets one of the base angles (angles opposite the equal sides).
  ///
  /// Both base angles are equal. This returns angle B.
  Angle get baseAngle => angleB!;

  /// Gets the height from the apex to the base.
  ///
  /// This uses the Pythagorean theorem:
  /// height = √(equalSide² - (base/2)²)
  double get heightToBase {
    return sqrt(equalSide * equalSide - (baseLength / 2) * (baseLength / 2));
  }

  /// Gets the median from the apex to the base.
  ///
  /// For an isosceles triangle, this is the same as the height to the base.
  double get medianToBase => heightToBase;

  @override
  String toString() {
    return 'IsoscelesTriangle(equalSide: $equalSide, base: $baseLength, apexAngle: $apexAngle, area: ${area()})';
  }
}
