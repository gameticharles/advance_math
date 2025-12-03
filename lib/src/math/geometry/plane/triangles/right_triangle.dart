part of '../../geometry.dart';

/// A class representing a right triangle in 2D space.
///
/// A right triangle has one angle equal to 90 degrees (π/2 radians).
/// The two sides forming the right angle are called legs, and the side
/// opposite the right angle is called the hypotenuse.
///
/// Properties:
/// - One angle is exactly 90° (π/2 radians)
/// - Pythagorean theorem: c² = a² + b² (where c is the hypotenuse)
/// - Area = (1/2) × leg1 × leg2
///
/// Example:
/// ```dart
/// var rightTri = RightTriangle.from(leg1: 3.0, leg2: 4.0);
/// print('Hypotenuse: ${rightTri.hypotenuse}'); // 5.0
/// print('Area: ${rightTri.area()}'); // 6.0
/// ```
class RightTriangle extends Triangle {
  /// Creates a right triangle from two legs (the sides forming the right angle).
  ///
  /// The hypotenuse is calculated using the Pythagorean theorem:
  /// hypotenuse = √(leg1² + leg2²)
  ///
  /// [leg1] and [leg2] are the two sides forming the right angle.
  ///
  /// Throws [ArgumentError] if any leg is not positive.
  RightTriangle(double leg1, double leg2)
      : super(
          a: leg1,
          b: leg2,
          c: sqrt(leg1 * leg1 + leg2 * leg2),
          angleA: Angle(deg: 90),
        ) {
    if (leg1 <= 0 || leg2 <= 0) {
      throw ArgumentError(
          'Leg lengths must be positive. Got leg1: $leg1, leg2: $leg2');
    }
  }

  /// Creates a right triangle from one leg and the hypotenuse.
  ///
  /// The other leg is calculated using the Pythagorean theorem:
  /// otherLeg = √(hypotenuse² - leg²)
  ///
  /// Throws [ArgumentError] if:
  /// - Any parameter is not positive
  /// - The hypotenuse is not longer than the leg
  RightTriangle.fromHypotenuse(double leg, double hypotenuse)
      : super(
          a: leg,
          b: sqrt(hypotenuse * hypotenuse - leg * leg),
          c: hypotenuse,
          angleA: Angle(deg: 90),
        ) {
    if (leg <= 0 || hypotenuse <= 0) {
      throw ArgumentError(
          'Lengths must be positive. Got leg: $leg, hypotenuse: $hypotenuse');
    }
    if (hypotenuse <= leg) {
      throw ArgumentError(
          'Hypotenuse must be longer than leg. Got leg: $leg, hypotenuse: $hypotenuse');
    }
  }

  /// Creates a right triangle from three vertices.
  ///
  /// Validates that one of the angles is 90 degrees within a small tolerance.
  ///
  /// Throws [ArgumentError] if the vertices don't form a right triangle.
  RightTriangle.fromVertices(Point pointA, Point pointB, Point pointC)
      : super(A: pointA, B: pointB, C: pointC) {
    const tolerance = 0.01; // Allow small deviation for floating point errors

    bool hasRightAngle = (angleA!.deg - 90).abs() < tolerance ||
        (angleB!.deg - 90).abs() < tolerance ||
        (angleC!.deg - 90).abs() < tolerance;

    if (!hasRightAngle) {
      throw ArgumentError(
          'Vertices must form a right triangle (one 90° angle). Angles: A=${angleA!.deg}°, B=${angleB!.deg}°, C=${angleC!.deg}°');
    }
  }

  /// Named constructor following the pattern in existing code.
  ///
  /// Creates a right triangle with [leg1] and [leg2].
  factory RightTriangle.from({required double leg1, required double leg2}) {
    return RightTriangle(leg1, leg2);
  }

