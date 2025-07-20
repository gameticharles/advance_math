part of '../../geometry.dart';

class Square extends PlaneGeometry {
  num side;

  /// Constructs a Square with a given side length.
  Square(this.side) : super("Square");

  /// Named constructor to create a Square from various parameters.
  ///
  /// You can specify exactly one of the following parameters:
  /// - side: Side length of the square.
  /// - diagonal: Diagonal length of the square.
  /// - perimeter: Perimeter of the square.
  /// - area: Area of the square.
  /// - inRadius: Inscribed radius of the square.
  /// - circumRadius: Circumscribed radius of the square.
  Square.from({
    num? side,
    num? diagonal,
    num? perimeter,
    num? area,
    num? inRadius,
    num? circumRadius,
  })  : side = side ??
            (diagonal != null
                ? diagonal / sqrt(2)
                : perimeter != null
                    ? perimeter / 4
                    : area != null
                        ? sqrt(area)
                        : inRadius != null
                            ? 2 * inRadius
                            : circumRadius != null
                                ? (2 * circumRadius) / sqrt(2)
                                : throw ArgumentError(
                                    'Insufficient parameters provided.')),
        super("Square");

  @override
  num area() {
    return side * side;
  }

  @override
  num perimeter() {
    return 4 * side;
  }

  /// Calculates the diagonal length of the square.
  ///
  /// The diagonal length of a square is equal to the side length multiplied by the square root of 2.
  num diagonal() {
    return side * sqrt(2);
  }

  /// Calculates the angle between the diagonal and the sides of a square.
  ///
  /// The angle between the diagonals of a square is always 45 degrees, or π/4 radians.
  Angle angleBetweenDiagonals() {
    return Angle(rad: atan(1));
  }

  /// Get the inRadius of the rectangle.
  num get inRadius => side / 2;

  /// Get the outRadius of the rectangle.
  num get circumRadius => (side * sqrt(2)) / 2;
}
