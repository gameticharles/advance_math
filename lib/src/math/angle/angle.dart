part of maths;

// Converts degrees to radians.
//
// Example:
// ```dart
// print(degToRad(180));  // Output: 3.141592653589793
// ```
double radians(num deg) {
  return deg * (pi / 180);
}

// Converts radians to degrees.
//
// Example:
// ```dart
// print(radToDeg(math.pi));  // Output: 180.0
// ```
double degrees(num rad) {
  return rad * (180 / pi);
}
