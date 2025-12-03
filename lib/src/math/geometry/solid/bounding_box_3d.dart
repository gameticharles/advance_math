part of '../geometry.dart';

/// Represents an axis-aligned bounding box (AABB) in 3D space.
///
/// A bounding box is defined by its minimum and maximum corner points,
/// creating a rectangular box that fully contains a 3D object.
///
/// Useful for collision detection, spatial queries, and rendering optimizations.
///
/// Example:
/// ```dart
/// var bbox = BoundingBox3D(
///   Point(-1, -1, -1),  // min corner
///   Point(1, 1, 1),     // max corner
/// );
/// print('Volume: ${bbox.volume}');
/// print('Contains origin: ${bbox.contains(Point(0, 0, 0))}');
/// ```
class BoundingBox3D {
  /// The minimum corner point (x_min, y_min, z_min).
  final Point min;

  /// The maximum corner point (x_max, y_max, z_max).
  final Point max;

  /// Creates a bounding box from minimum and maximum corner points.
  ///
  /// Throws [ArgumentError] if points are not 3D or if min > max in any dimension.
  BoundingBox3D(this.min, this.max) {
    if (!min.is3DPoint() || !max.is3DPoint()) {
      throw ArgumentError('Both points must be 3D points');
    }
    if (min.x > max.x || min.y > max.y || min.z! > max.z!) {
      throw ArgumentError(
          'min must be less than or equal to max in all dimensions');
    }
  }

  /// Gets the width of the bounding box (x dimension).
  double get width => (max.x - min.x).toDouble();

  /// Gets the height of the bounding box (y dimension).
  double get height => (max.y - min.y).toDouble();

  /// Gets the depth of the bounding box (z dimension).
  double get depth => (max.z! - min.z!).toDouble();

  /// Gets the center point of the bounding box.
  Point get center => Point(
        (min.x + max.x) / 2,
        (min.y + max.y) / 2,
        (min.z! + max.z!) / 2,
      );

  /// Calculates the volume of the bounding box.
  double get volume => width * height * depth;

  /// Gets the diagonal length of the bounding box.
  double get diagonal => sqrt(width * width + height * height + depth * depth);

  /// Checks if this bounding box contains a given point.
  ///
  /// Returns true if the point is inside or on the boundary of the box.
  bool contains(Point point) {
    if (!point.is3DPoint()) return false;
    return point.x >= min.x &&
        point.x <= max.x &&
        point.y >= min.y &&
        point.y <= max.y &&
        point.z! >= min.z! &&
        point.z! <= max.z!;
  }

  /// Checks if this bounding box intersects with another bounding box.
  ///
  /// Returns true if the boxes overlap or touch.
  bool intersects(BoundingBox3D other) {
    return !(other.min.x > max.x ||
        other.max.x < min.x ||
        other.min.y > max.y ||
        other.max.y < min.y ||
        other.min.z! > max.z! ||
        other.max.z! < min.z!);
  }

  /// Expands this bounding box to include another bounding box.
  ///
  /// Returns a new bounding box that contains both boxes.
  BoundingBox3D merge(BoundingBox3D other) {
    return BoundingBox3D(
      Point(
        min.x < other.min.x ? min.x : other.min.x,
        min.y < other.min.y ? min.y : other.min.y,
        min.z! < other.min.z! ? min.z : other.min.z,
      ),
      Point(
        max.x > other.max.x ? max.x : other.max.x,
        max.y > other.max.y ? max.y : other.max.y,
        max.z! > other.max.z! ? max.z : other.max.z,
      ),
    );
  }

  /// Expands this bounding box to include a point.
  ///
  /// Returns a new bounding box that contains both the original box and the point.
  BoundingBox3D expandToInclude(Point point) {
    if (!point.is3DPoint()) {
      throw ArgumentError('Point must be 3D');
    }
    return BoundingBox3D(
      Point(
        min.x < point.x ? min.x : point.x,
        min.y < point.y ? min.y : point.y,
        min.z! < point.z! ? min.z : point.z,
      ),
      Point(
        max.x > point.x ? max.x : point.x,
        max.y > point.y ? max.y : point.y,
        max.z! > point.z! ? max.z : point.z,
      ),
    );
  }

  @override
  String toString() {
    return 'BoundingBox3D(min: $min, max: $max, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoundingBox3D && other.min == min && other.max == max;
  }

  @override
  int get hashCode => min.hashCode ^ max.hashCode;
}
