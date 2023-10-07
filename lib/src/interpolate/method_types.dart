part of interpolate;

/// An enumeration of interpolation methods.
enum MethodType {
  /// Linear interpolation between two data points.
  linear,

  /// Uses the nearest data point as the interpolated value.
  nearest,

  /// Uses the previous data point as the interpolated value.
  previous,

  /// Uses the next data point as the interpolated value.
  next,

  /// Uses a quadratic polynomial to interpolate between data points.
  quadratic,

  /// Uses a cubic polynomial to interpolate between data points.
  cubic,

  /// Uses Newton's divided difference formula for interpolation.
  newton
}
