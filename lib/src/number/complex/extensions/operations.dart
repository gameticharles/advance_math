part of '../complex.dart';

extension ComplexOperationX<T extends Complex> on T {

  /// Returns the distance between this complex number and another in the complex plane.
  ///
  /// Example:
  /// ```dart
  /// Complex(1, 2).distanceTo(Complex(4, 6))  // 5.0
  /// ```
  num distanceTo(Complex other) {
    return (this - other).abs();
  }

  /// Checks if this complex number lies within a circle centered at the given point
  /// with the specified radius.
  ///
  /// Example:
  /// ```dart
  /// Complex(2, 3).isWithinCircle(Complex(0, 0), 5)  // true
  /// ```
  bool isWithinCircle(Complex center, num radius) {
    return distanceTo(center) <= radius;
  }

  /// Returns the minimum of two complex numbers based on their magnitudes.
  ///
  /// Example:
  /// ```dart
  /// Complex.min(Complex(3, 4), Complex(1, 1))  // 1 + 1i
  /// ```
  static Complex min(Complex a, Complex b) {
    return a.abs() <= b.abs() ? a : b;
  }

  /// Returns the maximum of two complex numbers based on their magnitudes.
  ///
  /// Example:
  /// ```dart
  /// Complex.max(Complex(3, 4), Complex(1, 1))  // 3 + 4i
  /// ```
  static Complex max(Complex a, Complex b) {
    return a.abs() >= b.abs() ? a : b;
  }

  /// Linearly interpolates between two complex numbers.
  ///
  /// Example:
  /// ```dart
  /// Complex.lerp(Complex(1, 1), Complex(3, 3), 0.5)  // 2 + 2i
  /// ```
  static Complex lerp(Complex a, Complex b, num t) {
    if (t <= 0) return a;
    if (t >= 1) return b;
    return a + (b - a) * t;
  }

  /// Clamps this complex number's magnitude between the specified minimum and maximum values.
  Complex clampMagnitude(num min, num max) {
    final mag = abs();
    if (mag < min) {
      return normalize() * min;
    } else if (mag > max) {
      return normalize() * max;
    }
    return this as Complex;
  }

  /// Rotates this complex number by the specified angle in radians.
  Complex rotate(num angleRadians) {
    final mag = abs();
    final newAngle = argument + angleRadians;
    return Complex.polar(mag, newAngle);
  }

  /// Returns a complex number with the same magnitude but opposite phase.
  Complex flipPhase() {
    return Complex.polar(abs(), argument + math.pi);
  }

  

}