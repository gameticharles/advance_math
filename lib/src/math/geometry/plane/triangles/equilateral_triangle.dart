part of '../../geometry.dart';

/// A class representing an equilateral triangle in 2D space.
///
/// An equilateral triangle has all three sides of equal length and
/// all three angles equal to 60 degrees (π/3 radians).
///
/// Properties:
/// - All sides are equal
/// - All angles are 60° (π/3 radians)
/// - Height = (√3/2) × side
/// - Area = (√3/4) × side²
///
/// Example:
/// ```dart
/// var equilateral = EquilateralTriangle.fromSide(5.0);
/// print('Area: ${equilateral.area()}'); // Area: 10.825...
/// print('Height: ${equilateral.height}'); // Height: 4.330...
/// ```
class EquilateralTriangle extends Triangle {
  /// Creates an equilateral triangle from a single side length.
  ///
  /// All three sides will be equal to [side], and all angles will be 60°.
  ///
  /// Throws [ArgumentError] if [side] is not positive.
  EquilateralTriangle.fromSide(double side)
      : super(
          a: side,
          b: side,
          c: side,
          angleA: Angle(deg: 60),
          angleB: Angle(deg: 60),
          angleC: Angle(deg: 60),
        ) {
    if (side <= 0) {
      throw ArgumentError('Side length must be positive, got: $side');
    }
  }

  /// Creates an equilateral triangle from its height.
  ///
  /// The side length is calculated as: side = (2 × height) / √3
  ///
  /// Throws [ArgumentError] if [height] is not positive.
  EquilateralTriangle.fromHeight(double height)
      : super(
          a: (2 * height) / sqrt(3),
          b: (2 * height) / sqrt(3),
          c: (2 * height) / sqrt(3),
          angleA: Angle(deg: 60),
          angleB: Angle(deg: 60),
          angleC: Angle(deg: 60),
        ) {
    if (height <= 0) {
      throw ArgumentError('Height must be positive, got: $height');
    }
  }

  /// Creates an equilateral triangle from its area.
  ///
  /// The side length is calculated as: side = √((4 × area) / √3)
  ///
  /// Throws [ArgumentError] if [area] is not positive.
  EquilateralTriangle.fromArea(double area)
      : super(
          a: sqrt((4 * area) / sqrt(3)),
          b: sqrt((4 * area) / sqrt(3)),
          c: sqrt((4 * area) / sqrt(3)),
          angleA: Angle(deg: 60),
          angleB: Angle(deg: 60),
          angleC: Angle(deg: 60),
        ) {
    if (area <= 0) {
      throw ArgumentError('Area must be positive, got: $area');
    }
  }

  /// Creates an equilateral triangle from three vertices.
  ///
  /// Validates that all three sides are equal within a small tolerance.
  ///
  /// Throws [ArgumentError] if the vertices don't form an equilateral triangle.
  EquilateralTriangle.fromVertices(Point a, Point b, Point c)
      : super(A: a, B: b, C: c) {
    const tolerance = 1e-10;
    if ((this.a! - this.b!).abs() > tolerance ||
        (this.b! - this.c!).abs() > tolerance ||
        (this.a! - this.c!).abs() > tolerance) {
      throw ArgumentError(
          'Vertices must form an equilateral triangle. Sides: a=${this.a}, b=${this.b}, c=${this.c}');
    }
  }

  /// Creates an equilateral triangle from its perimeter.
  ///
  /// The side length is calculated as: side = perimeter / 3
  ///
  /// Throws [ArgumentError] if [perimeter] is not positive.
  EquilateralTriangle.fromPerimeter(double perimeter)
      : super(
          a: perimeter / 3,
          b: perimeter / 3,
          c: perimeter / 3,
          angleA: Angle(deg: 60),
          angleB: Angle(deg: 60),
          angleC: Angle(deg: 60),
        ) {
    if (perimeter <= 0) {
      throw ArgumentError('Perimeter must be positive, got: $perimeter');
    }
  }

  /// Creates an equilateral triangle from its inradius.
  ///
  /// The side length is calculated as: side = 2√3 × inradius
  ///
  /// Throws [ArgumentError] if [inradius] is not positive.
  EquilateralTriangle.fromInradius(double inradius)
      : super(
          a: 2 * sqrt(3) * inradius,
          b: 2 * sqrt(3) * inradius,
          c: 2 * sqrt(3) * inradius,
          angleA: Angle(deg: 60),
          angleB: Angle(deg: 60),
          angleC: Angle(deg: 60),
        ) {
    if (inradius <= 0) {
      throw ArgumentError('Inradius must be positive, got: $inradius');
    }
  }

  /// Creates an equilateral triangle from its circumradius.
  ///
  /// The side length is calculated as: side = √3 × circumradius
  ///
  /// Throws [ArgumentError] if [circumradius] is not positive.
  EquilateralTriangle.fromCircumradius(double circumradius)
      : super(
          a: sqrt(3) * circumradius,
          b: sqrt(3) * circumradius,
          c: sqrt(3) * circumradius,
          angleA: Angle(deg: 60),
          angleB: Angle(deg: 60),
          angleC: Angle(deg: 60),
        ) {
    if (circumradius <= 0) {
      throw ArgumentError('Circumradius must be positive, got: $circumradius');
    }
  }

  /// Named constructor following the pattern in existing code.
  ///
  /// Creates an equilateral triangle with the specified [side] length.
  factory EquilateralTriangle.from({required double side}) {
    return EquilateralTriangle.fromSide(side);
  }

  /// Gets the side length of the equilateral triangle.
  ///
  /// Since all sides are equal, this returns the value of side a.
  double get side => a!.toDouble();

  /// Gets the height of the equilateral triangle.
  ///
  /// Height = (√3/2) × side
  double get height => (sqrt(3) / 2) * side;

  /// Gets the inradius (radius of inscribed circle).
  ///
  /// For an equilateral triangle: inradius = side / (2√3)
  double get inRadius => side / (2 * sqrt(3));

  /// Gets the circumradius (radius of circumscribed circle).
  ///
  /// For an equilateral triangle: circumradius = side / √3
  double get circumRadius => side / sqrt(3);

  @override
  String toString() {
    return 'EquilateralTriangle(side: $side, height: $height, area: ${area()})';
  }
}
