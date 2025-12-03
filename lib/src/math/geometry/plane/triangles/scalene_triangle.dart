part of '../../geometry.dart';

/// A class representing a scalene triangle in 2D space.
///
/// A scalene triangle has all three sides of different lengths and
/// all three angles of different measures.
///
/// Properties:
/// - All sides have different lengths
/// - All angles have different measures
///
/// Example:
/// ```dart
/// var scalene = ScaleneTriangle.from(a: 3.0, b: 4.0, c: 5.0);
/// print('Area: ${scalene.area()}');
/// print('Perimeter: ${scalene.perimeter()}');
/// ```
class ScaleneTriangle extends Triangle {
  /// Creates a scalene triangle from three side lengths.
  ///
  /// [sideA], [sideB], and [sideC] must all be different lengths.
  ///
  /// Throws [ArgumentError] if:
  /// - Any side is not positive
  /// - Any two sides are equal
  /// - The triangle inequality is violated
  ScaleneTriangle(double sideA, double sideB, double sideC)
      : super(
          a: sideA,
          b: sideB,
          c: sideC,
        ) {
    if (sideA <= 0 || sideB <= 0 || sideC <= 0) {
      throw ArgumentError(
          'All side lengths must be positive. Got a: $sideA, b: $sideB, c: $sideC');
    }

    // Check that all sides are different
    const tolerance = 1e-10;
    if ((sideA - sideB).abs() < tolerance ||
        (sideB - sideC).abs() < tolerance ||
        (sideA - sideC).abs() < tolerance) {
      throw ArgumentError(
          'All sides must be different for a scalene triangle. Got a: $sideA, b: $sideB, c: $sideC');
    }

    // Triangle inequality: sum of any two sides must be greater than the third
    if (sideA + sideB <= sideC ||
        sideB + sideC <= sideA ||
        sideA + sideC <= sideB) {
      throw ArgumentError(
          'Triangle inequality violated. Got a: $sideA, b: $sideB, c: $sideC');
    }
  }

  /// Creates a scalene triangle from three vertices.
  ///
  /// Validates that all three sides are different within a small tolerance.
  ///
  /// Throws [ArgumentError] if the vertices don't form a scalene triangle.
  ScaleneTriangle.fromVertices(Point pointA, Point pointB, Point pointC)
      : super(A: pointA, B: pointB, C: pointC) {
    const tolerance = 1e-10;

    if ((a! - b!).abs() < tolerance ||
        (b! - c!).abs() < tolerance ||
        (a! - c!).abs() < tolerance) {
      throw ArgumentError(
          'Vertices must form a scalene triangle (all sides different). Sides: a=$a, b=$b, c=$c');
    }
  }

  /// Named constructor following the pattern in existing code.
  ///
  /// Creates a scalene triangle with sides [a], [b], and [c].
  factory ScaleneTriangle.from(
      {required double a, required double b, required double c}) {
    return ScaleneTriangle(a, b, c);
  }

  /// Checks if this triangle is acute (all angles < 90°).
  ///
  /// Returns true if all angles are less than 90 degrees.
  bool isAcute() {
    return angleA!.deg < 90 && angleB!.deg < 90 && angleC!.deg < 90;
  }

  /// Checks if this triangle is obtuse (one angle > 90°).
  ///
  /// Returns true if one angle is greater than 90 degrees.
  bool isObtuse() {
    return angleA!.deg > 90 || angleB!.deg > 90 || angleC!.deg > 90;
  }

  @override
  String toString() {
    return 'ScaleneTriangle(a: $a, b: $b, c: $c, area: ${area()})';
  }
}
