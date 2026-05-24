part of '../../geometry.dart';

/// Represent a rectangle in 2D space.
class Rectangle extends PlaneGeometry {
  num length;
  num width;

  /// Constructs a Rectangle with a given length and width.
  Rectangle(this.length, this.width) : super("Rectangle");

  /// Named constructor to create a Rectangle from various parameters.
  ///
  /// You can specify exactly two of the following parameters:
  /// - length: Length of the rectangle.
  /// - width: Width of the rectangle.
  /// - diagonal: Diagonal length of the rectangle.
  /// - perimeter: Perimeter of the rectangle.
  /// - area: Area of the rectangle.
  Rectangle.from({
    num? length,
    num? width,
    num? diagonal,
    num? perimeter,
    num? area,
  })  : length = length ??
            (perimeter != null && width != null
                ? (perimeter / 2) - width
                : diagonal != null && width != null
                    ? (sqrt(diagonal * diagonal - width * width) is Complex
                        ? (sqrt(diagonal * diagonal - width * width) as Complex).real.toDouble()
                        : (sqrt(diagonal * diagonal - width * width) as num).toDouble())
                    : area != null && width != null
                        ? area / width
                        : throw ArgumentError(
                            'Insufficient parameters provided.')),
        width = width ??
            (perimeter != null && length != null
                ? (perimeter / 2) - length
                : diagonal != null && length != null
                    ? (sqrt(diagonal * diagonal - length * length) is Complex
                        ? (sqrt(diagonal * diagonal - length * length) as Complex).real.toDouble()
                        : (sqrt(diagonal * diagonal - length * length) as num).toDouble())
                    : area != null && length != null
                        ? area / length
                        : throw ArgumentError(
                            'Insufficient parameters provided.')),
        super("Rectangle");

  /// Creates a rectangle from area and aspect ratio.
  ///
  /// The aspect ratio is defined as length/width.
  /// Calculates: length = √(area × aspectRatio), width = √(area / aspectRatio)
  ///
  /// Example:
  /// ```dart
  /// var rect = Rectangle.fromAreaAndAspectRatio(area: 100, aspectRatio: 2.0);
  /// // Creates rectangle with area 100 and length:width ratio of 2:1
  /// ```
  ///
  /// Throws [ArgumentError] if area or aspectRatio is not positive.
  factory Rectangle.fromAreaAndAspectRatio({
    required double area,
    required double aspectRatio,
  }) {
    if (area <= 0) throw ArgumentError('Area must be positive');
    if (aspectRatio <= 0) throw ArgumentError('Aspect ratio must be positive');

    var lenVal = sqrt(area * aspectRatio);
    double length = lenVal is Complex ? lenVal.real.toDouble() : (lenVal as num).toDouble();
    var widVal = sqrt(area / aspectRatio);
    double width = widVal is Complex ? widVal.real.toDouble() : (widVal as num).toDouble();
    return Rectangle(length, width);
  }

  @override
  num area() {
    return length * width;
  }

  @override
  num perimeter() {
    return 2 * (length + width);
  }

  /// Calculates the diagonal length of the rectangle.
  ///
  /// The diagonal length is calculated using the Pythagorean theorem, taking the square root of the sum of the squares of the length and width.
  double diagonal() {
    var result = sqrt(length * length + width * width);
    return result is Complex ? result.real.toDouble() : (result as num).toDouble();
  }

  /// Calculates the ratio of the perimeter to twice the diagonal of the rectangle.
  ///
  /// This method provides a way to measure how close the rectangle is to being a square.
  /// A square has a perimeter to diagonal ratio of 2, while other rectangles will have
  /// a ratio greater than 2.
  double perimeterRatio() {
    return perimeter() / (2 * diagonal());
  }

  /// Calculates the aspect ratio of the rectangle.
  ///
  /// The aspect ratio is the ratio of the length to the width of the rectangle.
  /// If the length is less than the width, the aspect ratio is the length divided by the width.
  /// If the length is greater than the width, the aspect ratio is the width divided by the length.
  /// If the length and width are equal, the aspect ratio is 1.
  double aspectRatio() {
    // l < w:  r = l÷w
    // l > w:  r = w÷l
    // l = w:  r = 1
    return length < width
        ? length / width
        : length > width
            ? width / length
            : 1;
  }

  /// Calculates the angles between the diagonals of the rectangle.
  ///
  /// The angles between the diagonals are calculated using the inverse tangent (atan) function,
  /// taking the ratio of the width to the length for one angle, and the ratio of the length to
  /// the width for the other angle.
  ///
  /// The returned value is a map with two keys, 'a' and 'b', each containing an [Angle] instance
  /// representing the angles between the diagonals.
  ({Angle a, Angle b}) anglesBetweenDiagonals() {
    var atanA = atan(width / length);
    var atanB = atan(length / width);
    return (
      a: Angle(rad: atanA is Complex ? atanA.real.toDouble() : (atanA as num).toDouble()),
      b: Angle(rad: atanB is Complex ? atanB.real.toDouble() : (atanB as num).toDouble()),
    );
  }
}
