part of '../geometry.dart';

// Epsilon is a small double value used for double comparisons
const double eps = 1e-9;

/// Checks if three points are collinear.
///
/// Throws an [ArgumentError] if any two points are identical.
///
/// Two points are collinear if the determinant of the matrix formed by their
/// coordinates and a third point is zero, within a small epsilon margin defined
/// by [eps].
///
/// Example:
/// ```dart
/// var a = Point(1, 1);
/// var b = Point(2, 2);
/// var c = Point(3, 3);
/// print(collinear(a, b, c)); // Output: true
/// ```
///
/// Returns `true` if the points are collinear, and `false` otherwise.
bool collinear(Point a, Point b, Point c) {
  // Check if any two points are identical
  if ((a.x == b.x && a.y == b.y) || (a.x == c.x && a.y == c.y)) {
    throw ArgumentError("Points a, b, and c must be distinct.");
  }

  // Calculate the determinant to determine collinearity
  var v1x = b.x - a.x;
  var v1y = b.y - a.y;
  var v2x = c.x - a.x;
  var v2y = c.y - a.y;

  var determinant = (v1x * v2y) - (v2x * v1y);

  // Check if the determinant is close to zero, indicating collinearity
  return (determinant.abs() < eps);
}

// Compressed version of collinear code above
int collinear2(Point a, Point b, Point c) {
  num area = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
  if (area.abs() < eps) return 0;
  return area.sign.toInt();
}

class GeoUtils {
  // Comparator to sort points by X coordinate
  static int xSort(Point pt1, Point pt2) {
    if ((pt1.x - pt2.x).abs() < eps) return 0;
    return pt1.x < pt2.x ? -1 : 1;
  }

  // Comparator to sort points by Y coordinate first, then by X coordinate
  static int yxSort(Point pt1, Point pt2) {
    if ((pt1.y - pt2.y).abs() < eps) {
      if ((pt1.x - pt2.x).abs() < eps) return 0;
      return pt1.x < pt2.x ? -1 : 1;
    }
    return pt1.y < pt2.y ? -1 : 1;
  }

  // Finds the closest pair of points in a list of points
  static List<Point> closestPair(List<Point> points) {
    if (points.length < 2) return [];

    final int n = points.length;
    int xQueueFront = 0, xQueueBack = 0;

    // Sort all points by x-coordinate
    points.sort(xSort);

    // Use a sorted list for yWorkingSet
    var yWorkingSet = <Point>[];

    Point pt1 = Point.origin(), pt2 = Point.origin();
    double d = double.infinity;

    for (int i = 0; i < n; i++) {
      Point nextPoint = points[i];

      // Remove points from yWorkingSet that are out of the d-distance window
      while (xQueueFront != xQueueBack &&
          nextPoint.x - points[xQueueFront].x > d) {
        Point pt = points[xQueueFront++];
        yWorkingSet.remove(pt);
      }

      // Find points within the d-distance window above nextPoint
      double upperBound = nextPoint.y + d;
      int idx = _binarySearch(yWorkingSet, upperBound, 'upper');
      for (int j = max(0, idx - 5); j < min(yWorkingSet.length, idx + 5); j++) {
        Point next = yWorkingSet[j];
        double dist = nextPoint.distanceTo(next);
        if (dist < d) {
          pt1 = nextPoint;
          pt2 = next;
          d = dist;
        }
      }

      // Find points within the d-distance window below nextPoint
      double lowerBound = nextPoint.y - d;
      idx = _binarySearch(yWorkingSet, lowerBound, 'lower');
      for (int j = max(0, idx - 5); j < min(yWorkingSet.length, idx + 5); j++) {
        Point next = yWorkingSet[j];
        double dist = nextPoint.distanceTo(next);
        if (dist < d) {
          pt1 = nextPoint;
          pt2 = next;
          d = dist;
        }
      }

      // Handle the case of duplicate points
      if (yWorkingSet.contains(nextPoint)) {
        pt1 = pt2 = nextPoint;
        d = 0;
        break;
      }

      // Add nextPoint to yWorkingSet
      yWorkingSet.add(nextPoint);
      yWorkingSet.sort(yxSort);
      xQueueBack++;
    }

    return [pt1, pt2];
  }

  // Binary search helper function to find the index of y in yWorkingSet
  static int _binarySearch(List<Point> yWorkingSet, double y, String mode) {
    int low = 0, high = yWorkingSet.length - 1;
    int idx = 0;
    while (low <= high) {
      int mid = low + ((high - low) ~/ 2);
      if (yWorkingSet[mid].y == y) {
        idx = mid;
        break;
      } else if (yWorkingSet[mid].y < y) {
        low = mid + 1;
        idx = low;
      } else {
        high = mid - 1;
        idx = high;
      }
    }
    return idx;
  }
}