  /// Creates a right triangle from area and one leg.
  ///
  /// Calculates the other leg from: otherLeg = 2×area / leg
  ///
  /// Throws [ArgumentError] if area or leg is not positive.
  factory RightTriangle.fromArea({required double area, required double leg}) {
    if (area <= 0) throw ArgumentError('Area must be positive');
    if (leg <= 0) throw ArgumentError('Leg must be positive');

    double otherLeg = (2 * area) / leg;
    return RightTriangle(leg, otherLeg);
  }

  /// Creates a right triangle from perimeter and one leg.
  ///
  /// Uses the constraint: perimeter = leg1 + leg2 + hypotenuse
  /// where hypotenuse = √(leg1² + leg2²)
  ///
  /// Solves the quadratic equation to find the other leg.
  ///
  /// Throws [ArgumentError] if parameters don't form a valid triangle.
  factory RightTriangle.fromPerimeter({
    required double perimeter,
    required double leg,
  }) {
    if (perimeter <= 0) throw ArgumentError('Perimeter must be positive');
    if (leg <= 0) throw ArgumentError('Leg must be positive');
    if (leg >= perimeter / 2) {
      throw ArgumentError('Leg is too large for given perimeter');
    }

    // p = a + b + √(a² + b²)
    // p - a = b + √(a² + b²)
    // (p - a)² = b² + 2b√(a² + b²) + a² + b²
    // Solving for b using quadratic formula:
    double a = leg;
    double p = perimeter;

    // This leads to: 2b² - 2pb + p² - 2pa + a² = 0
    // Simplified: b² - pb + (p² - 2pa + a²)/2 = 0
    double A = 2.0;
    double B = -2 * p;
    double C = p * p - 2 * p * a + a * a;

    double discriminant = B * B - 4 * A * C;
    if (discriminant < 0) {
      throw ArgumentError('No valid triangle for given parameters');
    }

    double b1 = (-B + sqrt(discriminant)) / (2 * A);
    double b2 = (-B - sqrt(discriminant)) / (2 * A);

    // Choose the positive solution that isn't close to 'a'
    double otherLeg = (b1 > 0 && (b1 - a).abs() > 0.001) ? b1 : b2;

    if (otherLeg <= 0) {
      throw ArgumentError('Invalid perimeter for given leg');
    }

    return RightTriangle(a, otherLeg);
  }

  /// Gets the first leg of the right triangle.
  ///
  /// This is side a, one of the two sides forming the right angle.
  double get leg1 => a!.toDouble();

  /// Gets the second leg of the right triangle.
  ///
  /// This is side b, one of the two sides forming the right angle.
  double get leg2 => b!.toDouble();

  /// Gets the hypotenuse of the right triangle.
  ///
  /// This is side c, the longest side opposite the right angle.
  double get hypotenuse => c!.toDouble();

  /// Gets the angle opposite leg1.
  ///
  /// This angle is calculated as: arctan(leg1 / leg2)
  Angle get angleOppositeLeg1 => angleB!;

  /// Gets the angle opposite leg2.
  ///
  /// This angle is calculated as: arctan(leg2 / leg1)
  Angle get angleOppositeLeg2 => angleC!;

  /// Gets the altitude to the hypotenuse.
  ///
  /// This is calculated as: (leg1 × leg2) / hypotenuse
  double get altitudeToHypotenuse => (leg1 * leg2) / hypotenuse;

  /// Calculates the area using the simple formula for right triangles.
  ///
  /// Area = (1/2) × leg1 × leg2
  ///
  /// This overrides the base triangle area calculation to use the
  /// optimized formula for right triangles.
  @override
  double area([AreaMethod method = AreaMethod.baseHeight]) {
    return 0.5 * leg1 * leg2;
  }

  /// Checks if this is a Pythagorean triple (all sides are integers).
  ///
  /// Returns true if all three sides are whole numbers.
  bool isPythagoreanTriple() {
    return leg1 == leg1.toInt() &&
        leg2 == leg2.toInt() &&
        hypotenuse == hypotenuse.toInt();
  }

  @override
  String toString() {
    return 'RightTriangle(leg1: $leg1, leg2: $leg2, hypotenuse: $hypotenuse, area: ${area()})';
  }
}
