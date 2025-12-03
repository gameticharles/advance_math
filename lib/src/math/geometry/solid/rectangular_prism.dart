part of '../geometry.dart';

/// A class representing a rectangular prism (cuboid) in 3D space.
///
/// A rectangular prism is a polyhedron with 6 rectangular faces.
///
/// Properties:
/// - Length, Width, Height
/// - Volume = l × w × h
/// - Surface Area = 2(lw + lh + wh)
/// - Space Diagonal = √(l² + w² + h²)
///
/// Example:
/// ```dart
/// var prism = RectangularPrism(length: 3, width: 4, height: 5);
/// print('Diagonal: ${prism.diagonal}');
/// ```
class RectangularPrism extends SolidGeometry {
  /// The center point of the prism.
  Point center;

  /// The length of the prism (x-axis dimension).
  double length;

  /// The width of the prism (y-axis dimension).
  double width;

  /// The height of the prism (z-axis dimension).
  double height;

  /// Creates a rectangular prism with specified dimensions.
  ///
  /// [length], [width], and [height] must be positive.
  /// [center] defaults to (0, 0, 0).
  RectangularPrism(
      {required this.length,
      required this.width,
      required this.height,
      Point? center})
      : center = center ?? Point(0, 0, 0),
        super('RectangularPrism') {
    if (length <= 0 || width <= 0 || height <= 0) {
      throw ArgumentError(
          'Dimensions must be positive. Got length: $length, width: $width, height: $height');
    }
  }

  /// Creates a cube (special case of rectangular prism).
  factory RectangularPrism.cube(double side, {Point? center}) {
    return RectangularPrism(
        length: side, width: side, height: side, center: center);
  }

  /// Calculates the volume of the prism.
  ///
  /// Volume = l × w × h
  @override
  double volume() {
    return length * width * height;
  }

  /// Calculates the total surface area of the prism.
  ///
  /// Surface Area = 2(lw + lh + wh)
  @override
  double surfaceArea() {
    return 2 * (length * width + length * height + width * height);
  }

  /// Gets the length of the space diagonal.
  ///
  /// Diagonal = √(l² + w² + h²)
  double get diagonal =>
      sqrt(length * length + width * width + height * height);

  @override
  double area() => surfaceArea();

  /// Calculates the vertices of the prism.
  List<Point> vertices() {
    double hl = length / 2;
    double hw = width / 2;
    double hh = height / 2;
    double cx = center.x.toDouble();
    double cy = center.y.toDouble();
    double cz = center.z?.toDouble() ?? 0.0;

    return [
      Point(cx + hl, cy + hw, cz + hh),
      Point(cx + hl, cy + hw, cz - hh),
      Point(cx + hl, cy - hw, cz + hh),
      Point(cx + hl, cy - hw, cz - hh),
      Point(cx - hl, cy + hw, cz + hh),
      Point(cx - hl, cy + hw, cz - hh),
      Point(cx - hl, cy - hw, cz + hh),
      Point(cx - hl, cy - hw, cz - hh),
    ];
  }

  @override
  String toString() {
    return 'RectangularPrism(center: $center, length: $length, width: $width, height: $height, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    return BoundingBox3D(
      Point(
          center.x - length / 2, center.y - width / 2, center.z! - height / 2),
      Point(
          center.x + length / 2, center.y + width / 2, center.z! + height / 2),
    );
  }
}
