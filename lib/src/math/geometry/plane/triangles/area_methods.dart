part of '../../geometry.dart';

enum AreaMethod {
  /// Requires the lengths of all three sides of the triangle.
  /// The formula is √`[s(s - a)(s - b)(s - c)]`,
  /// where s is the semi-perimeter of the triangle (a + b + c) / 2,
  /// and a, b, and c are the lengths of the sides.
  heron,

  /// Requires the length of a base and the height from that base.
  /// The formula is 0.5 * base * height.
  baseHeight,

  /// Requires two side lengths and the included angle.
  /// The formula is 0.5 * a * b * sin(C),
  /// where a and b are the lengths of the sides, and C is the included angle.
  trigonometry,

  /// If you know the coordinates of the triangle vertices,
  /// you can calculate the area as well.
  /// Formula: `0.5 * abs[(x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2))]`
  coordinates
}
